"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { useMemo } from "react";

import { reportsService } from "../api/reports-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { DEFAULT_PAGE_SIZE, getNextOffset } from "@/shared/api/pagination";
import type { ApiError } from "@/shared/api";
import type { Page } from "@/entities/quest";
import type { Report } from "@/entities/report";

export type UseReportsParams = {
  pageSize?: number;
};

export function useReports({
  pageSize = DEFAULT_PAGE_SIZE,
}: UseReportsParams = {}) {
  const query = useInfiniteQuery<Page<Report>, ApiError>({
    queryKey: queryKeys.reports.list(),
    queryFn: ({ pageParam }) =>
      reportsService.list({
        limit: pageSize,
        offset: typeof pageParam === "number" ? pageParam : 0,
      }),
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
