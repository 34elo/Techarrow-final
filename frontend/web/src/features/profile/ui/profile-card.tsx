"use client";

import { useState } from "react";
import { Pencil } from "lucide-react";

import type { AuthUser } from "@/entities/user";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";
import { Card, CardContent } from "@/shared/ui/card";

import { EditProfileDialog } from "./edit-profile-dialog";

type ProfileCardProps = {
  user: AuthUser;
  className?: string;
};

function getInitials(value: string): string {
  return value
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join("");
}

export function ProfileCard({ user, className }: ProfileCardProps) {
  const { t } = useTranslations();
  const [isEditing, setIsEditing] = useState(false);
  const initials = getInitials(user.username || user.email);

  return (
    <Card className={cn("relative border-0 shadow-md", className)}>
      <CardContent className="flex flex-1 flex-col items-center gap-5 p-6 text-center">
        <Button
          variant="ghost"
          size="icon"
          className="absolute right-3 top-3 size-8 rounded-full text-muted-foreground hover:text-foreground"
          aria-label={t("profile.editButton")}
          onClick={() => setIsEditing(true)}
        >
          <Pencil className="size-3.5" />
        </Button>

        <div className="flex size-20 items-center justify-center rounded-full bg-muted text-2xl font-semibold text-foreground">
          {initials}
        </div>

        <div className="min-w-0 space-y-1">
          <h2 className="truncate text-lg font-semibold leading-tight">
            {user.username}
          </h2>
          <p className="truncate text-xs text-muted-foreground">{user.email}</p>
        </div>

        <div className="flex flex-wrap items-center justify-center gap-1.5">
          <Badge variant="outline">{user.role}</Badge>
          {user.team_name ? (
            <Badge variant="default">{user.team_name}</Badge>
          ) : null}
        </div>

        <div className="mt-auto flex w-full items-end justify-between border-t pt-4">
          <span className="text-[10px] font-medium uppercase tracking-wider text-muted-foreground">
            {t("profile.totalPointsLabel")}
          </span>
          <span className="text-2xl font-semibold leading-none tabular-nums">
            {user.total_points.toLocaleString()}
          </span>
        </div>
      </CardContent>

      <EditProfileDialog
        key={`${user.id}:${user.username}:${user.birthdate}`}
        open={isEditing}
        onOpenChange={setIsEditing}
        user={user}
      />
    </Card>
  );
}
