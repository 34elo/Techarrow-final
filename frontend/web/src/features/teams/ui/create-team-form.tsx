"use client";

import { useState, type FormEvent } from "react";
import { toast } from "sonner";

import { useCreateTeam } from "@/features/teams";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";
import { Label } from "@/shared/ui/label";
import { Textarea } from "@/shared/ui/textarea";

export function CreateTeamForm() {
  const { t } = useTranslations();
  const createTeam = useCreateTeam();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    createTeam.mutate(
      { name, description },
      {
        onSuccess: () => {
          toast.success(t("team.createSuccess"));
          setName("");
          setDescription("");
        },
        onError: (error) =>
          toast.error(t("team.createFailed"), { description: error.message }),
      },
    );
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>{t("team.createTitle")}</CardTitle>
        <p className="text-sm text-muted-foreground">
          {t("team.createDescription")}
        </p>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-3">
          <div className="space-y-1.5">
            <Label htmlFor="team-name">{t("team.nameLabel")}</Label>
            <Input
              id="team-name"
              value={name}
              minLength={1}
              maxLength={255}
              required
              onChange={(event) => setName(event.target.value)}
              disabled={createTeam.isPending}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="team-description">
              {t("team.descriptionLabel")}
            </Label>
            <Textarea
              id="team-description"
              rows={3}
              value={description}
              minLength={1}
              maxLength={2000}
              required
              onChange={(event) => setDescription(event.target.value)}
              disabled={createTeam.isPending}
            />
          </div>
          <Button
            type="submit"
            disabled={createTeam.isPending}
            className="w-full sm:w-auto"
          >
            {createTeam.isPending
              ? t("team.creatingButton")
              : t("team.createButton")}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
