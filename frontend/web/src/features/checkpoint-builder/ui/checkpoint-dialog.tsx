"use client";

import { useEffect, useMemo, useState } from "react";
import { Crosshair } from "lucide-react";
import { toast } from "sonner";

import type { CheckpointDraft } from "@/entities/checkpoint";
import { getDefaultMapCenter } from "@/entities/quest";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { useGeolocation } from "@/shared/lib/geolocation";
import { cn } from "@/shared/lib/classnames";
import { Button } from "@/shared/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/shared/ui/dialog";
import { Input } from "@/shared/ui/input";
import { Label } from "@/shared/ui/label";
import { MapView, type MapPickerMarker } from "@/shared/ui/map";
import { Textarea } from "@/shared/ui/textarea";

type CheckpointDialogProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSave: (draft: CheckpointDraft) => void;
  /** When provided, the dialog opens in edit mode and pre-fills the form. */
  initial?: CheckpointDraft | null;
};

const TASK_MIN_LENGTH = 20;

type FormState = {
  title: string;
  task: string;
  correctAnswer: string;
  hint: string;
  pointRules: string;
  coords: MapPickerMarker | null;
};

const INITIAL_STATE: FormState = {
  title: "",
  task: "",
  correctAnswer: "",
  hint: "",
  pointRules: "",
  coords: null,
};

function toFormState(draft: CheckpointDraft | null | undefined): FormState {
  if (!draft) return INITIAL_STATE;
  return {
    title: draft.title,
    task: draft.task,
    correctAnswer: draft.correct_answer,
    hint: draft.hint ?? "",
    pointRules: draft.point_rules ?? "",
    coords: { lat: draft.latitude, lng: draft.longitude },
  };
}

export function CheckpointDialog(props: CheckpointDialogProps) {
  const { open, onOpenChange } = props;
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-3xl">
        {/* Re-mount the body on every open so local state resets without an effect. */}
        {open ? <CheckpointDialogBody {...props} /> : null}
      </DialogContent>
    </Dialog>
  );
}

