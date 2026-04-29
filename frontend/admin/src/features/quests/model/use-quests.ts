"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { useMemo } from "react";

import { questsService, type QuestFilters } from "../api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { DEFAULT_PAGE_SIZE, getNextOffset } from "@/shared/api/pagination";
import type { ApiError } from "@/shared/api";
import type { Page, QuestSummary } from "@/entities/quest";

export type UseQuestsParams = QuestFilters & {
  scope: "moderation" | "public";
  pageSize?: number;
};

export function useQuests({
  scope,
  pageSize = DEFAULT_PAGE_SIZE,
  ...filters
}: UseQuestsParams) {
  const query = useInfiniteQuery<Page<QuestSummary>, ApiError>({
    queryKey: queryKeys.quests.list({ scope, ...filters }),
    queryFn: ({ pageParam }) => {
      const params = {
        ...filters,
        limit: pageSize,
        offset: typeof pageParam === "number" ? pageParam : 0,
      };
      return scope === "moderation"
        ? questsService.listOnModeration(params)
        : questsService.listPublic(params);
    },
    initialPageParam: 0 as number,
    getNextPageParam: (lastPage) =>
      getNextOffset({
        total: lastPage.total,
        limit: lastPage.limit,
        offset: lastPage.offset,
      }),
  });

  const items = useMemo(
    () => query.data?.pages.flatMap((page) => page.items) ?? [],
    [query.data],
  );

  const total = query.data?.pages[0]?.total ?? 0;

  return { ...query, items, total };
}
