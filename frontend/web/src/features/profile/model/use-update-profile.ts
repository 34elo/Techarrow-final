"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import {
  profileService,
  type UpdateProfilePayload,
} from "../api/profile-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { useAuthStore } from "@/shared/store/auth-store";
import type { AuthUser } from "@/entities/user";
import type { ApiError } from "@/shared/api";

export function useUpdateProfile() {
  const queryClient = useQueryClient();
  const setUser = useAuthStore((state) => state.setUser);

  return useMutation<AuthUser, ApiError, UpdateProfilePayload>({
    mutationFn: (payload) => profileService.update(payload),
    onSuccess: (updated) => {
      setUser(updated);
      queryClient.setQueryData(queryKeys.auth.me(), updated);
    },
  });
}
