"use client";

import { Heart } from "lucide-react";
import { toast } from "sonner";

import { useFavoriteIds } from "../model/use-favorite-ids";
import { useToggleFavorite } from "../model/use-toggle-favorite";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import { Button } from "@/shared/ui/button";

type FavoriteButtonProps = {
  questId: number;
  variant?: "icon" | "text";
  className?: string;
};

export function FavoriteButton({
  questId,
  variant = "icon",
  className,
}: FavoriteButtonProps) {
  const { t } = useTranslations();
  const { data: favoriteIds } = useFavoriteIds();
  const toggle = useToggleFavorite();

  const isFavorite = favoriteIds?.has(questId) ?? false;

  const handleClick = (event: React.MouseEvent) => {
    event.preventDefault();
    event.stopPropagation();
    toggle.mutate(
      { questId, isFavorite },
      {
        onError: (error) => {
          toast.error(t("favorites.toggleFailed"), {
            description: error.message || t("common.tryAgain"),
          });
        },
      },
    );
  };

  const label = isFavorite ? t("favorites.remove") : t("favorites.add");

  if (variant === "icon") {
    return (
      <Button
        type="button"
        size="icon-sm"
        variant="ghost"
        aria-label={label}
        onClick={handleClick}
        disabled={toggle.isPending}
        className={cn("text-muted-foreground", className)}
      >
        <Heart
          className={cn(
            "size-5 transition-colors",
            isFavorite && "fill-destructive text-destructive",
          )}
        />
      </Button>
    );
  }

  return (
    <Button
      type="button"
      variant={isFavorite ? "secondary" : "outline"}
      onClick={handleClick}
      disabled={toggle.isPending}
      className={className}
    >
      <Heart
        className={cn(isFavorite && "fill-destructive text-destructive")}
      />
      {label}
    </Button>
  );
}
