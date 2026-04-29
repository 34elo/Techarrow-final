"use client";

import {
  BookmarkCheck,
  Compass,
  Trophy,
  UserRound,
  UsersRound,
} from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type { ComponentType, SVGProps } from "react";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";

type NavItem = {
  href: string;
  labelKey: string;
  icon: ComponentType<SVGProps<SVGSVGElement>>;
  match: (pathname: string) => boolean;
};

const navItems: NavItem[] = [
  {
    href: "/quests",
    labelKey: "nav.quests",
    icon: Compass,
    match: (pathname) => pathname === "/quests",
  },
  {
    href: "/quests/my",
    labelKey: "nav.myQuests",
    icon: BookmarkCheck,
    match: (pathname) =>
      pathname.startsWith("/quests/my") ||
      pathname.startsWith("/quests/favorites"),
  },
  {
    href: "/leaderboard",
    labelKey: "nav.leaderboard",
    icon: Trophy,
    match: (pathname) => pathname.startsWith("/leaderboard"),
  },
  {
    href: "/team",
    labelKey: "nav.team",
    icon: UsersRound,
    match: (pathname) => pathname.startsWith("/team"),
  },
  {
    href: "/profile",
    labelKey: "nav.profile",
    icon: UserRound,
    match: (pathname) => pathname.startsWith("/profile"),
  },
];

export function BottomNav() {
  const pathname = usePathname();
  const { t } = useTranslations();

  return (
    <nav
      aria-label={t("nav.ariaLabel")}
      className="fixed inset-x-0 bottom-0 z-20 border-t border-border bg-background/95 pb-[env(safe-area-inset-bottom)] backdrop-blur supports-[backdrop-filter]:bg-background/80 md:hidden"
    >
      <ul className="mx-auto flex w-full max-w-md items-stretch justify-around px-2 py-1.5">
        {navItems.map((item) => {
          const isActive = item.match(pathname);
          const Icon = item.icon;

          return (
            <li key={item.href} className="flex-1">
              <Link
                href={item.href}
                aria-current={isActive ? "page" : undefined}
                className={cn(
                  "flex h-14 flex-col items-center justify-center gap-1 rounded-2xl px-2 text-xs font-medium transition-colors",
                  isActive
                    ? "bg-secondary text-secondary-foreground"
                    : "text-muted-foreground hover:bg-secondary/60 hover:text-secondary-foreground",
                )}
              >
                <Icon
                  aria-hidden="true"
                  className={cn(
                    "size-5 transition-colors",
                    isActive && "text-primary",
                  )}
                />
                <span className="leading-none">{t(item.labelKey)}</span>
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
