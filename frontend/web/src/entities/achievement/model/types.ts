import { env } from "@/shared/config/env";

export type AchievementResponse = {
  id: number;
  title: string;
  description: string;
  image_file_id: string | null;
};

export type UserAchievementResponse = AchievementResponse & {
  awarded_at: string;
};

export type Achievement = {
  id: number;
  title: string;
  description: string;
  imageFileId: string | null;
  unlocked: boolean;
  awardedAt: string | null;
};

export function getAchievementImageUrl(
  achievement: Pick<Achievement, "imageFileId">,
): string | null {
  if (!achievement.imageFileId) return null;
  return `${env.apiBaseUrl}/api/file/${encodeURIComponent(achievement.imageFileId)}`;
}

export function mergeAchievements(
  catalog: AchievementResponse[],
  earned: UserAchievementResponse[],
): Achievement[] {
  const earnedMap = new Map<number, UserAchievementResponse>();
  for (const item of earned) {
    earnedMap.set(item.id, item);
  }

  const merged: Achievement[] = catalog.map((item) => {
    const own = earnedMap.get(item.id);
    return {
      id: item.id,
      title: item.title,
      description: item.description,
      imageFileId: item.image_file_id,
      unlocked: Boolean(own),
      awardedAt: own?.awarded_at ?? null,
    };
  });

  // Surface achievements that are awarded but missing from the public catalog
  // — e.g. private/limited series — so we never hide them from the user.
  for (const own of earned) {
    if (catalog.some((item) => item.id === own.id)) continue;
    merged.push({
      id: own.id,
      title: own.title,
      description: own.description,
      imageFileId: own.image_file_id,
      unlocked: true,
      awardedAt: own.awarded_at,
    });
  }

  // Unlocked first, then by id
  merged.sort((a, b) => {
    if (a.unlocked !== b.unlocked) return a.unlocked ? -1 : 1;
    return a.id - b.id;
  });

  return merged;
}
