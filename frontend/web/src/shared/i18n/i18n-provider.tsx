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
import { isPluralForms, selectPluralForm } from "./plural";

type I18nContextValue = {
  locale: Locale;
  setLocale: (nextLocale: Locale) => void;
  t: (key: string, params?: Record<string, string | number>) => string;
};

const I18nContext = createContext<I18nContextValue | null>(null);

function pickValue(locale: Locale, key: string): unknown {
  return key.split(".").reduce<unknown>((acc, segment) => {
    if (typeof acc !== "object" || !acc || !(segment in acc)) {
      return undefined;
    }
    return (acc as Record<string, unknown>)[segment];
  }, translations[locale]);
}

function resolveTranslation(
  locale: Locale,
  key: string,
  count: number | undefined,
): string {
  const value = pickValue(locale, key);
  if (typeof value === "string") return value;
  if (typeof count === "number" && isPluralForms(value)) {
    return selectPluralForm(value, count, locale) ?? key;
  }
  return key;
}

function interpolate(
  template: string,
  params?: Record<string, string | number>,
): string {
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

function readPersistedLocale(): Locale {
  if (typeof window === "undefined") return defaultLocale;
  const saved = window.localStorage.getItem("locale");
  return locales.includes(saved as Locale) ? (saved as Locale) : defaultLocale;
}

export function I18nProvider({ children }: I18nProviderProps) {
  // SSR and first client render must agree, so start from defaultLocale and
  // swap to the persisted value after mount.
  const [locale, setLocaleState] = useState<Locale>(defaultLocale);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setLocaleState(readPersistedLocale());
  }, []);

  const value = useMemo<I18nContextValue>(
    () => ({
      locale,
      setLocale: (next) => {
        setLocaleState(next);
        if (typeof window !== "undefined") {
          window.localStorage.setItem("locale", next);
        }
      },
      t: (key, params) => {
        const count =
          typeof params?.count === "number" ? params.count : undefined;
        return interpolate(resolveTranslation(locale, key, count), params);
      },
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
