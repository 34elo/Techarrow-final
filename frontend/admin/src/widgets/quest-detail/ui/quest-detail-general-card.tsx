"use client";

import {
  getQuestStatusLabel,
  type QuestDetail,
} from "@/entities/quest/model/quest-detail";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";
import { cn } from "@/shared/lib/classnames";

import { DetailRow } from "./detail-row";

type QuestDetailGeneralCardProps = {
  quest: QuestDetail;
  className?: string;
};

export function QuestDetailGeneralCard({
  quest,
  className,
}: QuestDetailGeneralCardProps) {
  const { t } = useTranslations();
  const statusLabel = getQuestStatusLabel(t, quest.status);
  const emptyValue = <span className="text-muted-foreground">—</span>;
  const rules =
    quest.rules_and_warnings && quest.rules_and_warnings.trim().length > 0 ? (
      <span className="whitespace-pre-wrap">{quest.rules_and_warnings}</span>
    ) : (
      emptyValue
    );
  const rejection =
    quest.rejection_reason && quest.rejection_reason.trim().length > 0
      ? quest.rejection_reason
      : emptyValue;

  return (
    <Card className={cn("flex h-full min-h-0 flex-col shadow-sm", className)}>
      <CardHeader className="border-b border-border/60 pb-4">
        <CardTitle className="text-base">
          {t("questDetail.aboutSection")}
        </CardTitle>
      </CardHeader>
      <CardContent className="flex-1 pt-4">
        <dl>
          <DetailRow label={t("questDetail.description")}>
            <span className="whitespace-pre-wrap">{quest.description}</span>
          </DetailRow>
          <DetailRow label={t("questDetail.location")}>
            {quest.location}
          </DetailRow>
          <DetailRow label={t("questDetail.difficulty")}>
            {quest.difficulty}
          </DetailRow>
          <DetailRow label={t("questDetail.duration")}>
            {t("questDetail.durationMinutes", {
              minutes: quest.duration_minutes,
            })}
          </DetailRow>
          <DetailRow label={t("questDetail.rulesAndWarnings")}>
            {rules}
          </DetailRow>
          <DetailRow label={t("questDetail.status")}>{statusLabel}</DetailRow>
          {quest.status === "rejected" ? (
            <DetailRow label={t("questDetail.rejectionReason")}>
              {rejection}
            </DetailRow>
          ) : null}
        </dl>
      </CardContent>
    </Card>
  );
}
