"use client";

import { useEffect, useMemo, useRef } from "react";
import type {
  GeoJSONSource,
  Map as MapLibreMap,
  Marker as MapLibreMarker,
  MapMouseEvent,
} from "maplibre-gl";

import { STATUS_COLORS, type QuestPersonalStatus } from "@/features/quests";
import { cn } from "@/shared/lib/classnames";

const OSM_RASTER_STYLE = {
  version: 8 as const,
  sources: {
    osm: {
      type: "raster" as const,
      tiles: [
        "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
        "https://b.tile.openstreetmap.org/{z}/{x}/{y}.png",
        "https://c.tile.openstreetmap.org/{z}/{x}/{y}.png",
      ],
      tileSize: 256,
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    },
  },
  layers: [
    {
      id: "osm",
      type: "raster" as const,
      source: "osm",
    },
  ],
};

const SOURCE_ID = "quests";
const CLUSTER_LAYER = "quests-cluster";
const CLUSTER_COUNT_LAYER = "quests-cluster-count";
const POINT_LAYER = "quests-unclustered";

const PIN_IMAGE_NAMES: Record<QuestPersonalStatus, string> = {
  completed: "quest-pin-completed",
  in_progress: "quest-pin-in-progress",
  none: "quest-pin-none",
};

function buildPinImageData(color: string, size = 56): ImageData | null {
  const canvas = document.createElement("canvas");
  canvas.width = size;
  canvas.height = size;
  const ctx = canvas.getContext("2d");
  if (!ctx) return null;

  const cx = size / 2;
  const cy = size / 2.4;
  const r = size * 0.32;

  // soft drop shadow
  ctx.beginPath();
  ctx.ellipse(cx, size - 6, r * 0.7, r * 0.18, 0, 0, Math.PI * 2);
  ctx.fillStyle = "rgba(0,0,0,0.18)";
  ctx.fill();

  // teardrop pin: circle + triangle
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.moveTo(cx - r * 0.55, cy + r * 0.7);
  ctx.lineTo(cx, size - 8);
  ctx.lineTo(cx + r * 0.55, cy + r * 0.7);
  ctx.closePath();
  ctx.fillStyle = color;
  ctx.fill();
  ctx.lineWidth = 3;
  ctx.strokeStyle = "#ffffff";
  ctx.stroke();

  // inner dot
  ctx.beginPath();
  ctx.arc(cx, cy, r * 0.34, 0, Math.PI * 2);
  ctx.fillStyle = "#ffffff";
  ctx.fill();

  return ctx.getImageData(0, 0, size, size);
}

async function ensurePinImages(map: MapLibreMap): Promise<void> {
  for (const status of Object.keys(STATUS_COLORS) as QuestPersonalStatus[]) {
    const name = PIN_IMAGE_NAMES[status];
    if (map.hasImage(name)) continue;
    const data = buildPinImageData(STATUS_COLORS[status]);
    if (data) {
      map.addImage(name, data, { pixelRatio: 2 });
    }
  }
}

export type ClusterQuestPoint = {
  id: number;
  title: string;
  latitude: number;
  longitude: number;
  status: QuestPersonalStatus;
};

export type QuestsClusterMapProps = {
  className?: string;
  center: { lat: number; lng: number };
  zoom?: number;
  points: ClusterQuestPoint[];
  userLocation?: { lat: number; lng: number } | null;
  onSelect?: (questId: number) => void;
  /** Bumps when the host (e.g. dialog) resizes so the map recalculates. */
  resizeKey?: string | number;
};

function pointsToFeatureCollection(
  points: ClusterQuestPoint[],
): GeoJSON.FeatureCollection<GeoJSON.Point> {
  return {
    type: "FeatureCollection",
    features: points.map((p) => ({
      type: "Feature",
      properties: {
        id: p.id,
        title: p.title,
        status: p.status,
      },
      geometry: {
        type: "Point",
        coordinates: [p.longitude, p.latitude],
      },
    })),
  };
}

function buildUserEl(): HTMLDivElement {
  const wrapper = document.createElement("div");
  wrapper.className = "city-quest-user-marker";
  wrapper.style.position = "relative";
  wrapper.style.width = "20px";
  wrapper.style.height = "20px";

  const ring = document.createElement("div");
  ring.style.position = "absolute";
  ring.style.inset = "-8px";
  ring.style.borderRadius = "9999px";
  ring.style.background =
    "radial-gradient(rgba(30,101,134,0.35), rgba(30,101,134,0))";
  ring.style.animation = "city-quest-pulse 1.6s ease-out infinite";

  const dot = document.createElement("div");
  dot.style.position = "absolute";
  dot.style.inset = "0";
  dot.style.borderRadius = "9999px";
  dot.style.background = "var(--md-sys-color-primary, #1e6586)";
  dot.style.border = "3px solid white";
  dot.style.boxShadow = "0 2px 6px rgba(0,0,0,0.25)";

  wrapper.appendChild(ring);
  wrapper.appendChild(dot);
  return wrapper;
}

