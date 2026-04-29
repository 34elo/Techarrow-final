"use client";

import type { ReactNode } from "react";

import { PanelHeader } from "@/widgets/panel-header";

type PanelLayoutProps = {
  children: ReactNode;
};

export function PanelLayout({ children }: PanelLayoutProps) {
  return (
    <main className="min-h-screen bg-background px-6 py-4 text-foreground">
      <div className="mx-auto flex w-full max-w-6xl flex-col gap-8">
        <PanelHeader />
        <section className="space-y-2">{children}</section>
      </div>
    </main>
  );
}
