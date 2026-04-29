import { redirect } from "next/navigation";

export default function FavoritesRedirect() {
  redirect("/quests/my?tab=favorites");
}
