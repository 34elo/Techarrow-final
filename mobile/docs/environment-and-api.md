# Окружение и API

## Переменные

Источник: `lib/services/api.dart` (`ApiService.baseUrl`), шаблон: [`.env.example`](../.env.example).

| Переменная | Обязательность | Поведение |
|---|---|---|
| `API_BASE_URL` | Нет | Базовый URL API. Если не задано или `.env` не загружен — `http://localhost:8000`. |

`.env` подключён в `pubspec.yaml` как asset и читается на старте через `flutter_dotenv`. На устройстве переменные **запекаются в bundle** на этапе сборки — пересоберите приложение после изменения значения.

При работе на эмуляторе Android backend на хосте доступен по `http://10.0.2.2:8000`. На iOS-симуляторе — `http://localhost:8000`. На реальном устройстве — IP машины, на которой поднят backend.

## HTTP-клиент

Файл: `lib/services/api.dart`.

- Синглтон `ApiService.instance`. Инициализируется в конструкторе `StreamAuth` — после рантайма `main()` клиент уже готов.
- Базовый клиент — `Swagger.create(...)` (Chopper, генерируется из `openapi/swagger.json`).
- `AuthInterceptor` подкладывает `Authorization: Bearer <access_token>` ко всем запросам.
- При ответе **401** на не-`/api/auth/*` пути делает single-flight рефреш через `POST /api/auth/refresh` и повторяет исходный запрос с заголовком `x-auth-retry: 1`. Повторно ретраить тот же запрос не будет.
- Refresh-токен и user-данные хранятся в `flutter_secure_storage` (ключи `ACCESS_TOKEN`, `REFRESH_TOKEN`, `user_data`).
- Multipart-запрос на создание квеста (`createQuest`) и список квестов (`getQuests`) реализованы поверх `package:http` напрямую — Chopper не подходит для динамических form-полей и query-массивов.

## Где живут вызовы API

| Файл | Что использует |
|---|---|
| `lib/services/auth.dart` | `apiAuthLoginPost`, `apiAuthRegisterPost`, `apiAuthLogoutPost`, `apiAuthRefreshPost`, `apiAuthMeGet` |
| `lib/services/api.dart` | `createQuest`, `getQuests` (multipart и кастомная пагинация) |
| `lib/services/quest.dart` | `apiQuestRunsActiveGet`, `apiQuestRunsHistoryGet`, `apiQuestsQuestIdGet`, `apiTeamQuestRunsActiveGet` |
| `lib/screens/index_screen/pages/main.dart` | Каталог квестов, добавление в избранное |
| `lib/screens/index_screen/pages/favourite.dart` | `apiQuestsFavoritesGet` |
| `lib/screens/index_screen/leaderboard_pages/*.dart` | `apiRatingUsersGet`, `apiRatingTeamsGet` |
| `lib/screens/index_screen/team_pages/*.dart` | `apiTeamsPost`, `apiTeamsMeGet`, `apiTeamsJoinPost`, `apiTeamsLeavePost` |
| `lib/screens/quest_data/*.dart` | `apiQuestsQuestIdGet`, `apiQuestsQuestIdFavoritePost/Delete`, `apiTeamQuestRunsPatch` |
| `lib/screens/current_quest_screen/screen.dart` | `apiQuestRunsActiveAnswerPost`, `apiQuestRunsActiveAbandonPost`, командные ответы |
| `lib/screens/quest_history_screen/screen.dart` | `apiQuestRunsHistoryGet` |
| `lib/screens/achievements_screen/screen.dart` | `apiAchievementsGet`, `apiAchievementsMeGet` |
| `lib/screens/edit_user_screen/screen.dart` | `apiAuthMePatch` |
| `lib/screens/quest_creation/*.dart` | `ApiService.createQuest`, `apiQuestsMyGet`, `apiQuestsQuestIdDelete`, `apiQuestsQuestIdStatusPatch`, `apiQuestsQuestIdExportGet` |

## Используемые пути

Полная схема — в [`openapi/swagger.json`](../openapi/swagger.json) и в [бекенд-документации](../../backend/docs/environment-and-api.md). Ниже — то, что приложение реально дёргает.

### Авторизация

| Метод | Путь | Назначение |
|---|---|---|
| POST | `/api/auth/login` | Вход (email, password) → `access_token` + `refresh_token` + `user` |
| POST | `/api/auth/register` | Регистрация (email, username, password, birthdate) |
| POST | `/api/auth/refresh` | Обновление пары токенов |
| POST | `/api/auth/logout` | Логаут (refresh_token) |
| GET | `/api/auth/me` | Текущий пользователь |
| PATCH | `/api/auth/me` | Обновление профиля (username?, birthdate?) |

