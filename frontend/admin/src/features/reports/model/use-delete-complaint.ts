"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

import { reportsService } from "../api/reports-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import type { ApiError } from "@/shared/api";

export function useDeleteComplaint() {
  const queryClient = useQueryClient();

  return useMutation<void, ApiError, number | string>({
    mutationFn: (id) => reportsService.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.reports.lists() });
    },
  });
}
