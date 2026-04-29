export const USER_ROLES = ["user", "moderator"] as const;
export type UserRole = (typeof USER_ROLES)[number];

export type AuthUser = {
  id: number;
  email: string;
  username: string;
  birthdate: string;
  role: UserRole;
  team_name?: string | null;
};
