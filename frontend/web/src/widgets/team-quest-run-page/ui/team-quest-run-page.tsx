"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { ArrowLeft } from "lucide-react";

import { useQuestDetail } from "@/features/quests";
import {
  useActiveTeamQuestRun,
  useTeamRunNotifications,
} from "@/features/team-quest-run";
import { useMyTeam } from "@/features/teams";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { Skeleton } from "@/shared/ui/skeleton";

import { TeamCheckpointItem } from "./team-checkpoint-item";
import { TeamCountdownCard } from "./team-countdown-card";
import { TeamReadinessCard } from "./team-readiness-card";
import { TeamRunMapCard } from "./team-run-map-card";
import { TeamRunSummaryCard } from "./team-run-summary-card";

export function TeamQuestRunPage() {
  const { t } = useTranslations();
  const params = useParams<{ id: string }>();
  const idParam = params?.id;
  const questId = typeof idParam === "string" ? Number(idParam) : Number.NaN;
  const validQuestId = Number.isFinite(questId) ? questId : undefined;

  const runQuery = useActiveTeamQuestRun({ poll: true });
  const questQuery = useQuestDetail(validQuestId);
  const teamQuery = useMyTeam();

  const run = runQuery.data;
  const quest = questQuery.data;
  const team = teamQuery.data;

  useTeamRunNotifications(run, team);

  if (runQuery.isLoading || questQuery.isLoading) {
    return (
      <div className="space-y-4">
        <Skeleton className="h-8 w-32" />
        <Skeleton className="h-72 w-full rounded-3xl" />
      </div>
    );
  }

  const backButton = (
    <Button variant="ghost" size="sm" asChild>
      <Link href={`/quests/${questId}`}>
        <ArrowLeft />
        {t("common.back")}
      </Link>
    </Button>
  );

  if (!run || run.quest_id !== questId) {
    return (
      <div className="space-y-4">
        {backButton}
        <p className="rounded-2xl bg-card p-6 text-sm text-muted-foreground shadow-md">
          {t("teamRun.noActive")}
        </p>
      </div>
    );
  }

  if (!quest) return null;

  if (run.status === "completed") {
    return (
      <div className="space-y-4">
        {backButton}
        <TeamRunSummaryCard run={run} />
      </div>
    );
  }

  if (run.status === "waiting_for_team") {
    return (
      <div className="space-y-4">
        {backButton}
        <h1 className="text-2xl font-semibold tracking-tight">{quest.title}</h1>
        <TeamReadinessCard
          questId={questId}
          questTitle={quest.title}
          team={team}
          run={run}
        />
      </div>
    );
  }

  if (run.status === "starting") {
    return (
      <div className="space-y-4">
        {backButton}
        <h1 className="text-2xl font-semibold tracking-tight">{quest.title}</h1>
        <TeamCountdownCard startsAt={run.starts_at} />
        <TeamReadinessCard
          questId={questId}
          questTitle={quest.title}
          team={team}
          run={run}
        />
      </div>
    );
  }

  // in_progress
  const progressPct = Math.round(
    (run.completed_checkpoints / Math.max(run.total_checkpoints, 1)) * 100,
  );

  return (
    <div className="space-y-5">
      <header className="flex items-center justify-between gap-2">
        {backButton}
      </header>

      <div className="space-y-2">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <h1 className="text-2xl font-semibold tracking-tight">
            {quest.title}
          </h1>
          <span className="text-xs tabular-nums text-muted-foreground">
            {t("teamRun.progressLabel", {
              done: run.completed_checkpoints,
              total: run.total_checkpoints,
            })}
          </span>
        </div>
        <div className="h-1.5 overflow-hidden rounded-full bg-muted">
          <div
            className="h-full rounded-full bg-primary transition-[width] duration-300"
            style={{ width: `${progressPct}%` }}
          />
        </div>
      </div>

      <div className="grid gap-4 lg:grid-cols-[1.1fr_1fr] lg:items-start">
        <div className="space-y-3">
          {run.checkpoints.map((checkpoint, index) => (
            <TeamCheckpointItem
              key={checkpoint.id}
              checkpoint={checkpoint}
              index={index}
              team={team}
            />
          ))}
        </div>
        <TeamRunMapCard run={run} quest={quest} />
      </div>
    </div>
  );
}
