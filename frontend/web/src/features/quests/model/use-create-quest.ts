"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { questsService, type CreateQuestPayload } from "../api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";
import type { Quest } from "@/entities/quest";

export function useCreateQuest() {
  const queryClient = useQueryClient();

  return useMutation<Quest, ApiError, CreateQuestPayload>({
    mutationFn: (payload) => questsService.create(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.quests.lists() });
    },
  });
}
