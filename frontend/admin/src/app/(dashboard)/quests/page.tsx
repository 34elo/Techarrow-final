"use client";

import { useMemo, useState } from "react";
import { Trash2 } from "lucide-react";
import { toast } from "sonner";

import { mapQuestToCard, type QuestSummary } from "@/entities/quest";
import { useDeleteQuest, useQuests } from "@/features/quests";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { InfiniteListFooter } from "@/shared/ui/infinite-list-footer";
import { QuestCard, type QuestCardData } from "@/shared/ui/quest-card";
import { QuestCardsList } from "@/shared/ui/quest-cards-list";
import { QuestsSearch } from "@/shared/ui/quests-search";

export default function QuestsPage() {
  const { t } = useTranslations();
  const [searchQuery, setSearchQuery] = useState("");

  const questsQuery = useQuests({ scope: "public" });
  const deleteQuest = useDeleteQuest();

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

  const handleDelete = (quest: QuestSummary) => {
    deleteQuest.mutate(quest.id, {
      onSuccess: () => {
        toast.success(t("toasts.questDeleted"), {
          description: t("toasts.questDeletedDescription", {
            title: quest.title,
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

  return (
    <div>
      <h1 className="text-2xl font-semibold">{t("sections.questsTitle")}</h1>
      <p className="mb-4 text-sm text-muted-foreground">
        {t("sections.questsDescription")}
      </p>

      <QuestsSearch
        value={searchQuery}
        onChange={setSearchQuery}
        placeholder={t("quests.searchPlaceholder")}
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
          {t("quests.empty")}
        </p>
      ) : (
        <>
          <QuestCardsList<QuestCardData>
            quests={cards.map((entry) => entry.card)}
            renderCard={(card, index) => {
              const quest = cards[index].quest;
              return (
                <QuestCard
                  key={quest.id}
                  quest={card}
                  primaryAction={{
                    label: t("common.delete"),
                    icon: Trash2,
                    variant: "destructive",
                    onClick: () => handleDelete(quest),
                  }}
                />
              );
            }}
          />
          <InfiniteListFooter
            hasNextPage={Boolean(questsQuery.hasNextPage)}
            fetchNextPage={() => questsQuery.fetchNextPage()}
            isFetchingNextPage={questsQuery.isFetchingNextPage}
          />
        </>
      )}
    </div>
  );
}
