"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import {
  authService,
  type LoginPayload,
  type TokenPair,
} from "../api/auth-service";
import { useAuthStore } from "@/shared/store/auth-store";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { ApiError } from "@/shared/api";

export class ModeratorNotAllowedError extends ApiError {
  constructor() {
    super("Moderators must sign in through the admin panel.", 403);
    this.name = "ModeratorNotAllowedError";
  }
}

export function useLogin() {
  const setAuth = useAuthStore((state) => state.setAuth);
  const queryClient = useQueryClient();

  return useMutation<TokenPair, ApiError, LoginPayload>({
    mutationFn: async (payload) => {
      const data = await authService.login(payload);
      // Mirror of the admin login guard: backend issues tokens for any role,
      // so the user panel rejects moderator accounts on the client.
      if (data.user.role !== "user") {
        try {
          await authService.logout(data.refresh_token);
        } catch {
          // ignore — server-side cleanup is non-critical here.
        }
        throw new ModeratorNotAllowedError();
      }
      return data;
    },
    onSuccess: (data) => {
      setAuth({
        user: data.user,
        tokens: {
          accessToken: data.access_token,
          refreshToken: data.refresh_token,
        },
      });
      queryClient.setQueryData(queryKeys.auth.me(), data.user);
    },
  });
}
