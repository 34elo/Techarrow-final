"use client";

import { create } from "zustand";
import { persist } from "zustand/middleware";

import type { AuthUser } from "@/entities/user";
import { refreshTokenStorage } from "@/shared/lib/refresh-token-storage";

type AuthTokens = {
  accessToken: string;
  refreshToken: string;
};

type AuthState = {
  user: AuthUser | null;
  accessToken: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
  setAuth: (data: { user: AuthUser; tokens: AuthTokens }) => void;
  setTokens: (tokens: AuthTokens) => void;
  setUser: (user: AuthUser | null) => void;
  clearAuth: () => void;
};

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      refreshToken: null,
      isAuthenticated: false,
      setAuth: ({ user, tokens }) => {
        // Defensive guard: only regular users belong in the web store. The
        // login mutation already enforces this — protect future call sites.
        if (user.role !== "user") {
          refreshTokenStorage.remove();
          set({
            user: null,
            accessToken: null,
            refreshToken: null,
            isAuthenticated: false,
          });
          return;
        }
        refreshTokenStorage.set(tokens.refreshToken);
        set({
          user,
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
          isAuthenticated: true,
        });
      },
      setTokens: (tokens) => {
        refreshTokenStorage.set(tokens.refreshToken);
        set({
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        });
      },
      setUser: (user) => {
        // If the backend ever returns a non-user on /me, log out.
        if (user && user.role !== "user") {
          refreshTokenStorage.remove();
          set({
            user: null,
            accessToken: null,
            refreshToken: null,
            isAuthenticated: false,
          });
          return;
        }
        set({ user });
      },
      clearAuth: () => {
        refreshTokenStorage.remove();
        set({
          user: null,
          accessToken: null,
          refreshToken: null,
          isAuthenticated: false,
        });
      },
    }),
    {
      name: "auth",
      partialize: (state) => ({
        user: state.user,
        accessToken: state.accessToken,
        isAuthenticated: state.isAuthenticated,
      }),
      merge: (persistedState, currentState) => {
        const p = (persistedState ?? {}) as Partial<AuthState>;
        const fromDedicated = refreshTokenStorage.get();
        const fromLegacyPersist =
          typeof p.refreshToken === "string" ? p.refreshToken : null;
        const refreshToken = fromDedicated ?? fromLegacyPersist ?? null;
        if (refreshToken && !refreshTokenStorage.get()) {
          refreshTokenStorage.set(refreshToken);
        }
        // Drop any persisted user that isn't a regular user (defense against
        // stale state from older builds that shared the `auth` key with /admin).
        const safeUser = p.user && p.user.role === "user" ? p.user : null;
        const safeAuthenticated = Boolean(safeUser) && Boolean(p.accessToken);
        return {
          ...currentState,
          ...p,
          user: safeUser,
          isAuthenticated: safeAuthenticated,
          refreshToken,
        };
      },
    },
  ),
);
