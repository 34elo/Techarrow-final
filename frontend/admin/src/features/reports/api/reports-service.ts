import { httpClient } from "@/shared/api";
import { DEFAULT_PAGE_SIZE } from "@/shared/api/pagination";
import type { Page } from "@/entities/quest";
import type { Report } from "@/entities/report";

export type ReportsListParams = {
  limit?: number;
  offset?: number;
};

export const reportsService = {
  async list(params: ReportsListParams = {}): Promise<Page<Report>> {
    const { data } = await httpClient.get<Page<Report>>(
      "/api/moderation/complaints",
      {
        params: {
          limit: params.limit ?? DEFAULT_PAGE_SIZE,
          offset: params.offset ?? 0,
        },
      },
    );
    return data;
  },

  async delete(id: number | string): Promise<void> {
    await httpClient.delete(`/api/moderation/complaints/${id}`);
  },
};
