Анализ командных квестов StrelkaBack
Общее описание
Командные квесты позволяют группе пользователей (2-6 человек) совместно проходить геолокационные квесты. Основная особенность — система готовности (readiness): квест начинается только когда ВСЕ участники команды подтвердят готовность.
---
Как это работает (по коду)
1. Создание и присоединение к команде
Файлы: src/models/teams.py, src/services/teams.py
- Команда создаётся через POST /teams с автоматической генерацией 12-символьного кода
- Другие игроки присоединяются через POST /teams/join с кодом команды
- Максимум 6 участников на команду (TEAM_MAX_MEMBERS = 6 в teams.py:16)
2. Система готовности (Readiness Mechanism)
Файл: src/services/team_quest_runs.py:44-108
Когда игрок готов начать квест:
PATCH /team-quest-runs
{ "quest_id": 123, "is_ready": true }
Что происходит:
1. Проверяется, что пользователь в команде и в команде ≥2 участника
2. Создаётся запись TeamQuestRunModel со статусом WAITING_FOR_TEAM (строка 90-101)
3. В таблицу team_quest_run_participants добавляется запись о готовности игрока
4. Если ВСЕ участники команды готовы → статус меняется на STARTING, устанавливается starts_at = now + 5 секунд (строка 245-253)
5. Если игрок отменяет готовность (is_ready: false) → запись удаляется, и если статус был STARTING, он возвращается в WAITING_FOR_TEAM
3. Запуск квеста (с задержкой 5 секунд)
Файл: src/services/team_quest_runs.py:261-271
Статус STARTING автоматически переходит в IN_PROGRESS, когда наступает время starts_at. Это проверяется "лениво" при каждом запросе через _advance_start_if_ready().
Frontend должен поллить:
GET /team-quest-runs/active  (каждые 1-2 секунды)
Когда status меняется с "starting" на "in_progress" — квест начался.
4. Прохождение чекпоинтов
Файл: src/services/team_quest_runs.py:128-221
В командном режиме:
- Любой участник может ответить на любой чекпоинт (порядок не важен)
- Ответы проверяются через нормализацию (удаление пунктуации, приведение к lowercase, замена ё→е)
- Информация о прохождении чекпоинта записывается в TeamQuestRunCheckpointModel с указанием completed_by_user_id
POST /team-quest-runs/active/checkpoints/{checkpoint_id}/answer
{ "answer": "Ответ" }
5. Завершение и начисление очков
Файл: src/services/team_quest_runs.py:34-37, 189-215
Когда пройдены ВСЕ чекпоинты:
- Рассчитывается время прохождения (от started_at до completed_at)
- Очки = difficulty * 100 + (difficulty * 18000) / max(elapsed_seconds, 60)
- Очки начисляются КАЖДОМУ участнику команды (не делятся поровну!)
- Если команда включает создателя квеста или уже проходила этот квест — 0 очков
---
Работа на фронте
Полный флоу для фронтенда
// 1. Создать команду (лидер)
const teamResp = await fetch('/api/teams', {
  method: 'POST',
  headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: 'Отважные', description: 'Команда №1' })
});
const { code, id: teamId } = await teamResp.json();
// Поделиться кодом code с другими игроками
// 2. Присоединиться к команде (остальные)
await fetch('/api/teams/join', {
  method: 'POST',
  headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' },
  body: JSON.stringify({ code: 'ABC123DEF456' })
});
// 3. Сигнал о готовности (каждый игрок)
await fetch('/api/team-quest-runs', {
  method: 'PATCH',
  headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' },
  body: JSON.stringify({ quest_id: 123, is_ready: true })
});
// Ответ содержит ready_member_ids и total_members
// 4. Поллинг готовности (каждые 1-2 сек)
let runStatus = 'waiting_for_team';
while (!['in_progress', 'completed'].includes(runStatus)) {
  const resp = await fetch('/api/team-quest-runs/active', {
    headers: { 'Authorization': 'Bearer ' + token }
  });
  const progress = await resp.json();
  runStatus = progress.status;
  
  if (runStatus === 'starting') {
    // Показать обратный отсчёт до starts_at
    console.log('Квест начнётся в', progress.starts_at);
  }
  
  await new Promise(r => setTimeout(r, 1000));
}
// 5. Ответы на чекпоинты (любой участник)
const answerResp = await fetch(`/api/team-quest-runs/active/checkpoints/${checkpointId}/answer`, {
  method: 'POST',
  headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' },
  body: JSON.stringify({ answer: 'Ответ на задание' })
});
const answerResult = await answerResp.json();
// answerResult.correct — верно/неверно
// answerResult.progress — обновлённый прогресс
// answerResult.points_earned — очки (только при завершении)
// 6. Мониторинг прогресса
const progressResp = await fetch('/api/team-quest-runs/active', {
  headers: { 'Authorization': 'Bearer ' + token }
});
const { checkpoints, completed_checkpoints, total_checkpoints } = await progressResp.json();
// checkpoints[].is_completed — пройден ли чекпоинт
// checkpoints[].completed_by_user_id — кто прошёл
Статусы квеста
Статус	Описание
waiting_for_team	Ожидание готовности
starting	Все готовы, обратный отсчёт
in_progress	Квест идёт
completed	Квест завершён
Важные нюансы
- Отмена готовности: PATCH /team-quest-runs с is_ready: false удаляет игрока из готовых и отменяет запуск
- Удаление из команды: только создатель может кикнуть через DELETE /teams/members/{id}
- Выход из команды: POST /teams/leave (создатель не может выйти, если есть другие участники)
- Чекпоинты можно проходить в любом порядке (в отличие от одиночного прохождения)