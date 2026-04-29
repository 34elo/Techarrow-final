"use client";

import { useMemo } from "react";
import { Crosshair } from "lucide-react";

import {
  getDefaultMapCenter,
  questCoordinates,
  type QuestDetail,
} from "@/entities/quest";
import type { QuestRunProgress } from "@/entities/quest-run";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { useGeolocation } from "@/shared/lib/geolocation";
import { Button } from "@/shared/ui/button";
import { Card, CardContent } from "@/shared/ui/card";
import { MapView, type MapMarkerData } from "@/shared/ui/map";

type RunMapCardProps = {
  run: QuestRunProgress;
  quest: QuestDetail;
};

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

export function RunMapCard({ run, quest }: RunMapCardProps) {
  const { t } = useTranslations();
  const {
    coords: userCoords,
    request: requestLocation,
    isLoading: isLocating,
  } = useGeolocation({ watch: true, auto: false });

  const markers = useMemo<MapMarkerData[]>(() => {
    const items: MapMarkerData[] = run.previous_checkpoints.map(
      (cp, index) => ({
        id: `passed-${cp.id}`,
        lat: cp.latitude,
        lng: cp.longitude,
        variant: "passed",
        label: String(index + 1),
        popupHtml: `<div style="font-weight:600">${index + 1}. ${escapeHtml(cp.title)}</div>`,
      }),
    );

    if (run.current_checkpoint) {
      const stepNumber = run.current_step_index + 1;
      items.push({
        id: `current-${run.current_checkpoint.id}`,
        lat: run.current_checkpoint.latitude,
        lng: run.current_checkpoint.longitude,
        variant: "active",
        label: String(stepNumber),
        popupHtml: `<div style="font-weight:600">${stepNumber}. ${escapeHtml(run.current_checkpoint.title)}</div>`,
      });
    }

    return items;
  }, [
    run.previous_checkpoints,
    run.current_checkpoint,
    run.current_step_index,
  ]);

  const center = useMemo(() => {
    if (run.current_checkpoint) {
      return {
        lat: run.current_checkpoint.latitude,
        lng: run.current_checkpoint.longitude,
      };
    }
    if (
      typeof quest.latitude === "number" &&
      typeof quest.longitude === "number"
    ) {
      return questCoordinates(quest);
    }
    return getDefaultMapCenter();
  }, [run.current_checkpoint, quest]);

  return (
    <Card className="flex h-full flex-col border-0 shadow-md">
      <CardContent className="flex flex-1 flex-col gap-3 p-4">
        <div className="flex items-center justify-between gap-2">
          <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            {t("run.mapHeading")}
          </p>
          {!userCoords ? (
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => requestLocation()}
              disabled={isLocating}
            >
              <Crosshair />
              {isLocating
                ? t("geolocation.locating")
                : t("geolocation.locateMe")}
            </Button>
          ) : null}
        </div>
        <div className="min-h-72 flex-1 overflow-hidden rounded-2xl">
          <MapView
            center={center}
            zoom={15}
            markers={markers}
            userLocation={userCoords}
          />
        </div>
      </CardContent>
    </Card>
  );
}
