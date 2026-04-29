"use client";

import { useEffect, useState, type FormEvent } from "react";
import { X } from "lucide-react";
import { Controller, useForm } from "react-hook-form";
import { standardSchemaResolver } from "@hookform/resolvers/standard-schema";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { Button } from "@/shared/ui/button";
import { Input } from "@/shared/ui/input";
import { Label } from "@/shared/ui/label";
import { Textarea } from "@/shared/ui/textarea";
import { QUEST_DIFFICULTY_VALUES } from "@/entities/quest";

import { useQuestDraftStore } from "../model/quest-draft-store";
import {
  questFormSchema,
  type QuestFormValues,
} from "../model/quest-form-schema";

export type QuestFormSubmitPayload = QuestFormValues & {
  image: File | null;
};

type QuestFormProps = {
  defaultValues?: Partial<QuestFormValues>;
  isSubmitting?: boolean;
  submitLabel?: string;
  pendingLabel?: string;
  onSubmit: (payload: QuestFormSubmitPayload) => void | Promise<void>;
  /** Disable the submit button (e.g. when checkpoint requirement isn't met). */
  submitDisabled?: boolean;
  submitDisabledHint?: string;
  /** Persist field changes into the zustand draft store. */
  persistDraft?: boolean;
};

const DEFAULTS: QuestFormValues = {
  title: "",
  description: "",
  location: "",
  difficulty: 3,
  durationMinutes: 60,
  rulesAndWarnings: "",
};

