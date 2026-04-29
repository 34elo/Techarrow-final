"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { questFavoritesService } from "../api/quest-favorites-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";

type ToggleVars = {
  questId: number;
  isFavorite: boolean;
};

export function useToggleFavorite() {
  const queryClient = useQueryClient();

  return useMutation<void, ApiError, ToggleVars>({
    mutationFn: ({ questId, isFavorite }) =>
      isFavorite
        ? questFavoritesService.remove(questId)
        : questFavoritesService.add(questId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.quests.favorites() });
      queryClient.invalidateQueries({ queryKey: queryKeys.quests.lists() });
    },
  });
}
