"use client";

import Link from "next/link";

import { useTranslations } from "@/shared/i18n/i18n-provider";

export default function AccessDeniedPage() {
  const { t } = useTranslations();

  return (
    <main className="min-h-screen bg-background text-foreground flex items-center justify-center p-6">
      <div className="w-full max-w-md rounded-2xl border border-border bg-card p-6 text-center shadow-sm">
        <p className="text-sm text-muted-foreground">
          {t("errors.accessDeniedCode")}
        </p>
        <h1 className="mt-2 text-2xl font-semibold">
          {t("errors.accessDeniedTitle")}
        </h1>
        <p className="mt-3 text-sm text-muted-foreground">
          {t("errors.accessDeniedDescription")}
        </p>
        <Link
          href="/login"
          className="mt-5 inline-flex rounded-xl bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
        >
          {t("errors.backToLogin")}
        </Link>
      </div>
    </main>
  );
}
