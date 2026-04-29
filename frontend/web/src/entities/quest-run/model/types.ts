export const QUEST_RUN_STATUSES = [
  "in_progress",
  "completed",
  "abandoned",
] as const;

export type QuestRunStatus = (typeof QUEST_RUN_STATUSES)[number];

export type CheckpointPassedView = {
  id: number;
  title: string;
  latitude: number;
  longitude: number;
};

export type CheckpointCurrentView = {
  id: number;
  title: string;
  latitude: number;
  longitude: number;
  task: string;
  hint: string | null;
  point_rules: string | null;
};

export type QuestRunProgress = {
  run_id: number;
  quest_id: number;
  status: QuestRunStatus;
  started_at: string;
  completed_at: string | null;
  total_checkpoints: number;
  current_step_index: number;
  previous_checkpoints: CheckpointPassedView[];
  current_checkpoint: CheckpointCurrentView | null;
  points_awarded: number | null;
};

export type QuestRunAnswer = {
  correct: boolean;
  progress: QuestRunProgress;
  points_earned: number | null;
};

export type QuestRunHistoryItem = {
  run_id: number;
  quest_id: number;
  quest_title: string;
  status: QuestRunStatus;
  started_at: string;
  completed_at: string;
  points_awarded: number;
};
