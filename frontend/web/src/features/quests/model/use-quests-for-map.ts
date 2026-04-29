"use client";

import { useMemo } from "react";
import { useQuery } from "@tanstack/react-query";

import { questsService } from "../api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";
import type { Quest } from "@/entities/quest";

const PAGE_SIZE = 100;

// Walks all pages once so the map can show every published quest at once.
async function fetchAllQuests(signal?: AbortSignal): Promise<Quest[]> {
  const collected: Quest[] = [];
  let offset = 0;
  while (true) {
    if (signal?.aborted) break;
    const page = await questsService.list({ limit: PAGE_SIZE, offset });
    collected.push(...page.items);
    offset += page.limit;
    if (offset >= page.total || page.items.length === 0) break;
  }
  return collected;
}

type UseQuestsForMapOptions = {
  enabled?: boolean;
};

export function useQuestsForMap({
  enabled = true,
}: UseQuestsForMapOptions = {}) {
  const query = useQuery<Quest[], ApiError>({
    queryKey: queryKeys.quests.map(),
    queryFn: ({ signal }) => fetchAllQuests(signal),
    staleTime: 60_000,
    enabled,
  });

  const items = useMemo(() => query.data ?? [], [query.data]);

  return { ...query, items };
}
