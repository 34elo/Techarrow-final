"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { questsService, type RejectQuestPayload } from "../api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { QuestDetail } from "@/entities/quest";
import type { ApiError } from "@/shared/api";

export function useRejectQuest() {
  const queryClient = useQueryClient();

  return useMutation<QuestDetail, ApiError, RejectQuestPayload>({
    mutationFn: (payload) => questsService.reject(payload),
    onSuccess: (quest) => {
      queryClient.setQueryData(queryKeys.quests.detail(quest.id), quest);
      queryClient.invalidateQueries({ queryKey: queryKeys.quests.lists() });
    },
  });
}
