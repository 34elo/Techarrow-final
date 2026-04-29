"use client";

import Link from "next/link";
import { ArrowLeft, Trophy } from "lucide-react";

import { AchievementsGrid, useMyAchievements } from "@/features/achievements";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { Skeleton } from "@/shared/ui/skeleton";

export function AchievementsPage() {
  const { t } = useTranslations();
  const { data, isLoading, isError, error } = useMyAchievements();

  const unlockedCount = data.filter((item) => item.unlocked).length;

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
            {t("profile.achievementsHeading")}
          </h1>
          {!isLoading && !isError && data.length > 0 ? (
            <p className="text-xs text-muted-foreground">
              {t("achievements.progress", {
                unlocked: unlockedCount,
                total: data.length,
              })}
            </p>
          ) : null}
        </div>
      </header>

      {isLoading ? (
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 md:grid-cols-3">
          {Array.from({ length: 6 }).map((_, index) => (
            <Skeleton key={index} className="h-24 w-full rounded-2xl" />
          ))}
        </div>
      ) : isError ? (
        <p className="rounded-2xl border border-destructive/30 bg-destructive/10 p-4 text-sm text-destructive">
          {error?.message || t("common.loadError")}
        </p>
      ) : data.length === 0 ? (
        <div className="flex flex-col items-center justify-center gap-3 rounded-2xl border border-dashed border-border bg-card p-10 text-center">
          <Trophy className="size-10 text-muted-foreground" aria-hidden />
          <p className="text-sm text-muted-foreground">
            {t("profile.achievementsEmpty")}
          </p>
        </div>
      ) : (
        <AchievementsGrid achievements={data} />
      )}
    </div>
  );
}
