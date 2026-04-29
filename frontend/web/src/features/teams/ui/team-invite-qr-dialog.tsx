"use client";

import { useRef } from "react";
import { Download } from "lucide-react";
import { QRCodeCanvas } from "qrcode.react";
import { toast } from "sonner";

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

type TeamInviteQrDialogProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  team: { name: string; code: string };
};

export function TeamInviteQrDialog({
  open,
  onOpenChange,
  team,
}: TeamInviteQrDialogProps) {
  const { t } = useTranslations();
  const containerRef = useRef<HTMLDivElement>(null);

  const handleDownload = () => {
    const canvas = containerRef.current?.querySelector("canvas");
    if (!canvas) {
      toast.error(t("common.tryAgain"));
      return;
    }
    try {
      const dataUrl = canvas.toDataURL("image/png");
      const a = document.createElement("a");
      a.href = dataUrl;
      a.download = `team-${team.code}.png`;
      a.click();
    } catch {
      toast.error(t("common.tryAgain"));
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{t("team.qrTitle", { name: team.name })}</DialogTitle>
          <DialogDescription>{t("team.qrDescription")}</DialogDescription>
        </DialogHeader>
        <div className="flex flex-col items-center gap-4">
          <div
            ref={containerRef}
            className="rounded-2xl border border-border bg-white p-4"
          >
            <QRCodeCanvas
              value={team.code}
              size={224}
              marginSize={2}
              level="M"
            />
          </div>
          <code className="break-all rounded-lg border border-border bg-muted/40 px-3 py-1.5 text-sm font-mono">
            {team.code}
          </code>
          <p className="text-center text-xs text-muted-foreground">
            {t("team.qrHint")}
          </p>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            {t("common.cancel")}
          </Button>
          <Button onClick={handleDownload}>
            <Download />
            {t("team.qrDownload")}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
