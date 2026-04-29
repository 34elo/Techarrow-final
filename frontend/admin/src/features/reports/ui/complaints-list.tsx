"use client";

import type {
  InfiniteData,
  InfiniteQueryObserverResult,
} from "@tanstack/react-query";

import type { Page } from "@/entities/quest";
import type { Report } from "@/entities/report";
import type { ApiError } from "@/shared/api";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { InfiniteListFooter } from "@/shared/ui/infinite-list-footer";

import { ReportCard } from "./report-card";

type ComplaintsListProps = {
  items: Report[];
  isLoading: boolean;
  isError: boolean;
  errorMessage?: string | null;
  onAccept: (report: Report) => void;
  onDismiss: (report: Report) => void;
  isActionPending?: boolean;
  hasNextPage?: boolean;
  fetchNextPage?: () => Promise<
    InfiniteQueryObserverResult<InfiniteData<Page<Report>>, ApiError>
  >;
  isFetchingNextPage?: boolean;
};

export function ComplaintsList({
  items,
  isLoading,
  isError,
  errorMessage,
  onAccept,
  onDismiss,
  isActionPending,
  hasNextPage,
  fetchNextPage,
  isFetchingNextPage,
}: ComplaintsListProps) {
  const { t } = useTranslations();

  if (isLoading) {
    return (
      <p className="py-6 text-sm text-muted-foreground">
        {t("common.loading")}
      </p>
    );
  }

  if (isError) {
    return (
      <p className="py-6 text-sm text-destructive">
        {errorMessage || t("common.loadError")}
      </p>
    );
  }

  if (items.length === 0) {
    return (
      <p className="py-6 text-sm text-muted-foreground">
        {t("requests.empty")}
      </p>
    );
  }

  return (
    <>
      <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
        {items.map((report) => (
          <ReportCard
            key={report.id}
            report={report}
            onAccept={onAccept}
            onDismiss={onDismiss}
            isPending={isActionPending}
          />
        ))}
      </div>
      {hasNextPage && fetchNextPage ? (
        <InfiniteListFooter
          hasNextPage={hasNextPage}
          fetchNextPage={fetchNextPage}
          isFetchingNextPage={Boolean(isFetchingNextPage)}
        />
      ) : null}
    </>
  );
}
