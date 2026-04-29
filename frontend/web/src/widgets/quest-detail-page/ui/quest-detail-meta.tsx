"use client";

import { Clock3, Compass, MapPin, Sparkles, Trophy, User } from "lucide-react";

import {
  formatBestCompletion,
  getDifficultyLabel,
  parseLocation,
  type QuestDetail,
} from "@/entities/quest";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Badge } from "@/shared/ui/badge";

type QuestDetailMetaProps = {
  quest: QuestDetail;
};

export function QuestDetailMeta({ quest }: QuestDetailMetaProps) {
  const { t } = useTranslations();
  const { city, district } = parseLocation(quest.location);

  return (
    <div className="flex flex-wrap items-center gap-3 text-sm text-muted-foreground">
      <Badge variant="default">
        <Sparkles className="size-3.5" aria-hidden />
        {t("quest.difficulty")}: {getDifficultyLabel(quest.difficulty)}
      </Badge>
      <span className="inline-flex items-center gap-1">
        <Clock3 className="size-4" aria-hidden />
        {t("quest.durationLabel", { count: quest.duration_minutes })}
      </span>
      <span className="inline-flex items-center gap-1">
        <MapPin className="size-4" aria-hidden />
        {[district, city].filter(Boolean).join(", ") || quest.location}
      </span>
      <span className="inline-flex items-center gap-1">
        <User className="size-4" aria-hidden />
        {t("quest.byAuthor", { author: quest.creator.username })}
      </span>
      <span className="inline-flex items-center gap-1">
        <Compass className="size-4" aria-hidden />
        {t("questDetail.checkpointsCount", { count: quest.points.length })}
      </span>
      {quest.best_completion_seconds != null ? (
        <Badge variant="success">
          <Trophy className="size-3.5" aria-hidden />
          {t("quest.bestTime")}: {formatBestCompletion(quest.best_completion_seconds)}
        </Badge>
      ) : null}
    </div>
  );
}
