"use client";

import Link from "next/link";
import { ArrowRight, Trophy } from "lucide-react";

import type { TeamQuestRunProgress } from "@/entities/team-quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";
import { Card, CardContent } from "@/shared/ui/card";

type TeamRunSummaryCardProps = {
  run: TeamQuestRunProgress;
};

export function TeamRunSummaryCard({ run }: TeamRunSummaryCardProps) {
  const { t } = useTranslations();
  return (
    <Card className="border-0 shadow-md">
      <CardContent className="space-y-4 px-4 py-6 text-center">
        <Badge variant="default">
          <Trophy className="size-3" aria-hidden />
          {t("teamRun.completedBadge")}
        </Badge>
        <h2 className="text-2xl font-semibold tracking-tight">
          {t("teamRun.completedTitle")}
        </h2>
        <p className="text-sm text-muted-foreground">
          {t("run.totalPoints", { count: run.points_awarded ?? 0 })}
        </p>
        <div className="flex flex-wrap items-center justify-center gap-2">
          <Button asChild variant="outline">
            <Link href={`/quests/${run.quest_id}`}>{t("run.backToQuest")}</Link>
          </Button>
          <Button asChild>
            <Link href="/team">
              {t("teamRun.openTeam")}
              <ArrowRight />
            </Link>
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
