// Backend doesn't currently accept a run mode (only `quest_id`), but we still
// want to remember the user's intent (solo vs team) for UI display until the
// run finishes. Stored client-side, keyed by run_id.

export type QuestMode = "solo" | "team";

const STORAGE_KEY = "city-quest:run-modes";

type StorageShape = Record<string, QuestMode>;

function read(): StorageShape {
  if (typeof window === "undefined") return {};
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    return raw ? (JSON.parse(raw) as StorageShape) : {};
  } catch {
    return {};
  }
}

function write(value: StorageShape) {
  if (typeof window === "undefined") return;
  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(value));
}

export const runModeStorage = {
  set(runId: number, mode: QuestMode) {
    const all = read();
    all[String(runId)] = mode;
    write(all);
  },
  get(runId: number): QuestMode | null {
    return read()[String(runId)] ?? null;
  },
  clear(runId: number) {
    const all = read();
    delete all[String(runId)];
    write(all);
  },
};
