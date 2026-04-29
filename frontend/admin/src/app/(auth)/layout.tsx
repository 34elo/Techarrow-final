"use client";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { LanguageToggle } from "@/shared/i18n/language-switcher";
import { ThemeToggle } from "@/shared/ui/theme-toggle";

export default function AuthLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { t } = useTranslations();

  return (
    <div className="flex min-h-screen flex-col bg-background">
      <header className="sticky top-0 z-10 border-b border-border bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/80">
        <div className="mx-auto flex w-full max-w-6xl flex-wrap items-center justify-between gap-4 px-6 py-4">
          <span className="text-lg font-semibold tracking-tight">
            {t("panel.title")}
          </span>
          <div className="flex flex-wrap items-center justify-end gap-2">
            <LanguageToggle />
            <ThemeToggle />
          </div>
        </div>
      </header>

      <div className="flex flex-1 items-center justify-center px-4 py-12">
        {children}
      </div>
    </div>
  );
}
