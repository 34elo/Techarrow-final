"use client";

import { useCallback, useEffect, useRef, useState } from "react";

export type GeoCoords = { lat: number; lng: number; accuracy?: number };

export type UseGeolocationOptions = {
  /** Watch user position continuously instead of one-shot. */
  watch?: boolean;
  /** Request automatically on mount. */
  auto?: boolean;
  enableHighAccuracy?: boolean;
  maximumAge?: number;
  timeout?: number;
};

export type GeolocationState = {
  coords: GeoCoords | null;
  error: string | null;
  isLoading: boolean;
  isSupported: boolean;
  /**
   * Trigger a one-shot (or watch, if `watch: true`) location resolution.
   * The optional `onSuccess` callback fires for every successful fix —
   * use it from event handlers to apply coords without an extra effect.
   */
  request: (onSuccess?: (coords: GeoCoords) => void) => void;
};

function readError(error: GeolocationPositionError): string {
  switch (error.code) {
    case error.PERMISSION_DENIED:
      return "geolocation.permissionDenied";
    case error.POSITION_UNAVAILABLE:
      return "geolocation.unavailable";
    case error.TIMEOUT:
      return "geolocation.timeout";
    default:
      return "geolocation.unknown";
  }
}

export function useGeolocation(
  options: UseGeolocationOptions = {},
): GeolocationState {
  const {
    watch = false,
    auto = false,
    enableHighAccuracy = true,
    maximumAge,
    timeout,
  } = options;

  const isSupported =
    typeof navigator !== "undefined" && "geolocation" in navigator;

  const [coords, setCoords] = useState<GeoCoords | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const watchIdRef = useRef<number | null>(null);

  const request = useCallback(
    (onSuccess?: (coords: GeoCoords) => void) => {
      if (!isSupported) {
        setError("geolocation.unsupported");
        return;
      }
      setIsLoading(true);
      setError(null);

      const handleSuccess = (pos: GeolocationPosition) => {
        const next: GeoCoords = {
          lat: pos.coords.latitude,
          lng: pos.coords.longitude,
          accuracy: pos.coords.accuracy,
        };
        setCoords(next);
        setIsLoading(false);
        onSuccess?.(next);
      };
      const handleError = (err: GeolocationPositionError) => {
        setError(readError(err));
        setIsLoading(false);
      };
      const opts: PositionOptions = {
        enableHighAccuracy,
        maximumAge,
        timeout,
      };

      if (watch) {
        if (watchIdRef.current !== null) {
          navigator.geolocation.clearWatch(watchIdRef.current);
        }
        watchIdRef.current = navigator.geolocation.watchPosition(
          handleSuccess,
          handleError,
          opts,
        );
      } else {
        navigator.geolocation.getCurrentPosition(
          handleSuccess,
          handleError,
          opts,
        );
      }
    },
    [isSupported, watch, enableHighAccuracy, maximumAge, timeout],
  );

  useEffect(() => {
    if (auto) {
      request();
    }
    return () => {
      if (watchIdRef.current !== null && isSupported) {
        navigator.geolocation.clearWatch(watchIdRef.current);
        watchIdRef.current = null;
      }
    };
  }, [auto, request, isSupported]);

  return { coords, error, isLoading, isSupported, request };
}
