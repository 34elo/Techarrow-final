"use client";

import { useQuery } from "@tanstack/react-query";

import { questsService } from "../api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { QuestDetail } from "@/entities/quest";
import type { ApiError } from "@/shared/api";

export function useQuestDetail(id: number | string | undefined) {
  return useQuery<QuestDetail, ApiError>({
    queryKey: queryKeys.quests.detail(id ?? ""),
    queryFn: () => questsService.detail(id as number | string),
    enabled: id !== undefined && id !== "",
  });
}
