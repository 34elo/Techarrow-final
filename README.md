# ГеоВызов

Платформа городских квестов с геолокацией. Игроки проходят чекпоинты по карте соло или командой, набирают очки в общем рейтинге и создают свои маршруты. Модераторы проверяют контент через отдельную панель.

Монорепозиторий из трёх независимых частей: REST-бэкенд, две Next.js-панели (web для игроков, admin для модераторов) и Flutter-приложение для мобильных платформ.

## Демо

| Площадка                       | Ссылка                                  |
| ------------------------------ | --------------------------------------- |
| Пользовательская панель (web)  | <https://example.com>                   |
| Панель модерации (admin)       | <https://admin.example.com>             |
| Backend API + Swagger UI       | <https://api.example.com/docs>          |
| Мобильное приложение (APK)     | <https://example.com/app.apk>           |

> Ссылки — заглушки. Подмените на реальные домены, как только задеплоите.

### Демо-аккаунты

#### Для жюри

Готовая учётка модератора для проверки админ-панели:

| Роль      | Логин       | Пароль     | Где работает     |
| --------- | ----------- | ---------- | ---------------- |
| Модератор | `moderator` | `demo123`  | `frontend/admin` |

#### Моковые данные для разработки

Дополнительный набор аккаунтов создаётся скриптом `python backend/create_mock_data.py`. Пароль для всех — `11111111` (можно переопределить флагом `--password`).

| Роль       | Email                          | Пароль     | Где работает              |
| ---------- | ------------------------------ | ---------- | ------------------------- |
| Модератор  | `mock.moderator@example.com`   | `11111111` | `frontend/admin`          |
| Игрок      | `mock.alisa@example.com`       | `11111111` | `frontend/web`, `mobile`  |
| Игрок      | `mock.boris@example.com`       | `11111111` | `frontend/web`, `mobile`  |
| Игрок      | `mock.vika@example.com`        | `11111111` | `frontend/web`, `mobile`  |
| Игрок      | `mock.denis@example.com`       | `11111111` | `frontend/web`, `mobile`  |
| Игрок      | `mock.elena@example.com`       | `11111111` | `frontend/web`, `mobile`  |

Игроки уже состоят в командах и имеют пройденные квесты — удобно для проверки рейтинга, командных ранов и истории. Кросс-роли запрещены: модератор не пустит в `web`/`mobile`, игрок не пустит в `admin` — клиент сразу редиректит на `/access_denied`.

Сбросить и пересоздать моковые данные — `python backend/create_mock_data.py --reset-mock`.

## Структура


| Каталог                               | Что это                                      | Стек                                                 |
| ------------------------------------- | -------------------------------------------- | ---------------------------------------------------- |
| `[backend/](./backend)`               | REST API, БД, файловое хранилище             | FastAPI · PostgreSQL+PostGIS · Redis · MinIO         |
| `[frontend/web/](./frontend/web)`     | Пользовательская панель в браузере (`:3000`) | Next.js 16 · React 19 · TanStack Query · MapLibre GL |
| `[frontend/admin/](./frontend/admin)` | Панель модерации (`:3001`)                   | Next.js 16 · React 19 · TanStack Query               |
| `[mobile/](./mobile)`                 | Мобильное приложение для игроков             | Flutter · Chopper · `flutter_map` · `pedometer`      |


Каждая часть — самостоятельный проект со своим репозиторием в `.git`, своим `Dockerfile` (где применимо) и своим README. Все клиенты ходят в один backend.

## Возможности

