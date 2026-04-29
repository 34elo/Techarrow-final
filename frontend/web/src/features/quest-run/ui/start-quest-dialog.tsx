"use client";

import { useState } from "react";
import { User, Users } from "lucide-react";

import { useTranslations } from "@/shared/i18n/i18n-provider";
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

import type { QuestMode } from "../lib/run-mode-storage";

type StartQuestDialogProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  questTitle: string;
  hasTeam: boolean;
  isPending?: boolean;
  onConfirm: (mode: QuestMode) => void;
};

export function StartQuestDialog({
  open,
  onOpenChange,
  questTitle,
  hasTeam,
  isPending,
  onConfirm,
}: StartQuestDialogProps) {
  const { t } = useTranslations();
  const [mode, setMode] = useState<QuestMode>(hasTeam ? "team" : "solo");

  return (
    <Dialog
      open={open}
      onOpenChange={(value) => {
        onOpenChange(value);
        if (value) setMode(hasTeam ? "team" : "solo");
      }}
    >
      <DialogContent>
        <DialogHeader>
          <DialogTitle>
            {t("startQuest.modeTitle")} — {questTitle}
          </DialogTitle>
          <DialogDescription>
            {t("startQuest.modeDescription")}
          </DialogDescription>
        </DialogHeader>
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
          <ModeOption
            label={t("startQuest.solo")}
            description={t("startQuest.soloDescription")}
            icon={User}
            active={mode === "solo"}
            onClick={() => setMode("solo")}
          />
          <ModeOption
            label={t("startQuest.team")}
            description={
              hasTeam
                ? t("startQuest.teamDescription")
                : t("startQuest.teamDisabled")
            }
            icon={Users}
            active={mode === "team"}
            disabled={!hasTeam}
            onClick={() => hasTeam && setMode("team")}
          />
        </div>
        <DialogFooter>
          <Button
            variant="outline"
            onClick={() => onOpenChange(false)}
            disabled={isPending}
          >
            {t("common.cancel")}
          </Button>
          <Button
            onClick={() => onConfirm(mode)}
            disabled={isPending || (mode === "team" && !hasTeam)}
          >
            {isPending ? t("startQuest.starting") : t("startQuest.start")}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

type ModeOptionProps = {
  label: string;
  description: string;
  icon: typeof User;
  active: boolean;
  disabled?: boolean;
  onClick: () => void;
};

function ModeOption({
  label,
  description,
  icon: Icon,
  active,
  disabled,
  onClick,
}: ModeOptionProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      className={cn(
        "flex flex-col items-start gap-1 rounded-2xl border p-4 text-left transition-colors",
        active
          ? "border-primary bg-primary/10 text-foreground"
          : "border-border bg-card text-muted-foreground hover:bg-secondary hover:text-foreground",
        disabled && "cursor-not-allowed opacity-60 hover:bg-card",
      )}
    >
      <span className="inline-flex items-center gap-2 text-sm font-semibold text-foreground">
        <Icon className="size-4" aria-hidden />
        {label}
      </span>
      <span className="text-xs">{description}</span>
    </button>
  );
}
