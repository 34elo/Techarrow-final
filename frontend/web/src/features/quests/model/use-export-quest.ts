"use client";

import { useMutation } from "@tanstack/react-query";

import { questsService } from "../api/quests-service";
import type { ApiError } from "@/shared/api";

type ExportQuestPayload = {
  id: number | string;
  filename?: string;
};

export function useExportQuest() {
  return useMutation<void, ApiError, ExportQuestPayload>({
    mutationFn: async ({ id, filename }) => {
      const blob = await questsService.exportPdf(id);
      const url = URL.createObjectURL(blob);
      const link = document.createElement("a");
      link.href = url;
      link.download = filename ?? `quest-${id}.pdf`;
      document.body.appendChild(link);
      link.click();
      link.remove();
      URL.revokeObjectURL(url);
    },
  });
}
