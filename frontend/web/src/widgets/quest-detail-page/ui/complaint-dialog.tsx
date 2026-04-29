"use client";

import { useMutation } from "@tanstack/react-query";
import { useState, type FormEvent } from "react";
import { Flag } from "lucide-react";
import { toast } from "sonner";

import { questsService } from "@/features/quests";
import type { ApiError } from "@/shared/api";
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
import { Textarea } from "@/shared/ui/textarea";

const REASON_MIN = 5;
const REASON_MAX = 2000;

type ComplaintDialogProps = {
  questId: number;
};

export function ComplaintDialog({ questId }: ComplaintDialogProps) {
  const { t } = useTranslations();
  const [open, setOpen] = useState(false);
  const [reason, setReason] = useState("");

  const mutation = useMutation<void, ApiError, string>({
    mutationFn: (value) => questsService.complain(questId, value),
  });

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const trimmed = reason.trim();
    if (trimmed.length < REASON_MIN) return;
    mutation.mutate(trimmed, {
      onSuccess: () => {
        toast.success(t("questDetail.reportSuccess"));
        setReason("");
        setOpen(false);
      },
      onError: (error) =>
        toast.error(t("questDetail.reportFailed"), {
          description: error.message || t("common.tryAgain"),
        }),
    });
  };

  return (
    <Dialog
      open={open}
      onOpenChange={(value) => {
        if (!mutation.isPending) setOpen(value);
      }}
    >
      <Button
        type="button"
        variant="outline"
        size="icon"
        onClick={() => setOpen(true)}
        aria-label={t("questDetail.report")}
        title={t("questDetail.report")}
      >
        <Flag />
      </Button>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{t("questDetail.reportTitle")}</DialogTitle>
          <DialogDescription>
            {t("questDetail.reportDescription")}
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-3">
          <div className="space-y-1.5">
            <Label htmlFor="complaint-reason">
              {t("questDetail.reportReasonLabel")}
            </Label>
            <Textarea
              id="complaint-reason"
              rows={5}
              minLength={REASON_MIN}
              maxLength={REASON_MAX}
              required
              value={reason}
              onChange={(event) => setReason(event.target.value)}
              placeholder={t("questDetail.reportReasonPlaceholder")}
              disabled={mutation.isPending}
            />
          </div>
          <DialogFooter>
            <Button
              type="button"
              variant="outline"
              onClick={() => setOpen(false)}
              disabled={mutation.isPending}
            >
              {t("common.cancel")}
            </Button>
            <Button
              type="submit"
              disabled={mutation.isPending || reason.trim().length < REASON_MIN}
            >
              {mutation.isPending
                ? t("questDetail.reportSubmitting")
                : t("questDetail.reportSubmit")}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
