# Окружение и API

## Переменные

Источник: `src/shared/config/env.ts`, шаблон: `.env.example`.

| Переменная | Обязательность | Поведение |
|------------|----------------|-----------|
| `NEXT_PUBLIC_API_URL` | Нет | Базовый URL API. Если не задано — `http://localhost:8000`. Завершающий `/` отбрасывается. |

Клиентский код получает это значение на этапе сборки Next.js (`NEXT_PUBLIC_*`). Для Docker production-образа задавайте его при **`docker compose build`** (см. корневой README).

## HTTP-клиент

Файл: `src/shared/api/http-client.ts`.

- Базовый адрес: `env.apiBaseUrl`.
- Если в Zustand есть access-токен — заголовок `Authorization: Bearer …`.
- Ответ **401**: одна попытка обновить пару токенов через `POST /api/auth/refresh` с телом `{ refresh_token }`; при успехе повтор запроса; при ошибке — очистка сессии (`useAuthStore.clearAuth()`), сброс кэша запросов, переход на `/login`.
- Запросы к `/api/auth/login`, `/api/auth/register`, `/api/auth/logout` и сам `/api/auth/refresh` выведены из общего цикла повтора после refresh.
- Refresh-токен хранится отдельно от persist-состояния стора в ключе `localStorage["web_refresh_token"]` (см. `shared/lib/refresh-token-storage.ts`). При гидратации стора legacy-значение из persist подхватывается и переносится в выделенный ключ.
- Multipart-запросы (создание квеста) идут с `FormData` — Axios сам выставит `Content-Type` с boundary.

## Пути, которые вызывает этот клиент

### Авторизация

`src/features/auth/api/auth-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| POST | `/api/auth/login` | Вход (email, password) → `access_token` + `refresh_token` + `user` |
| POST | `/api/auth/register` | Регистрация (email, username, password, birthdate) |
| POST | `/api/auth/refresh` | Обновление пары токенов |
| GET | `/api/auth/me` | Текущий пользователь |
| PATCH | `/api/auth/me` | Обновление профиля (username?, birthdate?) |
| POST | `/api/auth/logout` | Логаут (refresh_token) |

### Квесты

`src/features/quests/api/quests-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/quests` | Опубликованные квесты + фильтры (city, difficulties[], min/max duration, nearLat/nearLng, limit, offset) |
| GET | `/api/quests/my` | Свои квесты (черновики, на модерации, опубликованные, отклонённые) |
| GET | `/api/quests/favorites` | Избранное |
| GET | `/api/quests/{id}` | Детальная карточка квеста с чекпоинтами |
| POST | `/api/quests` | Создание квеста (multipart: title, description, location, difficulty, duration_minutes, image, points JSON, rules_and_warnings?) |
| DELETE | `/api/quests/{id}` | Удаление своего квеста |
| PATCH | `/api/quests/{id}/status` | Смена статуса (`published` ↔ `archived`) |
| POST | `/api/quests/{id}/complaints` | Жалоба на квест (reason) |
| POST | `/api/quests/{id}/favorite` | Добавить в избранное |
| DELETE | `/api/quests/{id}/favorite` | Убрать из избранного |

### Прохождение

`src/features/quest-run/api/quest-run-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| POST | `/api/quest-runs` | Старт квеста (`quest_id`) |
| GET | `/api/quest-runs/active` | Активная сессия (или `null`) |
| POST | `/api/quest-runs/active/answer` | Отправка ответа на текущий чекпоинт |
| POST | `/api/quest-runs/active/abandon` | Прервать прохождение |
| GET | `/api/quest-runs/history` | История пройденных квестов |

### Командное прохождение

`src/features/team-quest-run/api/team-quest-run-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/team-quest-runs/active` | Активный командный ран (или `null`/404). Поллится: 1 с в `waiting_for_team`/`starting`, 2 с в `in_progress`. |
| PATCH | `/api/team-quest-runs` | Подтвердить или отменить готовность к квесту: `{quest_id, is_ready}`. Первый `is_ready: true` создаёт `TeamQuestRunModel` со статусом `waiting_for_team`. Когда готовы все участники команды (≥2) — статус переходит в `starting`, через ~5с — в `in_progress`. |
| POST | `/api/team-quest-runs/active/checkpoints/{checkpointId}/answer` | Ответ на чекпоинт. Любой участник может ответить на любой чекпоинт; ответ сравнивается без регистра/пунктуации. В `progress.checkpoints[].completed_by_user_id` фиксируется автор. |

Подробный flow и важные нюансы (5-секундная задержка через `starts_at`, кик/выход из команды во время рана, очки) — см. [`team-quests.md`](../../team-quests.md) в корне репозитория.

### Команды

`src/features/teams/api/teams-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| POST | `/api/teams` | Создать команду (name, description) |
| GET | `/api/teams/me` | Моя команда |
| POST | `/api/teams/join` | Присоединиться по коду |
| POST | `/api/teams/leave` | Выйти из команды |
| DELETE | `/api/teams/members/{memberId}` | Кикнуть участника (только создатель) |

### Рейтинг

`src/features/leaderboard/api/leaderboard-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/rating/users` | Рейтинг игроков с позицией текущего пользователя |
| GET | `/api/rating/teams` | Рейтинг команд с позицией команды текущего пользователя |

### Достижения

`src/features/achievements/api/achievements-service.ts`

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/achievements` | Каталог достижений (limit=100) |
| GET | `/api/achievements/me` | Полученные достижения текущего пользователя |

### Файлы

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/file/{fileId}` | Картинки квестов и достижений (см. `entities/quest/lib/cover-image.ts`, `entities/achievement/lib/image.ts`) |

Обложки квестов без своего файла подставляются через `https://picsum.photos/…`.

## Пагинация

Описана в `src/shared/api/pagination.ts`. По умолчанию `limit=10`, `offset` рассчитывается из количества загруженных элементов. Для бесконечных списков есть `fetch-all-next-pages.ts` и компонент `infinite-list-footer.tsx`.

## Ошибки

Класс `ApiError` (см. `src/shared/api/http-client.ts`): сообщение собирается из поля `detail` ответа (строка или массив с `msg`), иначе используется `message` ответа или текст оси axios. Для специальных сценариев есть подклассы — например, `ModeratorNotAllowedError` (HTTP 403) для попытки модератора зайти в пользовательскую панель.