export function QuestForm({
  defaultValues,
  isSubmitting,
  submitLabel,
  pendingLabel,
  onSubmit,
  submitDisabled,
  submitDisabledHint,
  persistDraft = false,
}: QuestFormProps) {
  const { t } = useTranslations();
  const [image, setImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);

  const setDraftFields = useQuestDraftStore((s) => s.setFields);

  const form = useForm<QuestFormValues>({
    resolver: standardSchemaResolver(questFormSchema),
    defaultValues: { ...DEFAULTS, ...defaultValues },
    mode: "onBlur",
  });

  // Auto-save form fields to the draft store as the user types.
  useEffect(() => {
    if (!persistDraft) return;
    const subscription = form.watch((values) => {
      setDraftFields(values as Partial<QuestFormValues>);
    });
    return () => subscription.unsubscribe();
  }, [form, persistDraft, setDraftFields]);

  // Build/cleanup an object URL for the preview.
  useEffect(() => {
    if (!image) {
      setImagePreview(null);
      return;
    }
    const url = URL.createObjectURL(image);
    setImagePreview(url);
    return () => URL.revokeObjectURL(url);
  }, [image]);

  const handleImageChange = (file: File | null) => {
    setImage(file);
  };

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    void form.handleSubmit((values) => {
      void onSubmit({ ...values, image });
    })();
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="title">{t("questCreate.titleLabel")}</Label>
        <Input
          id="title"
          placeholder={t("questCreate.titlePlaceholder")}
          {...form.register("title")}
          aria-invalid={Boolean(form.formState.errors.title)}
        />
        <FieldError message={form.formState.errors.title?.message} />
      </div>

      <div className="space-y-2">
        <Label htmlFor="description">{t("questCreate.descriptionLabel")}</Label>
        <Textarea
          id="description"
          rows={6}
          placeholder={t("questCreate.descriptionPlaceholder")}
          {...form.register("description")}
          aria-invalid={Boolean(form.formState.errors.description)}
        />
        <FieldError message={form.formState.errors.description?.message} />
      </div>

      <div className="space-y-2">
        <Label htmlFor="location">{t("questCreate.locationLabel")}</Label>
        <Input
          id="location"
          placeholder={t("questCreate.locationPlaceholder")}
          {...form.register("location")}
          aria-invalid={Boolean(form.formState.errors.location)}
        />
        <FieldError message={form.formState.errors.location?.message} />
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
        <div className="space-y-2">
          <Label id="difficulty-label">
            {t("questCreate.difficultyLabel")}
          </Label>
          <Controller
            control={form.control}
            name="difficulty"
            render={({ field }) => (
              <div
                role="radiogroup"
                aria-labelledby="difficulty-label"
                className="grid grid-cols-5 gap-1.5"
              >
                {QUEST_DIFFICULTY_VALUES.map((value) => {
                  const active = field.value === value;
                  return (
                    <button
                      key={value}
                      type="button"
                      role="radio"
                      aria-checked={active}
                      onClick={() => field.onChange(value)}
                      title={t(`questCreate.difficultyLevels.${value}`)}
                      className={cn(
                        "flex h-14 flex-col items-center justify-center gap-0.5 rounded-xl border px-1 text-center transition-colors",
                        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/40",
                        active
                          ? "border-primary bg-primary text-primary-foreground"
                          : "border-border bg-card text-card-foreground hover:border-primary/40",
                      )}
                    >
                      <span className="text-sm font-semibold leading-none">
                        {value}
                      </span>
                      <span
                        className={cn(
                          "truncate text-[9px] leading-tight",
                          active
                            ? "text-primary-foreground/85"
                            : "text-muted-foreground",
                        )}
                      >
                        {t(`questCreate.difficultyLevels.${value}`)}
                      </span>
                    </button>
                  );
                })}
              </div>
            )}
          />
          <FieldError message={form.formState.errors.difficulty?.message} />
        </div>

        <div className="space-y-2">
          <Label htmlFor="duration">{t("questCreate.durationLabel")}</Label>
          <Input
            id="duration"
            type="number"
            min={1}
            max={720}
            {...form.register("durationMinutes", { valueAsNumber: true })}
            aria-invalid={Boolean(form.formState.errors.durationMinutes)}
          />
          <FieldError
            message={form.formState.errors.durationMinutes?.message}
          />
        </div>
      </div>

      <div className="space-y-2">
        <Label htmlFor="rules">{t("questCreate.rulesLabel")}</Label>
        <Textarea
          id="rules"
          rows={3}
          placeholder={t("questCreate.rulesPlaceholder")}
          {...form.register("rulesAndWarnings")}
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="cover">{t("questCreate.coverLabel")}</Label>
        <Input
          id="cover"
          type="file"
          accept="image/*"
          onChange={(event) =>
            handleImageChange(event.target.files?.[0] ?? null)
          }
        />
        <p className="text-xs text-muted-foreground">
          {t("questCreate.coverHint")}
        </p>

        {imagePreview ? (
          <div className="relative mt-2 overflow-hidden rounded-xl border border-border bg-muted/30">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={imagePreview}
              alt={image?.name ?? ""}
              className="aspect-video w-full object-cover"
            />
            <Button
              type="button"
              variant="outline"
              size="icon-sm"
              className="absolute right-2 top-2 bg-background/80 backdrop-blur"
              aria-label={t("common.delete")}
              onClick={() => handleImageChange(null)}
            >
              <X />
            </Button>
            <p className="px-3 py-2 text-xs text-muted-foreground">
              {image?.name}
            </p>
          </div>
        ) : null}
      </div>

      <div className="space-y-2">
        <Button
          type="submit"
          disabled={isSubmitting || submitDisabled}
          className="w-full sm:w-auto"
          title={submitDisabled ? submitDisabledHint : undefined}
        >
          {isSubmitting
            ? (pendingLabel ?? t("questCreate.submitting"))
            : (submitLabel ?? t("questCreate.submit"))}
        </Button>
        {submitDisabled && submitDisabledHint ? (
          <p className="text-xs text-muted-foreground">{submitDisabledHint}</p>
        ) : null}
      </div>
    </form>
  );
}

function FieldError({ message }: { message?: string }) {
  const { t } = useTranslations();
  if (!message) return null;
  // Schema messages are i18n keys; fall back to the raw message if not found.
  const translated = t(message);
  return (
    <p className="text-xs text-destructive">
      {translated === message ? message : translated}
    </p>
  );
}
