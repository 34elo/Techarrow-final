import { env } from "@/shared/config/env";

export const QUEST_STATUSES = [
  "on_moderation",
  "published",
  "rejected",
  "archived",
] as const;

export type QuestStatus = (typeof QUEST_STATUSES)[number];

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

export type QuestDetail = {
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
  creator: QuestCreator;
  points: QuestPoint[];
};

export function getQuestCoverImageUrl(detail: QuestDetail): string {
  if (detail.image_file_id) {
    return `${env.apiBaseUrl}/api/file/${encodeURIComponent(detail.image_file_id)}`;
  }
  return `https://picsum.photos/seed/quest-${detail.id}/1200/675`;
}

export function getQuestStatusLabel(
  translate: (key: string, params?: Record<string, string | number>) => string,
  status: QuestStatus | string,
): string {
  const key = `questDetail.statusLabels.${status}`;
  const resolved = translate(key);
  if (resolved !== key) {
    return resolved;
  }
  return translate("questDetail.unknownStatus", { status });
}
