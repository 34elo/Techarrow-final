"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { teamsService, type CreateTeamPayload } from "../api/teams-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";
import type { Team } from "@/entities/team";

export function useCreateTeam() {
  const queryClient = useQueryClient();

  return useMutation<Team, ApiError, CreateTeamPayload>({
    mutationFn: (payload) => teamsService.create(payload),
    onSuccess: (team) => {
      queryClient.setQueryData(queryKeys.teams.me(), team);
      queryClient.invalidateQueries({ queryKey: queryKeys.auth.me() });
    },
  });
}
