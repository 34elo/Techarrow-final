"use client";

import Link from "next/link";

import type { QuestRunHistoryItem } from "@/entities/quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";

const PROGRESS_SEGMENTS = 3;

type RunHistoryCardProps = {
  item: QuestRunHistoryItem;
};

function getFilledSegments(status: QuestRunHistoryItem["status"]): number {
  if (status === "completed") return PROGRESS_SEGMENTS;
  if (status === "in_progress") return 2;
  return 1;
}

function formatUnit(
  locale: string,
  value: number,
  unit: "hour" | "minute",
): string {
  return new Intl.NumberFormat(locale, {
    style: "unit",
    unit,
    unitDisplay: "short",
  }).format(value);
}

function formatDuration(
  startedAt: string,
  completedAt: string,
  locale: string,
): string {
  const start = new Date(startedAt).getTime();
  const end = new Date(completedAt).getTime();
  const totalMinutes = Math.max(1, Math.round((end - start) / 60000));
  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;

  if (hours === 0) {
    return formatUnit(locale, totalMinutes, "minute");
  }
  if (minutes === 0) {
    return formatUnit(locale, hours, "hour");
  }
  return `${formatUnit(locale, hours, "hour")} ${formatUnit(locale, minutes, "minute")}`;
}

export function RunHistoryCard({ item }: RunHistoryCardProps) {
  const { t, locale } = useTranslations();
  const filled = getFilledSegments(item.status);
  const duration = formatDuration(item.started_at, item.completed_at, locale);

  return (
    <Link
      href={`/quests/${item.quest_id}`}
      className="group relative block overflow-hidden rounded-3xl bg-card shadow-md outline-none transition-shadow hover:shadow-lg focus-visible:ring-2 focus-visible:ring-ring/50 dark:shadow-none dark:ring-1 dark:ring-white/5"
    >
      <Hills className="pointer-events-none absolute bottom-0 right-0 h-full w-44 text-primary/30" />

      <div className="relative space-y-3 p-5">
        <h3 className="truncate text-lg font-semibold text-primary">
          {item.quest_title}
        </h3>

        <div className="flex gap-1.5" aria-hidden>
          {Array.from({ length: PROGRESS_SEGMENTS }).map((_, index) => (
            <span
              key={index}
              className={cn(
                "h-1.5 flex-1 rounded-full",
                index < filled ? "bg-primary" : "bg-muted",
              )}
            />
          ))}
        </div>

        <dl className="space-y-0.5 text-sm text-foreground/80">
          <div className="flex flex-wrap gap-x-1.5">
            <dt>{t("history.durationLabel")}:</dt>
            <dd className="tabular-nums">{duration}</dd>
          </div>
          <div className="flex flex-wrap gap-x-1.5">
            <dt>{t("history.pointsLabel")}:</dt>
            <dd className="tabular-nums">
              {item.points_awarded.toLocaleString(locale)}
            </dd>
          </div>
        </dl>
      </div>
    </Link>
  );
}

function Hills({ className }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 200 120"
      preserveAspectRatio="xMaxYMax meet"
      fill="currentColor"
      className={className}
      aria-hidden
    >
      <path
        d="M0 90 C 25 70, 45 80, 70 60 C 95 40, 120 70, 145 55 C 170 40, 185 65, 200 50 L 200 120 L 0 120 Z"
        opacity="0.55"
      />
      <path
        d="M40 100 C 70 80, 95 95, 125 78 C 150 65, 175 90, 200 78 L 200 120 L 40 120 Z"
        opacity="0.85"
      />
      <g fill="white" opacity="0.9">
        <rect x="155" y="78" width="10" height="10" rx="1" />
        <path d="M155 78 L 160 73 L 165 78 Z" />
        <rect x="172" y="82" width="8" height="8" rx="1" />
        <path d="M172 82 L 176 78 L 180 82 Z" />
      </g>
    </svg>
  );
}
