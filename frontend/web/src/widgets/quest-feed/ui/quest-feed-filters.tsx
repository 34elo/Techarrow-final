"use client";

import { useEffect, useState } from "react";
import { Crosshair, SlidersHorizontal, X } from "lucide-react";
import { toast } from "sonner";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { useGeolocation } from "@/shared/lib/geolocation";
import { cn } from "@/shared/lib/classnames";
import { Button } from "@/shared/ui/button";
import { Input } from "@/shared/ui/input";
import { Label } from "@/shared/ui/label";
import { Popover, PopoverContent, PopoverTrigger } from "@/shared/ui/popover";

export type QuestFeedFilterValues = {
  city: string;
  difficulties: number[];
  nearLat: number | null;
  nearLng: number | null;
};

export const EMPTY_FEED_FILTERS: QuestFeedFilterValues = {
  city: "",
  difficulties: [],
  nearLat: null,
  nearLng: null,
};

type DifficultyGroupId = "easy" | "medium" | "pro";

type DifficultyGroup = {
  id: DifficultyGroupId;
  values: number[];
  labelKey: string;
};

const DIFFICULTY_GROUPS: DifficultyGroup[] = [
  { id: "easy", values: [1, 2], labelKey: "filters.difficultyEasy" },
  { id: "medium", values: [3], labelKey: "filters.difficultyMedium" },
  { id: "pro", values: [4, 5], labelKey: "filters.difficultyPro" },
];

function isGroupActive(group: DifficultyGroup, selected: number[]): boolean {
  return group.values.every((value) => selected.includes(value));
}

function countActiveGroups(selected: number[]): number {
  return DIFFICULTY_GROUPS.filter((group) => isGroupActive(group, selected))
    .length;
}

export function countActiveFilters(value: QuestFeedFilterValues): number {
  return (
    (value.city.trim() ? 1 : 0) +
    countActiveGroups(value.difficulties) +
    (value.nearLat !== null ? 1 : 0)
  );
}

type QuestFeedFiltersProps = {
  value: QuestFeedFilterValues;
  onChange: (next: QuestFeedFilterValues) => void;
};

export function QuestFeedFilters({ value, onChange }: QuestFeedFiltersProps) {
  const { t } = useTranslations();
  const geolocation = useGeolocation();
  const [open, setOpen] = useState(false);

  useEffect(() => {
    if (geolocation.error) {
      toast.error(t("geolocation.error"), {
        description: t(geolocation.error),
      });
    }
  }, [geolocation.error, t]);

  useEffect(() => {
    if (geolocation.coords && value.nearLat === null) {
      onChange({
        ...value,
        nearLat: geolocation.coords.lat,
        nearLng: geolocation.coords.lng,
      });
      toast.success(t("filters.nearMeApplied"));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [geolocation.coords]);

  const handleToggleDifficultyGroup = (group: DifficultyGroup) => {
    const active = isGroupActive(group, value.difficulties);
    const next = active
      ? value.difficulties.filter((d) => !group.values.includes(d))
      : Array.from(new Set([...value.difficulties, ...group.values])).sort(
          (a, b) => a - b,
        );
    onChange({ ...value, difficulties: next });
  };

  const handleNearMe = () => {
    if (!geolocation.isSupported) {
      toast.error(t("geolocation.unsupported"));
      return;
    }
    geolocation.request();
  };

  const handleClearNear = () => {
    onChange({ ...value, nearLat: null, nearLng: null });
  };

  const handleReset = () => {
    onChange(EMPTY_FEED_FILTERS);
  };

  const activeCount = countActiveFilters(value);
  const nearActive = value.nearLat !== null;

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button variant="outline">
          <SlidersHorizontal />
          {t("filters.title")}
          {activeCount > 0 ? (
            <span className="ml-1 inline-flex h-5 min-w-5 items-center justify-center rounded-full bg-primary px-1.5 text-[11px] font-semibold text-primary-foreground">
              {activeCount}
            </span>
          ) : null}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-[min(22rem,calc(100vw-2rem))] space-y-4">
        <div className="flex items-center justify-between">
          <p className="text-sm font-semibold">{t("filters.title")}</p>
          {activeCount > 0 ? (
            <Button
              type="button"
              variant="ghost"
              size="xs"
              onClick={handleReset}
            >
              <X />
              {t("filters.reset")}
            </Button>
          ) : null}
        </div>

        <div className="space-y-1.5">
          <Label htmlFor="filter-city">{t("filters.cityLabel")}</Label>
          <Input
            id="filter-city"
            value={value.city}
            placeholder={t("filters.cityPlaceholder")}
            onChange={(event) =>
              onChange({ ...value, city: event.target.value })
            }
          />
        </div>

        <div className="space-y-1.5">
          <Label>{t("filters.difficultyLabel")}</Label>
          <div className="flex flex-col gap-1.5">
            {DIFFICULTY_GROUPS.map((group) => {
              const active = isGroupActive(group, value.difficulties);
              return (
                <button
                  key={group.id}
                  type="button"
                  onClick={() => handleToggleDifficultyGroup(group)}
                  aria-pressed={active}
                  className={cn(
                    "rounded-xl border px-3 py-1.5 text-left text-xs font-medium transition-colors",
                    active
                      ? "border-primary bg-primary text-primary-foreground"
                      : "border-border bg-card text-card-foreground hover:border-primary/40",
                  )}
                >
                  {t(group.labelKey)}
                </button>
              );
            })}
          </div>
        </div>

        <div className="space-y-1.5">
          <Label>{t("filters.nearLabel")}</Label>
          <div className="flex flex-wrap items-center gap-2">
            <Button
              type="button"
              variant={nearActive ? "default" : "outline"}
              size="sm"
              onClick={handleNearMe}
              disabled={!geolocation.isSupported || geolocation.isLoading}
            >
              <Crosshair />
              {geolocation.isLoading
                ? t("geolocation.locating")
                : nearActive
                  ? t("filters.nearActive")
                  : t("filters.nearMe")}
            </Button>
            {nearActive ? (
              <Button
                type="button"
                variant="ghost"
                size="sm"
                onClick={handleClearNear}
              >
                <X />
                {t("filters.nearClear")}
              </Button>
            ) : null}
          </div>
        </div>
      </PopoverContent>
    </Popover>
  );
}
