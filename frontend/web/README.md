# Web — пользовательская панель ГеоВызов

Каталог квестов, прохождение чекпоинтов с геолокацией (соло и командой), создание собственных квестов с модерацией, рейтинг и достижения. Next.js 16 + React 19 + TanStack Query + Tailwind + shadcn/ui + MapLibre GL поверх OpenStreetMap.

Backend поднимается отдельно и должен быть доступен по `NEXT_PUBLIC_API_URL`. Локально по умолчанию `http://localhost:8000`; на развёрнутом стенде — `https://api.tarr.ssrit.xyz`.

## Запуск

```bash
cp .env.example .env
pnpm install
pnpm dev
```

Откройте <http://localhost:3000>. Через Docker запускается из корня — см. [главный README](../README.md#запуск).

## Скрипты

| Команда | Назначение |
|---|---|
| `pnpm dev` | Dev-сервер с hot-reload |
| `pnpm build` | Production-сборка |
| `pnpm start` | Запуск собранного приложения |
| `pnpm lint` | ESLint |
| `pnpm format` | Prettier (write) |
| `pnpm format:check` | Prettier (check) |

## Регистрация

Аккаунт обычного пользователя создаётся через `/register` (email, никнейм, дата рождения, пароль ≥ 8 символов). Аккаунт с ролью `moderator` в этой панели не работает — после логина клиент отзывает токен и редиректит на `/access_denied`. Модераторы заходят в [админ-панель](../admin).

## Дальше

- [Архитектура](./docs/architecture.md) — FSD-слои, маршруты, авторизация, командные квесты, карты, локализация.
- [Окружение и API](./docs/environment-and-api.md) — HTTP-клиент, переменные, полный список путей API.
- [Контракт REST](../openapi.json), [командные квесты — backend-флоу](../team-quests.md).
