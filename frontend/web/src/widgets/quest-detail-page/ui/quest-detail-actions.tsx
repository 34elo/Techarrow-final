"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowRight, Download, Play } from "lucide-react";
import { toast } from "sonner";

import { FavoriteButton } from "@/features/quest-favorites";
import {
  StartQuestDialog,
  runModeStorage,
  useActiveQuestRun,
  useStartQuestRun,
  type QuestMode,
} from "@/features/quest-run";
import {
  useActiveTeamQuestRun,
  useSetTeamReadiness,
} from "@/features/team-quest-run";
import { useExportQuest } from "@/features/quests";
import { useMyTeam } from "@/features/teams";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";

import { ShareQuestButton } from "@/features/quests/ui/share-quest-button";

import { ComplaintDialog } from "./complaint-dialog";
import { ExportQuestDialog } from "./export-quest-dialog";

type QuestDetailActionsProps = {
  questId: number;
  questTitle: string;
  isOwn: boolean;
};

export function QuestDetailActions({
  questId,
  questTitle,
  isOwn,
}: QuestDetailActionsProps) {
  const { t } = useTranslations();
  const router = useRouter();
  const { data: activeRun } = useActiveQuestRun();
  const { data: activeTeamRun } = useActiveTeamQuestRun();
  const { data: team } = useMyTeam();
  const startRun = useStartQuestRun();
  const setTeamReadiness = useSetTeamReadiness();
  const exportMutation = useExportQuest();

  const [modeOpen, setModeOpen] = useState(false);
  const [exportOpen, setExportOpen] = useState(false);

  const isActiveOnThisQuest =
    activeRun?.status === "in_progress" && activeRun.quest_id === questId;
  const hasOtherActiveRun =
    activeRun?.status === "in_progress" && activeRun.quest_id !== questId;

  const teamRunOnThisQuest =
    activeTeamRun && activeTeamRun.quest_id === questId ? activeTeamRun : null;
  const hasOtherTeamRun =
    activeTeamRun &&
    activeTeamRun.quest_id !== questId &&
    activeTeamRun.status !== "completed";
  const teamRunIsActive =
    teamRunOnThisQuest &&
    (teamRunOnThisQuest.status === "in_progress" ||
      teamRunOnThisQuest.status === "starting" ||
      teamRunOnThisQuest.status === "waiting_for_team");

  const handleExportConfirm = () => {
    exportMutation.mutate(
      { id: questId, filename: `quest-${questId}.pdf` },
      {
        onSuccess: () => {
          setExportOpen(false);
        },
        onError: (error) => {
          toast.error(t("quests.exportFailed"), {
            description: error.message || t("common.tryAgain"),
          });
        },
      },
    );
  };

  const handleStartConfirm = (mode: QuestMode) => {
    if (isOwn) return;
    if (mode === "team") {
      setTeamReadiness.mutate(
        { questId, isReady: true },
        {
          onSuccess: () => {
            setModeOpen(false);
            toast.success(t("teamRun.readyToast"));
            router.push(`/quests/${questId}/team-run`);
          },
          onError: (error) => {
            toast.error(t("teamRun.readyFailed"), {
              description: error.message || t("common.tryAgain"),
            });
          },
        },
      );
      return;
    }
    startRun.mutate(
      { questId },
      {
        onSuccess: (run) => {
          runModeStorage.set(run.run_id, mode);
          setModeOpen(false);
          toast.success(t("startQuest.startedToast"));
          router.push(`/quests/${questId}/run`);
        },
        onError: (error) => {
          toast.error(t("startQuest.startFailed"), {
            description: error.message || t("common.tryAgain"),
          });
        },
      },
    );
  };

  const startDisabled =
    startRun.isPending ||
    setTeamReadiness.isPending ||
    isOwn ||
    hasOtherActiveRun ||
    Boolean(hasOtherTeamRun);
  const startTitle = isOwn
    ? t("startQuest.ownQuest")
    : hasOtherActiveRun
      ? t("startQuest.otherActive")
      : hasOtherTeamRun
        ? t("teamRun.otherActive")
        : undefined;
  const startPending = startRun.isPending || setTeamReadiness.isPending;

  return (
    <div className="flex flex-wrap items-center gap-2">
      {isActiveOnThisQuest ? (
        <Button onClick={() => router.push(`/quests/${questId}/run`)}>
          {t("activeQuest.continue")}
          <ArrowRight />
        </Button>
      ) : teamRunIsActive ? (
        <Button onClick={() => router.push(`/quests/${questId}/team-run`)}>
          {t("teamRun.continue")}
          <ArrowRight />
        </Button>
      ) : (
        <Button
          onClick={() => setModeOpen(true)}
          disabled={startDisabled}
          title={startTitle}
        >
          <Play />
          {startPending ? t("startQuest.starting") : t("startQuest.start")}
        </Button>
      )}
      <FavoriteButton questId={questId} />
      <Button
        variant="outline"
        size="icon"
        onClick={() => setExportOpen(true)}
        disabled={exportMutation.isPending}
        aria-label={t("quests.exportAria")}
        title={t("quests.exportPdf")}
      >
        <Download />
      </Button>
      <ShareQuestButton questId={questId} questTitle={questTitle} />
      {!isOwn ? <ComplaintDialog questId={questId} /> : null}

      <StartQuestDialog
        open={modeOpen}
        onOpenChange={(value) => {
          if (!startPending) setModeOpen(value);
        }}
        questTitle={questTitle}
        hasTeam={Boolean(team)}
        isPending={startPending}
        onConfirm={handleStartConfirm}
      />

      <ExportQuestDialog
        open={exportOpen}
        onOpenChange={(value) => {
          if (!exportMutation.isPending) setExportOpen(value);
        }}
        isPending={exportMutation.isPending}
        onConfirm={handleExportConfirm}
      />
    </div>
  );
}
