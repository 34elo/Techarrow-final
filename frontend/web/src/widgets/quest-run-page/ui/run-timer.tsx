"use client";

import { useEffect, useState } from "react";
import { Timer as TimerIcon } from "lucide-react";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";

type RunTimerProps = {
  startedAt: string;
  className?: string;
};

function formatElapsed(seconds: number): string {
  const safe = Math.max(0, Math.floor(seconds));
  const hours = Math.floor(safe / 3600);
  const minutes = Math.floor((safe % 3600) / 60);
  const secs = safe % 60;
  const pad = (n: number) => n.toString().padStart(2, "0");
  if (hours > 0) {
    return `${pad(hours)}:${pad(minutes)}:${pad(secs)}`;
  }
  return `${pad(minutes)}:${pad(secs)}`;
}

export function RunTimer({ startedAt, className }: RunTimerProps) {
  const { t } = useTranslations();
  const startMs = new Date(startedAt).getTime();
  const [now, setNow] = useState<number | null>(null);

  useEffect(() => {
    setNow(Date.now());
    const id = window.setInterval(() => setNow(Date.now()), 1000);
    return () => window.clearInterval(id);
  }, []);

  const elapsedSec =
    now === null || Number.isNaN(startMs) ? 0 : (now - startMs) / 1000;

  return (
    <div
      className={cn(
        "inline-flex items-center gap-1.5 rounded-full bg-muted px-2.5 py-1 text-xs font-medium tabular-nums text-foreground",
        className,
      )}
      role="timer"
      aria-label={t("run.elapsedLabel")}
    >
      <TimerIcon className="size-3.5 text-muted-foreground" aria-hidden />
      <span className="text-muted-foreground">{t("run.elapsedLabel")}</span>
      <span className="font-mono">{formatElapsed(elapsedSec)}</span>
    </div>
  );
}
