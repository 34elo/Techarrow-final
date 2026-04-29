"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { teamsService, type JoinTeamPayload } from "../api/teams-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";
import type { Team } from "@/entities/team";

export function useJoinTeam() {
  const queryClient = useQueryClient();

  return useMutation<Team, ApiError, JoinTeamPayload>({
    mutationFn: (payload) => teamsService.join(payload),
    onSuccess: (team) => {
      queryClient.setQueryData(queryKeys.teams.me(), team);
      queryClient.invalidateQueries({ queryKey: queryKeys.auth.me() });
    },
  });
}
