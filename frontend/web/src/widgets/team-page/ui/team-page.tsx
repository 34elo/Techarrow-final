"use client";

import { useSearchParams } from "next/navigation";

import { CreateTeamForm } from "@/features/teams/ui/create-team-form";
import { JoinTeamForm } from "@/features/teams/ui/join-team-form";
import { TeamInfoCard } from "@/features/teams/ui/team-info-card";
import { useMyTeam } from "@/features/teams";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Skeleton } from "@/shared/ui/skeleton";

export function TeamPage() {
  const { t } = useTranslations();
  const { data: team, isLoading, isError, error } = useMyTeam();
  const searchParams = useSearchParams();
  const inviteCode = searchParams?.get("code") ?? "";

  return (
    <div className="space-y-5">
      <header className="space-y-2">
        <h1 className="text-3xl font-semibold tracking-tight">
          {t("team.title")}
        </h1>
        <p className="text-sm text-muted-foreground">{t("team.description")}</p>
      </header>

      {isLoading ? (
        <Skeleton className="h-72 w-full" />
      ) : isError ? (
        <p className="rounded-2xl border border-destructive/30 bg-destructive/10 p-4 text-sm text-destructive">
          {error?.message || t("common.loadError")}
        </p>
      ) : team ? (
        <TeamInfoCard team={team} />
      ) : (
        <div className="space-y-4">
          <div className="rounded-2xl border border-dashed border-border bg-card p-6 text-center">
            <h2 className="text-lg font-semibold">{t("team.noTeamHeading")}</h2>
            <p className="mt-1 text-sm text-muted-foreground">
              {t("team.noTeamHint")}
            </p>
          </div>
          <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
            <CreateTeamForm />
            <JoinTeamForm
              initialCode={inviteCode}
              prefilledHint={Boolean(inviteCode)}
            />
          </div>
        </div>
      )}
    </div>
  );
}