function CheckpointDialogBody({
  open,
  onOpenChange,
  onSave,
  initial,
}: CheckpointDialogProps) {
  const { t } = useTranslations();
  const isEditing = Boolean(initial);
  const [state, setState] = useState<FormState>(() => toFormState(initial));
  const geolocation = useGeolocation();

  const center = useMemo(
    () => state.coords ?? geolocation.coords ?? getDefaultMapCenter(),
    [state.coords, geolocation.coords],
  );

  // When the user clicks "use my location", drop the picker on their position.
  useEffect(() => {
    if (geolocation.error) {
      toast.error(t("geolocation.error"), {
        description: t(geolocation.error),
      });
    }
  }, [geolocation.error, t]);

  // Each successful fix is a deliberate "use my location" action — apply it
  // directly from the click handler so it overrides any marker the user
  // previously dropped on the map.
  const handleUseMyLocation = () => {
    geolocation.request((coords) => {
      setState((prev) => ({
        ...prev,
        coords: { lat: coords.lat, lng: coords.lng },
      }));
    });
  };

  const handleSave = () => {
    if (state.title.trim().length === 0) {
      toast.error(t("questCreate.errors.titleRequired"));
      return;
    }
    const trimmedTask = state.task.trim();
    if (trimmedTask.length === 0) {
      toast.error(t("questCreate.errors.taskRequired"));
      return;
    }
    if (trimmedTask.length < TASK_MIN_LENGTH) {
      toast.error(
        t("questCreate.errors.taskMinLength", { min: TASK_MIN_LENGTH }),
      );
      return;
    }
    if (state.correctAnswer.trim().length === 0) {
      toast.error(t("questCreate.errors.answerRequired"));
      return;
    }
    if (!state.coords) {
      toast.error(t("questCreate.errors.coordsRequired"));
      return;
    }

    onSave({
      title: state.title.trim(),
      task: state.task.trim(),
      correct_answer: state.correctAnswer.trim(),
      latitude: state.coords.lat,
      longitude: state.coords.lng,
      hint: state.hint.trim() || null,
      point_rules: state.pointRules.trim() || null,
    });
    onOpenChange(false);
  };

  return (
    <>
      <DialogHeader>
        <DialogTitle>
          {isEditing
            ? t("checkpoint.dialogEditTitle")
            : t("checkpoint.dialogTitle")}
        </DialogTitle>
        <DialogDescription>
          {t("checkpoint.dialogDescription")}
        </DialogDescription>
      </DialogHeader>

      <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
        <div className="space-y-3">
          <div className="space-y-1.5">
            <Label htmlFor="cp-title">{t("checkpoint.titleLabel")}</Label>
            <Input
              id="cp-title"
              value={state.title}
              onChange={(event) =>
                setState((prev) => ({ ...prev, title: event.target.value }))
              }
            />
            <p className="text-xs text-muted-foreground">
              {t("checkpoint.titleHint")}
            </p>
          </div>

          <div className="space-y-1.5">
            <Label htmlFor="cp-task">{t("checkpoint.taskLabel")}</Label>
            <Textarea
              id="cp-task"
              rows={3}
              value={state.task}
              onChange={(event) =>
                setState((prev) => ({ ...prev, task: event.target.value }))
              }
              aria-invalid={
                state.task.trim().length > 0 &&
                state.task.trim().length < TASK_MIN_LENGTH
              }
            />
            <div className="flex items-start justify-between gap-3 text-xs text-muted-foreground">
              <p>{t("checkpoint.taskHint")}</p>
              <span
                className={cn(
                  "shrink-0 tabular-nums",
                  state.task.trim().length > 0 &&
                    state.task.trim().length < TASK_MIN_LENGTH &&
                    "text-destructive",
                )}
              >
                {state.task.trim().length}/{TASK_MIN_LENGTH}
              </span>
            </div>
          </div>

          <div className="space-y-1.5">
            <Label htmlFor="cp-answer">{t("checkpoint.answerLabel")}</Label>
            <Input
              id="cp-answer"
              value={state.correctAnswer}
              onChange={(event) =>
                setState((prev) => ({
                  ...prev,
                  correctAnswer: event.target.value,
                }))
              }
            />
            <p className="text-xs text-muted-foreground">
              {t("checkpoint.answerHint")}
            </p>
          </div>

          <div className="space-y-1.5">
            <Label htmlFor="cp-hint">{t("checkpoint.hintLabel")}</Label>
            <Textarea
              id="cp-hint"
              rows={2}
              value={state.hint}
              onChange={(event) =>
                setState((prev) => ({ ...prev, hint: event.target.value }))
              }
            />
          </div>

          <div className="space-y-1.5">
            <Label htmlFor="cp-rules">{t("checkpoint.pointRulesLabel")}</Label>
            <Textarea
              id="cp-rules"
              rows={2}
              value={state.pointRules}
              onChange={(event) =>
                setState((prev) => ({
                  ...prev,
                  pointRules: event.target.value,
                }))
              }
            />
          </div>
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between gap-2">
            <Label>{t("checkpoint.coordsLabel")}</Label>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={handleUseMyLocation}
              disabled={!geolocation.isSupported || geolocation.isLoading}
            >
              <Crosshair />
              {geolocation.isLoading
                ? t("geolocation.locating")
                : t("geolocation.locateMe")}
            </Button>
          </div>
          <div className="h-72 w-full">
            <MapView
              center={center}
              zoom={13}
              pickerMarker={state.coords}
              userLocation={geolocation.coords}
              onMapClick={(coords) => setState((prev) => ({ ...prev, coords }))}
              onPickerMove={(coords) =>
                setState((prev) => ({ ...prev, coords }))
              }
              resizeKey={open ? "open" : "closed"}
            />
          </div>
          <p className="text-xs text-muted-foreground">
            {t("checkpoint.pickHint")}
          </p>
          {state.coords ? (
            <p className="text-xs text-muted-foreground">
              {state.coords.lat.toFixed(5)}, {state.coords.lng.toFixed(5)}
            </p>
          ) : null}
        </div>
      </div>

      <DialogFooter>
        <Button variant="outline" onClick={() => onOpenChange(false)}>
          {t("common.cancel")}
        </Button>
        <Button onClick={handleSave}>
          {isEditing
            ? t("checkpoint.saveChanges")
            : t("checkpoint.saveCheckpoint")}
        </Button>
      </DialogFooter>
    </>
  );
}
