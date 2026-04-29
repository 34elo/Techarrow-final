import {
  AlertTriangle,
  Ban,
  BatteryCharging,
  ClipboardList,
  Compass,
  Gauge,
  HeartHandshake,
  HelpCircle,
  KeyRound,
  Leaf,
  LifeBuoy,
  Lightbulb,
  ListChecks,
  Map as MapIcon,
  MapPin,
  NotebookPen,
  Play,
  ScrollText,
  ShieldAlert,
  ShieldCheck,
  Sparkles,
  Trophy,
  UsersRound,
} from "lucide-react";

import type { GuideSection } from "../model/types";

export const GUIDE_SECTIONS: GuideSection[] = [
  {
    id: "welcome",
    icon: Sparkles,
    kind: "intro",
  },
  {
    id: "howTo",
    icon: Compass,
    kind: "list",
    rows: [
      { key: "start", icon: Play },
      { key: "checkpoints", icon: MapPin },
      { key: "team", icon: UsersRound },
      { key: "scoring", icon: Trophy },
    ],
  },
  {
    id: "etiquette",
    icon: HeartHandshake,
    kind: "bullet",
    rows: [
      { key: "respect", icon: Leaf },
      { key: "safety", icon: ShieldCheck },
      { key: "others", icon: UsersRound },
      { key: "noDangerous", icon: AlertTriangle },
    ],
  },
  {
    id: "tips",
    icon: Lightbulb,
    kind: "tips",
    rows: [
      { key: "route", icon: MapIcon },
      { key: "difficulty", icon: Gauge },
      { key: "gear", icon: BatteryCharging },
      { key: "team", icon: UsersRound },
    ],
  },
  {
    id: "hints",
    icon: HelpCircle,
    kind: "list",
    rows: [
      { key: "codeWord", icon: KeyRound },
      { key: "multipleChoice", icon: ListChecks },
      { key: "stuck", icon: LifeBuoy },
    ],
  },
  {
    id: "safety",
    icon: ShieldAlert,
    kind: "bullet",
    rows: [
      { key: "closedZones", icon: Ban },
      { key: "rules", icon: ScrollText },
      { key: "noRisk", icon: AlertTriangle },
    ],
  },
  {
    id: "authoring",
    icon: NotebookPen,
    kind: "list",
    rows: [
      { key: "create", icon: ClipboardList },
      { key: "checkpointsQuality", icon: MapPin },
      { key: "difficulty", icon: Gauge },
      { key: "moderation", icon: ShieldCheck },
    ],
  },
];
