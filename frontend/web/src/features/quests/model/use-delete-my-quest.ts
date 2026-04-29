"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { questsService } from "../api/quests-service";
import { ApiError } from "@/shared/api";
import { queryKeys } from "@/shared/lib/react-query/query-keys";

export function useDeleteMyQuest() {
  const queryClient = useQueryClient();
  return useMutation<void, ApiError, { id: number | string }>({
    mutationFn: ({ id }) => questsService.deleteMy(id),
    onSuccess: (_data, variables) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.quests.lists() });
      queryClient.removeQueries({
        queryKey: queryKeys.quests.detail(variables.id),
      });
    },
  });
}
