"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowLeft, Trash2 } from "lucide-react";
import Link from "next/link";
import { toast } from "sonner";

import {
  CheckpointDialog,
  CheckpointList,
} from "@/features/checkpoint-builder";
import {
  QuestForm,
  useQuestDraftStore,
  type QuestFormSubmitPayload,
  type QuestFormValues,
} from "@/features/quest-form";
import { checkpointToPointPayload, useCreateQuest } from "@/features/quests";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";

const MIN_CHECKPOINTS = 3;
const TASK_MIN_LENGTH = 20;

export function QuestCreatePage() {
  const router = useRouter();
  const { t } = useTranslations();
  const createQuest = useCreateQuest();

  const draft = useQuestDraftStore((s) => s.draft);
  const hasDraft = useQuestDraftStore((s) => s.hasDraft);
  const addCheckpoint = useQuestDraftStore((s) => s.addCheckpoint);
  const updateCheckpoint = useQuestDraftStore((s) => s.updateCheckpoint);
  const removeCheckpoint = useQuestDraftStore((s) => s.removeCheckpoint);
  const resetDraft = useQuestDraftStore((s) => s.reset);

  const [isCheckpointOpen, setIsCheckpointOpen] = useState(false);
  const [editingKey, setEditingKey] = useState<string | null>(null);
  // Toast a one-time hint when there's a saved draft on mount.
  const [hintShown, setHintShown] = useState(false);

  useEffect(() => {
    if (!hintShown && hasDraft && hasMeaningfulDraft(draft)) {
      toast.info(t("questCreate.draftRestored"));
      setHintShown(true);
    }
    // We intentionally fire only once after mount when the persisted draft is
    // already available, so list deps are minimal.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const drafts = draft.checkpoints;
  const reachedMin = drafts.length >= MIN_CHECKPOINTS;

  const handleSubmit = async (payload: QuestFormSubmitPayload) => {
    if (!reachedMin) {
      toast.error(t("questCreate.checkpointMinError"));
      return;
    }

    const shortTaskIndex = drafts.findIndex(
      (cp) => cp.task.trim().length < TASK_MIN_LENGTH,
    );
    if (shortTaskIndex !== -1) {
      const shortCp = drafts[shortTaskIndex];
      toast.error(
        t("questCreate.errors.taskMinLength", { min: TASK_MIN_LENGTH }),
        {
          description: `${shortTaskIndex + 1}. ${shortCp.title}`,
        },
      );
      setEditingKey(shortCp.key);
      setIsCheckpointOpen(true);
      return;
    }

    try {
      const quest = await createQuest.mutateAsync({
        title: payload.title,
        description: payload.description,
        location: payload.location,
        difficulty: payload.difficulty,
        durationMinutes: payload.durationMinutes,
        rulesAndWarnings: payload.rulesAndWarnings || null,
        image: payload.image,
        points: drafts.map(({ key: _key, ...cp }) =>
          checkpointToPointPayload(cp),
        ),
      });

      toast.success(t("questCreate.submitSuccess"), {
        description: quest.title,
      });
      resetDraft();
    } catch (error) {
      toast.error(t("questCreate.submitFailed"), {
        description:
          error instanceof Error ? error.message : t("common.tryAgain"),
      });
    }
  };

  const handleClearDraft = () => {
    resetDraft();
    toast.success(t("questCreate.draftCleared"));
  };

  const formDefaults: Partial<QuestFormValues> = {
    title: draft.title,
    description: draft.description,
    location: draft.location,
    difficulty: draft.difficulty,
    durationMinutes: draft.durationMinutes,
    rulesAndWarnings: draft.rulesAndWarnings,
  };

  return (
    <div className="space-y-6">
      <header className="flex flex-wrap items-center gap-3">
        <Button variant="ghost" size="sm" asChild>
          <Link href="/quests">
            <ArrowLeft />
            {t("common.back")}
          </Link>
        </Button>
        <div className="flex-1 space-y-1">
          <h1 className="text-2xl font-semibold tracking-tight">
            {t("questCreate.title")}
          </h1>
          <p className="text-sm text-muted-foreground">
            {t("questCreate.description")}
          </p>
        </div>
        {hasDraft && hasMeaningfulDraft(draft) ? (
          <Button
            variant="outline"
            size="sm"
            onClick={handleClearDraft}
            type="button"
          >
            <Trash2 />
            {t("questCreate.clearDraft")}
          </Button>
        ) : null}
      </header>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-[2fr_1fr] lg:items-stretch">
        <Card className="h-full">
          <CardHeader>
            <CardTitle>{t("questCreate.sectionMain")}</CardTitle>
          </CardHeader>
          <CardContent>
            <QuestForm
              isSubmitting={createQuest.isPending}
              onSubmit={handleSubmit}
              persistDraft
              defaultValues={formDefaults}
              submitDisabled={!reachedMin}
              submitDisabledHint={
                !reachedMin ? t("questCreate.checkpointMinError") : undefined
              }
            />
          </CardContent>
        </Card>

        <CheckpointList
          checkpoints={drafts}
          onAdd={() => {
            setEditingKey(null);
            setIsCheckpointOpen(true);
          }}
          onEdit={(key) => {
            setEditingKey(key);
            setIsCheckpointOpen(true);
          }}
          onRemove={removeCheckpoint}
        />
      </div>

      <CheckpointDialog
        open={isCheckpointOpen}
        onOpenChange={(open) => {
          setIsCheckpointOpen(open);
          if (!open) setEditingKey(null);
        }}
        initial={
          editingKey
            ? (drafts.find((cp) => cp.key === editingKey) ?? null)
            : null
        }
        onSave={(cp) => {
          if (editingKey) {
            updateCheckpoint(editingKey, cp);
          } else {
            addCheckpoint(cp);
          }
        }}
      />
    </div>
  );
}

function hasMeaningfulDraft(
  draft: ReturnType<typeof useQuestDraftStore.getState>["draft"],
): boolean {
  return (
    Boolean(draft.title) ||
    Boolean(draft.description) ||
    Boolean(draft.location) ||
    Boolean(draft.rulesAndWarnings) ||
    draft.checkpoints.length > 0
  );
}
