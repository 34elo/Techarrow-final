"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { teamsService } from "../api/teams-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";
import type { Team } from "@/entities/team";

export function useKickMember() {
  const queryClient = useQueryClient();

  return useMutation<Team, ApiError, number>({
    mutationFn: (memberId) => teamsService.kick(memberId),
    onSuccess: (team) => {
      queryClient.setQueryData(queryKeys.teams.me(), team);
    },
  });
}
