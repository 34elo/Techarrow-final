import type { QuestStatus } from "../model/quest-detail";
import type { QuestSummary } from "../model/types";

export type QuestCardLike = {
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

type Translator = (
  key: string,
  params?: Record<string, string | number>,
) => string;

function statusToCardLabel(t: Translator, status: QuestStatus): string {
  switch (status) {
    case "published":
      return t("questCard.publishedStatus");
    case "on_moderation":
      return t("questCard.waitingStatus");
    default:
      return t(`questDetail.statusLabels.${status}`);
  }
}

function splitLocation(location: string): { district: string; city: string } {
  const [first = "", second = ""] = location
    .split(",")
    .map((part) => part.trim());
  return second
    ? { district: first, city: second }
    : { district: "", city: first };
}

export function mapQuestToCard(
  quest: QuestSummary,
  t: Translator,
): QuestCardLike {
  const { district, city } = splitLocation(quest.location);

  return {
    id: String(quest.id),
    title: quest.title,
    author: quest.creator.username,
    district,
    city,
    status: statusToCardLabel(t, quest.status),
    description: quest.description,
    difficulty: `${quest.difficulty}/5`,
    duration: t("questCard.durationLabel", { minutes: quest.duration_minutes }),
  };
}
