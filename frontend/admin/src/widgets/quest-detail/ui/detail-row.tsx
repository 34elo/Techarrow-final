import type { ReactNode } from "react";

import { cn } from "@/shared/lib/classnames";

type DetailRowProps = {
  label: string;
  children: ReactNode;
  className?: string;
};

export function DetailRow({ label, children, className }: DetailRowProps) {
  return (
    <div
      className={cn(
        "grid gap-1 border-b border-border/60 py-3 last:border-b-0 sm:grid-cols-[minmax(10rem,12rem)_1fr] sm:gap-6",
        className,
      )}
    >
      <dt className="text-sm font-medium text-muted-foreground">{label}</dt>
      <dd className="text-sm text-foreground">{children}</dd>
    </div>
  );
}
