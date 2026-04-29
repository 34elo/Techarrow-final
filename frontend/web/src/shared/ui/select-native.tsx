import * as React from "react";

import { cn } from "@/shared/lib/classnames";

type SelectNativeProps = React.ComponentProps<"select">;

function SelectNative({ className, ...props }: SelectNativeProps) {
  return (
    <select
      data-slot="select-native"
      className={cn(
        "h-10 w-full rounded-lg border border-input bg-card px-3 text-base text-foreground transition-[color,box-shadow,border-color] outline-none disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        "focus-visible:border-ring focus-visible:ring-2 focus-visible:ring-ring/40",
        "aria-invalid:border-destructive aria-invalid:ring-2 aria-invalid:ring-destructive/30",
        className,
      )}
      {...props}
    />
  );
}

export { SelectNative };
