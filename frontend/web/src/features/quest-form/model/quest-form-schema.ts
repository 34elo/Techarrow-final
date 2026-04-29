import { z } from "zod";

export const questFormSchema = z.object({
  title: z
    .string()
    .min(5, "questCreate.errors.titleMin")
    .max(255, "questCreate.errors.titleMax"),
  description: z
    .string()
    .min(30, "questCreate.errors.descriptionMin")
    .max(5000, "questCreate.errors.descriptionMax"),
  location: z
    .string()
    .min(1, "questCreate.errors.locationRequired")
    .max(255, "questCreate.errors.locationMax"),
  difficulty: z
    .number({ message: "questCreate.errors.difficultyRange" })
    .min(1, "questCreate.errors.difficultyRange")
    .max(5, "questCreate.errors.difficultyRange"),
  durationMinutes: z
    .number({ message: "questCreate.errors.durationMin" })
    .int()
    .min(1, "questCreate.errors.durationMin")
    .max(720, "questCreate.errors.durationMax"),
  rulesAndWarnings: z
    .string()
    .max(5000, "questCreate.errors.rulesMax")
    .optional()
    .or(z.literal("")),
});

export type QuestFormValues = z.infer<typeof questFormSchema>;
