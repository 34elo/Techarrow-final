"use client";

import Link from "next/link";
import { useParams, useRouter } from "next/navigation";
import { ArrowLeft, X } from "lucide-react";
import { toast } from "sonner";

import { useAbandonQuestRun, useActiveQuestRun } from "@/features/quest-run";
import { useQuestDetail } from "@/features/quests";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { Skeleton } from "@/shared/ui/skeleton";

import { RunCheckpointCard } from "./run-checkpoint-card";
import { RunMapCard } from "./run-map-card";
import { RunSummaryCard } from "./run-summary-card";
import { RunTimer } from "./run-timer";

export function QuestRunPage() {
  const { t } = useTranslations();
  const router = useRouter();
  const params = useParams<{ id: string }>();
  const idParam = params?.id;
  const questId = typeof idParam === "string" ? Number(idParam) : Number.NaN;

  const runQuery = useActiveQuestRun();
  const questQuery = useQuestDetail(
    Number.isFinite(questId) ? questId : undefined,
  );
  const abandon = useAbandonQuestRun();

  const run = runQuery.data;
  const quest = questQuery.data;

  const handleAbandon = () => {
    abandon.mutate(undefined, {
      onSuccess: () => {
        toast.success(t("activeQuest.abandoned"));
      },
      onError: (error) => {
        toast.error(t("activeQuest.abandonFailed"), {
          description: error.message || t("common.tryAgain"),
        });
      },
    });
  };

  if (runQuery.isLoading || questQuery.isLoading) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-8 w-32" />
        <div className="grid gap-4 lg:grid-cols-2">
          <Skeleton className="h-72 w-full rounded-3xl" />
          <Skeleton className="h-72 w-full rounded-3xl" />
        </div>
      </div>
    );
  }

  if (!run || run.quest_id !== questId) {
    return (
      <div className="space-y-4">
        <Button variant="ghost" size="sm" asChild>
          <Link href={`/quests/${questId}`}>
            <ArrowLeft />
            {t("common.back")}
          </Link>
        </Button>
        <p className="rounded-2xl bg-card p-6 text-sm text-muted-foreground shadow-md">
          {t("run.noActive")}
        </p>
        <Button onClick={() => router.push(`/quests/${questId}`)}>
          {t("run.openQuest")}
        </Button>
      </div>
    );
  }

  if (run.status !== "in_progress") {
    return (
      <div className="space-y-4">
        <Button variant="ghost" size="sm" asChild>
          <Link href={`/quests/${questId}`}>
            <ArrowLeft />
            {t("common.back")}
          </Link>
        </Button>
        <RunSummaryCard run={run} />
      </div>
    );
  }

  if (!run.current_checkpoint || !quest) {
    return null;
  }

  const stepLabel = t("run.stepLabel", {
    current: run.current_step_index + 1,
    total: run.total_checkpoints,
  });
  const progress = Math.round(
    ((run.current_step_index + 1) / run.total_checkpoints) * 100,
  );

  return (
    <div className="space-y-5">
      <header className="flex items-center justify-between gap-2">
        <Button variant="ghost" size="sm" asChild>
          <Link href={`/quests/${questId}`}>
            <ArrowLeft />
            {t("common.back")}
          </Link>
        </Button>
        <Button
          variant="ghost"
          size="sm"
          onClick={handleAbandon}
          disabled={abandon.isPending}
          className="text-destructive hover:bg-destructive/10 hover:text-destructive"
        >
          <X />
          {t("activeQuest.stop")}
        </Button>
      </header>

      <div className="space-y-2">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <h1 className="text-2xl font-semibold tracking-tight">
            {quest.title}
          </h1>
          <RunTimer startedAt={run.started_at} />
        </div>
        <div className="flex items-center gap-3">
          <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-muted">
            <div
              className="h-full rounded-full bg-primary transition-[width] duration-300"
              style={{ width: `${progress}%` }}
            />
          </div>
          <span className="shrink-0 text-xs tabular-nums text-muted-foreground">
            {stepLabel}
          </span>
        </div>
      </div>

      <div className="grid gap-4 lg:grid-cols-[1.1fr_1fr] lg:items-stretch">
        <RunCheckpointCard
          checkpoint={run.current_checkpoint}
          stepLabel={stepLabel}
        />
        <RunMapCard run={run} quest={quest} />
      </div>
    </div>
  );
}
