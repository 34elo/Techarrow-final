"use client";

import { useCallback, useMemo } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Archive, Heart, Plus, Wand2 } from "lucide-react";

import { useQuests } from "@/features/quests";
import { QuestCardList } from "@/features/quests/ui/quest-card-list";
import { useTranslations } from "@/shared/i18n/i18n-provider";
import { Button } from "@/shared/ui/button";
import { InfiniteListFooter } from "@/shared/ui/infinite-list-footer";
import { Skeleton } from "@/shared/ui/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/shared/ui/tabs";

const TABS = ["created", "favorites", "archived"] as const;
type Tab = (typeof TABS)[number];

function isTab(value: string | null): value is Tab {
  return value !== null && (TABS as readonly string[]).includes(value);
}

export function MyQuestsPage() {
  const { t } = useTranslations();
  const router = useRouter();
  const searchParams = useSearchParams();
  const initialTab: Tab = isTab(searchParams?.get("tab") ?? null)
    ? (searchParams!.get("tab") as Tab)
    : "created";

  const handleTabChange = useCallback(
    (next: string) => {
      if (!isTab(next)) return;
      const params = new URLSearchParams(searchParams?.toString() ?? "");
      if (next === "created") {
        params.delete("tab");
      } else {
        params.set("tab", next);
      }
      const query = params.toString();
      router.replace(`/quests/my${query ? `?${query}` : ""}`);
    },
    [router, searchParams],
  );

  return (
    <div className="space-y-5">
      <header className="space-y-1">
        <h1 className="text-2xl font-semibold tracking-tight">
          {t("myQuests.title")}
        </h1>
        <p className="text-sm text-muted-foreground">
          {t("myQuests.description")}
        </p>
      </header>

      <Tabs value={initialTab} onValueChange={handleTabChange}>
        <TabsList>
          <TabsTrigger value="created">
            <Wand2 className="size-3.5" aria-hidden />
            {t("myQuests.tabCreated")}
          </TabsTrigger>
          <TabsTrigger value="favorites">
            <Heart className="size-3.5" aria-hidden />
            {t("myQuests.tabFavorites")}
          </TabsTrigger>
          <TabsTrigger value="archived">
            <Archive className="size-3.5" aria-hidden />
            {t("myQuests.tabArchived")}
          </TabsTrigger>
        </TabsList>

        <TabsContent value="created">
          <QuestSection
            scope="created"
            emptyText={t("myQuests.emptyCreated")}
            emptyAction={
              <Button asChild>
                <Link href="/quests/new">
                  <Plus />
                  {t("quests.create")}
                </Link>
              </Button>
            }
          />
        </TabsContent>
        <TabsContent value="favorites">
          <QuestSection
            scope="favorites"
            emptyText={t("myQuests.emptyFavorites")}
          />
        </TabsContent>
        <TabsContent value="archived">
          <QuestSection
            scope="archived"
            emptyText={t("myQuests.emptyArchived")}
          />
        </TabsContent>
      </Tabs>
    </div>
  );
}

type QuestSectionProps = {
  scope: "created" | "favorites" | "archived";
  emptyText: string;
  emptyAction?: React.ReactNode;
};

function QuestSection({ scope, emptyText, emptyAction }: QuestSectionProps) {
  const { t } = useTranslations();
  const query = useQuests({
    scope: scope === "favorites" ? "favorites" : "my",
  });

  const items = useMemo(() => {
    if (scope === "created") {
      return query.items.filter((quest) => quest.status !== "archived");
    }
    if (scope === "archived") {
      return query.items.filter((quest) => quest.status === "archived");
    }
    return query.items;
  }, [query.items, scope]);

  if (query.isLoading) {
    return (
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 3 }).map((_, index) => (
          <Skeleton key={index} className="aspect-[4/5] w-full" />
        ))}
      </div>
    );
  }

  if (query.isError) {
    return (
      <p className="rounded-2xl border border-destructive/30 bg-destructive/10 p-4 text-sm text-destructive">
        {query.error?.message || t("common.loadError")}
      </p>
    );
  }

  if (items.length === 0) {
    return (
      <div className="flex flex-col items-center gap-3 rounded-2xl border border-dashed border-border bg-card px-6 py-10 text-center">
        <p className="text-sm text-muted-foreground">{emptyText}</p>
        {emptyAction}
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <QuestCardList
        quests={items}
        showStatus={scope !== "favorites"}
        showOwnerActions={scope !== "favorites"}
      />
      <InfiniteListFooter
        hasNextPage={Boolean(query.hasNextPage)}
        fetchNextPage={() => query.fetchNextPage()}
        isFetchingNextPage={query.isFetchingNextPage}
      />
    </div>
  );
}
