"use client";

import Link from "next/link";
import { Check, CircleAlert, X } from "lucide-react";

import type { Report } from "@/entities/report";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/shared/ui/card";

type ReportCardProps = {
  report: Report;
  onAccept: (report: Report) => void;
  onDismiss: (report: Report) => void;
  isPending?: boolean;
};

export function ReportCard({
  report,
  onAccept,
  onDismiss,
  isPending,
}: ReportCardProps) {
  const { t } = useTranslations();

  return (
    <Card className="h-full min-w-0 gap-0 overflow-hidden border-border/70 py-4 shadow-none">
      <CardHeader className="gap-2 space-y-2 px-4 pb-2">
        <div className="flex flex-wrap items-start justify-between gap-2">
          <CardTitle className="line-clamp-2 text-base font-semibold leading-snug">
            <Link
              href={`/quests/${report.quest_id}`}
              className="text-foreground underline-offset-4 transition-colors hover:text-primary hover:underline focus-visible:rounded-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
            >
              {t("reportCard.questLink", { id: report.quest_id })}
            </Link>
          </CardTitle>
          <div className="inline-flex shrink-0 items-center gap-1 rounded-full border border-border/80 px-2 py-0.5 text-[11px] text-muted-foreground">
            <CircleAlert className="size-3" aria-hidden />
            <span>{t("reportCard.complaintLabel", { id: report.id })}</span>
          </div>
        </div>
        <p className="text-xs text-muted-foreground">
          {t("reportCard.from")} {report.author.username}
        </p>
      </CardHeader>

      <CardContent className="space-y-2 px-4 pb-3 pt-0">
        <p className="line-clamp-4 whitespace-pre-wrap text-sm text-muted-foreground">
          {report.reason}
        </p>
      </CardContent>

      <CardFooter className="mt-auto grid grid-cols-2 gap-2 px-4 pt-1">
        <Button
          size="sm"
          variant="destructive"
          className="w-full"
          disabled={isPending}
          onClick={() => onAccept(report)}
        >
          <Check />
          {t("reportCard.acceptComplaint")}
        </Button>
        <Button
          size="sm"
          variant="outline"
          className="w-full"
          disabled={isPending}
          onClick={() => onDismiss(report)}
        >
          <X />
          {t("reportCard.dismiss")}
        </Button>
      </CardFooter>
    </Card>
  );
}
