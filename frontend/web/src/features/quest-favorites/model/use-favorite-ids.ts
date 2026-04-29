"use client";

import { useQuery } from "@tanstack/react-query";

import { questsService } from "@/features/quests/api/quests-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { useAuthStore } from "@/shared/store/auth-store";
import type { ApiError } from "@/shared/api";

const PAGE_SIZE = 100;

async function fetchAllFavoriteIds(): Promise<Set<number>> {
  const ids = new Set<number>();
  let offset = 0;
  while (true) {
    const page = await questsService.listFavorites({
      limit: PAGE_SIZE,
      offset,
    });
    for (const quest of page.items) {
      ids.add(quest.id);
    }
    offset += page.limit;
    if (offset >= page.total || page.items.length === 0) break;
  }
  return ids;
}

export function useFavoriteIds() {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);

  return useQuery<Set<number>, ApiError>({
    queryKey: queryKeys.quests.favorites(),
    queryFn: () => fetchAllFavoriteIds(),
    enabled: isAuthenticated,
    staleTime: 30_000,
  });
}
