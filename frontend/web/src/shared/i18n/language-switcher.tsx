"use client";

import { Languages } from "lucide-react";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { locales } from "@/shared/i18n/translations";
import { Button } from "@/shared/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/shared/ui/dropdown-menu";

export function LanguageToggle() {
  const { locale, setLocale, t } = useTranslations();

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button
          type="button"
          variant="outline"
          size="icon-sm"
          aria-label="Select language"
          title="Select language"
        >
          <Languages className="size-4" />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        {locales.map((value) => (
          <DropdownMenuItem key={value} onClick={() => setLocale(value)}>
            {t(`language.${value}`)}
            {locale === value ? " •" : ""}
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
