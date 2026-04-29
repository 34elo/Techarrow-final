# Архитектура (admin)

[Feature-Sliced Design](https://feature-sliced.design/): зависимости сверху вниз, нижний слой не знает о вышестоящих.

## Слои

| Слой | Каталог | Что внутри |
|---|---|---|
| App | `src/app` | Роутинг, корневой `layout`, `providers`, `globals.css`, общие `error.tsx` / `not-found.tsx` / `access_denied/page.tsx` |
| Widgets | `src/widgets` | `panel-layout`, `panel-header`, `quest-detail` (обложка, общая инфо, чекпоинты) |
| Features | `src/features` | `auth` (логин и гард), `nav-tabs`, `quests` (очередь модерации, карточка), `reports` (жалобы), `reject` (диалог отказа с причиной) |
| Entities | `src/entities` | `user`, `quest`, `report` |
| Shared | `src/shared` | Axios-клиент, env, UI-kit (shadcn/ui + Radix), Zustand-стор, TanStack Query helpers, i18n, `refresh-token-storage` |

Алиас импортов: `@/*` → `src/*`.

## Маршруты

| Группа | Гард | Роуты |
|---|---|---|
| `(auth)` | `GuestGuard` (если залогинен — на `/`) | `/login` |
| `(dashboard)` | `AuthGuard` (роль `moderator`) | `/`, `/quests`, `/quests/[id]`, `/reports` |
| Корневые | — | `/access_denied`, `/error.tsx`, `/not-found.tsx` |

## Данные

- **Сервер:** TanStack Query, хуки рядом с фичами; запросы через `shared/api/http-client`. Ключи кэша — `shared/lib/react-query/query-keys.ts`. Бесконечные списки используют `fetch-all-next-pages` и `infinite-list-footer`.
- **Авторизация:** `shared/store/auth-store.ts` (Zustand + persist), refresh-токен — `shared/lib/refresh-token-storage.ts`. Интерцепторы — `src/app/providers.tsx`.

## Авторизация и роли

В этой панели допускается только роль `"moderator"`. Защита трёхслойная:

1. `useLogin` ловит чужую роль, делает best-effort `POST /api/auth/logout` и бросает `NotModeratorError`. Страница логина редиректит на `/access_denied`.
2. `auth-store.setAuth/setUser` отбрасывает не-модератора.
3. `AuthGuard` при гидратации сверяет роль и при несовпадении вызывает `clearAuth()` + `router.replace("/access_denied")`.

Ключи `localStorage` намеренно отличаются от web-панели: `"admin-auth"` (persist-стор) и `"admin_refresh_token"` (refresh).

## UI

- Базовая раскладка — `widgets/panel-layout.tsx` + `widgets/panel-header.tsx`.
- Карточка квеста на `/quests/[id]` рендерится в две колонки на `lg+` (общая информация слева, чекпоинты справа), стекается на меньших экранах. Длинные ответы и описания корректно ломаются (`break-words` / `break-all` для mono) — см. `widgets/quest-detail/ui/quest-detail-checkpoints-card.tsx`.

## Локализация

`shared/i18n/translations.ts` — словари для `ru` (default), `en`, `fr`, `hi`. Провайдер — `shared/i18n/i18n-provider.tsx` (`t(key, params?)` с интерполяцией и плюрализацией для русского).

## Где смотреть в коде

- HTTP-клиент: `shared/api/http-client.ts`
- Стор авторизации: `shared/store/auth-store.ts`
- Гарды: `features/auth/ui/auth-guard.tsx`
- Сервисы API: `features/*/api/*-service.ts` (полный список — в [environment-and-api.md](./environment-and-api.md))
