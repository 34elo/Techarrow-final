"use client";

import { useMemo, useState, type FormEvent } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { toast } from "sonner";

import { useRegister } from "@/features/auth";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import {
  MAX_AGE,
  MIN_AGE,
  getBirthdateBounds,
  isBirthdateInAgeRange,
} from "@/shared/lib/age";
import { Button } from "@/shared/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";
import { Label } from "@/shared/ui/label";

export default function RegisterPage() {
  const router = useRouter();
  const register = useRegister();
  const { t } = useTranslations();

  const [email, setEmail] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [birthdate, setBirthdate] = useState("");

  const birthdateBounds = useMemo(() => getBirthdateBounds(), []);

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (!isBirthdateInAgeRange(birthdate)) {
      toast.error(t("auth.ageInvalid", { min: MIN_AGE, max: MAX_AGE }));
      return;
    }

    register.mutate(
      { email, username, password, birthdate },
      {
        onSuccess: () => {
          router.replace("/quests");
        },
        onError: (error) => {
          toast.error(t("auth.registerError"), {
            description: error.message || t("auth.registerErrorFallback"),
          });
        },
      },
    );
  };

  return (
    <Card className="w-full max-w-md">
      <CardHeader>
        <CardTitle>{t("auth.registerTitle")}</CardTitle>
        <CardDescription>{t("auth.registerDescription")}</CardDescription>
      </CardHeader>
      <form onSubmit={handleSubmit}>
        <CardContent className="space-y-4 mb-6">
          <div className="space-y-2">
            <Label htmlFor="email">{t("auth.emailLabel")}</Label>
            <Input
              id="email"
              name="email"
              type="email"
              autoComplete="email"
              required
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              disabled={register.isPending}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="username">{t("auth.usernameLabel")}</Label>
            <Input
              id="username"
              name="username"
              type="text"
              autoComplete="username"
              required
              minLength={3}
              maxLength={255}
              value={username}
              onChange={(event) => setUsername(event.target.value)}
              disabled={register.isPending}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="birthdate">{t("auth.birthdateLabel")}</Label>
            <Input
              id="birthdate"
              name="birthdate"
              type="date"
              required
              min={birthdateBounds.min}
              max={birthdateBounds.max}
              value={birthdate}
              onChange={(event) => setBirthdate(event.target.value)}
              disabled={register.isPending}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="password">{t("auth.passwordLabel")}</Label>
            <Input
              id="password"
              name="password"
              type="password"
              autoComplete="new-password"
              required
              minLength={8}
              maxLength={255}
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              disabled={register.isPending}
            />
          </div>
        </CardContent>
        <CardFooter className="flex flex-col gap-3">
          <Button
            type="submit"
            className="w-full"
            disabled={register.isPending}
          >
            {register.isPending
              ? t("auth.submitRegisterPending")
              : t("auth.submitRegister")}
          </Button>
          <p className="text-sm text-muted-foreground">
            {t("auth.hasAccount")}{" "}
            <Link
              href="/login"
              className="font-medium text-primary hover:underline"
            >
              {t("auth.loginLink")}
            </Link>
          </p>
        </CardFooter>
      </form>
    </Card>
  );
}
