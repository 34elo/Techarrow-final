"use client";

import { useEffect, useSyncExternalStore } from "react";
import { useRouter } from "next/navigation";
import type { ReactNode } from "react";

import { useAuthStore } from "@/shared/store/auth-store";

type AuthGuardProps = {
  children: ReactNode;
};

function usePersistHydrated(): boolean {
  return useSyncExternalStore(
    (onStoreChange) =>
      useAuthStore.persist?.onFinishHydration(() => {
        onStoreChange();
      }) ?? (() => {}),
    () => useAuthStore.persist?.hasHydrated() ?? true,
    () => false,
  );
}

export function AuthGuard({ children }: AuthGuardProps) {
  const router = useRouter();
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const role = useAuthStore((state) => state.user?.role ?? null);
  const clearAuth = useAuthStore((state) => state.clearAuth);
  const hasHydrated = usePersistHydrated();

  const isUser = role === "user";

  useEffect(() => {
    if (!hasHydrated) return;
    if (!isAuthenticated) {
      router.replace("/login");
      return;
    }
    // Hydrated session but the account is not a regular user — flush and bounce.
    if (!isUser) {
      clearAuth();
      router.replace("/access_denied");
    }
  }, [hasHydrated, isAuthenticated, isUser, clearAuth, router]);

  if (!hasHydrated || !isAuthenticated || !isUser) return null;

  return <>{children}</>;
}
