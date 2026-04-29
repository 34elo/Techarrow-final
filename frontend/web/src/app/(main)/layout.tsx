import type { ReactNode } from "react";

import { AuthGuard } from "@/features/auth";
import { MainLayout } from "@/widgets/main-layout";

export default function RouteLayout({ children }: { children: ReactNode }) {
  return (
    <AuthGuard>
      <MainLayout>{children}</MainLayout>
    </AuthGuard>
  );
}
