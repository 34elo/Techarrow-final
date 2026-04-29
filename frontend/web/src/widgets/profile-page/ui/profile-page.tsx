"use client";

import { Eye, History, LogOut } from "lucide-react";

import { AchievementsPreview } from "@/features/achievements";
import { useCurrentUser, useLogout } from "@/features/auth";
import { ProfileCard } from "@/features/profile";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Skeleton } from "@/shared/ui/skeleton";

import { ProfileListCard, type ProfileListItem } from "./profile-list-card";

export function ProfilePage() {
  const { t } = useTranslations();
  const { data: user, isLoading } = useCurrentUser();
  const logout = useLogout();

  const items: ProfileListItem[] = [
    {
      icon: History,
      label: t("profile.viewHistory"),
      description: t("profile.viewHistoryHint"),
      href: "/profile/history",
    },
    {
      icon: Eye,
      label: t("profile.viewRecent"),
      description: t("profile.viewRecentHint"),
      href: "/profile/recent",
    },
    {
      icon: LogOut,
      label: t("profile.logout"),
      busyLabel: t("profile.logoutPending"),
      destructive: true,
      onClick: () => logout.mutate(),
      disabled: logout.isPending,
      isBusy: logout.isPending,
    },
  ];

  return (
    <div className="space-y-6">
      <header className="space-y-1">
        <h1 className="text-2xl font-semibold tracking-tight">
          {t("profile.title")}
        </h1>
        <p className="text-sm text-muted-foreground">
          {t("profile.description")}
        </p>
      </header>

      <div className="grid gap-4 lg:grid-cols-[minmax(0,320px)_minmax(0,1fr)] lg:items-stretch">
        <div className="flex">
          {isLoading || !user ? (
            <Skeleton className="h-full min-h-72 w-full rounded-3xl" />
          ) : (
            <ProfileCard user={user} className="h-full w-full" />
          )}
        </div>

        <div className="flex flex-col gap-4">
          <AchievementsPreview className="flex-1" />
          <ProfileListCard items={items} />
        </div>
      </div>
    </div>
  );
}
