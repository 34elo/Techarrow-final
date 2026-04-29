"use client";

import type { InfiniteQueryObserverResult } from "@tanstack/react-query";
import { useState } from "react";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { fetchAllNextPages } from "@/shared/lib/react-query/fetch-all-next-pages";
import { Button } from "@/shared/ui/button";

type InfiniteListFooterProps<TData, TError> = {
  hasNextPage: boolean;
  fetchNextPage: () => Promise<InfiniteQueryObserverResult<TData, TError>>;
  isFetchingNextPage: boolean;
};

export function InfiniteListFooter<TData, TError>({
  hasNextPage,
  fetchNextPage,
  isFetchingNextPage,
}: InfiniteListFooterProps<TData, TError>) {
  const { t } = useTranslations();
  const [isLoadingAll, setIsLoadingAll] = useState(false);

  if (!hasNextPage) return null;

  const busy = isFetchingNextPage || isLoadingAll;

  const handleLoadAll = async () => {
    setIsLoadingAll(true);
    try {
      await fetchAllNextPages(fetchNextPage);
    } finally {
      setIsLoadingAll(false);
    }
  };

  return (
    <div className="mt-6 flex flex-wrap justify-center gap-3">
      <Button
        variant="outline"
        onClick={() => void fetchNextPage()}
        disabled={busy}
      >
        {isFetchingNextPage && !isLoadingAll
          ? t("common.loading")
          : t("common.loadMore")}
      </Button>
      <Button
        variant="outline"
        onClick={() => void handleLoadAll()}
        disabled={busy}
      >
        {isLoadingAll ? t("common.loading") : t("common.loadAll")}
      </Button>
    </div>
  );
}
