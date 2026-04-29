"use client";

import Link from "next/link";

import { Button } from "@/shared/ui/button";
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/shared/ui/card";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Check, CircleAlert } from "lucide-react";
import type { LucideIcon } from "lucide-react";

export type QuestCardData = {
  id?: string;
  title: string;
  author: string;
  district: string;
  city: string;
  status: string;
  description: string;
  difficulty: string;
  duration: string;
};

type QuestCardAction = {
  label: string;
  icon?: LucideIcon;
  variant?:
    | "default"
    | "outline"
    | "secondary"
    | "ghost"
    | "link"
    | "destructive";
  onClick: (quest: QuestCardData) => void;
};

type QuestCardProps = {
  quest: QuestCardData;
  onApprove?: (quest: QuestCardData) => void;
  onReject?: (quest: QuestCardData) => void;
  primaryAction?: QuestCardAction;
  secondaryAction?: QuestCardAction;
};

export function QuestCard({
  quest,
  onApprove,
  onReject,
  primaryAction,
  secondaryAction,
}: QuestCardProps) {
  const { t } = useTranslations();

  const resolvedPrimaryAction = primaryAction ?? {
    label: t("common.approve"),
    icon: Check,
    variant: "default" as const,
    onClick: onApprove ?? (() => undefined),
  };
  const resolvedSecondaryAction = secondaryAction ?? {
    label: t("common.reject"),
    icon: CircleAlert,
    variant: "destructive" as const,
    onClick: onReject ?? (() => undefined),
  };
  const PrimaryIcon = resolvedPrimaryAction.icon;
  const SecondaryIcon = resolvedSecondaryAction.icon;

  const detailHref = quest.id
    ? `/quests/${encodeURIComponent(quest.id)}`
    : undefined;

  const titleNode = detailHref ? (
    <Link
      href={detailHref}
      className="text-foreground underline-offset-4 transition-colors hover:text-primary hover:underline focus-visible:rounded-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
    >
      {quest.title}
    </Link>
  ) : (
    quest.title
  );

  return (
    <Card className="h-full min-w-0 gap-0 overflow-hidden border-border/70 py-4 shadow-none">
      <CardHeader className="gap-2 space-y-2 px-4 pb-2">
        <div className="flex flex-wrap items-start justify-between gap-2">
          <CardTitle className="line-clamp-2 text-base font-semibold leading-snug">
            {titleNode}
          </CardTitle>
          <div className="inline-flex shrink-0 items-center gap-1 rounded-full border border-border/80 px-2 py-0.5 text-[11px] text-muted-foreground">
            <CircleAlert className="size-3" aria-hidden />
            <span>{quest.status}</span>
          </div>
        </div>
        <p className="text-xs text-muted-foreground">
          {quest.author} · {quest.district}, {quest.city}
        </p>
      </CardHeader>

      <CardContent className="space-y-2 px-4 pb-3 pt-0">
        <p className="line-clamp-2 text-sm text-muted-foreground">
          {quest.description}
        </p>
        <p className="text-xs text-muted-foreground">
          {t("questCard.difficulty")}: {quest.difficulty}
          <span className="mx-1.5 text-border">·</span>
          {t("questCard.duration")}: {quest.duration}
        </p>
      </CardContent>

      <CardFooter className="mt-auto grid grid-cols-2 gap-2 px-4 pt-1">
        <Button
          size="sm"
          variant={resolvedPrimaryAction.variant}
          className={
            secondaryAction || onReject ? "w-full" : "col-span-2 w-full"
          }
          onClick={() => resolvedPrimaryAction.onClick(quest)}
        >
          {PrimaryIcon ? <PrimaryIcon /> : null}
          {resolvedPrimaryAction.label}
        </Button>
        {secondaryAction || onReject ? (
          <Button
            size="sm"
            variant={resolvedSecondaryAction.variant}
            className="w-full"
            onClick={() => resolvedSecondaryAction.onClick(quest)}
          >
            {SecondaryIcon ? <SecondaryIcon /> : null}
            {resolvedSecondaryAction.label}
          </Button>
        ) : null}
      </CardFooter>
    </Card>
  );
}
