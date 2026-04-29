"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import type { Map as MapLibreMap, Marker as MapLibreMarker } from "maplibre-gl";

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

export type MapMarkerData = {
  id: string | number;
  lat: number;
  lng: number;
  popupHtml?: string;
  variant?: "default" | "active" | "passed";
  /** Optional short label rendered inside the marker (e.g. checkpoint index). */
  label?: string;
};

export type MapPickerMarker = { lat: number; lng: number };

export type MapUserLocation = {
  lat: number;
  lng: number;
  accuracy?: number;
};

export type MapViewProps = {
  className?: string;
  center: { lat: number; lng: number };
  zoom?: number;
  markers?: MapMarkerData[];
  onMarkerClick?: (markerId: string | number) => void;
  onMapClick?: (coords: { lat: number; lng: number }) => void;
  /** When provided, exactly one draggable marker is rendered for picking a point. */
  pickerMarker?: MapPickerMarker | null;
  onPickerMove?: (coords: { lat: number; lng: number }) => void;
  /** Pulse-style marker for the current user position. */
  userLocation?: MapUserLocation | null;
  /** Force the map to recompute its size — useful inside dialogs. */
  resizeKey?: string | number;
};

const VARIANT_COLORS: Record<NonNullable<MapMarkerData["variant"]>, string> = {
  default: "var(--md-sys-color-primary, #1e6586)",
  active: "var(--md-sys-color-tertiary, #615a7c)",
  passed: "var(--md-sys-color-outline, #71787e)",
};

function buildMarkerEl(
  variant: NonNullable<MapMarkerData["variant"]>,
  label?: string,
): HTMLDivElement {
  const el = document.createElement("div");
  el.className = "city-quest-map-marker";
  const size = label ? 26 : 20;
  el.style.width = `${size}px`;
  el.style.height = `${size}px`;
  el.style.borderRadius = "9999px";
  el.style.border = "2px solid white";
  el.style.boxShadow = "0 2px 6px rgba(0,0,0,0.25)";
  el.style.background = VARIANT_COLORS[variant];
  el.style.cursor = "pointer";
  if (label) {
    el.style.display = "flex";
    el.style.alignItems = "center";
    el.style.justifyContent = "center";
    el.style.color = "white";
    el.style.fontWeight = "600";
    el.style.fontSize = "12px";
    el.textContent = label;
  }
  return el;
}

function buildPickerEl(): HTMLDivElement {
  const el = document.createElement("div");
  el.style.width = "26px";
  el.style.height = "26px";
  el.style.borderRadius = "9999px";
  el.style.border = "3px solid white";
  el.style.boxShadow = "0 4px 12px rgba(0,0,0,0.3)";
  el.style.background = "var(--md-sys-color-error, #ba1a1a)";
  el.style.cursor = "grab";
  return el;
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

export function MapView({
  className,
  center,
  zoom = 13,
  markers,
  onMarkerClick,
  onMapClick,
  pickerMarker,
  onPickerMove,
  userLocation,
  resizeKey,
}: MapViewProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const mapRef = useRef<MapLibreMap | null>(null);
  const markersRef = useRef<MapLibreMarker[]>([]);
  const pickerRef = useRef<MapLibreMarker | null>(null);
  const userMarkerRef = useRef<MapLibreMarker | null>(null);
  const [mapReady, setMapReady] = useState(false);

  // Keep the latest callbacks in refs so the init effect runs once.
  const onMarkerClickRef = useRef(onMarkerClick);
  const onMapClickRef = useRef(onMapClick);
  const onPickerMoveRef = useRef(onPickerMove);
  useEffect(() => {
    onMarkerClickRef.current = onMarkerClick;
    onMapClickRef.current = onMapClick;
    onPickerMoveRef.current = onPickerMove;
  });

  // Stable signature so the marker effect doesn't re-fire on each render.
  const markerKey = useMemo(
    () =>
      (markers ?? [])
        .map(
          (m) =>
            `${m.id}:${m.lat.toFixed(5)}:${m.lng.toFixed(5)}:${m.variant ?? "default"}:${m.popupHtml ?? ""}`,
        )
        .join("|"),
    [markers],
  );

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

      map.on("click", (event) => {
        onMapClickRef.current?.({
          lat: event.lngLat.lat,
          lng: event.lngLat.lng,
        });
      });

      mapRef.current = map;
      // Wait until the style finishes loading before signalling readiness, so
      // markers attach to a fully initialized map.
      const markReady = () => setMapReady(true);
      if (map.isStyleLoaded()) {
        markReady();
      } else {
        map.once("load", markReady);
      }
    })();

    return () => {
      disposed = true;
      setMapReady(false);
      mapRef.current?.remove();
      mapRef.current = null;
      markersRef.current = [];
      pickerRef.current = null;
      userMarkerRef.current = null;
    };
    // Init once. Updates flow through the other effects.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    const map = mapRef.current;
    if (!map || !mapReady) return;
    map.flyTo({
      center: [center.lng, center.lat],
      zoom,
      essential: true,
      duration: 0,
    });
  }, [center.lat, center.lng, zoom, mapReady]);

  useEffect(() => {
    if (!mapReady) return;
    let cancelled = false;

    (async () => {
      const map = mapRef.current;
      if (!map) return;
      const maplibre = await import("maplibre-gl");
      if (cancelled) return;

      for (const marker of markersRef.current) {
        marker.remove();
      }
      markersRef.current = [];

      for (const data of markers ?? []) {
        const el = buildMarkerEl(data.variant ?? "default", data.label);
        const marker = new maplibre.Marker({ element: el })
          .setLngLat([data.lng, data.lat])
          .addTo(map);
        if (data.popupHtml) {
          marker.setPopup(
            new maplibre.Popup({ offset: 16, closeButton: false }).setHTML(
              data.popupHtml,
            ),
          );
        }
        el.addEventListener("click", (event) => {
          event.stopPropagation();
          onMarkerClickRef.current?.(data.id);
        });
        markersRef.current.push(marker);
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [markerKey, markers, mapReady]);

  useEffect(() => {
    if (!mapReady) return;
    let cancelled = false;

    (async () => {
      const map = mapRef.current;
      if (!map) return;
      const maplibre = await import("maplibre-gl");
      if (cancelled) return;

      if (!pickerMarker) {
        pickerRef.current?.remove();
        pickerRef.current = null;
        return;
      }

      if (!pickerRef.current) {
        const marker = new maplibre.Marker({
          element: buildPickerEl(),
          draggable: true,
        })
          .setLngLat([pickerMarker.lng, pickerMarker.lat])
          .addTo(map);
        marker.on("dragend", () => {
          const ll = marker.getLngLat();
          onPickerMoveRef.current?.({ lat: ll.lat, lng: ll.lng });
        });
        pickerRef.current = marker;
      } else {
        pickerRef.current.setLngLat([pickerMarker.lng, pickerMarker.lat]);
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [pickerMarker, mapReady]);

  useEffect(() => {
    if (!mapReady) return;
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
        const marker = new maplibre.Marker({ element: buildUserEl() })
          .setLngLat([userLocation.lng, userLocation.lat])
          .addTo(map);
        userMarkerRef.current = marker;
      } else {
        userMarkerRef.current.setLngLat([userLocation.lng, userLocation.lat]);
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [userLocation, mapReady]);

  // Force resize when the host dialog/section changes size.
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
