"use client";

import { useState, type FormEvent } from "react";
import { toast } from "sonner";

import { TEAM_INVITE_CODE_LENGTH } from "@/entities/team";
import { useJoinTeam } from "@/features/teams";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";
import { Label } from "@/shared/ui/label";

type JoinTeamFormProps = {
  initialCode?: string;
  /** Show a hint that the code came from an invite link. */
  prefilledHint?: boolean;
};

function normaliseCode(value: string): string {
  return value.toUpperCase().slice(0, TEAM_INVITE_CODE_LENGTH);
}

export function JoinTeamForm({
  initialCode = "",
  prefilledHint = false,
}: JoinTeamFormProps) {
  const { t } = useTranslations();
  const joinTeam = useJoinTeam();
  const [code, setCode] = useState(() => normaliseCode(initialCode));

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    joinTeam.mutate(
      { code },
      {
        onSuccess: () => {
          toast.success(t("team.joinSuccess"));
          setCode("");
        },
        onError: (error) =>
          toast.error(t("team.joinFailed"), { description: error.message }),
      },
    );
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>{t("team.joinTitle")}</CardTitle>
        <p className="text-sm text-muted-foreground">
          {t("team.joinDescription")}
        </p>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-3">
          {prefilledHint && code.length > 0 ? (
            <p className="rounded-lg border border-primary/30 bg-primary/5 p-2 text-xs text-primary">
              {t("team.prefilledFromUrl")}
            </p>
          ) : null}
          <div className="space-y-1.5">
            <Label htmlFor="team-code">{t("team.codeLabel")}</Label>
            <Input
              id="team-code"
              value={code}
              minLength={TEAM_INVITE_CODE_LENGTH}
              maxLength={TEAM_INVITE_CODE_LENGTH}
              required
              onChange={(event) => setCode(normaliseCode(event.target.value))}
              disabled={joinTeam.isPending}
              placeholder="XXXXXXXXXXXX"
              className="font-mono"
            />
          </div>
          <Button
            type="submit"
            disabled={
              joinTeam.isPending || code.length !== TEAM_INVITE_CODE_LENGTH
            }
          >
            {joinTeam.isPending
              ? t("team.joiningButton")
              : t("team.joinButton")}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
