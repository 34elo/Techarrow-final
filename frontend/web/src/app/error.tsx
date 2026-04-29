"use client";

import Link from "next/link";

import { useTranslations } from "@/shared/i18n/i18n-provider";

type ErrorPageProps = {
  error: Error & { digest?: string };
  reset: () => void;
};

export default function ErrorPage({ error, reset }: ErrorPageProps) {
  void error;
  const { t } = useTranslations();

  return (
    <main className="min-h-screen bg-background text-foreground flex items-center justify-center p-6">
      <div className="w-full max-w-md rounded-2xl border border-border bg-card p-6 text-center shadow-sm">
        <p className="text-sm text-muted-foreground">
          {t("errors.serverErrorCode")}
        </p>
        <h1 className="mt-2 text-2xl font-semibold">
          {t("errors.serverErrorTitle")}
        </h1>
        <p className="mt-3 text-sm text-muted-foreground">
          {t("errors.serverErrorDescription")}
        </p>
        <div className="mt-5 flex items-center justify-center gap-2">
          <button
            type="button"
            onClick={reset}
            className="inline-flex rounded-xl bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
          >
            {t("common.retry")}
          </button>
          <Link
            href="/"
            className="inline-flex rounded-xl border border-border px-4 py-2 text-sm font-medium text-foreground transition-colors hover:bg-accent"
          >
            {t("common.backHome")}
          </Link>
        </div>
      </div>
    </main>
  );
}
