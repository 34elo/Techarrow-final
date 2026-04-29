"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { ArrowRight, Compass, X } from "lucide-react";
import { toast } from "sonner";

import { useAbandonQuestRun, useActiveQuestRun } from "../model/use-quest-run";
import { runModeStorage, type QuestMode } from "../lib/run-mode-storage";
import { useQuestDetail } from "@/features/quests";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { truncateText } from "@/shared/lib/text";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";

const BANNER_TITLE_MAX = 50;

type ActiveQuestBannerProps = {
  className?: string;
};

export function ActiveQuestBanner({ className }: ActiveQuestBannerProps) {
  const { data: run } = useActiveQuestRun();
  const { data: quest } = useQuestDetail(run?.quest_id);
  const abandon = useAbandonQuestRun();
  const { t } = useTranslations();
  const [mode, setMode] = useState<QuestMode | null>(null);

  useEffect(() => {
    if (run) setMode(runModeStorage.get(run.run_id));
    else setMode(null);
  }, [run]);

  if (!run || run.status !== "in_progress") return null;

  const handleAbandon = () => {
    abandon.mutate(undefined, {
      onSuccess: () => {
        runModeStorage.clear(run.run_id);
        toast.success(t("activeQuest.abandoned"));
      },
      onError: (error) => {
        toast.error(t("activeQuest.abandonFailed"), {
          description: error.message || t("common.tryAgain"),
        });
      },
    });
  };

  const stepNumber = Math.min(
    run.current_step_index + 1,
    run.total_checkpoints,
  );
  const total = Math.max(run.total_checkpoints, 1);
  const progress = Math.round((stepNumber / total) * 100);

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
              <Compass className="size-3" aria-hidden />
              {t("activeQuest.badge")}
            </Badge>
            {mode ? (
              <Badge variant="outline">
                {mode === "team" ? t("startQuest.team") : t("startQuest.solo")}
              </Badge>
            ) : null}
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
                style={{ width: `${progress}%` }}
              />
            </div>
            <p className="text-xs text-muted-foreground">
              {t("activeQuest.progress", {
                current: stepNumber,
                total: run.total_checkpoints,
              })}
            </p>
          </div>
        </div>

        <div className="flex shrink-0 items-center gap-2">
          <Button asChild size="sm">
            <Link href={`/quests/${run.quest_id}/run`}>
              {t("activeQuest.continue")}
              <ArrowRight />
            </Link>
          </Button>
          <Button
            size="icon-sm"
            variant="ghost"
            onClick={handleAbandon}
            disabled={abandon.isPending}
            aria-label={t("activeQuest.stop")}
            className="text-destructive hover:bg-destructive/10 hover:text-destructive"
          >
            <X />
          </Button>
        </div>
      </div>
    </div>
  );
}
