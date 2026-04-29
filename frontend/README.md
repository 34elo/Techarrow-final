# ГеоВызов

Платформа городских квестов с геолокацией. Игроки проходят чекпоинты по карте соло или командой, набирают очки в общем рейтинге и создают свои маршруты. Модераторы проверяют контент через отдельную панель.

> Этот репозиторий — **только frontend**. Backend поднимается отдельно; контракт API — в [`openapi.json`](./openapi.json).

Полная таблица — в [корневом README](../README.md#демо-аккаунты).

## Структура

| Папка | Что это | Порт |
|---|---|---|
| [`web/`](./web) | Пользовательская панель | `3000` |
| [`admin/`](./admin) | Панель модерации | `3001` |
| `docker-compose.yml` | Production-оркестрация | — |
| `docker-compose.dev.yml` | Dev-режим с hot-reload | — |
| `openapi.json` | Контракт REST API | — |

Каждое приложение — самостоятельный Next.js-пакет (свои `package.json`, lockfile, Dockerfile), оба ходят в один backend.

## Стек

Next.js 16 (App Router) · React 19 · TypeScript · TanStack Query · Zustand · Tailwind 4 · shadcn/ui · Axios · MapLibre GL (только web)

Архитектура обеих панелей — [Feature-Sliced Design](https://feature-sliced.design/): `app → widgets → features → entities → shared`. Локализация — `ru` (default), `en`, `fr`, `hi`.

## Возможности

- **Лендинг** на `/` с описанием и кнопками входа в приложение / скачивания.
- **Каталог квестов** на `/quests` с фильтрами и картой.
- **Прохождение** соло и командой (до 6 игроков): чекпоинты с кодовым словом или вариантами ответа, подсказки, таймер старта команды.
- **Создание квестов** с маркерами на карте, обложкой и валидацией (≥3 чекпоинта).
- **Команды** с инвайт-кодом и QR, кик участников, командный рейтинг.
- **Достижения и история** прохождений в профиле.
- **Гид** на `/guide` (как играть, этикет, советы, безопасность) — доступен с плавающей кнопки `?` на любом экране.
- **Изоляция ролей**: web и admin — отдельные SPA с независимыми ключами `localStorage`; токены не мигрируют между панелями. Авторитетный контроль ролей — на backend.

## Запуск

Нужны **Docker** или **Node.js 20+ / pnpm 10** (`corepack enable && corepack prepare pnpm@10 --activate`).

### Docker Compose

```bash
cp .env.example .env             # один раз; правьте под себя
docker compose build
docker compose up -d
```

- Web → <http://localhost:3000>
- Admin → <http://localhost:3001>

Hot-reload в контейнере:

```bash
docker compose -f docker-compose.dev.yml up --build
```

`.env` в корне — единственный источник переменных (`NEXT_PUBLIC_API_URL`, `WEB_PORT`, `ADMIN_PORT`). `NEXT_PUBLIC_*` запекается в бандл на этапе сборки — после правки делайте `docker compose build`.

### Локально

```bash
cd web        # или admin
cp .env.example .env
pnpm install
pnpm dev
```

## Документация

| Раздел | Файл |
|---|---|
| Пользовательская панель | [`web/README.md`](./web/README.md) |
| Архитектура web (FSD, маршруты, авторизация, командные квесты, карты) | [`web/docs/architecture.md`](./web/docs/architecture.md) |
| HTTP-клиент и пути API (web) | [`web/docs/environment-and-api.md`](./web/docs/environment-and-api.md) |
| Панель модерации | [`admin/README.md`](./admin/README.md) |
| Архитектура admin | [`admin/docs/architecture.md`](./admin/docs/architecture.md) |
| HTTP-клиент и пути API (admin) | [`admin/docs/environment-and-api.md`](./admin/docs/environment-and-api.md) |
| Командные квесты — backend-флоу | [`team-quests.md`](./team-quests.md) |
| Контракт REST API | [`openapi.json`](./openapi.json) |
