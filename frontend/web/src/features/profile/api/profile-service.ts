import {
  authService,
  type UpdateMePayload,
} from "@/features/auth/api/auth-service";
import type { AuthUser } from "@/entities/user";

export type UpdateProfilePayload = UpdateMePayload;

export const profileService = {
  async update(payload: UpdateProfilePayload): Promise<AuthUser> {
    const trimmed: UpdateProfilePayload = {
      username: payload.username?.trim() || undefined,
      birthdate: payload.birthdate || undefined,
    };
    return authService.updateMe(trimmed);
  },
};
