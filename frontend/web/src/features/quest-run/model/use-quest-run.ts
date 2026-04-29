"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

import { questRunService } from "../api/quest-run-service";
import { queryKeys } from "@/shared/lib/react-query/query-keys";
import { ApiError } from "@/shared/api";
import { useAuthStore } from "@/shared/store/auth-store";
import type {
  QuestRunAnswer,
  QuestRunHistoryItem,
  QuestRunProgress,
} from "@/entities/quest-run";

export function useActiveQuestRun() {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);

  return useQuery<QuestRunProgress | null, ApiError>({
    queryKey: queryKeys.questRun.active(),
    queryFn: async () => {
      try {
        return await questRunService.getActive();
      } catch (error) {
        // 404 means no active run — treat as a normal "no run" state.
        if (error instanceof ApiError && error.status === 404) {
          return null;
        }
        throw error;
      }
    },
    enabled: isAuthenticated,
    staleTime: 15_000,
  });
}

export function useStartQuestRun() {
  const queryClient = useQueryClient();
  return useMutation<QuestRunProgress, ApiError, { questId: number }>({
    mutationFn: ({ questId }) => questRunService.start({ questId }),
    onSuccess: (run) => {
      queryClient.setQueryData(queryKeys.questRun.active(), run);
      queryClient.invalidateQueries({ queryKey: queryKeys.questRun.history() });
    },
  });
}

export function useSubmitAnswer() {
  const queryClient = useQueryClient();
  return useMutation<QuestRunAnswer, ApiError, { answer: string }>({
    mutationFn: ({ answer }) => questRunService.submitAnswer({ answer }),
    onSuccess: (result) => {
      queryClient.setQueryData(queryKeys.questRun.active(), result.progress);
      if (result.progress.status !== "in_progress") {
        queryClient.invalidateQueries({
          queryKey: queryKeys.questRun.history(),
        });
        queryClient.invalidateQueries({ queryKey: queryKeys.auth.me() });
        queryClient.invalidateQueries({ queryKey: queryKeys.teams.me() });
      }
    },
  });
}

export function useAbandonQuestRun() {
  const queryClient = useQueryClient();
  return useMutation<QuestRunProgress, ApiError, void>({
    mutationFn: () => questRunService.abandon(),
    onSuccess: (progress) => {
      queryClient.setQueryData(queryKeys.questRun.active(), progress);
      queryClient.invalidateQueries({ queryKey: queryKeys.questRun.history() });
    },
  });
}

export function useQuestRunHistory() {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  return useQuery<QuestRunHistoryItem[], ApiError>({
    queryKey: queryKeys.questRun.history(),
    queryFn: () => questRunService.history(),
    enabled: isAuthenticated,
  });
}

export function useCompletedQuestIds(): Set<number> {
  const history = useQuestRunHistory();
  const items = history.data ?? [];
  const ids = new Set<number>();
  for (const item of items) {
    if (item.status === "completed") {
      ids.add(item.quest_id);
    }
  }
  return ids;
}
