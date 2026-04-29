"use client";

import { AlertTriangle, MapPin, Pencil, Plus, Trash2 } from "lucide-react";

import type { CheckpointDraftEntry } from "@/features/quest-form";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { truncateText } from "@/shared/lib/text";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";

const MIN_CHECKPOINTS = 3;
const TASK_MIN_LENGTH = 20;
const PREVIEW_TASK_MAX = 50;
const PREVIEW_TITLE_MAX = 32;

type CheckpointListProps = {
  checkpoints: CheckpointDraftEntry[];
  onAdd: () => void;
  onEdit: (key: string) => void;
  onRemove: (key: string) => void;
};

export function CheckpointList({
  checkpoints,
  onAdd,
  onEdit,
  onRemove,
}: CheckpointListProps) {
  const { t } = useTranslations();
  const reachedMin = checkpoints.length >= MIN_CHECKPOINTS;

  return (
    <Card className="h-full">
      <CardHeader>
        <CardTitle className="flex items-center justify-between gap-2">
          <span>{t("questCreate.sectionCheckpoints")}</span>
          <Badge variant={reachedMin ? "default" : "outline"}>
            {checkpoints.length}/{MIN_CHECKPOINTS}+
          </Badge>
        </CardTitle>
        <p className="text-xs text-muted-foreground">
          {t("questCreate.checkpointsHint")}
        </p>
      </CardHeader>
      <CardContent className="space-y-3">
        {checkpoints.length === 0 ? (
          <p className="rounded-lg border border-dashed border-border p-3 text-center text-xs text-muted-foreground">
            {t("questCreate.noCheckpoints")}
          </p>
        ) : (
          <ul className="grid grid-cols-1 gap-2">
            {checkpoints.map((cp, index) => {
              const taskTooShort = cp.task.trim().length < TASK_MIN_LENGTH;
              return (
                <li
                  key={cp.key}
                  className={cn(
                    "flex h-28 items-start gap-3 overflow-hidden rounded-xl border bg-card p-3",
                    taskTooShort
                      ? "border-destructive/40 bg-destructive/5"
                      : "border-border",
                  )}
                >
                  <div className="flex size-7 shrink-0 items-center justify-center rounded-full bg-primary/15 text-xs font-semibold text-primary">
                    {index + 1}
                  </div>
                  <div className="flex min-w-0 flex-1 flex-col gap-1 overflow-hidden">
                    <p className="truncate text-sm font-medium leading-snug">
                      {truncateText(cp.title, PREVIEW_TITLE_MAX)}
                    </p>
                    <p className="truncate text-xs text-muted-foreground">
                      {truncateText(cp.task, PREVIEW_TASK_MAX)}
                    </p>
                    <p className="inline-flex items-center gap-1 truncate text-[11px] text-muted-foreground">
                      <MapPin className="size-3 shrink-0" aria-hidden />
                      {cp.latitude.toFixed(4)}, {cp.longitude.toFixed(4)}
                    </p>
                    {taskTooShort ? (
                      <p className="inline-flex items-center gap-1 truncate text-[11px] text-destructive">
                        <AlertTriangle
                          className="size-3 shrink-0"
                          aria-hidden
                        />
                        {t("questCreate.errors.taskMinLength", {
                          min: TASK_MIN_LENGTH,
                        })}
                      </p>
                    ) : null}
                  </div>
                  <div className="flex shrink-0 items-center gap-1">
                    <Button
                      size="icon-sm"
                      variant="ghost"
                      aria-label={t("checkpoint.editCheckpoint")}
                      onClick={() => onEdit(cp.key)}
                    >
                      <Pencil />
                    </Button>
                    <Button
                      size="icon-sm"
                      variant="ghost"
                      aria-label={t("checkpoint.removeCheckpoint")}
                      onClick={() => onRemove(cp.key)}
                    >
                      <Trash2 className="text-destructive" />
                    </Button>
                  </div>
                </li>
              );
            })}
          </ul>
        )}

        <Button onClick={onAdd} variant="outline" className="w-full">
          <Plus />
          {t("questCreate.addCheckpoint")}
        </Button>
      </CardContent>
    </Card>
  );
}
