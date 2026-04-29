"use client";

import Link from "next/link";
import { ChevronRight, Loader2, type LucideIcon } from "lucide-react";

import { cn } from "@/shared/lib/classnames";

type ProfileListCardItemBase = {
  icon: LucideIcon;
  label: string;
  description?: string;
  destructive?: boolean;
};

type ProfileLinkItem = ProfileListCardItemBase & {
  href: string;
};

type ProfileActionItem = ProfileListCardItemBase & {
  onClick: () => void;
  disabled?: boolean;
  busyLabel?: string;
  isBusy?: boolean;
};

export type ProfileListItem = ProfileLinkItem | ProfileActionItem;

type ProfileListCardProps = {
  items: ProfileListItem[];
};

export function ProfileListCard({ items }: ProfileListCardProps) {
  return (
    <div className="grid grid-cols-1 gap-2 sm:grid-cols-3">
      {items.map((item) => (
        <ProfileTile key={item.label} item={item} />
      ))}
    </div>
  );
}

function ProfileTile({ item }: { item: ProfileListItem }) {
  const Icon = item.icon;
  const busy = "isBusy" in item && item.isBusy;

  const tile = (
    <div
      className={cn(
        "group flex items-center gap-3 rounded-2xl bg-card px-4 py-3 text-left shadow-md transition-shadow hover:shadow-lg",
        "dark:shadow-none dark:ring-1 dark:ring-white/5",
      )}
    >
      <div
        className={cn(
          "flex size-9 shrink-0 items-center justify-center rounded-xl bg-muted text-muted-foreground",
          item.destructive && "bg-destructive/10 text-destructive",
        )}
      >
        {busy ? (
          <Loader2 className="size-4 animate-spin" aria-hidden />
        ) : (
          <Icon className="size-4" aria-hidden />
        )}
      </div>
      <div className="min-w-0 flex-1">
        <p
          className={cn(
            "truncate text-sm font-medium",
            item.destructive ? "text-destructive" : "text-foreground",
          )}
        >
          {busy && "busyLabel" in item && item.busyLabel
            ? item.busyLabel
            : item.label}
        </p>
        {item.description ? (
          <p className="truncate text-[11px] text-muted-foreground">
            {item.description}
          </p>
        ) : null}
      </div>
      <ChevronRight
        className={cn(
          "size-4 shrink-0 text-muted-foreground",
          item.destructive && "text-destructive/60",
        )}
        aria-hidden
      />
    </div>
  );

  if ("href" in item) {
    return (
      <Link
        href={item.href}
        className="block rounded-2xl outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
      >
        {tile}
      </Link>
    );
  }

  return (
    <button
      type="button"
      onClick={item.onClick}
      disabled={item.disabled}
      className="block w-full cursor-pointer rounded-2xl text-left outline-none focus-visible:ring-2 focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-60"
    >
      {tile}
    </button>
  );
}
