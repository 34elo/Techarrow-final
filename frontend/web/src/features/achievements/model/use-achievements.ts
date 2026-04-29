"use client";

import { useQueries } from "@tanstack/react-query";

import { achievementsService } from "../api/achievements-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { useAuthStore } from "@/shared/store/auth-store";
import {
  mergeAchievements,
  type Achievement,
  type AchievementResponse,
  type UserAchievementResponse,
} from "@/entities/achievement";

export type UseMyAchievementsResult = {
  data: Achievement[];
  isLoading: boolean;
  isError: boolean;
  error: Error | null;
};

export function useMyAchievements(): UseMyAchievementsResult {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);

  const results = useQueries({
    queries: [
      {
        queryKey: queryKeys.achievements.list(),
        queryFn: () => achievementsService.listAll(),
        staleTime: 5 * 60_000,
      },
      {
        queryKey: queryKeys.achievements.me(),
        queryFn: () => achievementsService.listMine(),
        enabled: isAuthenticated,
        staleTime: 60_000,
      },
    ],
  });

  const [catalogQuery, mineQuery] = results;
  const catalog = (catalogQuery.data ?? []) as AchievementResponse[];
  const mine = (mineQuery.data ?? []) as UserAchievementResponse[];

  const merged = mergeAchievements(catalog, mine);

  return {
    data: merged,
    isLoading: catalogQuery.isLoading || mineQuery.isLoading,
    isError: catalogQuery.isError || mineQuery.isError,
    error: (catalogQuery.error ?? mineQuery.error) as Error | null,
  };
}