export function QuestsClusterMap({
  className,
  center,
  zoom = 12,
  points,
  userLocation,
  onSelect,
  resizeKey,
}: QuestsClusterMapProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const mapRef = useRef<MapLibreMap | null>(null);
  const userMarkerRef = useRef<MapLibreMarker | null>(null);

  const onSelectRef = useRef(onSelect);
  useEffect(() => {
    onSelectRef.current = onSelect;
  });

  const data = useMemo(() => pointsToFeatureCollection(points), [points]);

  useEffect(() => {
    if (!containerRef.current) return;
    let disposed = false;

    (async () => {
      const maplibre = await import("maplibre-gl");
      if (disposed || !containerRef.current) return;

      const map = new maplibre.Map({
        container: containerRef.current,
        style: OSM_RASTER_STYLE,
        center: [center.lng, center.lat],
        zoom,
        attributionControl: { compact: true },
      });
      map.addControl(
        new maplibre.NavigationControl({ showCompass: false }),
        "top-right",
      );

      map.on("load", async () => {
        await ensurePinImages(map);

        map.addSource(SOURCE_ID, {
          type: "geojson",
          data,
          cluster: true,
          clusterRadius: 50,
          clusterMaxZoom: 14,
        });

        map.addLayer({
          id: CLUSTER_LAYER,
          type: "circle",
          source: SOURCE_ID,
          filter: ["has", "point_count"],
          paint: {
            "circle-color": STATUS_COLORS.none,
            "circle-radius": [
              "step",
              ["get", "point_count"],
              18,
              10,
              24,
              25,
              30,
            ],
            "circle-stroke-color": "#ffffff",
            "circle-stroke-width": 3,
            "circle-opacity": 0.95,
          },
        });

        map.addLayer({
          id: CLUSTER_COUNT_LAYER,
          type: "symbol",
          source: SOURCE_ID,
          filter: ["has", "point_count"],
          layout: {
            "text-field": ["get", "point_count_abbreviated"],
            "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
            "text-size": 13,
            "text-allow-overlap": true,
          },
          paint: {
            "text-color": "#ffffff",
          },
        });

        map.addLayer({
          id: POINT_LAYER,
          type: "symbol",
          source: SOURCE_ID,
          filter: ["!", ["has", "point_count"]],
          layout: {
            "icon-image": [
              "match",
              ["get", "status"],
              "completed",
              PIN_IMAGE_NAMES.completed,
              "in_progress",
              PIN_IMAGE_NAMES.in_progress,
              PIN_IMAGE_NAMES.none,
            ],
            "icon-anchor": "bottom",
            "icon-allow-overlap": true,
            "icon-size": 1,
          },
        });

        map.on("click", CLUSTER_LAYER, (event: MapMouseEvent) => {
          const feature = map.queryRenderedFeatures(event.point, {
            layers: [CLUSTER_LAYER],
          })[0];
          if (!feature) return;
          const clusterId = feature.properties?.cluster_id as number;
          const source = map.getSource(SOURCE_ID) as GeoJSONSource | undefined;
          if (!source) return;
          source.getClusterExpansionZoom(clusterId).then((nextZoom) => {
            const geom = feature.geometry as GeoJSON.Point;
            map.easeTo({
              center: geom.coordinates as [number, number],
              zoom: nextZoom,
            });
          });
        });

        map.on("click", POINT_LAYER, (event: MapMouseEvent) => {
          const feature = map.queryRenderedFeatures(event.point, {
            layers: [POINT_LAYER],
          })[0];
          const id = feature?.properties?.id;
          if (typeof id === "number") {
            onSelectRef.current?.(id);
          }
        });

        for (const layer of [CLUSTER_LAYER, POINT_LAYER]) {
          map.on("mouseenter", layer, () => {
            map.getCanvas().style.cursor = "pointer";
          });
          map.on("mouseleave", layer, () => {
            map.getCanvas().style.cursor = "";
          });
        }
      });

      mapRef.current = map;
    })();

    return () => {
      disposed = true;
      mapRef.current?.remove();
      mapRef.current = null;
      userMarkerRef.current = null;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    const map = mapRef.current;
    if (!map) return;
    if (!map.isStyleLoaded()) {
      const handler = () => updateSource();
      map.once("load", handler);
      return;
    }
    updateSource();

    function updateSource() {
      if (!map) return;
      const source = map.getSource(SOURCE_ID) as GeoJSONSource | undefined;
      if (source) source.setData(data);
    }
  }, [data]);

  useEffect(() => {
    const map = mapRef.current;
    if (!map) return;
    map.flyTo({
      center: [center.lng, center.lat],
      zoom,
      essential: true,
      duration: 0,
    });
  }, [center.lat, center.lng, zoom]);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      const map = mapRef.current;
      if (!map) return;
      const maplibre = await import("maplibre-gl");
      if (cancelled) return;

      if (!userLocation) {
        userMarkerRef.current?.remove();
        userMarkerRef.current = null;
        return;
      }
      if (!userMarkerRef.current) {
        userMarkerRef.current = new maplibre.Marker({ element: buildUserEl() })
          .setLngLat([userLocation.lng, userLocation.lat])
          .addTo(map);
      } else {
        userMarkerRef.current.setLngLat([userLocation.lng, userLocation.lat]);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [userLocation]);

  useEffect(() => {
    if (resizeKey === undefined) return;
    const map = mapRef.current;
    if (!map) return;
    const handle = window.requestAnimationFrame(() => map.resize());
    return () => window.cancelAnimationFrame(handle);
  }, [resizeKey]);

  return (
    <div
      ref={containerRef}
      className={cn(
        "relative h-full w-full overflow-hidden rounded-2xl border border-border",
        className,
      )}
    />
  );
}
