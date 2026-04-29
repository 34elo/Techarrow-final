"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { questsService } from "../api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";

export function useDeleteQuest() {
  const queryClient = useQueryClient();

  return useMutation<void, ApiError, number | string>({
    mutationFn: (id) => questsService.deleteAsModerator(id),
    onSuccess: (_, id) => {
      queryClient.removeQueries({ queryKey: queryKeys.quests.detail(id) });
      queryClient.invalidateQueries({ queryKey: queryKeys.quests.lists() });
      queryClient.invalidateQueries({ queryKey: queryKeys.reports.lists() });
    },
  });
}
