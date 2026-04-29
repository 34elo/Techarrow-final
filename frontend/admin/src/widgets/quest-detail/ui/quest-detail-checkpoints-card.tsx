"use client";

import { useState } from "react";
import {
  CheckCircle2,
  HelpCircle,
  ListChecks,
  MapPin,
  ScrollText,
} from "lucide-react";

import type { QuestDetail, QuestPoint } from "@/entities/quest";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/shared/ui/dialog";

type QuestDetailCheckpointsCardProps = {
  quest: QuestDetail;
  className?: string;
};

type CheckpointFieldProps = {
  icon: React.ReactNode;
  label: string;
  children: React.ReactNode;
  mono?: boolean;
};

function CheckpointField({
  icon,
  label,
  children,
  mono,
}: CheckpointFieldProps) {
  return (
    <div className="flex min-w-0 items-start gap-1.5 text-sm leading-relaxed">
      <span
        className="mt-0.5 inline-flex shrink-0 text-muted-foreground"
        aria-hidden
      >
        {icon}
      </span>
      <p className="min-w-0 flex-1 break-words">
        <span className="font-semibold">{label}: </span>
        <span
          className={cn(
            "whitespace-pre-wrap font-normal",
            mono && "break-all font-mono",
          )}
        >
          {children}
        </span>
      </p>
    </div>
  );
}

function buildOsmEmbedUrl(latitude: number, longitude: number): string {
  const delta = 0.005;
  const bbox = [
    longitude - delta,
    latitude - delta,
    longitude + delta,
    latitude + delta,
  ].join(",");
  const params = new URLSearchParams({
    bbox,
    layer: "mapnik",
    marker: `${latitude},${longitude}`,
  });
  return `https://www.openstreetmap.org/export/embed.html?${params.toString()}`;
}

export function QuestDetailCheckpointsCard({
  quest,
  className,
}: QuestDetailCheckpointsCardProps) {
  const { t } = useTranslations();
  const points = quest.points ?? [];
  const [activePoint, setActivePoint] = useState<QuestPoint | null>(null);

  return (
    <>
      <Card className={cn("flex h-full min-h-0 flex-col shadow-sm", className)}>
        <CardHeader className="border-b border-border/60 pb-4">
          <CardTitle className="text-base">
            {t("questDetail.checkpointsHeading")}
          </CardTitle>
          <p className="text-xs text-muted-foreground">
            {t("questDetail.checkpointsCount")}: {points.length}
          </p>
        </CardHeader>
        <CardContent className="flex-1 pt-4">
          {points.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              {t("questDetail.checkpointsEmpty")}
            </p>
          ) : (
            <ol className="space-y-3">
              {points.map((point, index) => (
                <li key={point.id}>
                  <button
                    type="button"
                    onClick={() => setActivePoint(point)}
                    className="group block w-full rounded-xl border border-border/60 bg-card p-3 text-left transition-colors hover:border-primary/40 hover:bg-secondary/40 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
                    aria-label={t("questDetail.checkpointShowMap")}
                  >
                    <div className="flex min-w-0 items-start gap-3">
                      <span className="flex size-7 shrink-0 items-center justify-center rounded-full bg-secondary text-xs font-semibold text-secondary-foreground">
                        {index + 1}
                      </span>
                      <div className="min-w-0 flex-1 space-y-2">
                        <div className="flex min-w-0 items-start justify-between gap-2">
                          <p className="min-w-0 flex-1 break-words text-sm font-semibold leading-snug">
                            {point.title}
                          </p>
                          <span
                            className="inline-flex shrink-0 items-center gap-1 rounded-md border border-border/60 px-1.5 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground transition-colors group-hover:border-primary/40 group-hover:text-foreground"
                            title={t("questDetail.checkpointShowMap")}
                          >
                            <MapPin className="size-3" aria-hidden />
                            <span className="hidden sm:inline">
                              {t("questDetail.checkpointShowMap")}
                            </span>
                          </span>
                        </div>
                        <p className="flex items-center gap-1.5 text-[11px] text-muted-foreground">
                          <MapPin className="size-3 shrink-0" aria-hidden />
                          <span className="break-all font-mono tabular-nums tracking-tight">
                            {point.latitude.toFixed(4)}°,{" "}
                            {point.longitude.toFixed(4)}°
                          </span>
                        </p>
                        {point.task ? (
                          <CheckpointField
                            icon={<ListChecks className="size-3.5" />}
                            label={t("questDetail.checkpointTask")}
                          >
                            {point.task}
                          </CheckpointField>
                        ) : null}
                        {point.correct_answer ? (
                          <CheckpointField
                            icon={<CheckCircle2 className="size-3.5" />}
                            label={t("questDetail.checkpointAnswer")}
                            mono
                          >
                            {point.correct_answer}
                          </CheckpointField>
                        ) : null}
                        {point.hint ? (
                          <CheckpointField
                            icon={<HelpCircle className="size-3.5" />}
                            label={t("questDetail.checkpointHint")}
                          >
                            {point.hint}
                          </CheckpointField>
                        ) : null}
                        {point.point_rules ? (
                          <CheckpointField
                            icon={<ScrollText className="size-3.5" />}
                            label={t("questDetail.checkpointRules")}
                          >
                            {point.point_rules}
                          </CheckpointField>
                        ) : null}
                      </div>
                    </div>
                  </button>
                </li>
              ))}
            </ol>
          )}
        </CardContent>
      </Card>

      <Dialog
        open={activePoint !== null}
        onOpenChange={(open) => {
          if (!open) setActivePoint(null);
        }}
      >
        <DialogContent className="sm:max-w-2xl">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <MapPin className="size-4" aria-hidden />
              {activePoint?.title || t("questDetail.checkpointMapTitle")}
            </DialogTitle>
            {activePoint ? (
              <p className="font-mono text-xs text-muted-foreground">
                {activePoint.latitude.toFixed(6)}°,{" "}
                {activePoint.longitude.toFixed(6)}°
              </p>
            ) : null}
          </DialogHeader>
          {activePoint ? (
            <div className="aspect-video w-full overflow-hidden rounded-xl border border-border/60 bg-muted">
              <iframe
                key={`${activePoint.latitude},${activePoint.longitude}`}
                title={activePoint.title}
                src={buildOsmEmbedUrl(
                  activePoint.latitude,
                  activePoint.longitude,
                )}
                className="h-full w-full"
                loading="lazy"
              />
            </div>
          ) : null}
        </DialogContent>
      </Dialog>
    </>
  );
}
