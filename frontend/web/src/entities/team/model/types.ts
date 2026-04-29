export type TeamMember = {
  id: number;
  username: string;
  age: number;
};

export type Team = {
  id: number;
  name: string;
  description: string;
  code: string;
  creator_id: number;
  members_count: number;
  total_points: number;
  members: TeamMember[];
};

export const TEAM_INVITE_CODE_LENGTH = 12;
