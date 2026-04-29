# Архитектура (backend)

Слоистая структура FastAPI-приложения: `api → services → models/database`. Каждый слой знает только о нижестоящих.

## Слои

| Слой | Каталог | Что внутри |
|---|---|---|
| App | `src/app.py`, `main.py` | Сборка `FastAPI`, lifespan (init Postgres/Redis/MinIO), CORS-мидлварь, роутер `/api` |
| API | `src/api/<resource>/router.py` | HTTP-эндпоинты, валидация через Pydantic-схемы, зависимости авторизации, делегирование в сервисы |
| Schemes | `src/schemes/` | Pydantic-схемы (Request/Response, фильтры, пагинация) |
| Services | `src/services/` | Бизнес-логика, транзакции, агрегации, начисление очков и достижений |
| Models | `src/models/` | SQLAlchemy ORM, Enum-ы статусов, связи и каскадные удаления |
| Database | `src/database/` | Async-движок Postgres, фабрика сессий, Redis-клиент, базовый `Base`, типы |
| Core | `src/core/security.py` | JWT (access/refresh), хэширование паролей через `pwdlib` |
| Settings | `src/settings.py` | Чтение `.env` через `pydantic-settings` |

## Сборка приложения

`src/app.py` делает три вещи:

1. **Lifespan**: на старте инициализирует `AsyncPostgresClient`, `RedisClient`, `MinioService` (создаёт бакет, если нет). На остановке — закрывает их в обратном порядке.
2. **Роутер**: монтирует `/api` со всеми ресурсами (`auth`, `quests`, `quest-runs`, `team-quest-runs`, `teams`, `rating`, `achievements`, `moderation`, `file`).
3. **CORS**: `allow_origins=["*"]`, `allow_credentials=True` — пускает фронтенды и мобилку без явного списка.

При первом запуске `Base.metadata.create_all` создаёт все таблицы. Миграций нет — изменения схемы выкатываются пересборкой контейнера на пустой БД (на проде — через миграционный инструмент по выбору команды).

## База данных

PostgreSQL 16 + PostGIS (расширение включается через `docker/postgres/init-postgis.sql`). Все таблицы — в `src/models/`:

| Таблица | Модель | Назначение |
|---|---|---|
| `users` | `UserModel` | Пользователи и модераторы (`role` enum: `user` / `moderator`), `total_points` для рейтинга |
| `teams` | `TeamModel` | Команды до 6 человек, инвайт-код 12 символов |
| `quests` | `QuestModel` | Квест с `status` (`on_moderation` / `published` / `archived` / `rejected`), обложкой в S3, `rejection_reason` |
| `quest_points` | `QuestPointModel` | Чекпоинты квеста (lat/lng, текст, правильный ответ, подсказка) |
| `quest_runs` | `QuestRunModel` | Соло-прохождения, активная сессия и история |
| `quest_complaints` | `QuestComplaintModel` | Жалобы на квест от пользователей |
| `quest_favorites` | `QuestFavoriteModel` | Избранное по составному `(user_id, quest_id)` |
| `team_quest_runs` | `TeamQuestRunModel` | Командные раны (`waiting_for_team` → `starting` → `in_progress` → `completed`). Частичный уникальный индекс — одновременно один активный ран на команду |
| `team_quest_run_participants` | `TeamQuestRunParticipantModel` | Готовность каждого участника команды |
| `team_quest_run_checkpoints` | `TeamQuestRunCheckpointModel` | Прохождения чекпоинтов в команде с `completed_by_user_id` |
| `achievements`, `user_achievements` | `AchievementModel`, `UserAchievementModel` | Каталог достижений и факт получения |

Базовый класс — `src/database/base.py`. Тип первичного ключа `intpk` — в `src/database/data_types.py`. Сессия отдаётся через `Depends(create_session)` (`db_session.py:39`).

## Redis

`src/database/redis_session.py` инициализируется в lifespan. Используется для:

- **Refresh-токены**: `auth:refresh:{user_id}` со списком активных JTI и TTL равным `JWT_REFRESH_TOKEN_EXPIRE_DAYS`. Логаут удаляет конкретный JTI, refresh выдаёт новую пару и заменяет старый.

## S3 / MinIO

`src/services/minio.py` — обёртка над синхронным клиентом `minio` через `asyncio.to_thread`. Методы: `upload_file`, `upload_file_with_uuid` (генерирует имя `<uuid>.<ext>`), `delete_file`, `get_file_stream`. Бакет создаётся при инициализации, если отсутствует.

