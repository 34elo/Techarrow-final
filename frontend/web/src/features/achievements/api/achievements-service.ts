import { httpClient } from "@/shared/api";
import type {
  AchievementResponse,
  UserAchievementResponse,
} from "@/entities/achievement";

type Page<T> = {
  items: T[];
  total: number;
  limit: number;
  offset: number;
};

const PAGE_LIMIT = 100;

export const achievementsService = {
  async listAll(): Promise<AchievementResponse[]> {
    const { data } = await httpClient.get<Page<AchievementResponse>>(
      "/api/achievements",
      { params: { limit: PAGE_LIMIT, offset: 0 } },
    );
    return data.items;
  },

  async listMine(): Promise<UserAchievementResponse[]> {
    const { data } = await httpClient.get<Page<UserAchievementResponse>>(
      "/api/achievements/me",
      { params: { limit: PAGE_LIMIT, offset: 0 } },
    );
    return data.items;
  },
};
