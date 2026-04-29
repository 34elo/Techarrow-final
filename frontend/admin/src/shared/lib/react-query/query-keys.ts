export type QuestsListFilters = {
  scope: "moderation" | "public";
  city?: string;
  difficulties?: number[];
  minDurationMinutes?: number;
  maxDurationMinutes?: number;
};

export type ReportsListFilters = Record<string, never>;

export const queryKeys = {
  auth: {
    all: ["auth"] as const,
    me: () => [...queryKeys.auth.all, "me"] as const,
  },
  quests: {
    all: ["quests"] as const,
    lists: () => [...queryKeys.quests.all, "list"] as const,
    list: (filters: QuestsListFilters) =>
      [...queryKeys.quests.lists(), filters] as const,
    details: () => [...queryKeys.quests.all, "detail"] as const,
    detail: (id: number | string) =>
      [...queryKeys.quests.details(), String(id)] as const,
  },
  reports: {
    all: ["reports"] as const,
    lists: () => [...queryKeys.reports.all, "list"] as const,
    list: (filters: ReportsListFilters = {}) =>
      [...queryKeys.reports.lists(), filters] as const,
  },
} as const;
