"use client";

import { HelpCircle } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";

import { useTranslations } from "@/shared/i18n/i18n-provider";

export function GuideFab() {
  const pathname = usePathname();
  const { t } = useTranslations();

  if (pathname.startsWith("/guide")) return null;

  return (
    <Link
      href="/guide"
      aria-label={t("guide.openLink")}
      title={t("guide.openLink")}
      className="fixed right-4 bottom-[calc(5rem+env(safe-area-inset-bottom))] z-30 flex size-12 items-center justify-center rounded-full bg-primary text-primary-foreground shadow-lg shadow-primary/25 outline-none transition-transform hover:scale-105 focus-visible:ring-2 focus-visible:ring-ring/60 active:scale-95 md:right-6 md:bottom-6"
    >
      <HelpCircle aria-hidden className="size-6" />
    </Link>
  );
}
