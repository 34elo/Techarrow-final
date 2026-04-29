"use client";

import { create } from "zustand";
import { persist } from "zustand/middleware";

import type { CheckpointDraft } from "@/entities/checkpoint";

import type { QuestFormValues } from "./quest-form-schema";

export type CheckpointDraftEntry = CheckpointDraft & { key: string };

export type QuestDraft = Partial<QuestFormValues> & {
  checkpoints: CheckpointDraftEntry[];
};

type QuestDraftState = {
  draft: QuestDraft;
  hasDraft: boolean;
  setFields: (fields: Partial<QuestFormValues>) => void;
  addCheckpoint: (cp: CheckpointDraft) => void;
  updateCheckpoint: (key: string, cp: CheckpointDraft) => void;
  removeCheckpoint: (key: string) => void;
  reset: () => void;
};

const EMPTY_DRAFT: QuestDraft = { checkpoints: [] };

function generateKey(): string {
  if (typeof crypto !== "undefined" && "randomUUID" in crypto) {
    return crypto.randomUUID();
  }
  return `cp-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
}

export const useQuestDraftStore = create<QuestDraftState>()(
  persist(
    (set) => ({
      draft: EMPTY_DRAFT,
      hasDraft: false,
      setFields: (fields) =>
        set((state) => ({
          draft: { ...state.draft, ...fields },
          hasDraft: true,
        })),
      addCheckpoint: (cp) =>
        set((state) => ({
          draft: {
            ...state.draft,
            checkpoints: [
              ...state.draft.checkpoints,
              { ...cp, key: generateKey() },
            ],
          },
          hasDraft: true,
        })),
      updateCheckpoint: (key, cp) =>
        set((state) => ({
          draft: {
            ...state.draft,
            checkpoints: state.draft.checkpoints.map((entry) =>
              entry.key === key ? { ...cp, key } : entry,
            ),
          },
          hasDraft: true,
        })),
      removeCheckpoint: (key) =>
        set((state) => ({
          draft: {
            ...state.draft,
            checkpoints: state.draft.checkpoints.filter((cp) => cp.key !== key),
          },
          hasDraft: true,
        })),
      reset: () => set({ draft: EMPTY_DRAFT, hasDraft: false }),
    }),
    {
      name: "quest-draft",
      partialize: (state) => ({ draft: state.draft, hasDraft: state.hasDraft }),
    },
  ),
);
