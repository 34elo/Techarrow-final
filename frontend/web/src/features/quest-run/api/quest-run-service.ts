import { httpClient } from "@/shared/api";
import type {
  QuestRunAnswer,
  QuestRunHistoryItem,
  QuestRunProgress,
} from "@/entities/quest-run";

export type StartQuestRunPayload = {
  questId: number;
};

export type SubmitAnswerPayload = {
  answer: string;
};

export const questRunService = {
  async start(payload: StartQuestRunPayload): Promise<QuestRunProgress> {
    const { data } = await httpClient.post<QuestRunProgress>(
      "/api/quest-runs",
      {
        quest_id: payload.questId,
      },
    );
    return data;
  },

  async getActive(): Promise<QuestRunProgress | null> {
    const { data } = await httpClient.get<QuestRunProgress | null>(
      "/api/quest-runs/active",
    );
    return data ?? null;
  },

  async submitAnswer(payload: SubmitAnswerPayload): Promise<QuestRunAnswer> {
    const { data } = await httpClient.post<QuestRunAnswer>(
      "/api/quest-runs/active/answer",
      { answer: payload.answer },
    );
    return data;
  },

  async abandon(): Promise<QuestRunProgress> {
    const { data } = await httpClient.post<QuestRunProgress>(
      "/api/quest-runs/active/abandon",
    );
    return data;
  },

  async history(): Promise<QuestRunHistoryItem[]> {
    const { data } = await httpClient.get<QuestRunHistoryItem[]>(
      "/api/quest-runs/history",
    );
    return data;
  },
};
