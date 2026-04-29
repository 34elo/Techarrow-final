"use client";

import { useState } from "react";

import {
  getQuestCoverImageUrl,
  type QuestDetail,
} from "@/entities/quest/model/quest-detail";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";

type QuestDetailCoverCardProps = {
  quest: QuestDetail;
  className?: string;
};

export function QuestDetailCoverCard({
  quest,
  className,
}: QuestDetailCoverCardProps) {
  const { t } = useTranslations();
  const src = getQuestCoverImageUrl(quest);
  const [showFallback, setShowFallback] = useState(false);
  const alt =
    quest.title.trim().length > 0 ? quest.title : t("questDetail.cover");

  return (
    <Card
      className={cn(
        "flex h-full min-h-0 min-w-0 flex-col gap-0 overflow-hidden border-border/70 py-4 shadow-none",
        className,
      )}
    >
      <CardHeader className="shrink-0 space-y-0 border-b border-border/60 px-4 pb-4">
        <CardTitle className="text-base font-semibold leading-snug">
          {t("questDetail.cover")}
        </CardTitle>
      </CardHeader>
      <CardContent className="flex min-h-0 min-w-0 flex-1 flex-col gap-3 px-4 pt-4">
        <div className="relative isolate aspect-video w-full max-w-full overflow-hidden rounded-xl bg-muted ring-1 ring-border/50">
          {!showFallback ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={src}
              alt={alt}
              className="absolute inset-0 h-full w-full object-cover object-center"
              onError={() => setShowFallback(true)}
            />
          ) : (
            <div className="absolute inset-0 flex flex-col items-center justify-center px-4 py-10 text-center text-sm text-muted-foreground">
              {t("questDetail.coverPlaceholder")}
            </div>
          )}
        </div>
        {quest.image_file_id ? (
          <p className="break-all text-xs leading-relaxed text-muted-foreground">
            <span className="font-medium text-foreground">
              {t("questDetail.imageFileId")}:{" "}
            </span>
            <span className="font-mono">{quest.image_file_id}</span>
          </p>
        ) : null}
      </CardContent>
    </Card>
  );
}
