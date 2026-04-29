"use client";

import { usePathname } from "next/navigation";

import { navTabs } from "@/features/nav-tabs/model/tabs";
import { useTranslations } from "@/shared/i18n/i18n-provider";

import { NavTab } from "./nav-tab";

export function NavTabs() {
  const pathname = usePathname();
  const { t } = useTranslations();

  return (
    <nav className="flex items-center gap-6 border-b border-border">
      {navTabs.map((tab) => (
        <NavTab
          key={tab.href}
          href={tab.href}
          label={t(tab.translationKey)}
          isActive={
            pathname === tab.href || pathname.startsWith(`${tab.href}/`)
          }
        />
      ))}
    </nav>
  );
}
