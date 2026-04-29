"use client";

import type { LeaderboardEntry } from "@/entities/leaderboard";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";

type LeaderboardTableProps = {
  entries: LeaderboardEntry[];
  participantLabel: string;
};

const TOP_RANK_STYLES: Record<number, string> = {
  1: "bg-amber-400 text-amber-950",
  2: "bg-slate-300 text-slate-900",
  3: "bg-orange-400 text-orange-950",
};

export function LeaderboardTable({
  entries,
  participantLabel,
}: LeaderboardTableProps) {
  const { t } = useTranslations();

  if (entries.length === 0) {
    return (
      <p className="rounded-2xl border border-border bg-card p-6 text-center text-sm text-muted-foreground">
        {t("leaderboard.empty")}
      </p>
    );
  }

  return (
    <div className="overflow-hidden rounded-2xl border border-border">
      <table className="w-full text-sm">
        <thead className="bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
          <tr>
            <th className="w-14 px-4 py-3">{t("leaderboard.rankColumn")}</th>
            <th className="px-4 py-3">{participantLabel}</th>
            <th className="w-28 px-4 py-3 text-right">
              {t("leaderboard.scoreColumn")}
            </th>
          </tr>
        </thead>
        <tbody>
          {entries.map((entry) => {
            const topStyle = TOP_RANK_STYLES[entry.rank];
            return (
              <tr
                key={`${entry.rank}-${entry.name}`}
                className={cn(
                  "border-t border-border",
                  entry.isMine && "bg-primary/10",
                )}
              >
                <td className="px-4 py-3">
                  {topStyle ? (
                    <span
                      className={cn(
                        "inline-flex size-7 items-center justify-center rounded-full text-xs font-bold shadow-sm",
                        topStyle,
                      )}
                    >
                      {entry.rank}
                    </span>
                  ) : (
                    <span className="text-base font-semibold">
                      {entry.rank}
                    </span>
                  )}
                </td>
                <td className="px-4 py-3 font-medium">{entry.name}</td>
                <td className="px-4 py-3 text-right font-semibold tabular-nums">
                  {entry.score.toLocaleString()}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
