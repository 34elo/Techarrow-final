# Архитектура (web)

[Feature-Sliced Design](https://feature-sliced.design/): зависимости сверху вниз, нижний слой не знает о вышестоящих.

## Слои

| Слой | Каталог | Что внутри |
|---|---|---|
| App | `src/app` | Роутинг Next.js, корневой `layout`, `providers`, `globals.css`, публичный `page.tsx` (лендинг), общие `error.tsx` / `not-found.tsx` / `access_denied/page.tsx` |
| Widgets | `src/widgets` | `landing-page`, `quest-feed`, `quest-detail-page`, `quest-create-page`, `quest-run-page`, `team-quest-run-page`, `my-quests-page`, `recent-quests-page`, `leaderboard-page`, `team-page`, `profile-page`, `achievements-page`, `guide-page`, `guide-fab` (плавающая «?»), `main-layout`, `main-header`, `bottom-nav`, `quest-map-modal` |
| Features | `src/features` | `auth`, `quests`, `quest-form`, `quest-run`, `team-quest-run`, `quest-favorites`, `checkpoint-builder`, `teams`, `leaderboard`, `profile`, `achievements` |
| Entities | `src/entities` | `user`, `quest` (+ `lib/recently-viewed.ts`), `quest-run`, `team-quest-run`, `checkpoint`, `team`, `leaderboard`, `achievement`, `guide` |
| Shared | `src/shared` | Axios-клиент, env, UI-kit (shadcn/ui + Radix), Zustand-стор авторизации, TanStack Query helpers, i18n, MapLibre-обёртка, `use-geolocation`, `refresh-token-storage` |

Алиас импортов: `@/*` → `src/*`.

## Маршруты

| Путь | Гард | Экран |
|---|---|---|
| `/` | — | Публичный лендинг с CTA в приложение и на скачивание |
| `/login`, `/register` | `GuestGuard` (если залогинен — на `/quests`) | Формы входа и регистрации |
| `/quests` | `AuthGuard` (роль `user`) | Лента квестов |
| `/quests/[id]` | `AuthGuard` | Карточка квеста, старт прохождения |
| `/quests/[id]/run`, `/quests/[id]/team-run` | `AuthGuard` | Соло- и командное прохождение |
| `/quests/my`, `/quests/new`, `/quests/favorites` | `AuthGuard` | Свои квесты, создание, избранное |
| `/leaderboard`, `/team`, `/profile`, `/profile/achievements`, `/profile/history`, `/profile/recent` | `AuthGuard` | Рейтинг, команда, профиль и его подразделы |
| `/guide` | `AuthGuard` | Короткий справочник (как играть, этикет, советы, безопасность, создание) |
| `/access_denied` | — | Единая страница 403 |

`AuthGuard` проверяет роль `user`; не-юзера сбрасывает на `/access_denied`. `GuestGuard` редиректит залогиненных на `/quests`.

## Данные

- **Сервер:** TanStack Query, хуки рядом с фичами; запросы через `shared/api/http-client`. Ключи кэша — `shared/lib/react-query/query-keys.ts`. Бесконечные списки используют `fetch-all-next-pages` и `infinite-list-footer`.
- **Авторизация:** `shared/store/auth-store.ts` (Zustand + persist), refresh-токен — отдельным ключом в `shared/lib/refresh-token-storage.ts`. Интерцепторы — `src/app/providers.tsx`.

## Авторизация и роли

В этой панели допускается только роль `"user"`. Защита трёхслойная:

1. `useLogin` ловит чужую роль, делает best-effort `POST /api/auth/logout` и бросает `ModeratorNotAllowedError`. Страница логина редиректит на `/access_denied`.
2. `auth-store.setAuth/setUser` отбрасывает любого не-юзера — даже если стор позовут в обход хука или в `localStorage` останется stale-сессия.
3. `AuthGuard` при гидратации сверяет роль и при несовпадении вызывает `clearAuth()` + `router.replace("/access_denied")`.

Ключи `localStorage` намеренно отличаются от админ-панели: `"auth"` (persist-стор) и `"web_refresh_token"` (refresh).

## Командные квесты

Полный backend-контракт — в [`team-quests.md`](../../team-quests.md).

- **Состояния** (`entities/team-quest-run/model/types.ts`): `waiting_for_team → starting → in_progress → completed`. Backend создаёт `TeamQuestRunModel` сам — при первом `PATCH /api/team-quest-runs {is_ready: true}`.
- **Поллинг** (`model/use-team-quest-run.ts`): 1с в `waiting`/`starting`, 2с в `in_progress`, 0 в `completed`. `refetchOnWindowFocus: true`. Поллит только активная страница; баннер живёт на cache-hit.
- **Старт без задержки**: `widgets/team-quest-run-page/ui/team-countdown-card.tsx` по достижении 0 секунд однократно инвалидирует `queryKeys.teamQuestRun.active()` — не ждём следующего тика.
- **Тосты** (`model/use-team-run-notifications.ts`): сравнивает прошлый и новый снапшот рана, тостит при смене статуса и при ответе тиммейта на чекпоинт.
- **UI**: `TeamReadinessCard`, `TeamCountdownCard` (5-сек), `TeamCheckpointItem`, `TeamRunMapCard`, `TeamRunSummaryCard`. Запуск из `quest-detail-actions.tsx` (диалог выбора режима соло/команда).

## Карты и геолокация

- `shared/ui/map/maplibre-map.tsx` — растровый стиль OpenStreetMap (3 SD-CDN endpoints), маркеры (`default` / `active` / `passed`), label с номером, popup, picker-режим, отображение позиции пользователя с кругом точности.
- `shared/lib/geolocation/use-geolocation.ts` — обёртка над `navigator.geolocation` (one-shot и `watchPosition`), маппинг ошибок на i18n-ключи. SSR-safe.

## Локализация

`shared/i18n/translations.ts` — словари для `ru` (default), `en`, `fr`, `hi`. Провайдер — `shared/i18n/i18n-provider.tsx` (`t(key, params?)` с интерполяцией и плюрализацией для русского, см. `plural.ts`).

Провайдер стартует с `defaultLocale` и подтягивает сохранённый язык в `useEffect` после монтирования — это держит SSR HTML и первый клиентский рендер в синхроне (важно для публичного лендинга, который рендерится без `AuthGuard`-обёртки).

## Где смотреть в коде

- HTTP-клиент: `shared/api/http-client.ts`
- Стор авторизации: `shared/store/auth-store.ts`
- Гарды: `features/auth/ui/auth-guard.tsx`, `features/auth/ui/guest-guard.tsx`
- Сервисы API: `features/*/api/*-service.ts` (полный список — в [environment-and-api.md](./environment-and-api.md))