### Квесты

| Метод | Путь | Назначение |
|---|---|---|
| GET | `/api/quests` | Каталог + фильтры (`city`, `difficulties[]`, `min/max_duration_minutes`, `near_latitude`, `near_longitude`, `search`, `limit`, `offset`) |
| GET | `/api/quests/my` | Мои квесты (черновики/на модерации/опубликованные/отклонённые) |
| GET | `/api/quests/favorites` | Избранное |
| GET | `/api/quests/{quest_id}` | Карточка с чекпоинтами |
| GET | `/api/quests/{quest_id}/export` | PDF-экспорт |
| POST | `/api/quests` | Создание (multipart с обложкой и JSON-массивом точек) |
| PATCH | `/api/quests/{quest_id}/status` | `archived` ↔ `published` |
| DELETE | `/api/quests/{quest_id}` | Удалить свой квест |
| POST | `/api/quests/{quest_id}/favorite` | В избранное |
| DELETE | `/api/quests/{quest_id}/favorite` | Из избранного |

### Прохождение

| Метод | Путь | Назначение |
|---|---|---|
| POST | `/api/quest-runs` | Старт |
| GET | `/api/quest-runs/active` | Активная сессия (или `null`). `StreamQuest._restoreActiveRunOnInit` дёргает её на старте приложения — чтобы продолжить незавершённый ран после перезапуска |
| POST | `/api/quest-runs/active/answer` | Ответ на текущий чекпоинт |
| POST | `/api/quest-runs/active/abandon` | Прервать |
| GET | `/api/quest-runs/history` | История |

### Командное прохождение

| Метод | Путь | Назначение |
|---|---|---|
| GET | `/api/team-quest-runs/active` | Активный командный ран. Поллится из `team_waiting_room_sheet.dart` (`waiting_for_team`/`starting` ~1.5 с, `in_progress` 2 с) |
| PATCH | `/api/team-quest-runs` | `{quest_id, is_ready}` — подтвердить или отменить готовность. Первый `is_ready: true` создаёт ран, при готовности всех (≥2) запускается обратный отсчёт 5 с |

> Метод ответа на чекпоинт в командном раннере (`POST /api/team-quest-runs/active/checkpoints/{checkpoint_id}/answer`) сейчас вызывается через UI прохождения; см. `current_quest_screen/screen.dart`.

Подробный flow — в [`team-quests.md`](../team-quests.md).

### Команды

| Метод | Путь | Назначение |
|---|---|---|
| POST | `/api/teams` | Создать команду |
| GET | `/api/teams/me` | Моя команда |
| POST | `/api/teams/join` | Войти по коду (поддержка скана QR) |
| POST | `/api/teams/leave` | Выйти |

### Рейтинг

| Метод | Путь | Назначение |
|---|---|---|
| GET | `/api/rating/users` | Рейтинг игроков |
| GET | `/api/rating/teams` | Рейтинг команд |

### Достижения

| Метод | Путь | Назначение |
|---|---|---|
| GET | `/api/achievements` | Каталог |
| GET | `/api/achievements/me` | Полученные мной |

### Файлы

| Метод | Путь | Назначение |
|---|---|---|
| GET | `/api/file/{file_id}` | Картинки квестов и достижений (используются как `Image.network` в виджетах) |

## Локальное хранилище

| Хранилище | Что лежит |
|---|---|
| `flutter_secure_storage` | `ACCESS_TOKEN`, `REFRESH_TOKEN`, `user_data` (cached `UserResponse` + `accessTokenExpiresAt`), `quest_drafts_v1` (черновики мастера создания) |
| Asset bundle | `.env`, иконки, шрифты Material |

## Ошибки

Chopper отдаёт `Response<T>` с `isSuccessful` и `body`. Большая часть экранов проверяет `response.isSuccessful` и показывает универсальный snackbar (`lib/widgets/app_snackbar.dart`). Сообщения сервера в формате FastAPI (`{"detail": "..."}` или Pydantic-валидация) парсятся ad-hoc по месту использования.

При 401 интерсептор пытается обновить токен ровно один раз; если refresh не удался — `StreamAuth` оставляет UI как есть, и роутер при следующем `isSignedIn()` отправит на `/auth`.
