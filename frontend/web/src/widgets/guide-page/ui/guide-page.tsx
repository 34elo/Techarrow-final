"use client";

import { GUIDE_SECTIONS, type GuideSection } from "@/entities/guide";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";

import { GuideBlock } from "./guide-block";

export function GuidePage() {
  const { t } = useTranslations();

  return (
    <div className="space-y-6">
      <header className="space-y-1">
        <h1 className="text-2xl font-semibold tracking-tight">
          {t("guide.title")}
        </h1>
        <p className="text-sm text-muted-foreground">
          {t("guide.description")}
        </p>
      </header>

      <div className="space-y-4">
        {GUIDE_SECTIONS.map((section) => (
          <GuideBlock
            key={section.id}
            icon={section.icon}
            title={t(`guide.${section.id}.title`)}
          >
            <SectionContent section={section} t={t} />
          </GuideBlock>
        ))}
      </div>
    </div>
  );
}

type Translate = ReturnType<typeof useTranslations>["t"];

function SectionContent({
  section,
  t,
}: {
  section: GuideSection;
  t: Translate;
}) {
  if (section.kind === "intro") {
    return (
      <p className="text-sm leading-relaxed text-muted-foreground">
        {t(`guide.${section.id}.body`)}
      </p>
    );
  }

  if (!section.rows?.length) return null;

  if (section.kind === "tips") {
    return (
      <ul className="grid gap-2 sm:grid-cols-2">
        {section.rows.map((row) => {
          const RowIcon = row.icon;
          return (
            <li
              key={row.key}
              className="flex items-start gap-3 rounded-2xl bg-secondary/50 px-3 py-2.5"
            >
              <RowIcon
                aria-hidden
                className="mt-0.5 size-4 shrink-0 text-primary"
              />
              <span className="text-sm leading-snug">
                {t(`guide.${section.id}.items.${row.key}`)}
              </span>
            </li>
          );
        })}
      </ul>
    );
  }

  return (
    <ul className="space-y-3">
      {section.rows.map((row) => {
        const RowIcon = row.icon;
        const baseKey = `guide.${section.id}.items.${row.key}`;
        const isList = section.kind === "list";

        return (
          <li key={row.key} className="flex items-start gap-3">
            <span
              aria-hidden
              className={cn(
                "flex size-7 shrink-0 items-center justify-center rounded-xl bg-muted text-muted-foreground",
              )}
            >
              <RowIcon className="size-4" />
            </span>
            <div className="min-w-0 flex-1">
              {isList ? (
                <>
                  <p className="text-sm font-medium leading-snug">
                    {t(`${baseKey}.title`)}
                  </p>
                  <p className="text-[13px] leading-snug text-muted-foreground">
                    {t(`${baseKey}.body`)}
                  </p>
                </>
              ) : (
                <p className="text-sm leading-snug">{t(baseKey)}</p>
              )}
            </div>
          </li>
        );
      })}
    </ul>
  );
}
