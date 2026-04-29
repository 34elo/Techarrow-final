import { httpClient } from "@/shared/api";
import type {
  TeamQuestRunCheckpointAnswer,
  TeamQuestRunProgress,
} from "@/entities/team-quest-run";

export type SetReadinessPayload = {
  questId: number;
  isReady: boolean;
};

export type SubmitTeamCheckpointAnswerPayload = {
  checkpointId: number;
  answer: string;
};

export const teamQuestRunService = {
  async getActive(): Promise<TeamQuestRunProgress | null> {
    const { data } = await httpClient.get<TeamQuestRunProgress | null>(
      "/api/team-quest-runs/active",
    );
    return data ?? null;
  },

  async setReadiness(
    payload: SetReadinessPayload,
  ): Promise<TeamQuestRunProgress> {
    const { data } = await httpClient.patch<TeamQuestRunProgress>(
      "/api/team-quest-runs",
      { quest_id: payload.questId, is_ready: payload.isReady },
    );
    return data;
  },

  async submitCheckpointAnswer(
    payload: SubmitTeamCheckpointAnswerPayload,
  ): Promise<TeamQuestRunCheckpointAnswer> {
    const { data } = await httpClient.post<TeamQuestRunCheckpointAnswer>(
      `/api/team-quest-runs/active/checkpoints/${payload.checkpointId}/answer`,
      { answer: payload.answer },
    );
    return data;
  },
};
