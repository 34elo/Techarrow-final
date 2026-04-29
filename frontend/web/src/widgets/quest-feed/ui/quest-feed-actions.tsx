"use client";

import { useState, type ReactNode } from "react";
import Link from "next/link";
import { Map, Plus } from "lucide-react";

import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { QuestMapModal } from "@/widgets/quest-map-modal";

type QuestFeedActionsProps = {
  filtersSlot?: ReactNode;
};

export function QuestFeedActions({ filtersSlot }: QuestFeedActionsProps) {
  const { t } = useTranslations();
  const [mapOpen, setMapOpen] = useState(false);

  return (
    <>
      <div className="flex flex-wrap gap-2">
        {filtersSlot}
        <Button variant="outline" onClick={() => setMapOpen(true)}>
          <Map />
          {t("quests.openMap")}
        </Button>
        <Button asChild>
          <Link href="/quests/new">
            <Plus />
            {t("quests.create")}
          </Link>
        </Button>
      </div>
      <QuestMapModal open={mapOpen} onOpenChange={setMapOpen} />
    </>
  );
}
