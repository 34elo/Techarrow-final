"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import {
  authService,
  type RegisterPayload,
  type TokenPair,
} from "../api/auth-service";
import { useAuthStore } from "@/shared/store/auth-store";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";

export function useRegister() {
  const setAuth = useAuthStore((state) => state.setAuth);
  const queryClient = useQueryClient();

  return useMutation<TokenPair, ApiError, RegisterPayload>({
    mutationFn: (payload) => authService.register(payload),
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
