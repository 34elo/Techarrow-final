"use client";

import { useEffect, useSyncExternalStore } from "react";
import { useRouter } from "next/navigation";
import type { ReactNode } from "react";

import { useAuthStore } from "@/shared/store/auth-store";

type GuestGuardProps = {
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

export function GuestGuard({ children }: GuestGuardProps) {
  const router = useRouter();
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const hasHydrated = usePersistHydrated();

  useEffect(() => {
    if (!hasHydrated) return;
    if (isAuthenticated) {
      router.replace("/quests");
    }
  }, [hasHydrated, isAuthenticated, router]);

  if (!hasHydrated || isAuthenticated) return null;

  return <>{children}</>;
}
