export const DEFAULT_PAGE_SIZE = 10;

export type PageParams = {
  limit?: number;
  offset?: number;
};

export type InfinitePageParam = number;

export function getNextOffset(params: {
  total: number;
  limit: number;
  offset: number;
}): InfinitePageParam | undefined {
  const next = params.offset + params.limit;
  return next < params.total ? next : undefined;
}
