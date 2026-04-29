# Архитектура (mobile)

Flutter-приложение собрано вокруг feature-папок в `lib/screens/`, единого HTTP-клиента в `lib/services/api.dart` и двух глобальных «нотификаторов» состояния (`StreamAuth`, `StreamQuest`).

## Слои

| Каталог | Что внутри |
|---|---|
| `lib/main.dart` | Точка входа: загрузка `.env`, оборачивание дерева в `StreamAuthScope` и `StreamQuestScope`, объявление `GoRouter` с гардом по `isSignedIn()` |
| `lib/screens/<feature>/` | Один экран = одна папка. Корневой `screen.dart` + опциональные подстраницы в `pages/` |
| `lib/widgets/` | Переиспользуемые виджеты (`event_card.dart`, `app_snackbar.dart`) |
| `lib/services/` | Глобальное состояние (`StreamAuth`, `StreamQuest`), HTTP-обёртка (`ApiService`), локальное хранилище черновиков (`QuestDraftsService`) |
| `lib/models/` | Доменные DTO, не привязанные к контракту OpenAPI (`Quest`, `QuestDraft`, `StreamingQuestSession`) |
| `lib/util/` | Хелперы (`storage_consts.dart`, `quest_cover_upload.dart`) |
| `lib/theme/theme.dart` | Цветовая палитра и Material-тема |
| `lib/gen/` | **Сгенерированный** Chopper-клиент по `openapi/swagger.json`. Не редактируйте руками |
| `openapi/swagger.json` | Контракт API, источник для генерации |
| `assets/` | Статичные изображения |

## Экраны

| Папка `lib/screens/` | Назначение |
|---|---|
| `auth_screen/` | Вход и регистрация |
| `index_screen/` | Главный контейнер с `BottomNavigationBar`. 5 вкладок: главная, команда, рейтинг, избранное, профиль |
| `index_screen/pages/` | `main` (каталог квестов), `team`, `leaderboard`, `favourite`, `profile` |
| `index_screen/team_pages/` | Подэкраны командной вкладки: `creation`, `join`, `team` |
| `index_screen/leaderboard_pages/` | Вкладки рейтинга: `personal`, `command`, общий лист `common` |
| `quest_data/` | Карточка квеста + командная «комната ожидания» (`team_waiting_room_sheet.dart`) |
| `current_quest_screen/` | Активное соло-/командное прохождение с картой, чекпоинтами, шагомером |
| `quest_creation/` | 5-шаговый мастер создания (`step_one`…`step_five`) |
| `quest_draft_screen/` | Черновики квестов |
| `quest_history_screen/` | История прохождений |
| `quest_result_screen/` | Итоговый экран после завершения |
| `achievements_screen/` | Каталог + полученные достижения |
| `edit_user_screen/` | Редактирование профиля |

## Роутинг

`main.dart` объявляет `GoRouter` с двумя маршрутами: `/` (`IndexScreen`) и `/auth` (`AuthorizationScreen`). Гард `redirect` дёргает `StreamAuth.isSignedIn()` — если токенов нет или access протух и refresh не сработал, кидает на `/auth`. Внутри табов навигация — обычный `Navigator.push` к feature-экранам.

## Состояние

Два глобальных `InheritedNotifier`-скоупа на корне дерева:

- **`StreamAuthScope` / `StreamAuth`** (`lib/services/auth.dart`)
  - Хранит токены и `UserResponse` в `flutter_secure_storage` (ключи `ACCESS_TOKEN`, `REFRESH_TOKEN`, `user_data`).
  - Декодирует `exp` из access-токена через `jwt_decoder`, считает токен протухшим локально без обращения к серверу.
  - `signIn`, `signOn` (регистрация), `signOut`, `refreshAccessToken`, `refreshMe`. Все события транслируются через `Stream<UserData?>` — UI перерисовывается через `notifyListeners`.
  - При первом обращении читает хранилище в `_storageLoadFuture` и сразу инициализирует `ApiService`, передавая в него ссылку для рефреша.

- **`StreamQuestScope` / `StreamQuest`** (`lib/services/quest.dart`)
  - Активная сессия прохождения (соло и командная), последний результат, поллинг прогресса.
  - На старте подписывается на `Pedometer.stepCountStream` (запрашивает Android-разрешение `activityRecognition`), считает дельту шагов от старта рана.
  - Тикер раз в секунду эмитит обновление, чтобы UI пересчитал таймер. На жизненный цикл `WidgetsBindingObserver` — при возврате в foreground делает немедленный refetch.
  - При запуске приложения вызывает `_restoreActiveRunOnInit`: если на сервере есть активный ран — продолжает его без пользовательского действия.

