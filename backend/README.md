# Backend — ГеоВызов

REST API платформы городских квестов. Авторизация по JWT, хранение прогресса, командные раны с readiness-механикой, файлы в S3, кэш и refresh-токены в Redis.

> Этот репозиторий — **только backend**. Клиенты (web, admin, mobile) поднимаются отдельно и ходят сюда по базовому URL API: локально `http://<host>:8000`, на стенде — `https://api.tarr.ssrit.xyz`. Контракт API — Swagger UI на `/docs` (например <https://api.tarr.ssrit.xyz/docs>), машинно-читаемая схема — `/openapi.json`.

## Стек

FastAPI 0.136 · Python 3.13 · SQLAlchemy 2 (async, asyncpg) · PostgreSQL 16 + PostGIS · Redis 7 · MinIO (S3) · Pydantic v2 · PyJWT · ReportLab (PDF-экспорт)

## Структура

| Каталог | Что внутри |
|---|---|
| `main.py` | Точка входа Uvicorn |
| `src/app.py` | Сборка `FastAPI`-приложения, lifespan (Postgres/Redis/MinIO), CORS |
| `src/settings.py` | `pydantic-settings` — единый источник конфигурации из `.env` |
| `src/api/` | HTTP-роутеры, по одной папке на ресурс |
| `src/services/` | Бизнес-логика (quest, quest_runs, team_quest_runs, auth, rating, achievements, …) |
| `src/schemes/` | Pydantic-схемы запросов и ответов |
| `src/models/` | SQLAlchemy-модели и Enum-ы статусов |
| `src/database/` | Базовый класс, типы, async-сессии Postgres/Redis |
| `src/core/security.py` | JWT (access/refresh), хэширование паролей |
| `src/data/` | Статичные данные (каталог достижений) |
| `docker/postgres/` | `init-postgis.sql` — включение расширения PostGIS |
| `docker-compose.yml` | api + database + redis + minio + adminer |
| `Dockerfile` | Прод-образ Python 3.13 + DejaVu для PDF |
| `create_mock_data.py` | Скрипт наполнения БД демо-данными |

## Запуск

Нужны **Docker** или **Python 3.13** (локально + поднятые Postgres / Redis / MinIO).

### Docker Compose

```bash
cp .env.example .env             # заполните секреты
docker compose up -d --build
```

- API → <http://localhost:8000>
- Swagger UI → <http://localhost:8000/docs>
- Adminer (Postgres GUI) → <http://localhost:8081>
- MinIO Console → <http://localhost:9001>

При первом запуске `Base.metadata.create_all` создаст все таблицы автоматически. Миграций нет.

### Локально

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python main.py
```

Перед стартом поднимите Postgres + Redis + MinIO (например, `docker compose up database redis minio -d`) и выставьте переменные окружения в `.env`.

### Демо-данные

```bash
python create_mock_data.py
```

Скрипт создаёт моковых пользователей, команды, квесты, достижения. Удобно для прогона UI без ручного наполнения.

## Документация

| Раздел | Файл |
|---|---|
| Архитектура (слои, БД-схема, авторизация, командные раны) | [`docs/architecture.md`](./docs/architecture.md) |
| Переменные окружения и полный список путей API | [`docs/environment-and-api.md`](./docs/environment-and-api.md) |
| Командные квесты — детальный flow | [`team-quests.md`](../mobile/team-quests.md) (общий с фронтом) |
| Контракт REST | Swagger UI: локально `/docs`, на стенде <https://api.tarr.ssrit.xyz/docs>; машинная схема — `frontend/openapi.json` |
