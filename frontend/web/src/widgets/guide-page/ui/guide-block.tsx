import type { LucideIcon } from "lucide-react";
import type { ReactNode } from "react";

import { Card, CardContent, CardHeader, CardTitle } from "@/shared/ui/card";

type GuideBlockProps = {
  icon: LucideIcon;
  title: string;
  children: ReactNode;
};

export function GuideBlock({ icon: Icon, title, children }: GuideBlockProps) {
  return (
    <Card className="gap-4 py-5">
      <CardHeader className="flex flex-row items-center gap-2 space-y-0">
        <span
          aria-hidden
          className="flex size-9 shrink-0 items-center justify-center rounded-2xl bg-secondary text-primary"
        >
          <Icon className="size-5" />
        </span>
        <CardTitle className="text-base">{title}</CardTitle>
      </CardHeader>
      <CardContent>{children}</CardContent>
    </Card>
  );
}
