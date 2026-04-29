import { httpClient } from "@/shared/api";
import { DEFAULT_PAGE_SIZE } from "@/shared/api/pagination";
import type { Page } from "@/shared/api/pagination";
import type { CheckpointDraft } from "@/entities/checkpoint";
import type { Quest, QuestDetail } from "@/entities/quest";

export type QuestFilters = {
  city?: string;
  difficulties?: number[];
  minDurationMinutes?: number;
  maxDurationMinutes?: number;
  nearLat?: number;
  nearLng?: number;
};

export type QuestsListParams = QuestFilters & {
  limit?: number;
  offset?: number;
};

export type QuestPointPayload = {
  title: string;
  latitude: number;
  longitude: number;
  task: string;
  correct_answer: string;
  hint?: string | null;
  point_rules?: string | null;
};

export type CreateQuestPayload = {
  title: string;
  description: string;
  location: string;
  difficulty: number;
  durationMinutes: number;
  rulesAndWarnings?: string | null;
  image?: File | null;
  points: QuestPointPayload[];
};

function buildListParams(params: QuestsListParams) {
  return {
    limit: params.limit ?? DEFAULT_PAGE_SIZE,
    offset: params.offset ?? 0,
    city: params.city?.trim() || undefined,
    difficulties: params.difficulties?.length ? params.difficulties : undefined,
    min_duration_minutes: params.minDurationMinutes,
    max_duration_minutes: params.maxDurationMinutes,
    near_latitude: params.nearLat,
    near_longitude: params.nearLng,
  };
}

export function checkpointToPointPayload(
  draft: CheckpointDraft,
): QuestPointPayload {
  return {
    title: draft.title,
    latitude: draft.latitude,
    longitude: draft.longitude,
    task: draft.task,
    correct_answer: draft.correct_answer,
    hint: draft.hint?.trim() ? draft.hint.trim() : null,
    point_rules: draft.point_rules?.trim() ? draft.point_rules.trim() : null,
  };
}

function buildCreateFormData(payload: CreateQuestPayload): FormData {
  const fd = new FormData();
  fd.append("title", payload.title);
  fd.append("description", payload.description);
  fd.append("location", payload.location);
  fd.append("difficulty", String(payload.difficulty));
  fd.append("duration_minutes", String(payload.durationMinutes));
  if (payload.rulesAndWarnings) {
    fd.append("rules_and_warnings", payload.rulesAndWarnings);
  }
  if (payload.image) {
    fd.append("image", payload.image);
  }
  fd.append("points", JSON.stringify(payload.points));
  return fd;
}

export const questsService = {
  async list(params: QuestsListParams = {}): Promise<Page<Quest>> {
    const { data } = await httpClient.get<Page<Quest>>("/api/quests", {
      params: buildListParams(params),
    });
    return data;
  },

  async listMy(params: QuestsListParams = {}): Promise<Page<Quest>> {
    const { data } = await httpClient.get<Page<Quest>>("/api/quests/my", {
      params: buildListParams(params),
    });
    return data;
  },

  async listFavorites(params: QuestsListParams = {}): Promise<Page<Quest>> {
    const { data } = await httpClient.get<Page<Quest>>(
      "/api/quests/favorites",
      { params: buildListParams(params) },
    );
    return data;
  },

  async detail(id: number | string): Promise<QuestDetail> {
    const { data } = await httpClient.get<QuestDetail>(`/api/quests/${id}`);
    return data;
  },

  async create(payload: CreateQuestPayload): Promise<Quest> {
    const { data } = await httpClient.post<Quest>(
      "/api/quests",
      buildCreateFormData(payload),
      { headers: { "Content-Type": "multipart/form-data" } },
    );
    return data;
  },

  async deleteMy(id: number | string): Promise<void> {
    await httpClient.delete(`/api/quests/${id}`);
  },

  async updateStatus(
    id: number | string,
    status: "published" | "archived",
  ): Promise<Quest> {
    const { data } = await httpClient.patch<Quest>(`/api/quests/${id}/status`, {
      status,
    });
    return data;
  },

  async complain(id: number | string, reason: string): Promise<void> {
    await httpClient.post(`/api/quests/${id}/complaints`, { reason });
  },

  async addFavorite(id: number | string): Promise<void> {
    await httpClient.post(`/api/quests/${id}/favorite`);
  },

  async removeFavorite(id: number | string): Promise<void> {
    await httpClient.delete(`/api/quests/${id}/favorite`);
  },

  async exportPdf(id: number | string): Promise<Blob> {
    const { data } = await httpClient.get<Blob>(`/api/quests/${id}/export`, {
      responseType: "blob",
    });
    return data;
  },
};
