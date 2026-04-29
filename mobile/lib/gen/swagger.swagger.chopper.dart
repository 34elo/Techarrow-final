// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'swagger.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Swagger extends Swagger {
  _$Swagger([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Swagger;

  @override
  Future<Response<Object>> _apiHealthCheckGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Health check',
      operationId: 'health_check_api_health_check_get',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Health check"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/health_check');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<dynamic>> _apiFileFileIdGet({
    required String? fileId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get File',
      operationId: 'get_file_api_file__file_id__get',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Files"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/file/${fileId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<TokenPairResponse>> _apiAuthRegisterPost({
    required UserCreate? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Register new user',
      operationId: 'register_user_api_auth_register_post',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authorization"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/auth/register');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<TokenPairResponse, TokenPairResponse>($request);
  }

  @override
  Future<Response<TokenPairResponse>> _apiAuthRegisterModeratorPost({
    required UserCreate? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Register new moderator',
      operationId: 'register_moderator_api_auth_register_moderator_post',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authorization"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/auth/register/moderator');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<TokenPairResponse, TokenPairResponse>($request);
  }

  @override
  Future<Response<TokenPairResponse>> _apiAuthLoginPost({
    required LoginRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Login user',
      operationId: 'login_user_api_auth_login_post',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authorization"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<TokenPairResponse, TokenPairResponse>($request);
  }

  @override
  Future<Response<TokenPairResponse>> _apiAuthRefreshPost({
    required RefreshTokenRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Refresh tokens',
      operationId: 'refresh_tokens_api_auth_refresh_post',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authorization"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/auth/refresh');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<TokenPairResponse, TokenPairResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiAuthLogoutPost({
    required RefreshTokenRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Logout user',
      operationId: 'logout_user_api_auth_logout_post',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Authorization"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/auth/logout');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<UserResponse>> _apiAuthMeGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get current user',
      operationId: 'get_me_api_auth_me_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Authorization"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/auth/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<UserResponse, UserResponse>($request);
  }

  @override
  Future<Response<UserResponse>> _apiAuthMePatch({
    required UserUpdate? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update current user',
      operationId: 'update_me_api_auth_me_patch',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Authorization"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/auth/me');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<UserResponse, UserResponse>($request);
  }

  @override
  Future<Response<AchievementPageResponse>> _apiAchievementsGet({
    int? limit,
    int? offset,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get All Achievements',
      operationId: 'get_all_achievements_api_achievements_get',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Achievements"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/achievements');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<AchievementPageResponse, AchievementPageResponse>(
      $request,
    );
  }

  @override
  Future<Response<UserAchievementPageResponse>> _apiAchievementsMeGet({
    int? limit,
    int? offset,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get My Achievements',
      operationId: 'get_my_achievements_api_achievements_me_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Achievements"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/achievements/me');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client
        .send<UserAchievementPageResponse, UserAchievementPageResponse>(
          $request,
        );
  }

  @override
  Future<Response<AchievementResponse>> _apiAchievementsAchievementIdImagePost({
    required int? achievementId,
    required BodyUploadAchievementImageApiAchievementsAchievementIdImagePost
    body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Upload Achievement Image',
      operationId:
          'upload_achievement_image_api_achievements__achievement_id__image_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Achievements"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/achievements/${achievementId}/image');
    final List<PartValue> $parts = <PartValue>[
      PartValue<
        BodyUploadAchievementImageApiAchievementsAchievementIdImagePost
      >('body', body),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      tag: swaggerMetaData,
    );
    return client.send<AchievementResponse, AchievementResponse>($request);
  }

  @override
  Future<Response<TeamResponse>> _apiTeamsPost({
    required TeamCreate? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create Team',
      operationId: 'create_team_api_teams_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Teams"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/teams');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<TeamResponse, TeamResponse>($request);
  }

  @override
  Future<Response<TeamResponse>> _apiTeamsMeGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get My Team',
      operationId: 'get_my_team_api_teams_me_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Teams"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/teams/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<TeamResponse, TeamResponse>($request);
  }

  @override
  Future<Response<TeamResponse>> _apiTeamsJoinPost({
    required TeamJoinRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Join Team',
      operationId: 'join_team_api_teams_join_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Teams"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/teams/join');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<TeamResponse, TeamResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiTeamsLeavePost({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Leave Team',
      operationId: 'leave_team_api_teams_leave_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Teams"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/teams/leave');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<TeamResponse>> _apiTeamsMembersMemberIdDelete({
    required int? memberId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Kick Member',
      operationId: 'kick_member_api_teams_members__member_id__delete',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Teams"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/teams/members/${memberId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<TeamResponse, TeamResponse>($request);
  }

  @override
  Future<Response<QuestResponse>> _apiQuestsPost({
    required BodyCreateQuestApiQuestsPost body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create Quest',
      operationId: 'create_quest_api_quests_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests');
    final List<PartValue> $parts = <PartValue>[
      PartValue<BodyCreateQuestApiQuestsPost>('body', body),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      tag: swaggerMetaData,
    );
    return client.send<QuestResponse, QuestResponse>($request);
  }

  @override
  Future<Response<QuestPageResponse>> _apiQuestsGet({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List<dynamic>? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get All Quests',
      operationId: 'get_all_quests_api_quests_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'min_duration_minutes': minDurationMinutes,
      'max_duration_minutes': maxDurationMinutes,
      'difficulties': difficulties,
      'city': city,
      'near_latitude': nearLatitude,
      'near_longitude': nearLongitude,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<QuestPageResponse, QuestPageResponse>($request);
  }

  @override
  Future<Response<QuestPageResponse>> _apiQuestsMyGet({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List<dynamic>? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get My Quests',
      operationId: 'get_my_quests_api_quests_my_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/my');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'min_duration_minutes': minDurationMinutes,
      'max_duration_minutes': maxDurationMinutes,
      'difficulties': difficulties,
      'city': city,
      'near_latitude': nearLatitude,
      'near_longitude': nearLongitude,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<QuestPageResponse, QuestPageResponse>($request);
  }

  @override
  Future<Response<QuestPageResponse>> _apiQuestsFavoritesGet({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List<dynamic>? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get Favorite Quests',
      operationId: 'get_favorite_quests_api_quests_favorites_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/favorites');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'min_duration_minutes': minDurationMinutes,
      'max_duration_minutes': maxDurationMinutes,
      'difficulties': difficulties,
      'city': city,
      'near_latitude': nearLatitude,
      'near_longitude': nearLongitude,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<QuestPageResponse, QuestPageResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiQuestsQuestIdExportGet({
    required int? questId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Export Quest To Pdf',
      operationId: 'export_quest_to_pdf_api_quests__quest_id__export_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/${questId}/export');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<QuestDetailResponse>> _apiQuestsQuestIdGet({
    required int? questId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get Quest',
      operationId: 'get_quest_api_quests__quest_id__get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/${questId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<QuestDetailResponse, QuestDetailResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiQuestsQuestIdDelete({
    required int? questId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete My Quest',
      operationId: 'delete_my_quest_api_quests__quest_id__delete',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/${questId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<QuestResponse>> _apiQuestsQuestIdStatusPatch({
    required int? questId,
    required QuestArchiveStatusUpdateRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update My Quest Status',
      operationId: 'update_my_quest_status_api_quests__quest_id__status_patch',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/${questId}/status');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<QuestResponse, QuestResponse>($request);
  }

  @override
  Future<Response<QuestComplaintResponse>> _apiQuestsQuestIdComplaintsPost({
    required int? questId,
    required QuestComplaintCreateRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create Quest Complaint',
      operationId:
          'create_quest_complaint_api_quests__quest_id__complaints_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/${questId}/complaints');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<QuestComplaintResponse, QuestComplaintResponse>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _apiQuestsQuestIdFavoritePost({
    required int? questId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Add Quest To Favorites',
      operationId: 'add_quest_to_favorites_api_quests__quest_id__favorite_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/${questId}/favorite');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiQuestsQuestIdFavoriteDelete({
    required int? questId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Remove Quest From Favorites',
      operationId:
          'remove_quest_from_favorites_api_quests__quest_id__favorite_delete',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quests"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quests/${questId}/favorite');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<QuestRunProgressResponse>> _apiQuestRunsActiveGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get Active Quest Run',
      operationId: 'get_active_quest_run_api_quest_runs_active_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quest Runs"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quest-runs/active');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<QuestRunProgressResponse, QuestRunProgressResponse>(
      $request,
    );
  }

  @override
  Future<Response<QuestRunAnswerResponse>> _apiQuestRunsActiveAnswerPost({
    required QuestRunAnswerRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Submit Active Quest Run Answer',
      operationId:
          'submit_active_quest_run_answer_api_quest_runs_active_answer_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quest Runs"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quest-runs/active/answer');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<QuestRunAnswerResponse, QuestRunAnswerResponse>(
      $request,
    );
  }

  @override
  Future<Response<QuestRunProgressResponse>> _apiQuestRunsActiveAbandonPost({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Abandon Active Quest Run',
      operationId:
          'abandon_active_quest_run_api_quest_runs_active_abandon_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quest Runs"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quest-runs/active/abandon');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<QuestRunProgressResponse, QuestRunProgressResponse>(
      $request,
    );
  }

  @override
  Future<Response<QuestRunProgressResponse>> _apiQuestRunsPost({
    required QuestRunStartRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Start Quest Run',
      operationId: 'start_quest_run_api_quest_runs_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quest Runs"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quest-runs');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<QuestRunProgressResponse, QuestRunProgressResponse>(
      $request,
    );
  }

  @override
  Future<Response<List<QuestRunHistoryItem>>> _apiQuestRunsHistoryGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get Quest Runs History',
      operationId: 'get_quest_runs_history_api_quest_runs_history_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Quest Runs"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/quest-runs/history');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<QuestRunHistoryItem>, QuestRunHistoryItem>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _apiTeamQuestRunsPatch({
    required TeamQuestRunReadinessRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update Team Quest Run Readiness',
      operationId: 'update_team_quest_run_readiness_api_team_quest_runs_patch',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Team Quest Runs"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/team-quest-runs');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<TeamQuestRunProgressResponse>> _apiTeamQuestRunsActiveGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get Active Team Quest Run',
      operationId: 'get_active_team_quest_run_api_team_quest_runs_active_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Team Quest Runs"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/team-quest-runs/active');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client
        .send<TeamQuestRunProgressResponse, TeamQuestRunProgressResponse>(
          $request,
        );
  }

  @override
  Future<Response<TeamQuestRunCheckpointAnswerResponse>>
  _apiTeamQuestRunsActiveCheckpointsCheckpointIdAnswerPost({
    required int? checkpointId,
    required TeamQuestRunCheckpointAnswerRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Submit Team Quest Checkpoint Answer',
      operationId:
          'submit_team_quest_checkpoint_answer_api_team_quest_runs_active_checkpoints__checkpoint_id__answer_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Team Quest Runs"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse(
      '/api/team-quest-runs/active/checkpoints/${checkpointId}/answer',
    );
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<
      TeamQuestRunCheckpointAnswerResponse,
      TeamQuestRunCheckpointAnswerResponse
    >($request);
  }

  @override
  Future<Response<UserRatingPageResponse>> _apiRatingUsersGet({
    int? limit,
    int? offset,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get Users Rating',
      operationId: 'get_users_rating_api_rating_users_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Rating"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/rating/users');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<UserRatingPageResponse, UserRatingPageResponse>(
      $request,
    );
  }

  @override
  Future<Response<TeamRatingPageResponse>> _apiRatingTeamsGet({
    int? limit,
    int? offset,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get Teams Rating',
      operationId: 'get_teams_rating_api_rating_teams_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Rating"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/rating/teams');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<TeamRatingPageResponse, TeamRatingPageResponse>(
      $request,
    );
  }

  @override
  Future<Response<QuestPageResponse>> _apiModerationQuestsGet({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List<dynamic>? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get Quests On Moderation',
      operationId: 'get_quests_on_moderation_api_moderation_quests_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Moderation"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/moderation/quests');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'min_duration_minutes': minDurationMinutes,
      'max_duration_minutes': maxDurationMinutes,
      'difficulties': difficulties,
      'city': city,
      'near_latitude': nearLatitude,
      'near_longitude': nearLongitude,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<QuestPageResponse, QuestPageResponse>($request);
  }

  @override
  Future<Response<QuestResponse>> _apiModerationQuestsQuestIdPublishPost({
    required int? questId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Publish Quest',
      operationId:
          'publish_quest_api_moderation_quests__quest_id__publish_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Moderation"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/moderation/quests/${questId}/publish');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<QuestResponse, QuestResponse>($request);
  }

  @override
  Future<Response<QuestResponse>> _apiModerationQuestsQuestIdRejectPost({
    required int? questId,
    required QuestRejectRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Reject Quest',
      operationId: 'reject_quest_api_moderation_quests__quest_id__reject_post',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Moderation"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/moderation/quests/${questId}/reject');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<QuestResponse, QuestResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiModerationQuestsQuestIdDelete({
    required int? questId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete Quest As Moderator',
      operationId:
          'delete_quest_as_moderator_api_moderation_quests__quest_id__delete',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Moderation"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/moderation/quests/${questId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<QuestComplaintPageResponse>> _apiModerationComplaintsGet({
    int? limit,
    int? offset,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get All Complaints',
      operationId: 'get_all_complaints_api_moderation_complaints_get',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Moderation"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/moderation/complaints');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<QuestComplaintPageResponse, QuestComplaintPageResponse>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _apiModerationComplaintsComplaintIdDelete({
    required int? complaintId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete Complaint',
      operationId:
          'delete_complaint_api_moderation_complaints__complaint_id__delete',
      consumes: [],
      produces: [],
      security: ["HTTPBearer"],
      tags: ["Moderation"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/moderation/complaints/${complaintId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