- **Каталог квестов** с фильтрами по городу, сложности, длительности, поиском и геопоиском «рядом со мной».
- **Прохождение** соло и в команде до 6 человек: чекпоинты на карте с кодовым словом или вариантами ответа, подсказки, таймер старта команды (5 с после готовности всех).
- **Создание квестов** с маркерами на карте, обложкой в S3 и валидацией (≥3 чекпоинта). Каждый квест проходит модерацию.
- **Команды** с 12-символьным инвайт-кодом и QR, кик участников, командный рейтинг.
- **Рейтинги и достижения** в профиле, история прохождений, экспорт квеста в PDF.
- **Изоляция ролей**: `user` ходит во `frontend/web` и `mobile`, `moderator` — только в `frontend/admin`. Авторитетный контроль ролей — на backend.

## Быстрый старт

```bash
# 1. Backend (API + Postgres + Redis + MinIO)
cd backend
cp .env .env.local           # либо отредактируйте существующий
docker compose up -d --build
# API → http://localhost:8000, Swagger → /docs, Adminer → :8081, MinIO → :9001

# 2. Frontend (web + admin одной командой)
cd ../frontend
cp .env.example .env
docker compose up -d --build
# Web → http://localhost:3000, Admin → http://localhost:3001

# 3. Mobile
cd ../mobile
cp .env.example .env
flutter pub get
make gen-swag
flutter run
```

Демо-данными можно наполнить БД скриптом `python backend/create_mock_data.py`.

## Авторизация

JWT с access (15 мин) и refresh (7 дней) токенами. Refresh-токены хранятся в Redis и могут быть отозваны (logout). У пользователя ровно одна роль: `user` или `moderator`.

- Регистрация обычного пользователя — через `/api/auth/register` (web и mobile).
- Модераторов заводит backend (`/api/auth/register/moderator`) — фронтенд админки регистрацию не показывает.
- Каждый клиент имеет собственное хранилище токенов с уникальными ключами, чтобы сессии web/admin/mobile не пересекались.

## Документация


| Раздел                                         | Файл                                                                                                                                           |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Backend — README, архитектура, окружение и API | `[backend/README.md](./backend/README.md)`, `[backend/docs/](./backend/docs)`                                                                  |
| Frontend (общий) — обзор, запуск, контракт API | `[frontend/README.md](./frontend/README.md)`                                                                                                   |
| Frontend web — пользовательская панель         | `[frontend/web/README.md](./frontend/web/README.md)`, `[frontend/web/docs/](./frontend/web/docs)`                                              |
| Frontend admin — панель модерации              | `[frontend/admin/README.md](./frontend/admin/README.md)`, `[frontend/admin/docs/](./frontend/admin/docs)`                                      |
| Mobile — Flutter-приложение                    | `[mobile/README.md](./mobile/README.md)`, `[mobile/docs/](./mobile/docs)`                                                                      |
| Командные квесты — backend-флоу                | `[mobile/team-quests.md](./mobile/team-quests.md)`                                                                                             |
| Контракт REST                                  | Swagger UI бекенда `/docs`, `[frontend/openapi.json](./frontend/openapi.json)`, `[mobile/openapi/swagger.json](./mobile/openapi/swagger.json)` |


## Карта зависимостей

```
                ┌──────────────────────────────┐
                │         backend (API)        │пш
                │  FastAPI + Postgres + Redis  │
                │            + MinIO           │
                └──────────────┬───────────────┘
                               │ REST (JWT)
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
┌───────┴────────┐   ┌─────────┴─────────┐   ┌────────┴────────┐
│ frontend/web   │   │  frontend/admin   │   │     mobile      │
│  role=user     │   │ role=moderator    │   │   role=user     │
│  Next.js 16    │   │   Next.js 16      │   │   Flutter       │
└────────────────┘   └───────────────────┘   └─────────────────┘
```

Контракт API един для всех клиентов: один и тот же `openapi.json` лежит во `frontend/` (общий для web и admin) и в `mobile/openapi/swagger.json`. При изменении API:

1. Перегенерируйте `openapi.json` из FastAPI.
2. Обновите файл во `frontend/` и `mobile/openapi/`.
3. В `mobile/` запустите `make gen-swag` — пересоберётся типизированный Chopper-клиент.

