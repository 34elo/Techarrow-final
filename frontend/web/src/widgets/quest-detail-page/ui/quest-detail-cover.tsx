"use client";

import { useState } from "react";
import Image from "next/image";
import { Maximize2 } from "lucide-react";

import { getQuestCoverImageUrl, type QuestDetail } from "@/entities/quest";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { cn } from "@/shared/lib/classnames";
import {
  Dialog,
  DialogContent,
  DialogTitle,
} from "@/shared/ui/dialog";

type QuestDetailCoverProps = {
  quest: QuestDetail;
};

export function QuestDetailCover({ quest }: QuestDetailCoverProps) {
  const { t } = useTranslations();
  const [open, setOpen] = useState(false);
  const src = getQuestCoverImageUrl(quest);
  const alt = quest.title || t("quest.defaultLocation");

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        aria-label={t("questDetail.coverFullscreen")}
        title={t("questDetail.coverFullscreen")}
        className={cn(
          "group relative block aspect-video w-full max-w-2xl overflow-hidden rounded-2xl bg-muted",
          "cursor-zoom-in outline-none focus-visible:ring-2 focus-visible:ring-ring/50",
        )}
      >
        <Image
          src={src}
          alt={alt}
          fill
          sizes="(max-width: 640px) 100vw, (max-width: 1024px) 60vw, 672px"
          className="object-cover transition-transform duration-300 group-hover:scale-[1.02]"
          unoptimized
          priority
        />
        <span
          aria-hidden
          className="absolute right-2 top-2 inline-flex size-8 items-center justify-center rounded-full bg-black/55 text-white opacity-0 backdrop-blur-sm transition-opacity duration-200 group-hover:opacity-100 group-focus-visible:opacity-100"
        >
          <Maximize2 className="size-4" />
        </span>
      </button>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="max-h-[95vh] max-w-[95vw] gap-0 border-0 bg-transparent p-0 shadow-none sm:max-w-[90vw]">
          <DialogTitle className="sr-only">{alt}</DialogTitle>
          <div className="relative mx-auto flex max-h-[95vh] w-full items-center justify-center">
            <Image
              src={src}
              alt={alt}
              width={1920}
              height={1080}
              sizes="95vw"
              className="h-auto max-h-[92vh] w-auto max-w-full rounded-2xl object-contain"
              unoptimized
              priority
            />
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
