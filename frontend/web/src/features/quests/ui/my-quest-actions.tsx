"use client";

import { useState, type MouseEvent } from "react";
import { Archive, ArchiveRestore, MoreVertical, Trash2 } from "lucide-react";
import { toast } from "sonner";

import type { Quest } from "@/entities/quest";
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
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/shared/ui/dropdown-menu";

import { useDeleteMyQuest } from "../model/use-delete-my-quest";
import { useUpdateMyQuestStatus } from "../model/use-update-my-quest-status";

type MyQuestActionsProps = {
  quest: Quest;
};

function stopLink(event: MouseEvent) {
  event.preventDefault();
  event.stopPropagation();
}

export function MyQuestActions({ quest }: MyQuestActionsProps) {
  const { t } = useTranslations();
  const updateStatus = useUpdateMyQuestStatus();
  const deleteQuest = useDeleteMyQuest();
  const [confirmDelete, setConfirmDelete] = useState(false);

  const canArchive = quest.status !== "archived";
  const canRestore = quest.status === "archived";

  const handleArchive = () => {
    updateStatus.mutate(
      { id: quest.id, status: "archived" },
      {
        onSuccess: () => toast.success(t("myQuests.archivedToast")),
        onError: (error) =>
          toast.error(t("myQuests.archiveFailed"), {
            description: error.message || t("common.tryAgain"),
          }),
      },
    );
  };

  const handleRestore = () => {
    updateStatus.mutate(
      { id: quest.id, status: "published" },
      {
        onSuccess: () => toast.success(t("myQuests.restoredToast")),
        onError: (error) =>
          toast.error(t("myQuests.restoreFailed"), {
            description: error.message || t("common.tryAgain"),
          }),
      },
    );
  };

  const handleDelete = () => {
    deleteQuest.mutate(
      { id: quest.id },
      {
        onSuccess: () => {
          setConfirmDelete(false);
          toast.success(t("myQuests.deletedToast"));
        },
        onError: (error) =>
          toast.error(t("myQuests.deleteFailed"), {
            description: error.message || t("common.tryAgain"),
          }),
      },
    );
  };

  return (
    <>
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button
            type="button"
            size="icon-sm"
            variant="secondary"
            className="size-7 rounded-full bg-card/80 backdrop-blur-sm"
            onClick={stopLink}
            aria-label={t("myQuests.actionsLabel")}
          >
            <MoreVertical className="size-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent
          align="end"
          onClick={(event) => event.stopPropagation()}
        >
          {canArchive ? (
            <DropdownMenuItem
              onSelect={(event) => {
                event.preventDefault();
                handleArchive();
              }}
              disabled={updateStatus.isPending}
            >
              <Archive />
              {t("myQuests.archive")}
            </DropdownMenuItem>
          ) : null}
          {canRestore ? (
            <DropdownMenuItem
              onSelect={(event) => {
                event.preventDefault();
                handleRestore();
              }}
              disabled={updateStatus.isPending}
            >
              <ArchiveRestore />
              {t("myQuests.restore")}
            </DropdownMenuItem>
          ) : null}
          <DropdownMenuItem
            className="text-destructive focus:bg-destructive/10 focus:text-destructive"
            onSelect={(event) => {
              event.preventDefault();
              setConfirmDelete(true);
            }}
          >
            <Trash2 />
            {t("myQuests.delete")}
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>

      <Dialog open={confirmDelete} onOpenChange={setConfirmDelete}>
        <DialogContent
          className="sm:max-w-md"
          onClick={(event) => event.stopPropagation()}
        >
          <DialogHeader>
            <DialogTitle>{t("myQuests.deleteConfirmTitle")}</DialogTitle>
            <DialogDescription>
              {t("myQuests.deleteConfirmDescription", { title: quest.title })}
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => setConfirmDelete(false)}
              disabled={deleteQuest.isPending}
            >
              {t("common.cancel")}
            </Button>
            <Button
              variant="destructive"
              onClick={handleDelete}
              disabled={deleteQuest.isPending}
            >
              <Trash2 />
              {deleteQuest.isPending
                ? t("myQuests.deleting")
                : t("myQuests.delete")}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
