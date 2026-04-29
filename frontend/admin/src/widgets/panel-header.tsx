"use client";

import Image from "next/image";

import { useLogout } from "@/features/auth";
import { NavTabs } from "@/features/nav-tabs/ui/nav-tabs";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { LanguageToggle } from "@/shared/i18n/language-switcher";
import { ThemeToggle } from "@/shared/ui/theme-toggle";

export function PanelHeader() {
  const { t } = useTranslations();
  const logout = useLogout();

  return (
    <header className="space-y-6">
      <div className="flex items-center justify-between gap-3 border-b border-border pb-4">
        <div className="inline-flex items-center gap-2 text-lg font-semibold tracking-tight">
          <Image
            src="/logo.svg"
            alt=""
            width={28}
            height={28}
            className="size-7"
            priority
          />
          <span>{t("brand.name")}</span>
        </div>
        <div className="flex items-center gap-2">
          <LanguageToggle />
          <ThemeToggle />
          <Button
            variant="destructive"
            disabled={logout.isPending}
            onClick={() => logout.mutate()}
          >
            {logout.isPending
              ? t("panel.logoutPending")
              : t("panel.logoutButton")}
          </Button>
        </div>
      </div>
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div className="space-y-2">
          <h1 className="text-3xl font-semibold tracking-tight">
            {t("panel.title")}
          </h1>
          <p className="text-sm text-muted-foreground">
            {t("panel.description")}
          </p>
        </div>
      </div>
      <NavTabs />
    </header>
  );
}
