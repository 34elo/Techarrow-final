"use client";

import { useEffect, useState, type FormEvent } from "react";
import { Lightbulb, MapPin } from "lucide-react";
import { toast } from "sonner";

import { useSubmitAnswer } from "@/features/quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { Card, CardContent } from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";
import type { CheckpointCurrentView } from "@/entities/quest-run";

type RunCheckpointCardProps = {
  checkpoint: CheckpointCurrentView;
  stepLabel: string;
};

export function RunCheckpointCard({
  checkpoint,
  stepLabel,
}: RunCheckpointCardProps) {
  const { t } = useTranslations();
  const submit = useSubmitAnswer();
  const [answer, setAnswer] = useState("");
  const [hintOpen, setHintOpen] = useState(false);

  useEffect(() => {
    setAnswer("");
    setHintOpen(false);
  }, [checkpoint.id]);

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const trimmed = answer.trim();
    if (!trimmed) return;

    submit.mutate(
      { answer: trimmed },
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
    <Card className="flex h-full flex-col border-0 shadow-md">
      <CardContent className="flex flex-1 flex-col gap-5 p-6">
        <div className="space-y-1">
          <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            {stepLabel}
          </p>
          <h2 className="break-words text-xl font-semibold leading-tight">
            {checkpoint.title}
          </h2>
          <p className="inline-flex items-center gap-1.5 text-xs text-muted-foreground">
            <MapPin className="size-3" aria-hidden />
            <span className="font-mono tabular-nums">
              {checkpoint.latitude.toFixed(5)}°,{" "}
              {checkpoint.longitude.toFixed(5)}°
            </span>
          </p>
        </div>

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
              onClick={() => setHintOpen((open) => !open)}
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

        <form
          onSubmit={handleSubmit}
          className="mt-auto flex flex-col gap-2 sm:flex-row"
        >
          <Input
            id="run-answer"
            autoComplete="off"
            value={answer}
            onChange={(event) => setAnswer(event.target.value)}
            placeholder={t("run.answerPlaceholder")}
            aria-label={t("run.answerLabel")}
          />
          <Button type="submit" disabled={submit.isPending || !answer.trim()}>
            {submit.isPending ? t("run.submitting") : t("run.submit")}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
