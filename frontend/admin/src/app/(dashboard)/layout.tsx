import type { ReactNode } from "react";

import { AuthGuard } from "@/features/auth";
import { PanelLayout } from "@/widgets/panel-layout";

export default function RouteLayout({ children }: { children: ReactNode }) {
  return (
    <AuthGuard>
      <PanelLayout>{children}</PanelLayout>
    </AuthGuard>
  );
}
