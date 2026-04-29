"use client";

import Link from "next/link";
import { ArrowRight, Trophy } from "lucide-react";

import type { QuestRunProgress } from "@/entities/quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";
import { Card, CardContent } from "@/shared/ui/card";

type RunSummaryCardProps = {
  run: QuestRunProgress;
};

export function RunSummaryCard({ run }: RunSummaryCardProps) {
  const { t } = useTranslations();
  const completed = run.status === "completed";

  return (
    <Card className="border-0 shadow-md">
      <CardContent className="space-y-4 px-4 py-6 text-center">
        <Badge variant="default">
          <Trophy className="size-3" aria-hidden />
          {completed ? t("run.completed") : t("run.abandoned")}
        </Badge>
        <h2 className="text-2xl font-semibold tracking-tight">
          {completed ? t("run.completedTitle") : t("run.abandonedTitle")}
        </h2>
        {completed ? (
          <p className="text-sm text-muted-foreground">
            {t("run.totalPoints", { count: run.points_awarded ?? 0 })}
          </p>
        ) : null}
        <div className="flex flex-wrap items-center justify-center gap-2">
          <Button asChild variant="outline">
            <Link href={`/quests/${run.quest_id}`}>{t("run.backToQuest")}</Link>
          </Button>
          <Button asChild>
            <Link href="/profile/history">
              {t("run.viewHistory")}
              <ArrowRight />
            </Link>
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
