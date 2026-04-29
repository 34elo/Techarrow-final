import { httpClient } from "@/shared/api";
import type { Team } from "@/entities/team";

export type CreateTeamPayload = {
  name: string;
  description: string;
};

export type JoinTeamPayload = {
  code: string;
};

export const teamsService = {
  async create(payload: CreateTeamPayload): Promise<Team> {
    const { data } = await httpClient.post<Team>("/api/teams", payload);
    return data;
  },

  async getMy(): Promise<Team> {
    const { data } = await httpClient.get<Team>("/api/teams/me");
    return data;
  },

  async join(payload: JoinTeamPayload): Promise<Team> {
    const { data } = await httpClient.post<Team>("/api/teams/join", payload);
    return data;
  },

  async leave(): Promise<void> {
    await httpClient.post("/api/teams/leave");
  },

  async kick(memberId: number): Promise<Team> {
    const { data } = await httpClient.delete<Team>(
      `/api/teams/members/${memberId}`,
    );
    return data;
  },
};
