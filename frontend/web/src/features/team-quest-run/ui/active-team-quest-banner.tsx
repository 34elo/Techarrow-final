"use client";

import Image from "next/image";
import Link from "next/link";
import { ArrowRight, Users } from "lucide-react";

import { useActiveTeamQuestRun } from "../model/use-team-quest-run";
import { useQuestDetail } from "@/features/quests";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { truncateText } from "@/shared/lib/text";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";

const BANNER_TITLE_MAX = 50;

type ActiveTeamQuestBannerProps = {
  className?: string;
};

export function ActiveTeamQuestBanner({
  className,
}: ActiveTeamQuestBannerProps) {
  const { data: run } = useActiveTeamQuestRun({ poll: true });
  const { data: quest } = useQuestDetail(run?.quest_id);
  const { t } = useTranslations();

  if (!run || run.status === "completed") return null;

  const statusLabel =
    run.status === "in_progress"
      ? t("teamRun.statusInProgress")
      : run.status === "starting"
        ? t("teamRun.statusStarting")
        : t("teamRun.statusWaiting");

  let progressPct: number;
  let progressLine: string;
  if (run.status === "in_progress") {
    const total = Math.max(run.total_checkpoints, 1);
    progressPct = Math.round((run.completed_checkpoints / total) * 100);
    progressLine = t("teamRun.progressLabel", {
      done: run.completed_checkpoints,
      total: run.total_checkpoints,
    });
  } else {
    const total = Math.max(run.total_members, 1);
    progressPct = Math.round((run.ready_member_ids.length / total) * 100);
    progressLine = t("teamRun.readyOf", {
      ready: run.ready_member_ids.length,
      total: run.total_members,
    });
  }

  return (
    <div
      className={cn(
        "relative overflow-hidden rounded-3xl bg-card p-5 shadow-md dark:shadow-none dark:ring-1 dark:ring-white/5",
        className,
      )}
    >
      <Image
        src="/image.png"
        alt=""
        width={300}
        height={120}
        priority
        aria-hidden
        className="pointer-events-none absolute bottom-0 right-0 h-full w-44 select-none object-contain object-right-bottom opacity-80"
      />

      <div className="relative flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div className="min-w-0 flex-1 space-y-3">
          <div className="flex flex-wrap items-center gap-2">
            <Badge variant="default">
              <Users className="size-3" aria-hidden />
              {t("teamRun.bannerBadge")}
            </Badge>
            <Badge variant="outline">{statusLabel}</Badge>
          </div>

          <h3 className="truncate text-lg font-semibold text-primary">
            {quest?.title
              ? truncateText(quest.title, BANNER_TITLE_MAX)
              : t("activeQuest.loadingTitle")}
          </h3>

          <div className="space-y-1.5">
            <div className="h-1.5 overflow-hidden rounded-full bg-muted">
              <div
                className="h-full rounded-full bg-primary transition-[width] duration-300"
                style={{ width: `${progressPct}%` }}
              />
            </div>
            <p className="text-xs text-muted-foreground">{progressLine}</p>
          </div>
        </div>

        <div className="flex shrink-0 items-center gap-2">
          <Button asChild size="sm">
            <Link href={`/quests/${run.quest_id}/team-run`}>
              {t("activeQuest.continue")}
              <ArrowRight />
            </Link>
          </Button>
        </div>
      </div>
    </div>
  );
}
