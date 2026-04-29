"use client";

import { useState, type FormEvent } from "react";
import { Check, ChevronDown, ChevronUp, Lightbulb, MapPin } from "lucide-react";
import { toast } from "sonner";

import type { Team } from "@/entities/team";
import type { TeamQuestRunCheckpointView } from "@/entities/team-quest-run";
import { useSubmitTeamCheckpointAnswer } from "@/features/team-quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";
import { Card, CardContent } from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";

type TeamCheckpointItemProps = {
  checkpoint: TeamQuestRunCheckpointView;
  index: number;
  team: Team | null | undefined;
};

export function TeamCheckpointItem({
  checkpoint,
  index,
  team,
}: TeamCheckpointItemProps) {
  const { t } = useTranslations();
  const submit = useSubmitTeamCheckpointAnswer();
  const [answer, setAnswer] = useState("");
  const [hintOpen, setHintOpen] = useState(false);
  const [open, setOpen] = useState(!checkpoint.is_completed);

  const completedBy = checkpoint.completed_by_user_id
    ? (team?.members.find((m) => m.id === checkpoint.completed_by_user_id)
        ?.username ?? null)
    : null;

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const trimmed = answer.trim();
    if (!trimmed) return;
    submit.mutate(
      { checkpointId: checkpoint.id, answer: trimmed },
      {
        onSuccess: (result) => {
          if (result.correct) {
            toast.success(t("run.correct"), {
              description: result.points_earned
                ? t("run.pointsEarned", { count: result.points_earned })
                : undefined,
            });
            setAnswer("");
          } else {
            toast.error(t("run.wrong"));
          }
        },
        onError: (error) => {
          toast.error(t("run.submitFailed"), {
            description: error.message || t("common.tryAgain"),
          });
        },
      },
    );
  };

  return (
    <Card
      className={cn(
        "border-0 shadow-md",
        checkpoint.is_completed && "bg-muted/40",
      )}
    >
      <CardContent className="space-y-3 p-4">
        <button
          type="button"
          onClick={() => setOpen((value) => !value)}
          className="flex w-full items-start justify-between gap-3 text-left"
          aria-expanded={open}
        >
          <div className="min-w-0 space-y-1">
            <div className="flex flex-wrap items-center gap-2">
              <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                {t("teamRun.checkpointNumber", { number: index + 1 })}
              </span>
              {checkpoint.is_completed ? (
                <Badge variant="success">
                  <Check className="size-3" aria-hidden />
                  {completedBy
                    ? t("teamRun.completedBy", { name: completedBy })
                    : t("teamRun.completed")}
                </Badge>
              ) : (
                <Badge variant="outline">{t("teamRun.openCheckpoint")}</Badge>
              )}
            </div>
            <h3 className="break-words text-base font-semibold leading-tight">
              {checkpoint.title}
            </h3>
            <p className="inline-flex items-center gap-1.5 text-xs text-muted-foreground">
              <MapPin className="size-3" aria-hidden />
              <span className="font-mono tabular-nums">
                {checkpoint.latitude.toFixed(5)}°,{" "}
                {checkpoint.longitude.toFixed(5)}°
              </span>
            </p>
          </div>
          {open ? (
            <ChevronUp className="size-4 shrink-0 text-muted-foreground" />
          ) : (
            <ChevronDown className="size-4 shrink-0 text-muted-foreground" />
          )}
        </button>

        {open ? (
          <div className="space-y-3">
            <p className="whitespace-pre-wrap break-words text-sm leading-relaxed">
              {checkpoint.task}
            </p>

            {checkpoint.point_rules ? (
              <div className="rounded-2xl bg-muted/40 p-3 text-sm text-muted-foreground">
                <p className="mb-1 text-xs font-semibold uppercase tracking-wide text-foreground/80">
                  {t("run.pointRules")}
                </p>
                <p className="whitespace-pre-wrap break-words">
                  {checkpoint.point_rules}
                </p>
              </div>
            ) : null}

            {checkpoint.hint ? (
              <div>
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  className="h-auto gap-1.5 px-2 py-1 text-primary hover:bg-primary/10"
                  onClick={() => setHintOpen((value) => !value)}
                  aria-expanded={hintOpen}
                >
                  <Lightbulb className="size-3.5" aria-hidden />
                  {hintOpen ? t("run.hideHint") : t("run.showHint")}
                </Button>
                {hintOpen ? (
                  <p className="mt-2 whitespace-pre-wrap break-words rounded-2xl bg-primary/5 p-3 text-sm text-foreground/80">
                    {checkpoint.hint}
                  </p>
                ) : null}
              </div>
            ) : null}

            {!checkpoint.is_completed ? (
              <form
                onSubmit={handleSubmit}
                className="flex flex-col gap-2 sm:flex-row"
              >
                <Input
                  autoComplete="off"
                  value={answer}
                  onChange={(event) => setAnswer(event.target.value)}
                  placeholder={t("run.answerPlaceholder")}
                  aria-label={t("run.answerLabel")}
                />
                <Button
                  type="submit"
                  disabled={submit.isPending || !answer.trim()}
                >
                  {submit.isPending ? t("run.submitting") : t("run.submit")}
                </Button>
              </form>
            ) : null}
          </div>
        ) : null}
      </CardContent>
    </Card>
  );
}
