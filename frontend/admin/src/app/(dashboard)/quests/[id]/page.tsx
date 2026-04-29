"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { ArrowLeft, Download, User, Users } from "lucide-react";
import { toast } from "sonner";

import { useExportQuest, useQuestDetail } from "@/features/quests";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { QuestDetailCheckpointsCard } from "@/widgets/quest-detail/ui/quest-detail-checkpoints-card";
import { QuestDetailCoverCard } from "@/widgets/quest-detail/ui/quest-detail-cover-card";
import { QuestDetailGeneralCard } from "@/widgets/quest-detail/ui/quest-detail-general-card";

export default function QuestDetailPage() {
  const params = useParams<{ id: string }>();
  const rawId = params.id;
  const routeId = typeof rawId === "string" ? decodeURIComponent(rawId) : "";
  const { t } = useTranslations();

  const questQuery = useQuestDetail(routeId);
  const quest = questQuery.data;
  const exportMutation = useExportQuest();

  const handleExport = () => {
    if (!quest) return;
    exportMutation.mutate(
      { id: quest.id, filename: `quest-${quest.id}.pdf` },
      {
        onError: (error) => {
          toast.error(t("quests.exportFailed"), {
            description: error.message,
          });
        },
      },
    );
  };

  return (
    <div className="mx-auto flex w-full max-w-6xl flex-col gap-6 pb-8 sm:gap-8">
      <div className="flex flex-col gap-4">
        <Button variant="outline" size="sm" asChild className="w-fit">
          <Link href="/quests">
            <ArrowLeft />
            {t("quests.backToList")}
          </Link>
        </Button>
        <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between sm:gap-6">
          <div className="min-w-0">
            <h1 className="text-balance text-2xl font-semibold tracking-tight sm:text-3xl">
              {quest?.title || t("quests.detailTitle")}
            </h1>
            {quest ? (
              <div className="mt-2 flex flex-wrap items-center gap-x-4 gap-y-1 text-sm text-muted-foreground">
                <span>
                  {t("questDetail.id")}:{" "}
                  <span className="font-mono text-foreground">
                    {String(quest.id)}
                  </span>
                </span>
                <span className="inline-flex items-center gap-1.5">
                  <User className="size-3.5" aria-hidden />
                  <span className="text-foreground">
                    {quest.creator.username}
                  </span>
                </span>
                <span className="inline-flex items-center gap-1.5">
                  <Users className="size-3.5" aria-hidden />
                  <span>
                    {quest.creator.team_name ?? t("questDetail.noTeam")}
                  </span>
                </span>
              </div>
            ) : null}
          </div>
          {quest ? (
            <Button
              variant="outline"
              size="sm"
              onClick={handleExport}
              disabled={exportMutation.isPending}
              className="w-fit"
            >
              <Download />
              {exportMutation.isPending
                ? t("quests.exportPending")
                : t("quests.exportPdf")}
            </Button>
          ) : null}
        </div>
      </div>

      {questQuery.isLoading ? (
        <p className="text-sm text-muted-foreground">{t("common.loading")}</p>
      ) : questQuery.isError ? (
        <p className="text-sm text-destructive">
          {questQuery.error?.message || t("common.loadError")}
        </p>
      ) : quest ? (
        <div className="grid gap-6 lg:grid-cols-12 lg:gap-8 lg:items-stretch">
          <div className="flex min-w-0 flex-col gap-6 lg:col-span-7 xl:col-span-8">
            <QuestDetailCoverCard quest={quest} className="w-full" />
            <QuestDetailGeneralCard quest={quest} className="w-full" />
          </div>
          <aside className="flex min-w-0 flex-col gap-6 lg:col-span-5 xl:col-span-4">
            <QuestDetailCheckpointsCard
              quest={quest}
              className="w-full lg:sticky lg:top-6"
            />
          </aside>
        </div>
      ) : null}
    </div>
  );
}