Файлы возвращаются клиенту через `GET /api/file/{file_id}` (см. [environment-and-api.md](./environment-and-api.md)).

## Авторизация и роли

JWT с двумя типами токенов (`src/core/security.py`):

- **Access** — короткоживущий (`JWT_ACCESS_TOKEN_EXPIRE_MINUTES`, по умолчанию 15 мин).
- **Refresh** — длинноживущий (`JWT_REFRESH_TOKEN_EXPIRE_DAYS`, по умолчанию 7 дней).

Полезная нагрузка: `sub` (user_id), `role`, `type` (`access` | `refresh`), `jti`, `iat`, `exp`. Алгоритм — `HS256`, секрет из `JWT_SECRET_KEY`.

Зависимости в `src/services/auth.py`:

| Зависимость | Поведение |
|---|---|
| `get_current_user` | Парсит `Authorization: Bearer …`, проверяет тип `access`, существование пользователя в БД. На ошибке — 401 |
| `get_current_user_optional` | То же, но возвращает `None` для гостя без 401 |
| `require_roles(*roles)` | Фабрика; пускает только указанные роли |
| `require_moderator` | `require_roles(UserRole.MODERATOR)` — для всех модерационных эндпоинтов |

Refresh-флоу: `POST /api/auth/refresh` принимает `refresh_token`, проверяет JTI в Redis, выдаёт новую пару (старый JTI отзывается). Логаут — `POST /api/auth/logout` — удаляет JTI из Redis.

## Командные раны

Полный flow и нюансы — в [`team-quests.md`](../../mobile/team-quests.md). Кратко:

- `PATCH /api/team-quest-runs {quest_id, is_ready: true}` — первый «готов» в команде создаёт `TeamQuestRunModel(status=waiting_for_team)`. Когда готовы все участники (≥2) — статус переходит в `starting`, ставится `starts_at = now + 5s`.
- Статус `starting → in_progress` переключается **лениво** — на каждый запрос `_advance_start_if_ready` сравнивает `starts_at` с текущим временем (`src/services/team_quest_runs.py`). Поэтому фронт поллит `/active` каждые 1–2 секунды.
- Чекпоинты можно решать в любом порядке. Любой участник отвечает за любой чекпоинт; `completed_by_user_id` фиксирует автора.
- При завершении: `points = difficulty * 100 + difficulty * 18000 / max(elapsed_seconds, 60)`. Очки начисляются **каждому** участнику. Создатель квеста и повторное прохождение — 0 очков.
- Частичный уникальный индекс `uq_team_quest_runs_one_active_per_team` гарантирует не более одного активного рана на команду.

## Соло-раны

`src/services/quest_runs.py`:

- `POST /api/quest-runs {quest_id}` — стартует, валидирует, что нет другой активной сессии у пользователя.
- `POST /api/quest-runs/active/answer {answer}` — нормализует строки (lowercase, удаление пунктуации, ё→е), сравнивает с `correct_answer` текущего чекпоинта. Очки и достижения начисляются на завершении.
- `POST /api/quest-runs/active/abandon` — закрывает сессию без очков.
- `GET /api/quest-runs/history` — список пройденных и заброшенных ранов.

## Модерация

Изолированный роутер `src/api/moderation/router.py`, все эндпоинты под `require_moderator`. Возможности:

- Очередь квестов в статусе `on_moderation` с теми же фильтрами, что и публичный список.
- `POST /publish` / `POST /reject {reason}` — переводят в `published` / `rejected`.
- `DELETE /quests/{id}` — удаление модератором (каскад — раны, чекпоинты, жалобы).
- Лента жалоб + удаление.

## Достижения

`src/services/achievements.py`:

- Каталог достижений описан декларативно в `src/data/achievements.json` и синхронизируется в БД при старте.
- После каждого завершённого рана сервис проверяет условия (количество пройденных квестов, суммарные очки, прохождение в команде, скорость и т. д.) и выдаёт новые `UserAchievementModel`.
- Иконки достижений — файлы в S3 (`POST /api/achievements/{id}/image`, доступно только модератору).

## Where to look

- HTTP-точки входа: `src/api/<resource>/router.py`.
- Бизнес-логика: `src/services/<resource>.py` (одноимённый файл с роутером).
- Pydantic-контракт: `src/schemes/<resource>.py`.
- ORM-модели: `src/models/<resource>.py`.
- Авторизационные зависимости: `src/services/auth.py` (`get_current_user`, `require_moderator`).
- HTTP/JWT-секьюрити: `src/core/security.py`.
