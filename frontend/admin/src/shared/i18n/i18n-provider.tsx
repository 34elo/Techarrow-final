"use client";

import {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";

import {
  defaultLocale,
  locales,
  type Locale,
  translations,
} from "./translations";

function isLocale(value: string | null): value is Locale {
  return value !== null && (locales as readonly string[]).includes(value);
}

type I18nContextValue = {
  locale: Locale;
  setLocale: (nextLocale: Locale) => void;
  t: (key: string, params?: Record<string, string | number>) => string;
};

const I18nContext = createContext<I18nContextValue | null>(null);

function resolveTranslation(locale: Locale, key: string): string {
  const value = key.split(".").reduce<unknown>((acc, segment) => {
    if (typeof acc !== "object" || !acc || !(segment in acc)) {
      return undefined;
    }
    return (acc as Record<string, unknown>)[segment];
  }, translations[locale]);

  return typeof value === "string" ? value : key;
}

function interpolate(
  template: string,
  params?: Record<string, string | number>,
) {
  if (!params) {
    return template;
  }

  return template.replace(/\{(\w+)\}/g, (_, token) =>
    String(params[token] ?? `{${token}}`),
  );
}

type I18nProviderProps = {
  children: ReactNode;
};

export function I18nProvider({ children }: I18nProviderProps) {
  const [locale, setLocale] = useState<Locale>(defaultLocale);

  useEffect(() => {
    const saved = window.localStorage.getItem("locale");
    if (isLocale(saved)) {
      setLocale(saved);
    }
  }, []);

  useEffect(() => {
    window.localStorage.setItem("locale", locale);
  }, [locale]);

  const value = useMemo<I18nContextValue>(
    () => ({
      locale,
      setLocale,
      t: (key, params) => interpolate(resolveTranslation(locale, key), params),
    }),
    [locale],
  );

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}

export function useTranslations() {
  const context = useContext(I18nContext);

  if (!context) {
    throw new Error("useTranslations must be used inside I18nProvider");
  }

  return context;
}
