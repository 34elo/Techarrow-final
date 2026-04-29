"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { useMemo } from "react";

import {
  leaderboardService,
  type RatingPage,
} from "../api/leaderboard-service";
import {
  queryKeys,
  type RatingScope,
} from "@/shared/lib/react-query/query-keys";
import { DEFAULT_PAGE_SIZE, getNextOffset } from "@/shared/api";
import type { ApiError } from "@/shared/api";
import { useAuthStore } from "@/shared/store/auth-store";

const PAGE_SIZE = DEFAULT_PAGE_SIZE;

export function useLeaderboard(scope: RatingScope) {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);

  const query = useInfiniteQuery<RatingPage, ApiError>({
    queryKey: queryKeys.rating.list(scope),
    queryFn: ({ pageParam }) => {
      const params = {
        limit: PAGE_SIZE,
        offset: typeof pageParam === "number" ? pageParam : 0,
      };
      return scope === "users"
        ? leaderboardService.listUsers(params)
        : leaderboardService.listTeams(params);
    },
    initialPageParam: 0 as number,
    getNextPageParam: (lastPage) =>
      getNextOffset({
        total: lastPage.total,
        limit: lastPage.limit,
        offset: lastPage.offset,
      }),
    enabled: isAuthenticated,
    staleTime: 60_000,
  });

  // Self comes from the first page only — flatten entries across pages.
  const entries = useMemo(
    () => query.data?.pages.flatMap((page) => page.entries) ?? [],
    [query.data],
  );

  const self = query.data?.pages[0]?.self ?? null;
  const total = query.data?.pages[0]?.total ?? 0;

  return { ...query, entries, self, total };
}
