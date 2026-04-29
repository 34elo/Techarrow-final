"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { teamsService } from "../api/teams-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";

export function useLeaveTeam() {
  const queryClient = useQueryClient();

  return useMutation<void, ApiError, void>({
    mutationFn: () => teamsService.leave(),
    onSuccess: () => {
      queryClient.setQueryData(queryKeys.teams.me(), null);
      queryClient.invalidateQueries({ queryKey: queryKeys.auth.me() });
    },
  });
}
