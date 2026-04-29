# Окружение и API

## Переменные

Источник: `src/settings.py` (`pydantic-settings`), шаблон: `.env.example` / готовый `.env`.

| Переменная | Обязательность | Назначение |
|---|---|---|
| `HOST` | Да | Адрес, на котором слушает Uvicorn (`0.0.0.0` в Docker) |
| `PORT` | Да | Порт API (по умолчанию `8000`) |
| `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_DATABASE` | Да | Подключение к Postgres (asyncpg). Hostname в Docker — имя сервиса `database` |
| `JWT_SECRET_KEY` | Да | Секрет для подписи JWT |
| `JWT_ALGORITHM` | Нет (по умолчанию `HS256`) | Алгоритм подписи |
| `JWT_ACCESS_TOKEN_EXPIRE_MINUTES` | Да | TTL access-токена |
| `JWT_REFRESH_TOKEN_EXPIRE_DAYS` | Да | TTL refresh-токена и одновременно TTL записи в Redis |
| `REDIS_HOST`, `REDIS_PORT`, `REDIS_DB`, `REDIS_PASSWORD` | Да | Подключение к Redis (refresh-токены) |
| `S3_HOST`, `S3_PORT`, `S3_ADMIN_PORT`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`, `S3_BUCKET` | Да | MinIO/S3-хранилище файлов |
| `S3_SECURE` | Нет (по умолчанию `false`) | HTTPS для MinIO |

`Settings.postgres_url`, `Settings.redis_url`, `Settings.s3_endpoint` — собираются автоматически из перечисленных полей.

## Авторизация в запросах

Все защищённые эндпоинты ждут заголовок `Authorization: Bearer <access_token>`. Токены выдаются `/api/auth/login`, `/api/auth/register`, `/api/auth/refresh`. Refresh-токен передаётся в теле, **не** в заголовке.

Роли: `user` (по умолчанию при регистрации) и `moderator`. Эндпоинты с пометкой **moderator** в таблицах ниже требуют `require_moderator` — иначе 403.

## Префикс

Все ресурсы смонтированы под `/api`. Каждый роутер из `src/api/<resource>/router.py` отвечает за один ресурс.

## Health check

| Метод | Путь | Auth | Назначение |
|---|---|---|---|
| GET | `/api/health_check` | — | Возвращает `{ "status": "ok" }` |

## Авторизация — `src/api/auth/router.py`

| Метод | Путь | Auth | Тело / параметры | Ответ |
|---|---|---|---|---|
| POST | `/api/auth/register` | — | `UserCreate` (email, username, password, birthdate) | `TokenPairResponse` |
| POST | `/api/auth/register/moderator` | — | `UserCreate` | `TokenPairResponse` (роль `moderator`) |
| POST | `/api/auth/login` | — | `LoginRequest` (email, password) | `TokenPairResponse` |
| POST | `/api/auth/refresh` | — | `RefreshTokenRequest` | `TokenPairResponse` |
| POST | `/api/auth/logout` | — | `RefreshTokenRequest` | `204` |
| GET | `/api/auth/me` | user/mod | — | `UserResponse` |
| PATCH | `/api/auth/me` | user/mod | `UserUpdate` (username?, birthdate?) | `UserResponse` |

`TokenPairResponse` содержит `access_token`, `refresh_token`, `user`. Refresh-токен сохраняется в Redis под ключом `auth:refresh:{user_id}` с TTL `JWT_REFRESH_TOKEN_EXPIRE_DAYS`.

## Квесты — `src/api/quests/router.py`

| Метод | Путь | Auth | Назначение |
|---|---|---|---|
| GET | `/api/quests` | optional | Опубликованные квесты (фильтры: `city`, `difficulties[]`, `min_duration_minutes`, `max_duration_minutes`, `near_latitude`, `near_longitude`, `search`, `limit`, `offset`) |
| GET | `/api/quests/my` | user | Свои квесты во всех статусах |
| GET | `/api/quests/favorites` | user | Избранное |
| GET | `/api/quests/{quest_id}` | optional | Детальная карточка с чекпоинтами |
| GET | `/api/quests/{quest_id}/export` | user | PDF-экспорт квеста (ReportLab, DejaVu для кириллицы) |
| POST | `/api/quests` | user | Создание (multipart: `title`, `description`, `location`, `difficulty`, `duration_minutes`, `points` JSON, `image`?, `rules_and_warnings`?). Сразу попадает в `on_moderation` |
| PATCH | `/api/quests/{quest_id}/status` | user (автор) | `archived` ↔ `published` для своих |
| DELETE | `/api/quests/{quest_id}` | user (автор) | Удаление своего квеста |
| POST | `/api/quests/{quest_id}/complaints` | user | Жалоба (`reason`) |
| POST | `/api/quests/{quest_id}/favorite` | user | Добавить в избранное |
| DELETE | `/api/quests/{quest_id}/favorite` | user | Убрать из избранного |

## Соло-прохождение — `src/api/quest_runs/router.py`

| Метод | Путь | Auth | Назначение |
|---|---|---|---|
| POST | `/api/quest-runs` | user | Старт (`quest_id`). 409, если уже идёт другой ран |
| GET | `/api/quest-runs/active` | user | Текущая сессия или `null` |
| POST | `/api/quest-runs/active/answer` | user | Ответ на текущий чекпоинт. Возвращает `{correct, progress, points_earned?}` |
| POST | `/api/quest-runs/active/abandon` | user | Прервать без очков |
| GET | `/api/quest-runs/history` | user | История с временем, очками и стартами |

## Командное прохождение — `src/api/team_quest_runs/router.py`

| Метод | Путь | Auth | Назначение |
|---|---|---|---|
| GET | `/api/team-quest-runs/active` | user | Активный командный ран команды или `null`/404. На каждом запросе сервис «лениво» переводит `starting → in_progress`, если `starts_at` уже прошёл |
| PATCH | `/api/team-quest-runs` | user | `{quest_id, is_ready}`. Первый `is_ready: true` создаёт `TeamQuestRunModel(waiting_for_team)`. Когда готовы все участники команды (≥2) — статус `starting`, `starts_at = now + 5s`. `is_ready: false` отменяет |
| POST | `/api/team-quest-runs/active/checkpoints/{checkpoint_id}/answer` | user | Ответ на любой чекпоинт. `completed_by_user_id` фиксирует автора |

Подробный flow и формула очков — в [`team-quests.md`](../../mobile/team-quests.md).

## Команды — `src/api/teams/router.py`

| Метод | Путь | Auth | Назначение |
|---|---|---|---|
| POST | `/api/teams` | user | Создать команду (`name`, `description`). 12-символьный инвайт-код в ответе |
| GET | `/api/teams/me` | user | Текущая команда или `null` |
| POST | `/api/teams/join` | user | Войти по `code`. Лимит — 6 участников |
| POST | `/api/teams/leave` | user | Выйти. Создатель не может выйти, пока в команде есть другие |
| DELETE | `/api/teams/members/{member_id}` | user (создатель) | Кикнуть участника |

## Рейтинг — `src/api/rating/router.py`

| Метод | Путь | Auth | Назначение |
|---|---|---|---|
| GET | `/api/rating/users` | user | Топ игроков, плюс позиция текущего пользователя (`limit`, `offset`) |
| GET | `/api/rating/teams` | user | Топ команд, плюс позиция текущей команды |

## Достижения — `src/api/achievements/router.py`

| Метод | Путь | Auth | Назначение |
|---|---|---|---|
| GET | `/api/achievements` | — | Каталог достижений (`limit`, `offset`) |
| GET | `/api/achievements/me` | user | Полученные текущим пользователем |
| POST | `/api/achievements/{achievement_id}/image` | moderator | Загрузить иконку (multipart `UploadFile`) |

## Модерация — `src/api/moderation/router.py`

Все эндпоинты — `require_moderator`.

| Метод | Путь | Назначение |
|---|---|---|
| GET | `/api/moderation/quests` | Очередь на модерации (те же фильтры, что и `/api/quests`) |
| POST | `/api/moderation/quests/{quest_id}/publish` | Перевод в `published` |
| POST | `/api/moderation/quests/{quest_id}/reject` | Отклонение с `reason` (запишется в `rejection_reason`) |
| DELETE | `/api/moderation/quests/{quest_id}` | Удалить квест |
| GET | `/api/moderation/complaints` | Список жалоб (`limit` 1–100, `offset`) |
| DELETE | `/api/moderation/complaints/{complaint_id}` | Закрыть жалобу |

## Файлы — `src/api/files/router.py`

| Метод | Путь | Auth | Назначение |
|---|---|---|---|
| GET | `/api/file/{file_id}` | — | Стримит файл из S3. `Content-Type` — из заголовка S3-объекта; `Content-Disposition: inline`. 404, если объекта нет |

Загрузка идёт через специализированные эндпоинты: обложка квеста — multipart в `POST /api/quests`, иконка достижения — `POST /api/achievements/{id}/image`. Имена объектов — `<uuid>.<ext>`, генерирует `MinioService.upload_file_with_uuid`.

## Пагинация

Большинство списков принимают `limit` (по умолчанию 10–20) и `offset`. Ответ содержит `items`, `total`, иногда `has_more` — конкретные поля смотрите в `src/schemes/<resource>.py`.

## Ошибки

Стандартный FastAPI-формат: `{ "detail": "..." }` для строковых ошибок и `{ "detail": [{"loc": [...], "msg": "...", "type": "..."}] }` для валидационных ошибок Pydantic. Клиенты собирают сообщение из `detail` (см. их `ApiError`).

Типичные коды:

- **401** — нет/просрочен `access_token`. Клиенту нужно дёрнуть `/api/auth/refresh`.
- **403** — роль не подходит (например, `user` пытается зайти в `/api/moderation/...`).
- **404** — ресурс не найден.
- **409** — конфликт состояния (например, попытка стартовать ран при уже активном).
- **422** — валидация Pydantic.
