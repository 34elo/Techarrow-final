import type { QuestDetail } from "./quest-detail";

export type Page<T> = {
  items: T[];
  total: number;
  limit: number;
  offset: number;
};

export type QuestSummary = Omit<QuestDetail, "points">;
