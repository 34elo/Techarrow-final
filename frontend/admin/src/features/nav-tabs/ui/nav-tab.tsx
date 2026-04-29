"use client";

import Link from "next/link";

import { cn } from "@/shared/lib/classnames";

type NavTabProps = {
  href: string;
  label: string;
  isActive: boolean;
};

export function NavTab({ href, label, isActive }: NavTabProps) {
  return (
    <Link
      href={href}
      aria-current={isActive ? "page" : undefined}
      className={cn(
        "inline-flex h-11 items-center border-b-2 border-transparent text-sm font-medium text-muted-foreground transition-colors hover:text-foreground",
        isActive && "border-foreground text-foreground",
      )}
    >
      {label}
    </Link>
  );
}
