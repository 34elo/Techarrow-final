"use client";

import type { ReactNode } from "react";

import { BottomNav } from "@/widgets/bottom-nav";
import { GuideFab } from "@/widgets/guide-fab";
import { MainHeader } from "@/widgets/main-header";

type MainLayoutProps = {
  children: ReactNode;
};

export function MainLayout({ children }: MainLayoutProps) {
  return (
    <div className="flex min-h-screen flex-col bg-background">
      <MainHeader />
      <main className="flex-1 px-4 py-6 pb-[calc(5.5rem+env(safe-area-inset-bottom))] text-foreground md:px-6 md:py-8 md:pb-8">
        <div className="mx-auto w-full max-w-6xl">{children}</div>
      </main>
      <GuideFab />
      <BottomNav />
    </div>
  );
}
