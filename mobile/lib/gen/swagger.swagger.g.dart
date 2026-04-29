// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementPageResponse _$AchievementPageResponseFromJson(
  Map<String, dynamic> json,
) => AchievementPageResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => AchievementResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$AchievementPageResponseToJson(
  AchievementPageResponse instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};

AchievementResponse _$AchievementResponseFromJson(Map<String, dynamic> json) =>
    AchievementResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      imageFileId: json['image_file_id'] as String?,
    );

Map<String, dynamic> _$AchievementResponseToJson(
  AchievementResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'image_file_id': instance.imageFileId,
};

BodyCreateQuestApiQuestsPost _$BodyCreateQuestApiQuestsPostFromJson(
  Map<String, dynamic> json,
) => BodyCreateQuestApiQuestsPost(
  image: json['image'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  difficulty: (json['difficulty'] as num).toInt(),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  rulesAndWarnings: json['rules_and_warnings'] as String?,
  points: json['points'] as String?,
);

Map<String, dynamic> _$BodyCreateQuestApiQuestsPostToJson(
  BodyCreateQuestApiQuestsPost instance,
) => <String, dynamic>{
  'image': instance.image,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'difficulty': instance.difficulty,
  'duration_minutes': instance.durationMinutes,
  'rules_and_warnings': instance.rulesAndWarnings,
  'points': instance.points,
};

BodyUploadAchievementImageApiAchievementsAchievementIdImagePost
_$BodyUploadAchievementImageApiAchievementsAchievementIdImagePostFromJson(
  Map<String, dynamic> json,
) => BodyUploadAchievementImageApiAchievementsAchievementIdImagePost(
  image: json['image'] as String,
);

Map<String, dynamic>
_$BodyUploadAchievementImageApiAchievementsAchievementIdImagePostToJson(
  BodyUploadAchievementImageApiAchievementsAchievementIdImagePost instance,
) => <String, dynamic>{'image': instance.image};

CheckpointCurrentView _$CheckpointCurrentViewFromJson(
  Map<String, dynamic> json,
) => CheckpointCurrentView(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  task: json['task'] as String,
  hint: json['hint'] as String?,
  pointRules: json['point_rules'] as String?,
);

Map<String, dynamic> _$CheckpointCurrentViewToJson(
  CheckpointCurrentView instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'task': instance.task,
  'hint': instance.hint,
  'point_rules': instance.pointRules,
};

CheckpointPassedView _$CheckpointPassedViewFromJson(
  Map<String, dynamic> json,
) => CheckpointPassedView(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$CheckpointPassedViewToJson(
  CheckpointPassedView instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

HTTPValidationError _$HTTPValidationErrorFromJson(Map<String, dynamic> json) =>
    HTTPValidationError(
      detail:
          (json['detail'] as List<dynamic>?)
              ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HTTPValidationErrorToJson(
  HTTPValidationError instance,
) => <String, dynamic>{
  'detail': instance.detail?.map((e) => e.toJson()).toList(),
};

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

QuestArchiveStatusUpdateRequest _$QuestArchiveStatusUpdateRequestFromJson(
  Map<String, dynamic> json,
) => QuestArchiveStatusUpdateRequest(
  status: questArchiveStatusSchemaFromJson(json['status']),
);

Map<String, dynamic> _$QuestArchiveStatusUpdateRequestToJson(
  QuestArchiveStatusUpdateRequest instance,
) => <String, dynamic>{
  'status': questArchiveStatusSchemaToJson(instance.status),
};

QuestComplaintAuthorResponse _$QuestComplaintAuthorResponseFromJson(
  Map<String, dynamic> json,
) => QuestComplaintAuthorResponse(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
);

Map<String, dynamic> _$QuestComplaintAuthorResponseToJson(
  QuestComplaintAuthorResponse instance,
) => <String, dynamic>{'id': instance.id, 'username': instance.username};

QuestComplaintCreateRequest _$QuestComplaintCreateRequestFromJson(
  Map<String, dynamic> json,
) => QuestComplaintCreateRequest(reason: json['reason'] as String);

Map<String, dynamic> _$QuestComplaintCreateRequestToJson(
  QuestComplaintCreateRequest instance,
) => <String, dynamic>{'reason': instance.reason};

QuestComplaintPageResponse _$QuestComplaintPageResponseFromJson(
  Map<String, dynamic> json,
) => QuestComplaintPageResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => QuestComplaintResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$QuestComplaintPageResponseToJson(
  QuestComplaintPageResponse instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};

QuestComplaintResponse _$QuestComplaintResponseFromJson(
  Map<String, dynamic> json,
) => QuestComplaintResponse(
  id: (json['id'] as num).toInt(),
  reason: json['reason'] as String,
  questId: (json['quest_id'] as num).toInt(),
  author: QuestComplaintAuthorResponse.fromJson(
    json['author'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$QuestComplaintResponseToJson(
  QuestComplaintResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'reason': instance.reason,
  'quest_id': instance.questId,
  'author': instance.author.toJson(),
};

QuestCreatorResponse _$QuestCreatorResponseFromJson(
  Map<String, dynamic> json,
) => QuestCreatorResponse(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  teamName: json['team_name'] as String?,
);

Map<String, dynamic> _$QuestCreatorResponseToJson(
  QuestCreatorResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'team_name': instance.teamName,
};

QuestDetailResponse _$QuestDetailResponseFromJson(
  Map<String, dynamic> json,
) => QuestDetailResponse(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  difficulty: (json['difficulty'] as num).toInt(),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  rulesAndWarnings: json['rules_and_warnings'] as String?,
  imageFileId: json['image_file_id'] as String?,
  rejectionReason: json['rejection_reason'] as String?,
  status: questStatusSchemaFromJson(json['status']),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  creator: QuestCreatorResponse.fromJson(
    json['creator'] as Map<String, dynamic>,
  ),
  isFavourite: json['is_favourite'] as bool? ?? false,
  isCompleted: json['is_completed'] as bool? ?? false,
  bestCompletionSeconds: (json['best_completion_seconds'] as num?)?.toDouble(),
  points:
      (json['points'] as List<dynamic>?)
          ?.map((e) => QuestPointResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$QuestDetailResponseToJson(
  QuestDetailResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'difficulty': instance.difficulty,
  'duration_minutes': instance.durationMinutes,
  'rules_and_warnings': instance.rulesAndWarnings,
  'image_file_id': instance.imageFileId,
  'rejection_reason': instance.rejectionReason,
  'status': questStatusSchemaToJson(instance.status),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'creator': instance.creator.toJson(),
  'is_favourite': instance.isFavourite,
  'is_completed': instance.isCompleted,
  'best_completion_seconds': instance.bestCompletionSeconds,
  'points': instance.points.map((e) => e.toJson()).toList(),
};

QuestPageResponse _$QuestPageResponseFromJson(Map<String, dynamic> json) =>
    QuestPageResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => QuestResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$QuestPageResponseToJson(QuestPageResponse instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

QuestPointResponse _$QuestPointResponseFromJson(Map<String, dynamic> json) =>
    QuestPointResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      task: json['task'] as String,
      correctAnswer: json['correct_answer'] as String,
      hint: json['hint'] as String?,
      pointRules: json['point_rules'] as String?,
    );

Map<String, dynamic> _$QuestPointResponseToJson(QuestPointResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'task': instance.task,
      'correct_answer': instance.correctAnswer,
      'hint': instance.hint,
      'point_rules': instance.pointRules,
    };

QuestRejectRequest _$QuestRejectRequestFromJson(Map<String, dynamic> json) =>
    QuestRejectRequest(reason: json['reason'] as String);

Map<String, dynamic> _$QuestRejectRequestToJson(QuestRejectRequest instance) =>
    <String, dynamic>{'reason': instance.reason};

QuestResponse _$QuestResponseFromJson(Map<String, dynamic> json) =>
    QuestResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      difficulty: (json['difficulty'] as num).toInt(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      rulesAndWarnings: json['rules_and_warnings'] as String?,
      imageFileId: json['image_file_id'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      status: questStatusSchemaFromJson(json['status']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      creator: QuestCreatorResponse.fromJson(
        json['creator'] as Map<String, dynamic>,
      ),
      isFavourite: json['is_favourite'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? false,
      bestCompletionSeconds: (json['best_completion_seconds'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$QuestResponseToJson(QuestResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'difficulty': instance.difficulty,
      'duration_minutes': instance.durationMinutes,
      'rules_and_warnings': instance.rulesAndWarnings,
      'image_file_id': instance.imageFileId,
      'rejection_reason': instance.rejectionReason,
      'status': questStatusSchemaToJson(instance.status),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'creator': instance.creator.toJson(),
      'is_favourite': instance.isFavourite,
      'is_completed': instance.isCompleted,
      'best_completion_seconds': instance.bestCompletionSeconds,
    };

QuestRunAnswerRequest _$QuestRunAnswerRequestFromJson(
  Map<String, dynamic> json,
) => QuestRunAnswerRequest(answer: json['answer'] as String);

Map<String, dynamic> _$QuestRunAnswerRequestToJson(
  QuestRunAnswerRequest instance,
) => <String, dynamic>{'answer': instance.answer};

QuestRunAnswerResponse _$QuestRunAnswerResponseFromJson(
  Map<String, dynamic> json,
) => QuestRunAnswerResponse(
  correct: json['correct'] as bool,
  progress: QuestRunProgressResponse.fromJson(
    json['progress'] as Map<String, dynamic>,
  ),
  pointsEarned: (json['points_earned'] as num?)?.toInt(),
);

Map<String, dynamic> _$QuestRunAnswerResponseToJson(
  QuestRunAnswerResponse instance,
) => <String, dynamic>{
  'correct': instance.correct,
  'progress': instance.progress.toJson(),
  'points_earned': instance.pointsEarned,
};

QuestRunHistoryItem _$QuestRunHistoryItemFromJson(Map<String, dynamic> json) =>
    QuestRunHistoryItem(
      runId: (json['run_id'] as num).toInt(),
      questId: (json['quest_id'] as num).toInt(),
      questTitle: json['quest_title'] as String,
      status: questRunStatusSchemaFromJson(json['status']),
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: DateTime.parse(json['completed_at'] as String),
      pointsAwarded: (json['points_awarded'] as num).toInt(),
    );

Map<String, dynamic> _$QuestRunHistoryItemToJson(
  QuestRunHistoryItem instance,
) => <String, dynamic>{
  'run_id': instance.runId,
  'quest_id': instance.questId,
  'quest_title': instance.questTitle,
  'status': questRunStatusSchemaToJson(instance.status),
  'started_at': instance.startedAt.toIso8601String(),
  'completed_at': instance.completedAt.toIso8601String(),
  'points_awarded': instance.pointsAwarded,
};

QuestRunProgressResponse _$QuestRunProgressResponseFromJson(
  Map<String, dynamic> json,
) => QuestRunProgressResponse(
  runId: (json['run_id'] as num).toInt(),
  questId: (json['quest_id'] as num).toInt(),
  status: questRunStatusSchemaFromJson(json['status']),
  startedAt: DateTime.parse(json['started_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  totalCheckpoints: (json['total_checkpoints'] as num).toInt(),
  currentStepIndex: (json['current_step_index'] as num).toInt(),
  previousCheckpoints:
      (json['previous_checkpoints'] as List<dynamic>?)
          ?.map((e) => CheckpointPassedView.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  currentCheckpoint: json['current_checkpoint'] == null
      ? null
      : CheckpointCurrentView.fromJson(
          json['current_checkpoint'] as Map<String, dynamic>,
        ),
  pointsAwarded: (json['points_awarded'] as num?)?.toInt(),
);

Map<String, dynamic> _$QuestRunProgressResponseToJson(
  QuestRunProgressResponse instance,
) => <String, dynamic>{
  'run_id': instance.runId,
  'quest_id': instance.questId,
  'status': questRunStatusSchemaToJson(instance.status),
  'started_at': instance.startedAt.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
  'total_checkpoints': instance.totalCheckpoints,
  'current_step_index': instance.currentStepIndex,
  'previous_checkpoints': instance.previousCheckpoints
      .map((e) => e.toJson())
      .toList(),
  'current_checkpoint': instance.currentCheckpoint?.toJson(),
  'points_awarded': instance.pointsAwarded,
};

QuestRunStartRequest _$QuestRunStartRequestFromJson(
  Map<String, dynamic> json,
) => QuestRunStartRequest(questId: (json['quest_id'] as num).toInt());

Map<String, dynamic> _$QuestRunStartRequestToJson(
  QuestRunStartRequest instance,
) => <String, dynamic>{'quest_id': instance.questId};

RatingEntry _$RatingEntryFromJson(Map<String, dynamic> json) => RatingEntry(
  name: json['name'] as String,
  points: (json['points'] as num).toInt(),
  place: (json['place'] as num).toInt(),
);

Map<String, dynamic> _$RatingEntryToJson(RatingEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'points': instance.points,
      'place': instance.place,
    };

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    RefreshTokenRequest(refreshToken: json['refresh_token'] as String);

Map<String, dynamic> _$RefreshTokenRequestToJson(
  RefreshTokenRequest instance,
) => <String, dynamic>{'refresh_token': instance.refreshToken};

TeamCreate _$TeamCreateFromJson(Map<String, dynamic> json) => TeamCreate(
  name: json['name'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$TeamCreateToJson(TeamCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };

TeamJoinRequest _$TeamJoinRequestFromJson(Map<String, dynamic> json) =>
    TeamJoinRequest(code: json['code'] as String);

Map<String, dynamic> _$TeamJoinRequestToJson(TeamJoinRequest instance) =>
    <String, dynamic>{'code': instance.code};

TeamMemberResponse _$TeamMemberResponseFromJson(Map<String, dynamic> json) =>
    TeamMemberResponse(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      age: (json['age'] as num).toInt(),
    );

Map<String, dynamic> _$TeamMemberResponseToJson(TeamMemberResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'age': instance.age,
    };

TeamQuestRunCheckpointAnswerRequest
_$TeamQuestRunCheckpointAnswerRequestFromJson(Map<String, dynamic> json) =>
    TeamQuestRunCheckpointAnswerRequest(answer: json['answer'] as String);

Map<String, dynamic> _$TeamQuestRunCheckpointAnswerRequestToJson(
  TeamQuestRunCheckpointAnswerRequest instance,
) => <String, dynamic>{'answer': instance.answer};

TeamQuestRunCheckpointAnswerResponse
_$TeamQuestRunCheckpointAnswerResponseFromJson(Map<String, dynamic> json) =>
    TeamQuestRunCheckpointAnswerResponse(
      correct: json['correct'] as bool,
      progress: TeamQuestRunProgressResponse.fromJson(
        json['progress'] as Map<String, dynamic>,
      ),
      pointsEarned: (json['points_earned'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TeamQuestRunCheckpointAnswerResponseToJson(
  TeamQuestRunCheckpointAnswerResponse instance,
) => <String, dynamic>{
  'correct': instance.correct,
  'progress': instance.progress.toJson(),
  'points_earned': instance.pointsEarned,
};

TeamQuestRunCheckpointView _$TeamQuestRunCheckpointViewFromJson(
  Map<String, dynamic> json,
) => TeamQuestRunCheckpointView(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  task: json['task'] as String,
  hint: json['hint'] as String?,
  pointRules: json['point_rules'] as String?,
  isCompleted: json['is_completed'] as bool,
  completedByUserId: (json['completed_by_user_id'] as num?)?.toInt(),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
);

Map<String, dynamic> _$TeamQuestRunCheckpointViewToJson(
  TeamQuestRunCheckpointView instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'task': instance.task,
  'hint': instance.hint,
  'point_rules': instance.pointRules,
  'is_completed': instance.isCompleted,
  'completed_by_user_id': instance.completedByUserId,
  'completed_at': instance.completedAt?.toIso8601String(),
};

TeamQuestRunProgressResponse _$TeamQuestRunProgressResponseFromJson(
  Map<String, dynamic> json,
) => TeamQuestRunProgressResponse(
  runId: (json['run_id'] as num).toInt(),
  teamId: (json['team_id'] as num).toInt(),
  questId: (json['quest_id'] as num).toInt(),
  status: teamQuestRunStatusSchemaFromJson(json['status']),
  readyMemberIds:
      (json['ready_member_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  totalMembers: (json['total_members'] as num).toInt(),
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  totalCheckpoints: (json['total_checkpoints'] as num).toInt(),
  completedCheckpoints: (json['completed_checkpoints'] as num).toInt(),
  checkpoints:
      (json['checkpoints'] as List<dynamic>?)
          ?.map(
            (e) =>
                TeamQuestRunCheckpointView.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  pointsAwarded: (json['points_awarded'] as num?)?.toInt(),
);

Map<String, dynamic> _$TeamQuestRunProgressResponseToJson(
  TeamQuestRunProgressResponse instance,
) => <String, dynamic>{
  'run_id': instance.runId,
  'team_id': instance.teamId,
  'quest_id': instance.questId,
  'status': teamQuestRunStatusSchemaToJson(instance.status),
  'ready_member_ids': instance.readyMemberIds,
  'total_members': instance.totalMembers,
  'starts_at': instance.startsAt?.toIso8601String(),
  'started_at': instance.startedAt?.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
  'total_checkpoints': instance.totalCheckpoints,
  'completed_checkpoints': instance.completedCheckpoints,
  'checkpoints': instance.checkpoints.map((e) => e.toJson()).toList(),
  'points_awarded': instance.pointsAwarded,
};

TeamQuestRunReadinessRequest _$TeamQuestRunReadinessRequestFromJson(
  Map<String, dynamic> json,
) => TeamQuestRunReadinessRequest(
  questId: (json['quest_id'] as num).toInt(),
  isReady: json['is_ready'] as bool,
);

Map<String, dynamic> _$TeamQuestRunReadinessRequestToJson(
  TeamQuestRunReadinessRequest instance,
) => <String, dynamic>{
  'quest_id': instance.questId,
  'is_ready': instance.isReady,
};

TeamRatingPageResponse _$TeamRatingPageResponseFromJson(
  Map<String, dynamic> json,
) => TeamRatingPageResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => RatingEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  currentUserTeam: json['current_user_team'] == null
      ? null
      : RatingEntry.fromJson(json['current_user_team'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TeamRatingPageResponseToJson(
  TeamRatingPageResponse instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
  'current_user_team': instance.currentUserTeam?.toJson(),
};

TeamResponse _$TeamResponseFromJson(Map<String, dynamic> json) => TeamResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  code: json['code'] as String,
  creatorId: (json['creator_id'] as num).toInt(),
  membersCount: (json['members_count'] as num).toInt(),
  totalPoints: (json['total_points'] as num).toInt(),
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => TeamMemberResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$TeamResponseToJson(TeamResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'code': instance.code,
      'creator_id': instance.creatorId,
      'members_count': instance.membersCount,
      'total_points': instance.totalPoints,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };

TokenPairResponse _$TokenPairResponseFromJson(Map<String, dynamic> json) =>
    TokenPairResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String?,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenPairResponseToJson(TokenPairResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'user': instance.user.toJson(),
    };

UserAchievementPageResponse _$UserAchievementPageResponseFromJson(
  Map<String, dynamic> json,
) => UserAchievementPageResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => UserAchievementResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$UserAchievementPageResponseToJson(
  UserAchievementPageResponse instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};

UserAchievementResponse _$UserAchievementResponseFromJson(
  Map<String, dynamic> json,
) => UserAchievementResponse(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  imageFileId: json['image_file_id'] as String?,
  awardedAt: DateTime.parse(json['awarded_at'] as String),
);

Map<String, dynamic> _$UserAchievementResponseToJson(
  UserAchievementResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'image_file_id': instance.imageFileId,
  'awarded_at': instance.awardedAt.toIso8601String(),
};

UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => UserCreate(
  email: json['email'] as String,
  username: json['username'] as String,
  password: json['password'] as String,
  birthdate: DateTime.parse(json['birthdate'] as String),
);

Map<String, dynamic> _$UserCreateToJson(UserCreate instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'birthdate': _dateToJson(instance.birthdate),
    };

UserRatingPageResponse _$UserRatingPageResponseFromJson(
  Map<String, dynamic> json,
) => UserRatingPageResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => RatingEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  currentUser: RatingEntry.fromJson(
    json['current_user'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserRatingPageResponseToJson(
  UserRatingPageResponse instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
  'current_user': instance.currentUser.toJson(),
};

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  username: json['username'] as String,
  birthdate: DateTime.parse(json['birthdate'] as String),
  role: userRoleSchemaFromJson(json['role']),
  teamName: json['team_name'] as String?,
  totalPoints: (json['total_points'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'birthdate': _dateToJson(instance.birthdate),
      'role': userRoleSchemaToJson(instance.role),
      'team_name': instance.teamName,
      'total_points': instance.totalPoints,
    };

UserUpdate _$UserUpdateFromJson(Map<String, dynamic> json) => UserUpdate(
  username: json['username'] as String?,
  birthdate: json['birthdate'] == null
      ? null
      : DateTime.parse(json['birthdate'] as String),
);

Map<String, dynamic> _$UserUpdateToJson(UserUpdate instance) =>
    <String, dynamic>{
      'username': instance.username,
      'birthdate': _dateToJson(instance.birthdate),
    };

ValidationError _$ValidationErrorFromJson(
  Map<String, dynamic> json,
) => ValidationError(
  loc: (json['loc'] as List<dynamic>?)?.map((e) => e as Object).toList() ?? [],
  msg: json['msg'] as String,
  type: json['type'] as String,
  input: json['input'],
  ctx: json['ctx'],
);

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'loc': instance.loc,
      'msg': instance.msg,
      'type': instance.type,
      'input': instance.input,
      'ctx': instance.ctx,
    };
