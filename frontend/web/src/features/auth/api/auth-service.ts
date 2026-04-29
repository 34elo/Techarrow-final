import { httpClient } from "@/shared/api";
import type { AuthUser } from "@/entities/user";

export type LoginPayload = {
  email: string;
  password: string;
};

export type RegisterPayload = {
  email: string;
  username: string;
  password: string;
  birthdate: string;
};

export type UpdateMePayload = {
  username?: string;
  birthdate?: string;
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

  async register(payload: RegisterPayload): Promise<TokenPair> {
    const { data } = await httpClient.post<TokenPair>(
      "/api/auth/register",
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

  async updateMe(payload: UpdateMePayload): Promise<AuthUser> {
    const { data } = await httpClient.patch<AuthUser>("/api/auth/me", payload);
    return data;
  },

  async logout(refreshToken: string): Promise<void> {
    await httpClient.post("/api/auth/logout", { refresh_token: refreshToken });
  },
};
