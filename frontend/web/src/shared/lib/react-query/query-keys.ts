export type QuestsListFilters = {
  scope: "public" | "my" | "favorites";
  city?: string;
  difficulties?: number[];
  minDurationMinutes?: number;
  maxDurationMinutes?: number;
  nearLat?: number;
  nearLng?: number;
};

export type RatingScope = "users" | "teams";

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
    map: () => [...queryKeys.quests.all, "map"] as const,
    favorites: () => [...queryKeys.quests.all, "favorites"] as const,
  },
  questRun: {
    all: ["quest-run"] as const,
    active: () => [...queryKeys.questRun.all, "active"] as const,
    history: () => [...queryKeys.questRun.all, "history"] as const,
  },
  teamQuestRun: {
    all: ["team-quest-run"] as const,
    active: () => [...queryKeys.teamQuestRun.all, "active"] as const,
  },
  teams: {
    all: ["teams"] as const,
    me: () => [...queryKeys.teams.all, "me"] as const,
  },
  rating: {
    all: ["rating"] as const,
    list: (scope: RatingScope) => [...queryKeys.rating.all, scope] as const,
  },
  achievements: {
    all: ["achievements"] as const,
    list: () => [...queryKeys.achievements.all, "list"] as const,
    me: () => [...queryKeys.achievements.all, "me"] as const,
  },
} as const;
