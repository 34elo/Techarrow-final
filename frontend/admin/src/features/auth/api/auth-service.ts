import { httpClient } from "@/shared/api";
import type { AuthUser } from "@/entities/user";

export type LoginPayload = {
  email: string;
  password: string;
};

export type TokenPair = {
  access_token: string;
  refresh_token: string;
  token_type: string;
  user: AuthUser;
};

export const authService = {
  async login(payload: LoginPayload): Promise<TokenPair> {
    const { data } = await httpClient.post<TokenPair>(
      "/api/auth/login",
      payload,
    );
    return data;
  },

  async refresh(refreshToken: string): Promise<TokenPair> {
    const { data } = await httpClient.post<TokenPair>("/api/auth/refresh", {
      refresh_token: refreshToken,
    });
    return data;
  },

  async me(): Promise<AuthUser> {
    const { data } = await httpClient.get<AuthUser>("/api/auth/me");
    return data;
  },

  async logout(refreshToken: string): Promise<void> {
    await httpClient.post("/api/auth/logout", { refresh_token: refreshToken });
  },
};