Локальные экранные стейты — обычные `StatefulWidget` + `setState`, иногда `ValueNotifier`. Без Bloc/Riverpod.

## HTTP-клиент

`lib/services/api.dart`, синглтон `ApiService.instance`:

- На init создаёт `Swagger.create(...)` — Chopper-клиент, сгенерированный из OpenAPI. Базовый URL — `API_BASE_URL` из `.env`, fallback `http://localhost:8000`.
- `AuthInterceptor` подставляет `Authorization: Bearer …` и при ответе 401 делает single-flight refresh через `refreshAccessTokenSingleFlight()` (защита от шквала параллельных рефрешей). Если refresh успешен — повторяет исходный запрос с заголовком `x-auth-retry: 1` (ровно один раз). Запросы под `/api/auth/*` не ретраятся.
- Для multipart-эндпоинта создания квеста сделана отдельная функция `createQuest(...)` поверх `package:http` — Chopper не дружит с динамическими form-полями + файлом.
- Для каталога квестов — кастомная `getQuests(...)` (тоже на `package:http`), чтобы прозрачно собирать query-параметры с массивами `difficulties[]`.

Refresh-токен и `user_data` лежат в `flutter_secure_storage` — на iOS Keychain, на Android EncryptedSharedPreferences. Никаких токенов в `SharedPreferences`.

## Генерация клиента из OpenAPI

`build.yaml` указывает `swagger_dart_code_generator` смотреть в `openapi/`, складывать вывод в `lib/gen/`. Команды:

```bash
make gen-swag        # rm -rf lib/gen && build_runner build
```

Артефакты:

- `lib/gen/swagger.swagger.dart` — типы DTO и абстрактный клиент `Swagger`.
- `lib/gen/swagger.swagger.chopper.dart` — реализация Chopper (HTTP-методы).
- `lib/gen/swagger.swagger.g.dart` — `json_serializable`-сериализация.
- `lib/gen/swagger.enums.swagger.dart` — enum-ы (роли, статусы квеста и т. д.).

Никогда не редактируйте `lib/gen/` руками — изменения теряются на следующей генерации. Если нужно поведение, отсутствующее в контракте — добавляйте в `ApiService` обёртку, как `createQuest`.

## Карты и геолокация

- **Карты**: `flutter_map` поверх OpenStreetMap с `latlong2` для координат. Используются в каталоге, на карточке квеста и при создании (выбор точек чекпоинтов).
- **Геолокация**: `geolocator` для one-shot и потоковых координат. Запрашивает `Permission.locationWhenInUse`.
- **Шагомер**: `pedometer` запускается на старте рана из `StreamQuest.startSession`. На iOS использует CMPedometer, на Android — TYPE_STEP_COUNTER (требует `ACTIVITY_RECOGNITION` начиная с Android 10). Если шагомер недоступен (web, симулятор) — сессия продолжается с 0 шагов.

## Командные квесты

Frontend-логика реализует контракт из [`team-quests.md`](../team-quests.md):

1. На вкладке «Команда» — создание (`team_pages/creation.dart`), вход по коду или скан QR (`team_pages/join.dart`), карточка команды с QR-инвайтом и киком (`team_pages/team.dart`).
2. На карточке квеста — кнопка «Готов» открывает `team_waiting_room_sheet.dart`. Лист дёргает `PATCH /api/team-quest-runs` и поллит `/active` каждые ~1.5 с.
3. Когда статус `starting` — показывает обратный отсчёт 5 секунд (по `starts_at`).
4. Переход в `in_progress` → `current_quest_screen` со списком чекпоинтов; ответ кого угодно за любого; UI подсвечивает, кто из команды решил чекпоинт.

`StreamQuest.refreshActiveTeamRunProgress()` подавляет обновления, если идёт соло-ран — чтобы экраны не «дрались» за фокус.

## Локализация

Поддержаны `ru` (по умолчанию) и `en`. Делегаты — `flutter_localizations`. Конкретные строки сейчас живут прямо в виджетах; при росте переехать на `intl_translation`.

## Где смотреть в коде

- HTTP-клиент и интерсептор: `lib/services/api.dart`
- Аутентификация: `lib/services/auth.dart`, ключи хранилища — `lib/util/storage_consts.dart`
- Глобальный стейт прохождения: `lib/services/quest.dart`
- Сгенерированные DTO и клиент: `lib/gen/swagger.swagger.dart`
- Команды по сборке: `Makefile`
- Тема: `lib/theme/theme.dart`
