import { ApiError, httpClient } from "@/shared/api";
import type {
  LeaderboardEntry,
  LeaderboardSelfPosition,
} from "@/entities/leaderboard";
import type { Page } from "@/shared/api/pagination";

type RatingEntryDto = {
  name: string;
  points: number;
  place: number;
};

type UserRatingPage = Page<RatingEntryDto> & { current_user: RatingEntryDto };
type TeamRatingPage = Page<RatingEntryDto> & {
  current_user_team: RatingEntryDto | null;
};

export type RatingPageParams = {
  limit?: number;
  offset?: number;
};

export type RatingPage = {
  entries: LeaderboardEntry[];
  self: LeaderboardSelfPosition | null;
  total: number;
  limit: number;
  offset: number;
};

function adaptEntry(
  dto: RatingEntryDto,
  ownName: string | undefined,
): LeaderboardEntry {
  return {
    rank: dto.place,
    name: dto.name,
    score: dto.points,
    isMine: ownName !== undefined && dto.name === ownName,
  };
}

function adaptSelf(
  dto: RatingEntryDto | null | undefined,
  total: number,
): LeaderboardSelfPosition | null {
  if (!dto) return null;
  return {
    rank: dto.place,
    score: dto.points,
    name: dto.name,
    totalParticipants: total,
  };
}

function isCurrentUserMissing(error: unknown): boolean {
  if (!(error instanceof ApiError)) return false;
  if (error.status === 404) return true;
  return /current user.*not found.*rating|not found in rating/i.test(
    error.message ?? "",
  );
}

function emptyPage(limit: number, offset: number): RatingPage {
  return { entries: [], self: null, total: 0, limit, offset };
}

export const leaderboardService = {
  async listUsers(params: RatingPageParams = {}): Promise<RatingPage> {
    const limit = params.limit ?? 20;
    const offset = params.offset ?? 0;
    try {
      const { data } = await httpClient.get<UserRatingPage>(
        "/api/rating/users",
        { params: { limit, offset } },
      );
      const ownName = data.current_user?.name;
      return {
        entries: data.items.map((entry) => adaptEntry(entry, ownName)),
        self: adaptSelf(data.current_user, data.total),
        total: data.total,
        limit: data.limit,
        offset: data.offset,
      };
    } catch (error) {
      if (isCurrentUserMissing(error)) {
        return emptyPage(limit, offset);
      }
      throw error;
    }
  },

  async listTeams(params: RatingPageParams = {}): Promise<RatingPage> {
    const limit = params.limit ?? 20;
    const offset = params.offset ?? 0;
    try {
      const { data } = await httpClient.get<TeamRatingPage>(
        "/api/rating/teams",
        { params: { limit, offset } },
      );
      const ownName = data.current_user_team?.name;
      return {
        entries: data.items.map((entry) => adaptEntry(entry, ownName)),
        self: adaptSelf(data.current_user_team, data.total),
        total: data.total,
        limit: data.limit,
        offset: data.offset,
      };
    } catch (error) {
      if (isCurrentUserMissing(error)) {
        return emptyPage(limit, offset);
      }
      throw error;
    }
  },
};
