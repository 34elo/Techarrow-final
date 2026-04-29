"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";

import { useQuestRunHistory } from "@/features/quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { Skeleton } from "@/shared/ui/skeleton";

import { RunHistoryCard } from "./run-history-card";

const PAGE_SIZE = 10;

export function RunHistoryPage() {
  const { t } = useTranslations();
  const { data, isLoading, isError, error } = useQuestRunHistory();
  const [visibleCount, setVisibleCount] = useState(PAGE_SIZE);

  const visibleItems = useMemo(
    () => data?.slice(0, visibleCount) ?? [],
    [data, visibleCount],
  );

  const hasMore = (data?.length ?? 0) > visibleCount;

  return (
    <div className="space-y-6">
      <header className="flex flex-wrap items-center gap-3">
        <Button variant="ghost" size="sm" asChild>
          <Link href="/profile">
            <ArrowLeft />
            {t("common.back")}
          </Link>
        </Button>
        <div className="space-y-1">
          <h1 className="text-2xl font-semibold tracking-tight">
            {t("history.title")}
          </h1>
          <p className="text-sm text-muted-foreground">
            {t("history.description")}
          </p>
        </div>
      </header>

      {isLoading ? (
        <div className="space-y-3">
          {Array.from({ length: 4 }).map((_, index) => (
            <Skeleton key={index} className="h-20 w-full" />
          ))}
        </div>
      ) : isError ? (
        <p className="rounded-2xl border border-destructive/30 bg-destructive/10 p-4 text-sm text-destructive">
          {error?.message || t("common.loadError")}
        </p>
      ) : !data || data.length === 0 ? (
        <p className="rounded-2xl border border-border bg-card p-6 text-center text-sm text-muted-foreground">
          {t("history.empty")}
        </p>
      ) : (
        <>
          <ul className="space-y-3">
            {visibleItems.map((item) => (
              <li key={item.run_id}>
                <RunHistoryCard item={item} />
              </li>
            ))}
          </ul>
          {hasMore ? (
            <div className="mt-6 flex flex-wrap justify-center gap-3">
              <Button
                variant="outline"
                onClick={() => setVisibleCount((count) => count + PAGE_SIZE)}
              >
                {t("common.loadMore")}
              </Button>
              <Button
                variant="outline"
                onClick={() => setVisibleCount(data.length)}
              >
                {t("common.loadAll")}
              </Button>
            </div>
          ) : null}
        </>
      )}
    </div>
  );
}
