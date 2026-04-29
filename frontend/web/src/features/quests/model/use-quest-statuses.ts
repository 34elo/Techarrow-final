"use client";

import { useMemo } from "react";

import { useActiveQuestRun, useQuestRunHistory } from "@/features/quest-run";

export type QuestPersonalStatus = "completed" | "in_progress" | "none";

/**
 * Aggregates a per-quest status from the user's run history and active run:
 * - `in_progress` — there's an active run for this quest
 * - `completed`   — at least one finished run exists for this quest
 * - `none`        — never played
 */
export function useQuestStatuses(): Map<number, QuestPersonalStatus> {
  const { data: history } = useQuestRunHistory();
  const { data: active } = useActiveQuestRun();

  return useMemo(() => {
    const map = new Map<number, QuestPersonalStatus>();
    for (const item of history ?? []) {
      if (item.status === "completed") {
        map.set(item.quest_id, "completed");
      }
    }
    if (active?.status === "in_progress") {
      map.set(active.quest_id, "in_progress");
    }
    return map;
  }, [history, active]);
}

export const STATUS_COLORS: Record<QuestPersonalStatus, string> = {
  completed: "#16a34a",
  in_progress: "#f59e0b",
  none: "#1e6586",
};
