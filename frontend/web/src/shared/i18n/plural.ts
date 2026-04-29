export type PluralKey = "zero" | "one" | "two" | "few" | "many" | "other";

export type PluralForms = Partial<Record<PluralKey, string>>;

/**
 * Resolves the CLDR plural category for `count` in the given locale via
 * `Intl.PluralRules`. Falls back to a binary EN-style rule if Intl is missing.
 */
export function pluralCategory(count: number, locale: string): PluralKey {
  try {
    return new Intl.PluralRules(locale).select(count) as PluralKey;
  } catch {
    return count === 1 ? "one" : "other";
  }
}

/**
 * Picks the right form from a forms object by plural category, with sensible
 * fallbacks: requested → other → one → first defined.
 */
export function selectPluralForm(
  forms: PluralForms,
  count: number,
  locale: string,
): string | undefined {
  const cat = pluralCategory(count, locale);
  return (
    forms[cat] ??
    forms.other ??
    forms.many ??
    forms.few ??
    forms.one ??
    Object.values(forms)[0]
  );
}

export function isPluralForms(value: unknown): value is PluralForms {
  if (!value || typeof value !== "object") return false;
  return Object.keys(value as Record<string, unknown>).every((key) =>
    ["zero", "one", "two", "few", "many", "other"].includes(key),
  );
}
