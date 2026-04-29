"use client";

import { useMemo, useState, type FormEvent } from "react";
import { toast } from "sonner";

import type { AuthUser } from "@/entities/user";
import { useUpdateProfile } from "@/features/profile";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import {
  MAX_AGE,
  MIN_AGE,
  getBirthdateBounds,
  isBirthdateInAgeRange,
} from "@/shared/lib/age";
import { Button } from "@/shared/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/shared/ui/dialog";
import { Input } from "@/shared/ui/input";
import { Label } from "@/shared/ui/label";

type EditProfileDialogProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  user: AuthUser;
};

export function EditProfileDialog(props: EditProfileDialogProps) {
  return (
    <Dialog open={props.open} onOpenChange={props.onOpenChange}>
      <DialogContent>
        {props.open ? <EditProfileDialogBody {...props} /> : null}
      </DialogContent>
    </Dialog>
  );
}

function EditProfileDialogBody({ user, onOpenChange }: EditProfileDialogProps) {
  const { t } = useTranslations();
  const updateProfile = useUpdateProfile();
  const [username, setUsername] = useState(user.username);
  const [birthdate, setBirthdate] = useState(user.birthdate);

  const birthdateBounds = useMemo(() => getBirthdateBounds(), []);

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!isBirthdateInAgeRange(birthdate)) {
      toast.error(t("auth.ageInvalid", { min: MIN_AGE, max: MAX_AGE }));
      return;
    }
    updateProfile.mutate(
      { username, birthdate },
      {
        onSuccess: () => {
          toast.success(t("profile.saveSuccess"));
          onOpenChange(false);
        },
        onError: (error) =>
          toast.error(t("profile.saveFailed"), {
            description: error.message || t("common.tryAgain"),
          }),
      },
    );
  };

  return (
    <>
      <DialogHeader>
        <DialogTitle>{t("profile.editTitle")}</DialogTitle>
        <DialogDescription>{t("profile.editDescription")}</DialogDescription>
      </DialogHeader>
      <form onSubmit={handleSubmit} className="space-y-3">
        <div className="space-y-1.5">
          <Label htmlFor="profile-username">{t("profile.usernameLabel")}</Label>
          <Input
            id="profile-username"
            value={username}
            minLength={3}
            maxLength={255}
            required
            onChange={(event) => setUsername(event.target.value)}
          />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="profile-birthdate">
            {t("profile.birthdateLabel")}
          </Label>
          <Input
            id="profile-birthdate"
            type="date"
            required
            min={birthdateBounds.min}
            max={birthdateBounds.max}
            value={birthdate}
            onChange={(event) => setBirthdate(event.target.value)}
          />
        </div>
        <DialogFooter>
          <Button
            type="button"
            variant="outline"
            onClick={() => onOpenChange(false)}
            disabled={updateProfile.isPending}
          >
            {t("common.cancel")}
          </Button>
          <Button type="submit" disabled={updateProfile.isPending}>
            {updateProfile.isPending
              ? t("profile.savingButton")
              : t("profile.saveButton")}
          </Button>
        </DialogFooter>
      </form>
    </>
  );
}
