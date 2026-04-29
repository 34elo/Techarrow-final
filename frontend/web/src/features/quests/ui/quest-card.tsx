"use client";

import Image from "next/image";
import Link from "next/link";
import { CheckCircle2, Clock3, MapPin } from "lucide-react";

import {
  getDifficultyLabel,
  getQuestCoverImageUrl,
  getQuestStatusLabel,
  parseLocation,
  type Quest,
  type QuestStatus,
} from "@/entities/quest";
import { FavoriteButton } from "@/features/quest-favorites";
import { useCompletedQuestIds } from "@/features/quest-run";
import { ShareQuestButton } from "./share-quest-button";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { truncateText } from "@/shared/lib/text";
import { Badge } from "@/shared/ui/badge";
import { Card, CardContent } from "@/shared/ui/card";

const TITLE_PREVIEW_MAX = 60;
const DESCRIPTION_PREVIEW_MAX = 50;

type QuestCardProps = {
  quest: Quest;
  className?: string;
  showStatus?: boolean;
  actions?: React.ReactNode;
};

const STATUS_VARIANT: Record<
  QuestStatus,
  "default" | "secondary" | "outline" | "destructive" | "success"
> = {
  on_moderation: "secondary",
  published: "success",
  rejected: "destructive",
  archived: "outline",
};

export function QuestCard({
  quest,
  className,
  showStatus,
  actions,
}: QuestCardProps) {
  const { t } = useTranslations();
  const { city, district } = parseLocation(quest.location);
  const cover = getQuestCoverImageUrl(quest);
  const statusVariant = STATUS_VARIANT[quest.status] ?? "outline";
  const completedIds = useCompletedQuestIds();
  const isPassed = completedIds.has(quest.id);

  return (
    <Link
      href={`/quests/${quest.id}`}
      className={cn(
        "group block h-full w-full rounded-2xl outline-none focus-visible:ring-2 focus-visible:ring-ring/40",
        className,
      )}
    >
      <Card className="flex h-full flex-col overflow-hidden gap-0 py-0 text-left">
        <div className="relative aspect-[16/9] w-full shrink-0 overflow-hidden bg-muted">
          <Image
            src={cover}
            alt={quest.title}
            fill
            sizes="(max-width: 768px) 100vw, (max-width: 1024px) 50vw, 33vw"
            className="object-cover"
            unoptimized
          />
          <div className="absolute right-2 top-2 flex items-center gap-1.5">
            {actions}
            <ShareQuestButton
              questId={quest.id}
              questTitle={quest.title}
              variant="card"
              className="bg-card/80"
            />
            <FavoriteButton questId={quest.id} className="bg-card/80" />
          </div>
          {showStatus || isPassed ? (
            <div className="absolute left-2 top-2 flex flex-col items-start gap-1">
              {showStatus ? (
                <Badge variant={statusVariant} className="bg-card/90">
                  {getQuestStatusLabel(t, quest.status)}
                </Badge>
              ) : null}
              {isPassed ? (
                <Badge variant="success" className="bg-card/90">
                  <CheckCircle2 className="size-3" aria-hidden />
                  {t("quests.statusCompleted")}
                </Badge>
              ) : null}
            </div>
          ) : null}
        </div>
        <CardContent className="flex flex-1 flex-col gap-2 p-4">
          <div className="flex items-center justify-between gap-2">
            <span className="text-[11px] font-medium uppercase tracking-wide text-muted-foreground">
              {t("quest.difficulty")}: {getDifficultyLabel(quest.difficulty)}
            </span>
          </div>
          <h3 className="line-clamp-2 break-words text-base font-semibold leading-snug">
            {truncateText(quest.title, TITLE_PREVIEW_MAX)}
          </h3>
          <p className="line-clamp-2 break-words text-sm text-muted-foreground">
            {truncateText(quest.description, DESCRIPTION_PREVIEW_MAX)}
          </p>
          <div className="mt-auto flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-muted-foreground">
            <span className="inline-flex items-center gap-1">
              <MapPin className="size-3.5" aria-hidden />
              {[district, city].filter(Boolean).join(", ") || quest.location}
            </span>
            <span className="inline-flex items-center gap-1">
              <Clock3 className="size-3.5" aria-hidden />
              {t("quest.durationLabel", { count: quest.duration_minutes })}
            </span>
            <span className="text-muted-foreground/80">
              {t("quest.byAuthor", { author: quest.creator.username })}
            </span>
          </div>
        </CardContent>
      </Card>
    </Link>
  );
}
