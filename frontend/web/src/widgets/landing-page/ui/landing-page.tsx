"use client";

import { ArrowRight, Download, MapPin, Sparkles, UsersRound } from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import type { LucideIcon } from "lucide-react";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { LanguageToggle } from "@/shared/i18n/language-switcher";
import { Button } from "@/shared/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";
import { ThemeToggle } from "@/shared/ui/theme-toggle";

const DOWNLOAD_URL = "#";

const FEATURES: Array<{ key: string; icon: LucideIcon }> = [
  { key: "geo", icon: MapPin },
  { key: "team", icon: UsersRound },
  { key: "create", icon: Sparkles },
];

export function LandingPage() {
  const { t } = useTranslations();

  return (
    <div className="flex min-h-screen flex-col bg-background text-foreground">
      <header className="sticky top-0 z-10 border-b border-border bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/80">
        <div className="mx-auto flex w-full max-w-6xl items-center justify-between gap-4 px-4 py-3 md:px-6 md:py-4">
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

      <main className="flex-1 px-4 py-10 md:px-6 md:py-16">
        <div className="mx-auto w-full max-w-3xl">
          <section className="space-y-6 text-center">
            <span className="inline-flex items-center gap-2 rounded-full bg-secondary px-3 py-1 text-xs font-medium text-secondary-foreground">
              <Sparkles className="size-3.5 text-primary" aria-hidden />
              {t("landing.tagline")}
            </span>
            <h1 className="text-3xl font-semibold tracking-tight md:text-5xl">
              {t("brand.name")}
            </h1>
            <p className="mx-auto max-w-xl text-base leading-relaxed text-muted-foreground md:text-lg">
              {t("landing.description")}
            </p>
            <div className="flex flex-col items-center justify-center gap-3 pt-2 sm:flex-row">
              <Button asChild size="lg">
                <Link href="/quests">
                  {t("landing.openWeb")}
                  <ArrowRight />
                </Link>
              </Button>
              <Button asChild size="lg" variant="outline">
                <a href="https://disk.yandex.ru/d/hGIOuA_1WCC8Zg">
                  <Download />
                  {t("landing.download")}
                </a>
              </Button>
            </div>
          </section>

          <section className="mt-12 grid gap-4 sm:grid-cols-3">
            {FEATURES.map(({ key, icon: Icon }) => (
              <Card key={key} className="gap-3 py-5">
                <CardHeader className="flex flex-row items-center gap-2 space-y-0">
                  <span
                    aria-hidden
                    className="flex size-9 shrink-0 items-center justify-center rounded-2xl bg-secondary text-primary"
                  >
                    <Icon className="size-5" />
                  </span>
                  <CardTitle className="text-base">
                    {t(`landing.features.${key}.title`)}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-sm leading-relaxed text-muted-foreground">
                    {t(`landing.features.${key}.body`)}
                  </p>
                </CardContent>
              </Card>
            ))}
          </section>
        </div>
      </main>
    </div>
  );
}
