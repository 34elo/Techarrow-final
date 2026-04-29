import type { LucideIcon } from "lucide-react";

export type GuideRow = {
  key: string;
  icon: LucideIcon;
};

export type GuideSectionKind = "intro" | "list" | "bullet" | "tips";

export type GuideSection = {
  id: string;
  icon: LucideIcon;
  kind: GuideSectionKind;
  rows?: GuideRow[];
};
