export type NavTabConfig = {
  href: string;
  translationKey: string;
};

export const navTabs: NavTabConfig[] = [
  { href: "/quests", translationKey: "tabs.published" },
  { href: "/requests", translationKey: "tabs.moderation" },
  { href: "/reports", translationKey: "tabs.complaints" },
];
