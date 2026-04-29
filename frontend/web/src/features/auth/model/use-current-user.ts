"use client";

import { useQuery } from "@tanstack/react-query";

import { authService } from "../api/auth-service";
import { useAuthStore } from "@/shared/store/auth-store";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { AuthUser } from "@/entities/user";
import type { ApiError } from "@/shared/api";

export function useCurrentUser() {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const setUser = useAuthStore((state) => state.setUser);

  return useQuery<AuthUser, ApiError>({
    queryKey: queryKeys.auth.me(),
    queryFn: async () => {
      const user = await authService.me();
      setUser(user);
      return user;
    },
    enabled: isAuthenticated,
    staleTime: 5 * 60_000,
  });
}
