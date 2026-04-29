"use client";

import { Input } from "@/shared/ui/input";

type QuestsSearchProps = {
  value: string;
  onChange: (value: string) => void;
  placeholder: string;
};

export function QuestsSearch({
  value,
  onChange,
  placeholder,
}: QuestsSearchProps) {
  return (
    <Input
      value={value}
      onChange={(event) => onChange(event.target.value)}
      placeholder={placeholder}
      className="mb-4 max-w-md"
    />
  );
}
