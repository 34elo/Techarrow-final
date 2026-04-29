"use client";

import { Check, Loader2, X } from "lucide-react";
import { toast } from "sonner";

import type { Team } from "@/entities/team";
import type { TeamQuestRunProgress } from "@/entities/team-quest-run";
import { useSetTeamReadiness } from "@/features/team-quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { useAuthStore } from "@/shared/store/auth-store";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";

type TeamReadinessCardProps = {
  questId: number;
  questTitle: string;
  team: Team | null | undefined;
  run: TeamQuestRunProgress;
};

export function TeamReadinessCard({
  questId,
  questTitle,
  team,
  run,
}: TeamReadinessCardProps) {
  const { t } = useTranslations();
  const userId = useAuthStore((state) => state.user?.id);
  const setReadiness = useSetTeamReadiness();

  const readySet = new Set(run.ready_member_ids);
  const isReady = userId !== undefined && readySet.has(userId);

  const handleToggle = (next: boolean) => {
    setReadiness.mutate(
      { questId, isReady: next },
      {
        onError: (error) => {
          toast.error(
            next ? t("teamRun.readyFailed") : t("teamRun.unreadyFailed"),
            { description: error.message || t("common.tryAgain") },
          );
        },
      },
    );
  };

  return (
    <Card className="border-0 shadow-md">
      <CardHeader className="space-y-2">
        <CardTitle className="flex flex-wrap items-center gap-2">
          <span>{t("teamRun.waitingTitle")}</span>
          <Badge variant="outline">
            {t("teamRun.readyOf", {
              ready: run.ready_member_ids.length,
              total: run.total_members,
            })}
          </Badge>
        </CardTitle>
        <p className="text-sm text-muted-foreground">
          {t("teamRun.waitingDescription", { title: questTitle })}
        </p>
      </CardHeader>
      <CardContent className="space-y-4">
        {team ? (
          <ul className="grid grid-cols-1 gap-2 sm:grid-cols-2">
            {team.members.map((member) => {
              const ready = readySet.has(member.id);
              return (
                <li
                  key={member.id}
                  className="flex items-center justify-between gap-2 rounded-xl border border-border bg-card px-3 py-2"
                >
                  <div className="min-w-0">
                    <p className="truncate text-sm font-medium">
                      {member.username}
                      {member.id === team.creator_id ? (
                        <span className="ml-1 text-xs text-muted-foreground">
                          ★
                        </span>
                      ) : null}
                      {member.id === userId ? (
                        <span className="ml-1 text-xs text-muted-foreground">
                          ({t("teamRun.you")})
                        </span>
                      ) : null}
                    </p>
                  </div>
                  {ready ? (
                    <Badge variant="success">
                      <Check className="size-3" aria-hidden />
                      {t("teamRun.ready")}
                    </Badge>
                  ) : (
                    <Badge variant="secondary">
                      <Loader2 className="size-3 animate-spin" aria-hidden />
                      {t("teamRun.notReady")}
                    </Badge>
                  )}
                </li>
              );
            })}
          </ul>
        ) : null}

        <div className="flex flex-wrap items-center gap-2">
          {isReady ? (
            <Button
              variant="outline"
              onClick={() => handleToggle(false)}
              disabled={setReadiness.isPending}
            >
              <X />
              {setReadiness.isPending
                ? t("teamRun.unreadying")
                : t("teamRun.cancelReady")}
            </Button>
          ) : (
            <Button
              onClick={() => handleToggle(true)}
              disabled={setReadiness.isPending}
            >
              <Check />
              {setReadiness.isPending
                ? t("teamRun.readying")
                : t("teamRun.markReady")}
            </Button>
          )}
          <p className="text-xs text-muted-foreground">
            {t("teamRun.minTeamHint")}
          </p>
        </div>
      </CardContent>
    </Card>
  );
}
