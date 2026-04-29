"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { useMemo } from "react";

import { questsService, type QuestFilters } from "../api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { DEFAULT_PAGE_SIZE, getNextOffset } from "@/shared/api";
import type { ApiError, Page } from "@/shared/api";
import type { Quest } from "@/entities/quest";

export type QuestScope = "public" | "my" | "favorites";

export type UseQuestsParams = QuestFilters & {
  scope: QuestScope;
  pageSize?: number;
  enabled?: boolean;
};

export function useQuests({
  scope,
  pageSize = DEFAULT_PAGE_SIZE,
  enabled = true,
  ...filters
}: UseQuestsParams) {
  const query = useInfiniteQuery<Page<Quest>, ApiError>({
    queryKey: queryKeys.quests.list({ scope, ...filters }),
    queryFn: ({ pageParam }) => {
      const params = {
        ...filters,
        limit: pageSize,
        offset: typeof pageParam === "number" ? pageParam : 0,
      };
      switch (scope) {
        case "my":
          return questsService.listMy(params);
        case "favorites":
          return questsService.listFavorites(params);
        default:
          return questsService.list(params);
      }
    },
    initialPageParam: 0 as number,
    getNextPageParam: (lastPage) =>
      getNextOffset({
        total: lastPage.total,
        limit: lastPage.limit,
        offset: lastPage.offset,
      }),
    enabled,
  });

  const items = useMemo(
    () => query.data?.pages.flatMap((page) => page.items) ?? [],
    [query.data],
  );

  const total = query.data?.pages[0]?.total ?? 0;

  return { ...query, items, total };
}
