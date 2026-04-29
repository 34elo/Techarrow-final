"use client";

import { useEffect, useRef } from "react";
import { toast } from "sonner";

import type { Team } from "@/entities/team";
import type {
  TeamQuestRunCheckpointView,
  TeamQuestRunProgress,
  TeamQuestRunStatus,
} from "@/entities/team-quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { useAuthStore } from "@/shared/store/auth-store";

type Snapshot = {
  status: TeamQuestRunStatus;
  completedBy: Map<number, number | null>;
};

function snapshot(run: TeamQuestRunProgress): Snapshot {
  const completedBy = new Map<number, number | null>();
  for (const cp of run.checkpoints) {
    completedBy.set(cp.id, cp.is_completed ? cp.completed_by_user_id : null);
  }
  return { status: run.status, completedBy };
}

function findCheckpoint(
  run: TeamQuestRunProgress,
  id: number,
): TeamQuestRunCheckpointView | undefined {
  return run.checkpoints.find((cp) => cp.id === id);
}

export function useTeamRunNotifications(
  run: TeamQuestRunProgress | null | undefined,
  team: Team | null | undefined,
) {
  const { t } = useTranslations();
  const userId = useAuthStore((state) => state.user?.id);
  const previous = useRef<Snapshot | null>(null);

  useEffect(() => {
    if (!run) {
      previous.current = null;
      return;
    }
    const prev = previous.current;
    const next = snapshot(run);

    if (prev) {
      // Status transitions
      if (prev.status !== next.status) {
        if (next.status === "starting") {
          toast.success(t("teamRun.toastStarting"));
        } else if (next.status === "in_progress") {
          toast.success(t("teamRun.toastInProgress"));
        } else if (next.status === "completed") {
          toast.success(t("teamRun.toastCompleted"), {
            description: run.points_awarded
              ? t("run.pointsEarned", { count: run.points_awarded })
              : undefined,
          });
        }
      }

      // Checkpoint solved by a teammate (not by me)
      if (next.status === "in_progress" || prev.status === "in_progress") {
        for (const [id, completedBy] of next.completedBy) {
          const wasCompleted = prev.completedBy.get(id);
          if (!wasCompleted && completedBy && completedBy !== userId) {
            const checkpoint = findCheckpoint(run, id);
            const member = team?.members.find((m) => m.id === completedBy);
            if (checkpoint) {
              toast(
                t("teamRun.toastTeammateSolved", {
                  name: member?.username ?? `#${completedBy}`,
                  title: checkpoint.title,
                }),
              );
            }
          }
        }
      }
    }

    previous.current = next;
  }, [run, team, userId, t]);
}
