# Окружение и API

## Переменные

Источник: `src/shared/config/env.ts`, шаблон: `.env.example`.

| Переменная | Обязательность | Поведение |
|------------|----------------|-----------|
| `NEXT_PUBLIC_API_URL` | Нет | Базовый URL API. Если не задано — `http://localhost:8000`. На развёрнутом стенде укажите `https://api.tarr.ssrit.xyz`. Завершающий `/` отбрасывается. |

Клиентский код получает это значение на этапе сборки Next.js (`NEXT_PUBLIC_*`). Для Docker production-образа задавайте его при **`docker compose build`** (см. корневой README).

## HTTP-клиент

Файл: `src/shared/api/http-client.ts`.

- Базовый адрес: `env.apiBaseUrl`.
- Если в Zustand есть access-токен — заголовок `Authorization: Bearer …`.
- Ответ **401**: одна попытка обновить пару токенов через `POST /api/auth/refresh` с телом `{ refresh_token }`; при успехе повтор запроса; при ошибке — очистка сессии, сброс кэша запросов, переход на `/login`.
- Запросы к `/api/auth/login`, `/api/auth/logout` и сам `/api/auth/refresh` выведены из общего цикла повтора после refresh.
- Refresh-токен хранится отдельно от persist-состояния стора в ключе `localStorage["admin_refresh_token"]` (см. `shared/lib/refresh-token-storage.ts`). Эти ключи **не** пересекаются с web-панелью — токен из одной панели не подойдёт для другой.

## Пути, которые вызывает этот клиент

### Авторизация

`src/features/auth/api/auth-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| POST | `/api/auth/login` | Вход (email, password) → `access_token` + `refresh_token` + `user` (только роль `moderator` допускается клиентом) |
| POST | `/api/auth/refresh` | Обновление пары токенов |
| POST | `/api/auth/logout` | Логаут (refresh_token) |
| GET | `/api/auth/me` | Текущий пользователь |

### Квесты и модерация

`src/features/quests/api/quests-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/moderation/quests` | Очередь квестов на модерации (с фильтрами и пагинацией) |
| GET | `/api/quests` | Опубликованные квесты (для просмотра вне очереди) |
| GET | `/api/quests/{id}` | Детальная карточка квеста с чекпоинтами и геокоординатами |
| POST | `/api/moderation/quests/{id}/publish` | Одобрить квест → перевод в `published` |
| POST | `/api/moderation/quests/{id}/reject` | Отклонить (`reason`) → перевод в `rejected` |
| DELETE | `/api/moderation/quests/{id}` | Удалить квест как модератор |

### Жалобы

`src/features/reports/api/reports-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/moderation/complaints` | Список жалоб (limit, offset) |
| DELETE | `/api/moderation/complaints/{id}` | Закрыть/удалить жалобу |

### Файлы

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/file/{fileId}` | Картинки квестов (см. `entities/quest`) |

Обложки квестов без своего файла подставляются через `https://picsum.photos/…`.

## Пагинация

Описана в `src/shared/api/pagination.ts`. По умолчанию `limit=10`. Для бесконечных списков используется `fetch-all-next-pages.ts` и компонент `infinite-list-footer.tsx`.

## Ошибки

Класс `ApiError` (см. `src/shared/api/http-client.ts`): сообщение собирается из поля `detail` ответа (строка или массив с `msg`), иначе используется `message` ответа или текст оси axios. Для попытки обычного пользователя зайти в админку клиент бросает `NotModeratorError` (HTTP 403) — страница логина редиректит на `/access_denied`.
