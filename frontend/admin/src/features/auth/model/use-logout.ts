"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { authService } from "../api/auth-service";
import { useAuthStore } from "@/shared/store/auth-store";

export function useLogout() {
  const queryClient = useQueryClient();

  return useMutation<void, Error, void>({
    mutationFn: async () => {
      const refreshToken = useAuthStore.getState().refreshToken;
      if (!refreshToken) return;
      try {
        await authService.logout(refreshToken);
      } catch {}
    },
    onSettled: () => {
      useAuthStore.getState().clearAuth();
      queryClient.clear();
    },
  });
}
