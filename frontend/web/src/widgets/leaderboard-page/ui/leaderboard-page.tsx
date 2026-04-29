"use client";

import { useState } from "react";

import { useLeaderboard } from "@/features/leaderboard";
import { LeaderboardTable } from "@/features/leaderboard/ui/leaderboard-table";
import { SelfPositionCard } from "@/features/leaderboard/ui/self-position-card";
import { useMyTeam } from "@/features/teams";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { InfiniteListFooter } from "@/shared/ui/infinite-list-footer";
import { Skeleton } from "@/shared/ui/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/shared/ui/tabs";
import type { RatingScope } from "@/shared/lib/react-query/query-keys";

const TABS: RatingScope[] = ["users", "teams"];

export function LeaderboardPage() {
  const { t } = useTranslations();
  const { data: team } = useMyTeam();
  const [scope, setScope] = useState<RatingScope>("users");
  const query = useLeaderboard(scope);

  return (
    <div className="space-y-5">
      <header className="space-y-2">
        <h1 className="text-3xl font-semibold tracking-tight">
          {t("leaderboard.title")}
        </h1>
        <p className="text-sm text-muted-foreground">
          {t("leaderboard.description")}
        </p>
      </header>

      <Tabs
        value={scope}
        onValueChange={(value) => setScope(value as RatingScope)}
      >
        <TabsList>
          {TABS.map((value) => (
            <TabsTrigger key={value} value={value}>
              {value === "users"
                ? t("leaderboard.personalTab")
                : t("leaderboard.teamTab")}
            </TabsTrigger>
          ))}
        </TabsList>

        {TABS.map((value) => (
          <TabsContent key={value} value={value} className="space-y-4">
            <SelfPositionCard
              scope={value}
              self={query.self}
              team={team ?? null}
            />

            {query.isLoading ? (
              <Skeleton className="h-72 w-full" />
            ) : query.isError ? (
              <p className="rounded-2xl border border-destructive/30 bg-destructive/10 p-4 text-sm text-destructive">
                {query.error?.message || t("common.loadError")}
              </p>
            ) : (
              <>
                <LeaderboardTable
                  entries={query.entries}
                  participantLabel={
                    value === "users"
                      ? t("leaderboard.participantColumn")
                      : t("leaderboard.teamColumn")
                  }
                />
                <InfiniteListFooter
                  hasNextPage={Boolean(query.hasNextPage)}
                  fetchNextPage={() => query.fetchNextPage()}
                  isFetchingNextPage={query.isFetchingNextPage}
                />
              </>
            )}
          </TabsContent>
        ))}
      </Tabs>
    </div>
  );
}
