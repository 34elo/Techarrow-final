import { QuestCard, type QuestCardData } from "@/shared/ui/quest-card";
import type { ReactNode } from "react";

type QuestCardsListProps<T extends QuestCardData> = {
  quests: T[];
  onApprove?: (quest: T) => void;
  onReject?: (quest: T) => void;
  renderCard?: (quest: T, index: number) => ReactNode;
};

export function QuestCardsList<T extends QuestCardData>({
  quests,
  onApprove,
  onReject,
  renderCard,
}: QuestCardsListProps<T>) {
  return (
    <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
      {quests.map((quest, index) =>
        renderCard ? (
          renderCard(quest, index)
        ) : (
          <QuestCard
            key={quest.id ?? `${quest.title}-${index}`}
            quest={quest}
            onApprove={onApprove ? (item) => onApprove(item as T) : undefined}
            onReject={onReject ? (item) => onReject(item as T) : undefined}
          />
        ),
      )}
    </div>
  );
}
