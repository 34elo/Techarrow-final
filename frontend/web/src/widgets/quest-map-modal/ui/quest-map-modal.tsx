"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { Crosshair } from "lucide-react";
import { toast } from "sonner";

import {
  STATUS_COLORS,
  useQuestStatuses,
  useQuestsForMap,
  type QuestPersonalStatus,
} from "@/features/quests";
import { getDefaultMapCenter } from "@/entities/quest";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { useGeolocation } from "@/shared/lib/geolocation";
import { Button } from "@/shared/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/shared/ui/dialog";
import { Skeleton } from "@/shared/ui/skeleton";

import { QuestsClusterMap, type ClusterQuestPoint } from "./quests-cluster-map";

type QuestMapModalProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
};

export function QuestMapModal({ open, onOpenChange }: QuestMapModalProps) {
  const { t } = useTranslations();
  const router = useRouter();
  const { items, isLoading, isError, error } = useQuestsForMap({
    enabled: open,
  });
  const statuses = useQuestStatuses();
  const geolocation = useGeolocation();
  const [followUser, setFollowUser] = useState(false);

  const points = useMemo<ClusterQuestPoint[]>(
    () =>
      items
        .filter(
          (q) => Number.isFinite(q.latitude) && Number.isFinite(q.longitude),
        )
        .map((q) => ({
          id: q.id,
          title: q.title,
          latitude: q.latitude,
          longitude: q.longitude,
          status: statuses.get(q.id) ?? "none",
        })),
    [items, statuses],
  );

  const fallbackCenter = useMemo(() => {
    if (points.length === 0) return getDefaultMapCenter();
    const sumLat = points.reduce((acc, p) => acc + p.latitude, 0);
    const sumLng = points.reduce((acc, p) => acc + p.longitude, 0);
    return { lat: sumLat / points.length, lng: sumLng / points.length };
  }, [points]);

  const center =
    followUser && geolocation.coords
      ? { lat: geolocation.coords.lat, lng: geolocation.coords.lng }
      : fallbackCenter;

  useEffect(() => {
    if (!open) setFollowUser(false);
  }, [open]);

  useEffect(() => {
    if (geolocation.error) {
      toast.error(t("geolocation.error"), {
        description: t(geolocation.error),
      });
    }
  }, [geolocation.error, t]);

  const handleLocate = () => {
    setFollowUser(true);
    geolocation.request();
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-3xl">
        <DialogHeader>
          <DialogTitle>{t("quests.mapTitle")}</DialogTitle>
          <DialogDescription>{t("quests.mapDescription")}</DialogDescription>
        </DialogHeader>
        <div className="flex flex-wrap items-center justify-between gap-2">
          <StatusLegend />
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={handleLocate}
            disabled={!geolocation.isSupported || geolocation.isLoading}
          >
            <Crosshair />
            {geolocation.isLoading
              ? t("geolocation.locating")
              : t("geolocation.locateMe")}
          </Button>
        </div>
        <div className="h-[60vh] min-h-[420px] w-full">
          {isLoading ? (
            <Skeleton className="h-full w-full" />
          ) : isError ? (
            <p className="rounded-2xl border border-destructive/30 bg-destructive/10 p-4 text-sm text-destructive">
              {error?.message || t("common.loadError")}
            </p>
          ) : (
            <QuestsClusterMap
              center={center}
              zoom={points.length > 0 ? 12 : 11}
              points={points}
              userLocation={geolocation.coords}
              onSelect={(id) => {
                onOpenChange(false);
                router.push(`/quests/${id}`);
              }}
              resizeKey={open ? "open" : "closed"}
            />
          )}
        </div>
        {!isLoading && !isError && points.length === 0 ? (
          <p className="text-sm text-muted-foreground">
            {t("quests.mapEmpty")}
          </p>
        ) : null}
      </DialogContent>
    </Dialog>
  );
}

function StatusLegend() {
  const { t } = useTranslations();
  const items: Array<{ key: QuestPersonalStatus; label: string }> = [
    { key: "completed", label: t("quests.statusCompleted") },
    { key: "in_progress", label: t("quests.statusInProgress") },
    { key: "none", label: t("quests.statusNotStarted") },
  ];
  return (
    <div className="flex flex-wrap items-center gap-3 text-xs text-muted-foreground">
      <span className="font-medium">{t("quests.statusLegend")}:</span>
      {items.map((item) => (
        <span key={item.key} className="inline-flex items-center gap-1.5">
          <span
            aria-hidden
            className="inline-block size-2.5 rounded-full"
            style={{ backgroundColor: STATUS_COLORS[item.key] }}
          />
          {item.label}
        </span>
      ))}
    </div>
  );
}
