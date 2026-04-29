"use client";

import { useState } from "react";
import { Copy, LogOut, QrCode, UserMinus } from "lucide-react";
import { toast } from "sonner";

import type { Team, TeamMember } from "@/entities/team";
import { useKickMember, useLeaveTeam } from "@/features/teams";
import { TeamInviteQrDialog } from "@/features/teams/ui/team-invite-qr-dialog";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { useAuthStore } from "@/shared/store/auth-store";
import { Badge } from "@/shared/ui/badge";
import { Button } from "@/shared/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/shared/ui/dialog";

type TeamInfoCardProps = {
  team: Team;
};

export function TeamInfoCard({ team }: TeamInfoCardProps) {
  const { t } = useTranslations();
  const userId = useAuthStore((state) => state.user?.id);
  const leave = useLeaveTeam();
  const kick = useKickMember();
  const [copied, setCopied] = useState(false);
  const [qrOpen, setQrOpen] = useState(false);
  const [leaveOpen, setLeaveOpen] = useState(false);

  const isOwner = userId === team.creator_id;

  const handleCopyCode = async () => {
    try {
      await navigator.clipboard.writeText(team.code);
      setCopied(true);
      toast.success(t("team.copiedCode"));
      setTimeout(() => setCopied(false), 1500);
    } catch {
      toast.error(t("common.tryAgain"));
    }
  };

  const handleLeave = () => {
    leave.mutate(undefined, {
      onSuccess: () => {
        setLeaveOpen(false);
        toast.success(t("team.leaveSuccess"));
      },
      onError: (error) =>
        toast.error(t("team.leaveFailed"), {
          description: error.message,
        }),
    });
  };

  const handleKick = (member: TeamMember) => {
    kick.mutate(member.id, {
      onSuccess: () =>
        toast.success(t("team.kickSuccess"), { description: member.username }),
      onError: (error) =>
        toast.error(t("team.kickFailed"), { description: error.message }),
    });
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex flex-wrap items-center gap-2">
          <span>{team.name}</span>
          <Badge variant="outline">
            {t("team.membersCount", { count: team.members_count })}
          </Badge>
          <Badge variant="default">
            {t("team.totalPoints", {
              points: team.total_points.toLocaleString(),
            })}
          </Badge>
        </CardTitle>
        <p className="text-sm text-muted-foreground">{team.description}</p>
      </CardHeader>
      <CardContent className="space-y-5">
        <div className="space-y-1.5">
          <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            {t("team.inviteCodeLabel")}
          </p>
          <div className="flex flex-wrap items-center gap-2">
            <code className="rounded-lg border border-border bg-muted/40 px-3 py-1.5 text-sm font-mono">
              {team.code}
            </code>
            <Button size="sm" variant="outline" onClick={handleCopyCode}>
              <Copy />
              {copied ? t("team.copiedCode") : t("team.copyCode")}
            </Button>
            <Button size="sm" variant="outline" onClick={() => setQrOpen(true)}>
              <QrCode />
              {t("team.showQr")}
            </Button>
          </div>
        </div>

        <div className="space-y-2">
          <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            {t("nav.team")}
          </p>
          <ul className="grid grid-cols-1 gap-2 sm:grid-cols-2">
            {team.members.map((member) => (
              <li
                key={member.id}
                className="flex items-center justify-between gap-2 rounded-lg border border-border bg-card px-3 py-2"
              >
                <div className="min-w-0">
                  <p className="truncate text-sm font-medium">
                    {member.username}
                    {member.id === team.creator_id ? (
                      <span className="ml-1 text-xs text-muted-foreground">
                        ★
                      </span>
                    ) : null}
                  </p>
                  <p className="text-[11px] text-muted-foreground">
                    {member.age}
                  </p>
                </div>
                {isOwner && member.id !== team.creator_id ? (
                  <Button
                    size="icon-sm"
                    variant="ghost"
                    aria-label={t("team.kickMember")}
                    onClick={() => handleKick(member)}
                    disabled={kick.isPending}
                  >
                    <UserMinus className="text-destructive" />
                  </Button>
                ) : null}
              </li>
            ))}
          </ul>
        </div>

        <Button
          variant="destructive"
          onClick={() => setLeaveOpen(true)}
          disabled={leave.isPending}
        >
          <LogOut />
          {leave.isPending ? t("team.leavingTeam") : t("team.leaveTeam")}
        </Button>
      </CardContent>
      <TeamInviteQrDialog
        open={qrOpen}
        onOpenChange={setQrOpen}
        team={{ name: team.name, code: team.code }}
      />

      <Dialog open={leaveOpen} onOpenChange={setLeaveOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{t("team.leaveConfirmTitle")}</DialogTitle>
            <DialogDescription>
              {t("team.leaveConfirmDescription", { name: team.name })}
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => setLeaveOpen(false)}
              disabled={leave.isPending}
            >
              {t("common.cancel")}
            </Button>
            <Button
              variant="destructive"
              onClick={handleLeave}
              disabled={leave.isPending}
            >
              <LogOut />
              {leave.isPending ? t("team.leavingTeam") : t("team.leaveTeam")}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </Card>
  );
}
