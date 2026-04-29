"use client";

import type { ReactNode } from "react";
import Image from "next/image";
import Link from "next/link";

import { GuestGuard } from "@/features/auth";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { LanguageToggle } from "@/shared/i18n/language-switcher";
import { ThemeToggle } from "@/shared/ui/theme-toggle";

export default function AuthLayout({ children }: { children: ReactNode }) {
  const { t } = useTranslations();

  return (
    <GuestGuard>
      <div className="flex min-h-screen flex-col bg-background">
        <header className="sticky top-0 z-10 border-b border-border bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/80">
          <div className="mx-auto flex w-full max-w-6xl items-center justify-between gap-4 px-6 py-4">
            <Link
              href="/"
              className="inline-flex items-center gap-2 rounded-2xl text-lg font-semibold tracking-tight outline-none focus-visible:ring-2 focus-visible:ring-ring/40"
            >
              <Image
                src="/logo.svg"
                alt=""
                width={28}
                height={28}
                className="size-7"
                priority
              />
              <span>{t("brand.name")}</span>
            </Link>
            <div className="flex items-center gap-2">
              <LanguageToggle />
              <ThemeToggle />
            </div>
          </div>
        </header>

        <div className="flex flex-1 items-center justify-center px-4 py-12">
          {children}
        </div>
      </div>
    </GuestGuard>
  );
}
