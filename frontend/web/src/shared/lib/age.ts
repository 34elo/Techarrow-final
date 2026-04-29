export const MIN_AGE = 10;
export const MAX_AGE = 130;

function toIsoDate(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

export function getAgeFromBirthdate(birthdate: string): number | null {
  const parsed = new Date(birthdate);
  if (Number.isNaN(parsed.getTime())) return null;
  const today = new Date();
  let age = today.getFullYear() - parsed.getFullYear();
  const monthDiff = today.getMonth() - parsed.getMonth();
  if (
    monthDiff < 0 ||
    (monthDiff === 0 && today.getDate() < parsed.getDate())
  ) {
    age -= 1;
  }
  return age;
}

export function getBirthdateBounds(): { min: string; max: string } {
  const today = new Date();
  const max = new Date(today);
  max.setFullYear(today.getFullYear() - MIN_AGE);
  const min = new Date(today);
  min.setFullYear(today.getFullYear() - MAX_AGE);
  return { min: toIsoDate(min), max: toIsoDate(max) };
}

export function isBirthdateInAgeRange(birthdate: string): boolean {
  const age = getAgeFromBirthdate(birthdate);
  if (age === null) return false;
  return age >= MIN_AGE && age <= MAX_AGE;
}
