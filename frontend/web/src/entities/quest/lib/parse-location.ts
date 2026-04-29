export type ParsedLocation = {
  city: string;
  district: string;
};

export function parseLocation(location: string): ParsedLocation {
  const [first = "", second = ""] = location
    .split(",")
    .map((part) => part.trim());
  return second
    ? { district: first, city: second }
    : { district: "", city: first };
}
