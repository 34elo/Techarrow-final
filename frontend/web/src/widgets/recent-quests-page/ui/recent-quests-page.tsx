"use client";

import Link from "next/link";
import { useState } from "react";
import { ArrowLeft, Trash2 } from "lucide-react";
import { toast } from "sonner";

import {
  clearRecentlyViewedQuests,
  useRecentlyViewedQuests,
} from "@/entities/quest/lib/recently-viewed";
import { QuestCardList } from "@/features/quests/ui/quest-card-list";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/shared/ui/dialog";

export function RecentQuestsPage() {
  const { t } = useTranslations();
  const recent = useRecentlyViewedQuests();
  const [confirmOpen, setConfirmOpen] = useState(false);

  const handleConfirmClear = () => {
    clearRecentlyViewedQuests();
    setConfirmOpen(false);
    toast.success(t("recent.cleared"));
  };

  return (
    <div className="space-y-6">
      <header className="flex flex-wrap items-center justify-between gap-3">
        <div className="flex flex-wrap items-center gap-3">
          <Button variant="ghost" size="sm" asChild>
            <Link href="/profile">
              <ArrowLeft />
              {t("common.back")}
            </Link>
          </Button>
          <div className="space-y-1">
            <h1 className="text-2xl font-semibold tracking-tight">
              {t("recent.title")}
            </h1>
            <p className="text-sm text-muted-foreground">
              {t("recent.description")}
            </p>
          </div>
        </div>
        {recent.length > 0 ? (
          <Button
            variant="outline"
            size="sm"
            onClick={() => setConfirmOpen(true)}
          >
            <Trash2 />
            {t("recent.clear")}
          </Button>
        ) : null}
      </header>

      {recent.length === 0 ? (
        <p className="rounded-2xl border border-border bg-card p-6 text-center text-sm text-muted-foreground">
          {t("recent.empty")}
        </p>
      ) : (
        <QuestCardList quests={recent} />
      )}

      <Dialog open={confirmOpen} onOpenChange={setConfirmOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{t("recent.confirmTitle")}</DialogTitle>
            <DialogDescription>
              {t("recent.confirmDescription")}
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setConfirmOpen(false)}>
              {t("common.cancel")}
            </Button>
            <Button variant="destructive" onClick={handleConfirmClear}>
              <Trash2 />
              {t("recent.clear")}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
