export type ReportAuthor = {
  id: number;
  username: string;
};

export type Report = {
  id: number;
  reason: string;
  quest_id: number;
  author: ReportAuthor;
};
