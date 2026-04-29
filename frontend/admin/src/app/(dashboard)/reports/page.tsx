"use client";

import { useMemo, useState } from "react";
import { toast } from "sonner";

import type { Report } from "@/entities/report";
import { useDeleteQuest } from "@/features/quests";
import {
  ComplaintsList,
  useDeleteComplaint,
  useReports,
} from "@/features/reports";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { QuestsSearch } from "@/shared/ui/quests-search";

export default function ReportsPage() {
  const { t } = useTranslations();
  const [searchQuery, setSearchQuery] = useState("");

  const reportsQuery = useReports();
  const deleteQuest = useDeleteQuest();
  const deleteComplaint = useDeleteComplaint();

  const items = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLowerCase();
    if (!normalizedQuery) return reportsQuery.items;
    return reportsQuery.items.filter(
      (report) =>
        report.reason.toLowerCase().includes(normalizedQuery) ||
        report.author.username.toLowerCase().includes(normalizedQuery) ||
        String(report.quest_id).includes(normalizedQuery),
    );
  }, [reportsQuery.items, searchQuery]);

  const handleAcceptComplaint = (report: Report) => {
    deleteQuest.mutate(report.quest_id, {
      onSuccess: () => {
        toast.success(t("toasts.questDeleted"), {
          description: t("toasts.questDeletedDescription", {
            title: String(report.quest_id),
          }),
        });
      },
      onError: (error) => {
        toast.error(t("toasts.questDeleteFailed"), {
          description: error.message || t("toasts.tryAgain"),
        });
      },
    });
  };

  const handleDismissComplaint = (report: Report) => {
    deleteComplaint.mutate(report.id, {
      onSuccess: () => {
        toast.success(t("toasts.complaintDismissed"), {
          description: t("toasts.complaintDismissedDescription", {
            id: report.id,
          }),
        });
      },
      onError: (error) => {
        toast.error(t("toasts.complaintDismissFailed"), {
          description: error.message || t("toasts.tryAgain"),
        });
      },
    });
  };

  const actionsPending = deleteQuest.isPending || deleteComplaint.isPending;

  return (
    <div>
      <h1 className="text-2xl font-semibold">{t("sections.reportsTitle")}</h1>
      <p className="mb-4 text-sm text-muted-foreground">
        {t("sections.reportsDescription")}
      </p>

      <QuestsSearch
        value={searchQuery}
        onChange={setSearchQuery}
        placeholder={t("reports.searchPlaceholder")}
      />

      <ComplaintsList
        items={items}
        isLoading={reportsQuery.isLoading}
        isError={reportsQuery.isError}
        errorMessage={reportsQuery.error?.message}
        onAccept={handleAcceptComplaint}
        onDismiss={handleDismissComplaint}
        isActionPending={actionsPending}
        hasNextPage={reportsQuery.hasNextPage}
        fetchNextPage={() => reportsQuery.fetchNextPage()}
        isFetchingNextPage={reportsQuery.isFetchingNextPage}
      />
    </div>
  );
}
