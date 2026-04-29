import type { InfiniteQueryObserverResult } from "@tanstack/react-query";

export async function fetchAllNextPages<TData, TError>(
  fetchNextPage: () => Promise<InfiniteQueryObserverResult<TData, TError>>,
): Promise<void> {
  let result = await fetchNextPage();
  while (result.hasNextPage) {
    result = await fetchNextPage();
  }
}
