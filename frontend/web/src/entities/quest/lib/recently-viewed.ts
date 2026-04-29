"use client";

import { useSyncExternalStore } from "react";

import type { Quest } from "../model/types";

const STORAGE_KEY = "quests/recently-viewed";
const UPDATE_EVENT = "quests:recently-viewed-updated";
const MAX_ENTRIES = 20;

export type RecentlyViewedQuest = Quest & { viewedAt: number };

function readEntries(): RecentlyViewedQuest[] {
  if (typeof window === "undefined") return EMPTY;
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return EMPTY;
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return EMPTY;
    return parsed.filter(
      (entry) => entry && typeof entry === "object" && "id" in entry,
    ) as RecentlyViewedQuest[];
  } catch {
    return EMPTY;
  }
}

function toSnapshot(quest: Quest): Quest {
  return {
    id: quest.id,
    title: quest.title,
    description: quest.description,
    location: quest.location,
    difficulty: quest.difficulty,
    duration_minutes: quest.duration_minutes,
    rules_and_warnings: quest.rules_and_warnings,
    image_file_id: quest.image_file_id,
    rejection_reason: quest.rejection_reason,
    status: quest.status,
    latitude: quest.latitude,
    longitude: quest.longitude,
    creator: {
      id: quest.creator.id,
      username: quest.creator.username,
      team_name: quest.creator.team_name ?? null,
    },
  };
}

export function pushRecentlyViewedQuest(quest: Quest): void {
  if (typeof window === "undefined") return;
  try {
    const rest = readEntries().filter((entry) => entry.id !== quest.id);
    rest.unshift({ ...toSnapshot(quest), viewedAt: Date.now() });
    window.localStorage.setItem(
      STORAGE_KEY,
      JSON.stringify(rest.slice(0, MAX_ENTRIES)),
    );
    window.dispatchEvent(new CustomEvent(UPDATE_EVENT));
  } catch {
    // ignore quota / serialization errors
  }
}

export function clearRecentlyViewedQuests(): void {
  if (typeof window === "undefined") return;
  try {
    window.localStorage.removeItem(STORAGE_KEY);
    window.dispatchEvent(new CustomEvent(UPDATE_EVENT));
  } catch {
    // ignore
  }
}

const EMPTY: RecentlyViewedQuest[] = [];

let cachedSnapshot: RecentlyViewedQuest[] = EMPTY;
let cachedRaw = "";

function getSnapshot(): RecentlyViewedQuest[] {
  if (typeof window === "undefined") return EMPTY;
  const raw = window.localStorage.getItem(STORAGE_KEY) ?? "";
  if (raw === cachedRaw) return cachedSnapshot;
  cachedRaw = raw;
  cachedSnapshot = readEntries();
  return cachedSnapshot;
}

function getServerSnapshot(): RecentlyViewedQuest[] {
  return EMPTY;
}

function subscribe(callback: () => void): () => void {
  if (typeof window === "undefined") return () => {};
  window.addEventListener(UPDATE_EVENT, callback);
  window.addEventListener("storage", callback);
  return () => {
    window.removeEventListener(UPDATE_EVENT, callback);
    window.removeEventListener("storage", callback);
  };
}

export function useRecentlyViewedQuests(): RecentlyViewedQuest[] {
  return useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot);
}
