# Admin — панель модерации ГеоВызов

Очередь квестов на модерацию, одобрение и отклонение с причиной, обработка жалоб. Next.js 16 + React 19 + TanStack Query + Tailwind + shadcn/ui.

Backend поднимается отдельно и должен быть доступен по `NEXT_PUBLIC_API_URL` (по умолчанию `http://localhost:8000`).

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

## Демо-аккаунт

Учётка модератора создаётся на стороне backend с ролью `moderator`. Регистрация в этой панели отсутствует — модераторов заводит backend.

| Поле | Значение |
|---|---|
| Email | `moderator` |
| Пароль | `demo123` |

Аккаунт с ролью `user` в этой панели не работает — клиент отзывает токен и редиректит на `/access_denied`.

## Дальше

- [Архитектура](./docs/architecture.md) — FSD-слои, маршруты, авторизация.
- [Окружение и API](./docs/environment-and-api.md) — HTTP-клиент, переменные, пути API.
- [Контракт REST](../openapi.json).
