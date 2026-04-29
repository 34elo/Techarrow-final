import { env } from "@/shared/config/env";

export const QUEST_STATUSES = [
  "on_moderation",
  "published",
  "rejected",
  "archived",
] as const;

export type QuestStatus = (typeof QUEST_STATUSES)[number];

export const QUEST_DIFFICULTY_VALUES = [1, 2, 3, 4, 5] as const;
export type QuestDifficulty = (typeof QUEST_DIFFICULTY_VALUES)[number];

export type QuestCreator = {
  id: number;
  username: string;
  team_name?: string | null;
};

export type QuestPoint = {
  id: number;
  title: string;
  latitude: number;
  longitude: number;
  task: string;
  correct_answer: string;
  hint: string | null;
  point_rules: string | null;
};

export type Quest = {
  id: number;
  title: string;
  description: string;
  location: string;
  difficulty: number;
  duration_minutes: number;
  rules_and_warnings: string | null;
  image_file_id: string | null;
  rejection_reason: string | null;
  status: QuestStatus;
  latitude: number;
  longitude: number;
  creator: QuestCreator;
  best_completion_seconds: number | null;
};

export type QuestDetail = Quest & {
  points: QuestPoint[];
};

export function getQuestCoverImageUrl(
  quest: Pick<Quest, "id" | "image_file_id">,
): string {
  if (quest.image_file_id) {
    return `${env.apiBaseUrl}/api/file/${encodeURIComponent(
      quest.image_file_id,
    )}`;
  }
  return `https://picsum.photos/seed/quest-${quest.id}/1200/675`;
}

export function getDifficultyLabel(difficulty: number): string {
  const safe = Math.max(1, Math.min(5, difficulty));
  return `${safe}/5`;
}

export function formatQuestDuration(
  minutes: number,
  translate: (key: string, params?: Record<string, string | number>) => string,
): string {
  return translate("quest.durationLabel", { count: minutes });
}

export function formatBestCompletion(totalSeconds: number): string {
  const s = Math.max(0, Math.round(totalSeconds));
  const hours = Math.floor(s / 3600);
  const minutes = Math.floor((s % 3600) / 60);
  const seconds = s % 60;
  const mm = String(minutes).padStart(2, "0");
  const ss = String(seconds).padStart(2, "0");
  return hours > 0 ? `${hours}:${mm}:${ss}` : `${mm}:${ss}`;
}

export function getQuestStatusLabel(
  translate: (key: string, params?: Record<string, string | number>) => string,
  status: QuestStatus | string,
): string {
  const key = `questStatus.${status}`;
  const resolved = translate(key);
  return resolved === key ? String(status) : resolved;
}
