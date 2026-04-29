import { httpClient } from "@/shared/api";
import { DEFAULT_PAGE_SIZE } from "@/shared/api/pagination";
import type { Page, QuestDetail, QuestSummary } from "@/entities/quest";

export type QuestFilters = {
  city?: string;
  difficulties?: number[];
  minDurationMinutes?: number;
  maxDurationMinutes?: number;
};

export type QuestsListParams = QuestFilters & {
  limit?: number;
  offset?: number;
};

export type RejectQuestPayload = {
  id: number | string;
  reason: string;
};

function buildListParams(params: QuestsListParams) {
  return {
    limit: params.limit ?? DEFAULT_PAGE_SIZE,
    offset: params.offset ?? 0,
    city: params.city?.trim() || undefined,
    difficulties: params.difficulties?.length ? params.difficulties : undefined,
    min_duration_minutes: params.minDurationMinutes,
    max_duration_minutes: params.maxDurationMinutes,
  };
}

export const questsService = {
  async listOnModeration(
    params: QuestsListParams = {},
  ): Promise<Page<QuestSummary>> {
    const { data } = await httpClient.get<Page<QuestSummary>>(
      "/api/moderation/quests",
      {
        params: buildListParams(params),
      },
    );
    return data;
  },

  async listPublic(params: QuestsListParams = {}): Promise<Page<QuestSummary>> {
    const { data } = await httpClient.get<Page<QuestSummary>>("/api/quests", {
      params: buildListParams(params),
    });
    return data;
  },

  async detail(id: number | string): Promise<QuestDetail> {
    const { data } = await httpClient.get<QuestDetail>(`/api/quests/${id}`);
    return data;
  },

  async approve(id: number | string): Promise<QuestDetail> {
    const { data } = await httpClient.post<QuestDetail>(
      `/api/moderation/quests/${id}/publish`,
    );
    return data;
  },

  async reject({ id, reason }: RejectQuestPayload): Promise<QuestDetail> {
    const { data } = await httpClient.post<QuestDetail>(
      `/api/moderation/quests/${id}/reject`,
      { reason },
    );
    return data;
  },

  async deleteAsModerator(id: number | string): Promise<void> {
    await httpClient.delete(`/api/moderation/quests/${id}`);
  },

  async exportPdf(id: number | string): Promise<Blob> {
    const { data } = await httpClient.get<Blob>(`/api/quests/${id}/export`, {
      responseType: "blob",
    });
    return data;
  },
};
