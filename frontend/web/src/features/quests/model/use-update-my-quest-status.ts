"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { questsService } from "../api/quests-service";
import { ApiError } from "@/shared/api";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { Quest } from "@/entities/quest";

export type MyQuestArchiveStatus = "published" | "archived";

export function useUpdateMyQuestStatus() {
  const queryClient = useQueryClient();
  return useMutation<
    Quest,
    ApiError,
    { id: number | string; status: MyQuestArchiveStatus }
  >({
    mutationFn: ({ id, status }) => questsService.updateStatus(id, status),
    onSuccess: (quest) => {
      queryClient.setQueryData(queryKeys.quests.detail(quest.id), (prev) =>
        prev ? { ...prev, ...quest } : prev,
      );
      queryClient.invalidateQueries({ queryKey: queryKeys.quests.lists() });
    },
  });
}
