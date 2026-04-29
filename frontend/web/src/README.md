# Каталог `src/`

| Слой | Папка | Назначение |
|---|---|---|
| App | `app` | Маршруты Next.js, провайдеры, глобальные стили, общие `error.tsx` / `not-found.tsx` |
| Widgets | `widgets` | Крупные UI-блоки страниц (`landing-page`, `quest-feed`, `quest-detail-page`, `guide-page`, `guide-fab` и т.д.) |
| Features | `features` | Сценарии: `auth`, `quests`, `quest-form`, `quest-run`, `team-quest-run`, `teams`, `leaderboard`, `profile`, `achievements`, `quest-favorites`, `checkpoint-builder` |
| Entities | `entities` | Доменные типы и хелперы (`quest`, `team`, `quest-run`, `team-quest-run`, `checkpoint`, `user`, `achievement`, `leaderboard`, `guide`) |
| Shared | `shared` | API-клиент, конфиг env, UI-kit, Zustand-сторы, TanStack Query helpers, i18n, MapLibre-обёртка, геолокация |

Подробнее: [docs/architecture.md](../docs/architecture.md), [README в корне](../../README.md).
