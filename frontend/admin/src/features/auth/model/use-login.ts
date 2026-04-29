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

export class NotModeratorError extends ApiError {
  constructor() {
    super("Only moderators can sign in to the admin panel.", 403);
    this.name = "NotModeratorError";
  }
}

export function useLogin() {
  const setAuth = useAuthStore((state) => state.setAuth);
  const queryClient = useQueryClient();

  return useMutation<TokenPair, ApiError, LoginPayload>({
    mutationFn: async (payload) => {
      const data = await authService.login(payload);
      // Reject regular user accounts at the client. The backend issues tokens
      // for any role, so the admin panel guards itself.
      if (data.user.role !== "moderator") {
        // Best-effort revoke of the freshly issued refresh token.
        try {
          await authService.logout(data.refresh_token);
        } catch {
          // ignore — server-side cleanup is non-critical here.
        }
        throw new NotModeratorError();
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
