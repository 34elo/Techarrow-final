export const TEAM_QUEST_RUN_STATUSES = [
  "waiting_for_team",
  "starting",
  "in_progress",
  "completed",
] as const;

export type TeamQuestRunStatus = (typeof TEAM_QUEST_RUN_STATUSES)[number];

export type TeamQuestRunCheckpointView = {
  id: number;
  title: string;
  latitude: number;
  longitude: number;
  task: string;
  hint: string | null;
  point_rules: string | null;
  is_completed: boolean;
  completed_by_user_id: number | null;
  completed_at: string | null;
};

export type TeamQuestRunProgress = {
  run_id: number;
  team_id: number;
  quest_id: number;
  status: TeamQuestRunStatus;
  ready_member_ids: number[];
  total_members: number;
  starts_at: string | null;
  started_at: string | null;
  completed_at: string | null;
  total_checkpoints: number;
  completed_checkpoints: number;
  checkpoints: TeamQuestRunCheckpointView[];
  points_awarded: number | null;
};

export type TeamQuestRunCheckpointAnswer = {
  correct: boolean;
  progress: TeamQuestRunProgress;
  points_earned: number | null;
};
