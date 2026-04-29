"use client";

import { useMemo, useState } from "react";
import { toast } from "sonner";

import { mapQuestToCard, type QuestSummary } from "@/entities/quest";
import { useApproveQuest, useQuests, useRejectQuest } from "@/features/quests";
import { RejectReasonDialog } from "@/features/reject/ui/reject-reason-dialog";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { InfiniteListFooter } from "@/shared/ui/infinite-list-footer";
import { QuestCardsList } from "@/shared/ui/quest-cards-list";
import { type QuestCardData } from "@/shared/ui/quest-card";
import { QuestsSearch } from "@/shared/ui/quests-search";

export default function RequestsPage() {
  const { t } = useTranslations();
  const [searchQuery, setSearchQuery] = useState("");
  const [questToReject, setQuestToReject] = useState<QuestSummary | null>(null);

  const questsQuery = useQuests({ scope: "moderation" });
  const approveQuest = useApproveQuest();
  const rejectQuest = useRejectQuest();

  const cards = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLowerCase();
    return questsQuery.items
      .filter((quest) => {
        if (!normalizedQuery) return true;
        return (
          quest.title.toLowerCase().includes(normalizedQuery) ||
          quest.creator.username.toLowerCase().includes(normalizedQuery) ||
          quest.location.toLowerCase().includes(normalizedQuery)
        );
      })
      .map((quest) => ({
        quest,
        card: mapQuestToCard(quest, t) as QuestCardData,
      }));
  }, [questsQuery.items, searchQuery, t]);

  const cardsByCardId = useMemo(() => {
    const map = new Map<string, QuestSummary>();
    for (const { quest, card } of cards) {
      if (card.id) map.set(card.id, quest);
    }
    return map;
  }, [cards]);

  const handleApprove = (card: QuestCardData) => {
    if (!card.id) return;
    const quest = cardsByCardId.get(card.id);
    if (!quest) return;

    approveQuest.mutate(quest.id, {
      onSuccess: () => {
        toast.success(t("toasts.questApproved"), {
          description: t("toasts.questApprovedDescription", {
            title: quest.title,
          }),
        });
      },
      onError: (error) => {
        toast.error(t("toasts.approveFailed"), {
          description: error.message || t("toasts.tryAgain"),
        });
      },
    });
  };

  const handleRejectRequest = (card: QuestCardData) => {
    if (!card.id) return;
    const quest = cardsByCardId.get(card.id);
    if (!quest) return;
    setQuestToReject(quest);
  };

  const handleConfirmReject = async (reason: string) => {
    if (!questToReject) return;

    await rejectQuest.mutateAsync(
      { id: questToReject.id, reason },
      {
        onSuccess: () => {
          toast.success(t("toasts.questRejected"), {
            description: t("toasts.questRejectedDescription", {
              title: questToReject.title,
              reason,
            }),
          });
        },
      },
    );
  };

  return (
    <>
      <div>
        <h1 className="text-2xl font-semibold">
          {t("sections.requestsTitle")}
        </h1>
        <p className="text-sm text-muted-foreground mb-4">
          {t("sections.requestsDescription")}
        </p>
        <QuestsSearch
          value={searchQuery}
          onChange={setSearchQuery}
          placeholder={t("requests.searchPlaceholder")}
        />

        {questsQuery.isLoading ? (
          <p className="text-sm text-muted-foreground py-6">
            {t("common.loading")}
          </p>
        ) : questsQuery.isError ? (
          <p className="text-sm text-destructive py-6">
            {questsQuery.error?.message || t("common.loadError")}
          </p>
        ) : cards.length === 0 ? (
          <p className="text-sm text-muted-foreground py-6">
            {t("requests.empty")}
          </p>
        ) : (
          <>
            <QuestCardsList
              quests={cards.map((entry) => entry.card)}
              onApprove={handleApprove}
              onReject={handleRejectRequest}
            />
            <InfiniteListFooter
              hasNextPage={Boolean(questsQuery.hasNextPage)}
              fetchNextPage={() => questsQuery.fetchNextPage()}
              isFetchingNextPage={questsQuery.isFetchingNextPage}
            />
          </>
        )}
      </div>

      <RejectReasonDialog
        open={Boolean(questToReject)}
        onOpenChange={(open) => {
          if (!open) {
            setQuestToReject(null);
          }
        }}
        questTitle={questToReject?.title ?? ""}
        onConfirm={handleConfirmReject}
      />
    </>
  );
}
