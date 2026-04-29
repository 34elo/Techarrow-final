"use client";

import { useState, type MouseEvent } from "react";
import { Check, Share2 } from "lucide-react";
import { toast } from "sonner";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { Button } from "@/shared/ui/button";

type ShareQuestButtonProps = {
  questId: number;
  questTitle: string;
  variant?: "outline" | "card";
  className?: string;
};

export function ShareQuestButton({
  questId,
  questTitle,
  variant = "outline",
  className,
}: ShareQuestButtonProps) {
  const { t } = useTranslations();
  const [copied, setCopied] = useState(false);

  const handleClick = async (event: MouseEvent) => {
    event.preventDefault();
    event.stopPropagation();
    if (typeof window === "undefined") return;
    const url = `${window.location.origin}/quests/${questId}`;

    if (
      typeof navigator !== "undefined" &&
      typeof navigator.share === "function"
    ) {
      try {
        await navigator.share({ title: questTitle, url });
        return;
      } catch (error) {
        if ((error as DOMException)?.name === "AbortError") return;
      }
    }

    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      toast.success(t("share.copied"));
      window.setTimeout(() => setCopied(false), 1800);
    } catch {
      toast.error(t("share.failed"));
    }
  };

  if (variant === "card") {
    return (
      <Button
        type="button"
        size="icon-sm"
        variant="ghost"
        onClick={handleClick}
        aria-label={t("share.aria")}
        title={t("share.title")}
        className={cn("text-muted-foreground", className)}
      >
        {copied ? <Check /> : <Share2 />}
      </Button>
    );
  }

  return (
    <Button
      type="button"
      variant="outline"
      size="icon"
      onClick={handleClick}
      aria-label={t("share.aria")}
      title={t("share.title")}
      className={className}
    >
      {copied ? <Check /> : <Share2 />}
    </Button>
  );
}
