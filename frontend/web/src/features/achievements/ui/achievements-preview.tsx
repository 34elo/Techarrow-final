"use client";

import Image from "next/image";
import Link from "next/link";
import { ChevronRight, Trophy } from "lucide-react";

import {
  getAchievementImageUrl,
  type Achievement,
} from "@/entities/achievement";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { Card, CardContent } from "@/shared/ui/card";
import { Skeleton } from "@/shared/ui/skeleton";

import { useMyAchievements } from "../model/use-achievements";

const RECENT_LIMIT = 3;
const RING_SIZE = 128;
const RING_STROKE = 8;

type AchievementsPreviewProps = {
  className?: string;
};

export function AchievementsPreview({ className }: AchievementsPreviewProps) {
  const { t } = useTranslations();
  const { data, isLoading } = useMyAchievements();

  const total = data.length;
  const unlocked = data.filter((item) => item.unlocked);
  const unlockedCount = unlocked.length;
  const recent = unlocked.slice(0, RECENT_LIMIT);
  const progress = total > 0 ? unlockedCount / total : 0;
  const percent = Math.round(progress * 100);

  return (
    <Card className={cn("overflow-hidden border-0 shadow-md", className)}>
      <CardContent className="flex h-full flex-col gap-4 p-5">
        <div className="flex items-center justify-between gap-3">
          <p className="text-sm font-semibold">
            {t("profile.achievementsHeading")}
          </p>
          <Link
            href="/profile/achievements"
            className="inline-flex items-center gap-0.5 rounded-xl px-2 py-1 text-xs font-medium text-primary outline-none transition-colors hover:text-primary/80 focus-visible:ring-2 focus-visible:ring-ring/40"
          >
            {t("common.show")}
            <ChevronRight className="size-3.5" aria-hidden />
          </Link>
        </div>

        {isLoading ? (
          <div className="flex flex-1 flex-col items-center justify-center gap-3 py-2">
            <Skeleton className="size-32 rounded-full" />
            <Skeleton className="h-3 w-24" />
          </div>
        ) : total === 0 ? (
          <div className="flex flex-1 flex-col items-center justify-center gap-2 py-4 text-center">
            <div className="flex size-16 items-center justify-center rounded-full bg-muted text-muted-foreground">
              <Trophy className="size-7" aria-hidden />
            </div>
            <p className="text-xs text-muted-foreground">
              {t("profile.achievementsEmpty")}
            </p>
          </div>
        ) : (
          <div className="flex flex-1 flex-col items-center justify-center gap-3 py-1 text-center">
            <ProgressRing progress={progress} percent={percent} />
            <p className="text-sm font-medium">
              {t("achievements.progress", {
                unlocked: unlockedCount,
                total,
              })}
            </p>
            {recent.length > 0 ? (
              <ul className="flex items-center justify-center gap-2">
                {recent.map((item) => (
                  <RecentBadge key={item.id} achievement={item} />
                ))}
              </ul>
            ) : (
              <p className="text-xs text-muted-foreground">
                {t("profile.achievementsEmpty")}
              </p>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function ProgressRing({
  progress,
  percent,
}: {
  progress: number;
  percent: number;
}) {
  const radius = (RING_SIZE - RING_STROKE) / 2;
  const center = RING_SIZE / 2;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference * (1 - Math.max(0, Math.min(1, progress)));

  return (
    <div
      className="relative flex items-center justify-center"
      style={{ width: RING_SIZE, height: RING_SIZE }}
    >
      <svg
        viewBox={`0 0 ${RING_SIZE} ${RING_SIZE}`}
        className="size-full -rotate-90"
        aria-hidden
      >
        <circle
          cx={center}
          cy={center}
          r={radius}
          fill="none"
          stroke="currentColor"
          strokeWidth={RING_STROKE}
          className="text-muted/60"
        />
        <circle
          cx={center}
          cy={center}
          r={radius}
          fill="none"
          stroke="currentColor"
          strokeWidth={RING_STROKE}
          strokeLinecap="round"
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          className="text-primary transition-[stroke-dashoffset] duration-500 ease-out"
        />
      </svg>
      <div className="pointer-events-none absolute inset-0 flex flex-col items-center justify-center gap-0.5">
        <Trophy className="size-7 text-primary" aria-hidden />
        <span className="text-xl font-semibold leading-none">{percent}%</span>
      </div>
    </div>
  );
}

function RecentBadge({ achievement }: { achievement: Achievement }) {
  const imageUrl = getAchievementImageUrl(achievement);

  return (
    <li
      title={achievement.title}
      className="relative flex size-10 shrink-0 items-center justify-center overflow-hidden rounded-full bg-primary/15 text-primary ring-2 ring-card"
    >
      {imageUrl ? (
        <Image
          src={imageUrl}
          alt={achievement.title}
          fill
          sizes="40px"
          className="object-cover"
          unoptimized
        />
      ) : (
        <Trophy className="size-5" aria-hidden />
      )}
    </li>
  );
}
