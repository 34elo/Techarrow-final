// Drafts that the user fills in while creating a quest. They map 1:1 to the
// `points` payload accepted by `POST /api/quests` (multipart `points` JSON).

export type CheckpointDraft = {
  title: string;
  task: string;
  correct_answer: string;
  latitude: number;
  longitude: number;
  hint?: string | null;
  point_rules?: string | null;
};
