"use client";

import { useQuery } from "@tanstack/react-query";

import { teamsService } from "../api/teams-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { useAuthStore } from "@/shared/store/auth-store";
import type { Team } from "@/entities/team";
import { ApiError } from "@/shared/api";

export function useMyTeam() {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);

  return useQuery<Team | null, ApiError>({
    queryKey: queryKeys.teams.me(),
    queryFn: async () => {
      try {
        return await teamsService.getMy();
      } catch (error) {
        if (
          error instanceof ApiError &&
          (error.status === 404 || error.status === 400)
        ) {
          return null;
        }
        throw error;
      }
    },
    enabled: isAuthenticated,
    staleTime: 30_000,
  });
}
