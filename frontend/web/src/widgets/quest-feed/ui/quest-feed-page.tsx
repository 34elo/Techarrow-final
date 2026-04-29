"use client";

import { useState } from "react";

import { ActiveQuestBanner } from "@/features/quest-run";
import { ActiveTeamQuestBanner } from "@/features/team-quest-run";
import { QuestCardList } from "@/features/quests/ui/quest-card-list";
import { useQuests } from "@/features/quests";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { InfiniteListFooter } from "@/shared/ui/infinite-list-footer";
import { Skeleton } from "@/shared/ui/skeleton";

import { QuestFeedActions } from "./quest-feed-actions";
import {
  EMPTY_FEED_FILTERS,
  QuestFeedFilters,
  type QuestFeedFilterValues,
} from "./quest-feed-filters";

export function QuestFeedPage() {
  const { t } = useTranslations();
  const [filters, setFilters] =
    useState<QuestFeedFilterValues>(EMPTY_FEED_FILTERS);

  const questsQuery = useQuests({
    scope: "public",
    city: filters.city.trim() || undefined,
    difficulties: filters.difficulties.length
      ? filters.difficulties
      : undefined,
    nearLat: filters.nearLat ?? undefined,
    nearLng: filters.nearLng ?? undefined,
  });

  return (
    <div className="space-y-6">
      <header className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        <div className="space-y-2">
          <h1 className="text-3xl font-semibold tracking-tight">
            {t("quests.feedTitle")}
          </h1>
          <p className="text-sm text-muted-foreground">
            {t("quests.feedDescription")}
          </p>
        </div>
        <QuestFeedActions
          filtersSlot={
            <QuestFeedFilters value={filters} onChange={setFilters} />
          }
        />
      </header>

      <ActiveQuestBanner />
      <ActiveTeamQuestBanner />

      {questsQuery.isLoading ? (
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {Array.from({ length: 6 }).map((_, index) => (
            <Skeleton key={index} className="aspect-[4/5] w-full" />
          ))}
        </div>
      ) : questsQuery.isError ? (
        <p className="rounded-2xl border border-destructive/30 bg-destructive/10 p-4 text-sm text-destructive">
          {questsQuery.error?.message || t("common.loadError")}
        </p>
      ) : questsQuery.items.length === 0 ? (
        <p className="rounded-2xl border border-border bg-card p-6 text-center text-sm text-muted-foreground">
          {t("quests.empty")}
        </p>
      ) : (
        <>
          <QuestCardList quests={questsQuery.items} />
          <InfiniteListFooter
            hasNextPage={Boolean(questsQuery.hasNextPage)}
            fetchNextPage={() => questsQuery.fetchNextPage()}
            isFetchingNextPage={questsQuery.isFetchingNextPage}
          />
        </>
      )}
    </div>
  );
}
