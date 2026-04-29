"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { useEffect } from "react";
import { ArrowLeft, CheckCircle2 } from "lucide-react";

import { pushRecentlyViewedQuest } from "@/entities/quest/lib/recently-viewed";
import {
  ActiveQuestBanner,
  useActiveQuestRun,
  useCompletedQuestIds,
} from "@/features/quest-run";
import { ActiveTeamQuestBanner } from "@/features/team-quest-run";
import { useQuestDetail } from "@/features/quests";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { useAuthStore } from "@/shared/store/auth-store";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";
import { Skeleton } from "@/shared/ui/skeleton";

import { QuestCheckpointsList } from "./quest-checkpoints-list";
import { QuestDetailActions } from "./quest-detail-actions";
import { QuestDetailCover } from "./quest-detail-cover";
import { QuestDetailMeta } from "./quest-detail-meta";

export function QuestDetailPage() {
  const params = useParams<{ id: string }>();
  const idParam = params?.id;
  const questId = typeof idParam === "string" ? Number(idParam) : Number.NaN;
  const { t } = useTranslations();
  const userId = useAuthStore((state) => state.user?.id);

  const questQuery = useQuestDetail(
    Number.isFinite(questId) ? questId : undefined,
  );
  const { data: activeRun } = useActiveQuestRun();
  const completedIds = useCompletedQuestIds();

  const quest = questQuery.data;
  const isOwn = quest?.creator.id === userId;
  const isPassed = quest ? completedIds.has(quest.id) : false;
  const activeOnThisQuest =
    activeRun?.status === "in_progress" && activeRun.quest_id === questId;

  useEffect(() => {
    if (quest) {
      pushRecentlyViewedQuest(quest);
    }
  }, [quest]);

  return (
    <div className="space-y-6">
      <header className="flex flex-wrap items-center gap-3">
        <Button variant="ghost" size="sm" asChild>
          <Link href="/quests">
            <ArrowLeft />
            {t("common.back")}
          </Link>
        </Button>
      </header>

      <ActiveQuestBanner />
      <ActiveTeamQuestBanner />

      {questQuery.isLoading ? (
        <div className="grid gap-6 lg:grid-cols-[1.5fr_1fr]">
          <Skeleton className="aspect-video w-full" />
          <Skeleton className="h-72 w-full" />
        </div>
      ) : questQuery.isError ? (
        <p className="rounded-2xl border border-destructive/30 bg-destructive/10 p-4 text-sm text-destructive">
          {questQuery.error?.message || t("common.loadError")}
        </p>
      ) : quest ? (
        <div className="grid gap-6 lg:grid-cols-[1.5fr_1fr] lg:items-stretch">
          <div className="flex min-w-0 flex-col gap-4">
            <QuestDetailCover quest={quest} />
            <div className="space-y-3">
              <div className="flex flex-wrap items-start gap-3">
                <h1 className="text-balance text-2xl font-semibold tracking-tight sm:text-3xl">
                  {quest.title}
                </h1>
                {isPassed ? (
                  <Badge variant="success" className="mt-1 sm:mt-1.5">
                    <CheckCircle2 className="size-3.5" aria-hidden />
                    {t("quests.statusCompleted")}
                  </Badge>
                ) : null}
              </div>
              <QuestDetailMeta quest={quest} />
              <QuestDetailActions
                questId={quest.id}
                questTitle={quest.title}
                isOwn={Boolean(isOwn)}
              />
            </div>
            <Card className="flex min-w-0 flex-1 flex-col">
              <CardHeader>
                <CardTitle className="text-base">
                  {t("questDetail.aboutHeading")}
                </CardTitle>
              </CardHeader>
              <CardContent className="min-w-0 flex-1 space-y-4">
                <p className="min-w-0 whitespace-pre-wrap break-words text-sm leading-relaxed">
                  {quest.description}
                </p>
                {quest.rules_and_warnings ? (
                  <div className="min-w-0 space-y-1.5">
                    <h2 className="text-sm font-semibold">
                      {t("questDetail.rulesHeading")}
                    </h2>
                    <p className="min-w-0 whitespace-pre-wrap break-words text-sm leading-relaxed text-muted-foreground">
                      {quest.rules_and_warnings}
                    </p>
                  </div>
                ) : null}
              </CardContent>
            </Card>
          </div>
          <div className="flex h-full flex-col">
            <QuestCheckpointsList
              points={quest.points}
              hasActiveRun={activeOnThisQuest}
              currentStepIndex={
                activeOnThisQuest ? activeRun?.current_step_index : undefined
              }
            />
          </div>
        </div>
      ) : null}
    </div>
  );
}
