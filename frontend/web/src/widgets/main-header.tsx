"use client";

import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { LanguageToggle } from "@/shared/i18n/language-switcher";
import { cn } from "@/shared/lib/classnames";
import { ThemeToggle } from "@/shared/ui/theme-toggle";

const navItems = [
  {
    href: "/quests",
    labelKey: "nav.quests",
    match: (p: string) => p === "/quests",
  },
  {
    href: "/quests/my",
    labelKey: "nav.myQuests",
    match: (p: string) =>
      p.startsWith("/quests/my") || p.startsWith("/quests/favorites"),
  },
  {
    href: "/leaderboard",
    labelKey: "nav.leaderboard",
    match: (p: string) => p.startsWith("/leaderboard"),
  },
  {
    href: "/team",
    labelKey: "nav.team",
    match: (p: string) => p.startsWith("/team"),
  },
  {
    href: "/profile",
    labelKey: "nav.profile",
    match: (p: string) => p.startsWith("/profile"),
  },
];

export function MainHeader() {
  const pathname = usePathname();
  const { t } = useTranslations();

  return (
    <header className="sticky top-0 z-10 border-b border-border bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/80">
      <div className="mx-auto flex w-full max-w-6xl items-center justify-between gap-4 px-4 py-3 md:px-6 md:py-4">
        <Link
          href="/quests"
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

        <nav className="hidden flex-wrap items-center gap-1 md:flex">
          {navItems.map((item) => {
            const isActive = item.match(pathname);
            return (
              <Link
                key={item.href}
                href={item.href}
                aria-current={isActive ? "page" : undefined}
                className={cn(
                  "rounded-xl px-3 py-2 text-sm font-medium transition-colors",
                  isActive
                    ? "bg-secondary text-secondary-foreground"
                    : "text-muted-foreground hover:bg-secondary hover:text-secondary-foreground",
                )}
              >
                {t(item.labelKey)}
              </Link>
            );
          })}
        </nav>

        <div className="flex items-center gap-2">
          <LanguageToggle />
          <ThemeToggle />
        </div>
      </div>
    </header>
  );
}
