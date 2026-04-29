"use client";

import type { LeaderboardSelfPosition } from "@/entities/leaderboard";
import type { Team } from "@/entities/team";
import { useTranslations } from "@/shared/i18n/i18n-provider";

type SelfPositionCardProps = {
  scope: "users" | "teams";
  self: LeaderboardSelfPosition | null;
  team: Team | null;
};

export function SelfPositionCard({ scope, self, team }: SelfPositionCardProps) {
  const { t } = useTranslations();

  if (scope === "teams" && !team) {
    return (
      <p className="rounded-2xl border border-border bg-card px-4 py-3 text-sm text-muted-foreground">
        {t("leaderboard.noTeamYet")}
      </p>
    );
  }

  if (!self) {
    return null;
  }

  const caption =
    scope === "teams"
      ? t("leaderboard.myTeamLabel")
      : t("leaderboard.myPlace");
  const name = scope === "teams" ? (team?.name ?? self.name) : self.name;

  return (
    <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-2 rounded-2xl border border-primary/30 bg-primary/5 px-4 py-3 text-sm">
      <div className="min-w-0 flex-1">
        <p className="truncate text-base font-semibold leading-tight">{name}</p>
        <p className="text-[11px] uppercase tracking-wide text-muted-foreground">
          {caption}
        </p>
      </div>
      <div className="flex shrink-0 items-baseline gap-3 tabular-nums">
        <span className="text-lg font-semibold leading-none">
          #{self.rank}
        </span>
        <span className="text-muted-foreground/50">·</span>
        <span>
          <span className="text-lg font-semibold leading-none">
            {self.score.toLocaleString()}
          </span>
          <span className="ml-1 text-[11px] uppercase tracking-wide text-muted-foreground">
            {t("leaderboard.myScore")}
          </span>
        </span>
      </div>
    </div>
  );
}
