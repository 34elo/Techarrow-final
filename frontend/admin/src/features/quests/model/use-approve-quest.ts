"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { questsService } from "../api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { QuestDetail } from "@/entities/quest";
import type { ApiError } from "@/shared/api";

export function useApproveQuest() {
  const queryClient = useQueryClient();

  return useMutation<QuestDetail, ApiError, number | string>({
    mutationFn: (id) => questsService.approve(id),
    onSuccess: (quest) => {
      queryClient.setQueryData(queryKeys.quests.detail(quest.id), quest);
      queryClient.invalidateQueries({ queryKey: queryKeys.quests.lists() });
    },
  });
}
