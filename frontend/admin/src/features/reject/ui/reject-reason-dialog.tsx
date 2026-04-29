"use client";

import { type FormEvent, useState } from "react";
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
import { Label } from "@/shared/ui/label";

type RejectReasonDialogProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  questTitle: string;
  onConfirm?: (reason: string) => void | Promise<void>;
};

export function RejectReasonDialog({
  open,
  onOpenChange,
  questTitle,
  onConfirm,
}: RejectReasonDialogProps) {
  const { t } = useTranslations();
  const [reason, setReason] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const normalizedReason = reason.trim();

    if (!normalizedReason) {
      toast.error(t("rejectDialog.requiredError"));
      return;
    }

    if (normalizedReason.length < 10) {
      toast.error(t("rejectDialog.tooShortTitle"), {
        description: t("rejectDialog.tooShortDescription"),
      });
      return;
    }

    try {
      setIsSubmitting(true);
      await onConfirm?.(normalizedReason);
      onOpenChange(false);
    } catch {
      toast.error(t("toasts.rejectFailed"), {
        description: t("toasts.tryAgain"),
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Dialog
      open={open}
      onOpenChange={(nextOpen) => {
        onOpenChange(nextOpen);
        if (!nextOpen) {
          setReason("");
          setIsSubmitting(false);
        }
      }}
    >
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>{t("rejectDialog.title")}</DialogTitle>
          <DialogDescription>
            {t("rejectDialog.descriptionPrefix")} «{questTitle}».
          </DialogDescription>
        </DialogHeader>

        <form className="space-y-4" onSubmit={handleSubmit}>
          <div className="space-y-2">
            <Label htmlFor="reject-reason">
              {t("rejectDialog.reasonLabel")}
            </Label>
            <textarea
              id="reject-reason"
              value={reason}
              onChange={(event) => {
                setReason(event.target.value);
              }}
              rows={4}
              placeholder={t("rejectDialog.reasonPlaceholder")}
              className="w-full resize-none rounded-lg border border-input bg-card px-3 py-2 text-sm text-foreground outline-none transition-[color,box-shadow,border-color] placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-2 focus-visible:ring-ring/40"
            />
          </div>

          <DialogFooter className="gap-2 sm:justify-end">
            <Button
              type="button"
              variant="outline"
              onClick={() => onOpenChange(false)}
              disabled={isSubmitting}
            >
              {t("common.cancel")}
            </Button>
            <Button type="submit" variant="destructive" disabled={isSubmitting}>
              {isSubmitting
                ? t("rejectDialog.submitPending")
                : t("common.reject")}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
