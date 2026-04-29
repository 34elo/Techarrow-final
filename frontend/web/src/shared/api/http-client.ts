import axios, {
  AxiosError,
  type AxiosInstance,
  type InternalAxiosRequestConfig,
} from "axios";

import { env } from "@/shared/config/env";

export type ApiErrorPayload = {
  detail?: string | { msg?: string }[];
  message?: string;
  errors?: Record<string, string[]>;
};

export class ApiError extends Error {
  status: number;
  payload?: ApiErrorPayload;

  constructor(message: string, status: number, payload?: ApiErrorPayload) {
    super(message);
    this.name = "ApiError";
    this.status = status;
    this.payload = payload;
  }
}

type AuthHandlers = {
  getAccessToken: () => string | null;
  getRefreshToken: () => string | null;
  onTokensRefreshed: (tokens: {
    accessToken: string;
    refreshToken: string;
  }) => void;
  onUnauthorized: () => void;
};

let handlers: AuthHandlers | null = null;

export function configureAuth(next: AuthHandlers) {
  handlers = next;
}

export const httpClient: AxiosInstance = axios.create({
  baseURL: env.apiBaseUrl,
  headers: {
    "Content-Type": "application/json",
  },
  paramsSerializer: {
    indexes: null,
  },
});

httpClient.interceptors.request.use((config) => {
  const token = handlers?.getAccessToken();
  if (token) {
    config.headers.set("Authorization", `Bearer ${token}`);
  }
  return config;
});

type RetryableRequestConfig = InternalAxiosRequestConfig & {
  _retried?: boolean;
};

let refreshPromise: Promise<string> | null = null;

async function refreshAccessToken(): Promise<string> {
  if (!handlers) throw new Error("Auth handlers not configured");
  const refreshToken = handlers.getRefreshToken();
  if (!refreshToken) throw new Error("No refresh token");

  const { data } = await axios.post<{
    access_token: string;
    refresh_token: string;
  }>(
    `${env.apiBaseUrl}/api/auth/refresh`,
    { refresh_token: refreshToken },
    { headers: { "Content-Type": "application/json" } },
  );

  handlers.onTokensRefreshed({
    accessToken: data.access_token,
    refreshToken: data.refresh_token,
  });
  return data.access_token;
}

httpClient.interceptors.response.use(
  (response) => response,
  async (error: AxiosError<ApiErrorPayload>) => {
    const originalRequest = error.config as RetryableRequestConfig | undefined;
    const status = error.response?.status;

    const isRefreshCall = originalRequest?.url?.includes("/auth/refresh");
    const isAuthCall =
      originalRequest?.url?.includes("/auth/login") ||
      originalRequest?.url?.includes("/auth/register") ||
      originalRequest?.url?.includes("/auth/logout");

    if (
      status === 401 &&
      originalRequest &&
      !originalRequest._retried &&
      !isRefreshCall &&
      !isAuthCall &&
      handlers?.getRefreshToken()
    ) {
      originalRequest._retried = true;
      try {
        refreshPromise =
          refreshPromise ??
          refreshAccessToken().finally(() => {
            refreshPromise = null;
          });
        const accessToken = await refreshPromise;
        originalRequest.headers.set("Authorization", `Bearer ${accessToken}`);
        return httpClient(originalRequest);
      } catch {
        handlers?.onUnauthorized();
        return Promise.reject(toApiError(error));
      }
    }

    if (status === 401 && !isAuthCall) {
      handlers?.onUnauthorized();
    }

    return Promise.reject(toApiError(error));
  },
);

export function toApiError(error: unknown): ApiError {
  if (error instanceof ApiError) {
    return error;
  }

  if (axios.isAxiosError<ApiErrorPayload>(error)) {
    const status = error.response?.status ?? 0;
    const payload = error.response?.data;
    const detail = payload?.detail;
    const detailMessage =
      typeof detail === "string"
        ? detail
        : Array.isArray(detail)
          ? detail
              .map((entry) => entry?.msg)
              .filter(Boolean)
              .join("; ")
          : undefined;
    const message = detailMessage || payload?.message || error.message;
    return new ApiError(message, status, payload);
  }

  if (error instanceof Error) {
    return new ApiError(error.message, 0);
  }

  return new ApiError("Unknown error", 0);
}
