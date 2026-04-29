import { httpClient } from "@/shared/api";

export const questFavoritesService = {
  async add(questId: number | string): Promise<void> {
    await httpClient.post(`/api/quests/${questId}/favorite`);
  },

  async remove(questId: number | string): Promise<void> {
    await httpClient.delete(`/api/quests/${questId}/favorite`);
  },
};
