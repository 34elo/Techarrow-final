"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { QueryClientProvider } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";

import { configureAuth } from "@/shared/api";
import { I18nProvider } from "@/shared/i18n/i18n-provider";
import { refreshTokenStorage } from "@/shared/lib/refresh-token-storage";
import { createQueryClient } from "@/shared/lib/react-query/query-client";
import { useAuthStore } from "@/shared/store/auth-store";
import { useUiStore } from "@/shared/store/ui-store";
import { Toaster } from "@/shared/ui/sonner";

type ProvidersProps = {
  children: React.ReactNode;
};

export function AppProviders({ children }: ProvidersProps) {
  const [queryClient] = useState(createQueryClient);
  const theme = useUiStore((state) => state.theme);
  const setTheme = useUiStore((state) => state.setTheme);
  const accessToken = useAuthStore((state) => state.accessToken);
  const router = useRouter();

  useEffect(() => {
    configureAuth({
      getAccessToken: () => useAuthStore.getState().accessToken,
      getRefreshToken: () =>
        refreshTokenStorage.get() ?? useAuthStore.getState().refreshToken,
      onTokensRefreshed: ({ accessToken, refreshToken }) => {
        useAuthStore.getState().setTokens({ accessToken, refreshToken });
      },
      onUnauthorized: () => {
        useAuthStore.getState().clearAuth();
        queryClient.clear();
        router.replace("/login");
      },
    });
  }, [queryClient, router]);

  useEffect(() => {
    console.log("Access token:", accessToken);
  }, [accessToken]);

  useEffect(() => {
    const savedTheme = window.localStorage.getItem("theme");

    if (savedTheme === "light" || savedTheme === "dark") {
      setTheme(savedTheme);
      return;
    }

    const prefersDark = window.matchMedia(
      "(prefers-color-scheme: dark)",
    ).matches;
    setTheme(prefersDark ? "dark" : "light");
  }, [setTheme]);

  useEffect(() => {
    const root = document.documentElement;
    root.classList.remove("light", "dark");
    root.classList.add(theme);
    window.localStorage.setItem("theme", theme);
  }, [theme]);

  return (
    <QueryClientProvider client={queryClient}>
      <I18nProvider>{children}</I18nProvider>
      <Toaster />
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
