// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element_parameter

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'swagger.enums.swagger.dart' as enums;
import 'swagger.metadata.swagger.dart';
export 'swagger.enums.swagger.dart';

part 'swagger.swagger.chopper.dart';
part 'swagger.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Swagger extends ChopperService {
  static Swagger create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Swagger(client);
    }

    final newClient = ChopperClient(
      services: [_$Swagger()],
      converter: converter ?? $JsonSerializableConverter(),
      interceptors: interceptors ?? [],
      client: httpClient,
      authenticator: authenticator,
      errorConverter: errorConverter,
      baseUrl: baseUrl ?? Uri.parse('http://'),
    );
    return _$Swagger(newClient);
  }

  ///Health check
  Future<chopper.Response<Object>> apiHealthCheckGet() {
    return _apiHealthCheckGet();
  }

  ///Health check
  @GET(path: '/api/health_check')
  Future<chopper.Response<Object>> _apiHealthCheckGet({
    @chopper.Tag()
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
  });

  ///Get File
  ///@param file_id
  Future<chopper.Response> apiFileFileIdGet({required String? fileId}) {
    return _apiFileFileIdGet(fileId: fileId);
  }

  ///Get File
  ///@param file_id
  @GET(path: '/api/file/{file_id}')
  Future<chopper.Response> _apiFileFileIdGet({
    @Path('file_id') required String? fileId,
    @chopper.Tag()
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
  });

  ///Register new user
  Future<chopper.Response<TokenPairResponse>> apiAuthRegisterPost({
    required UserCreate? body,
  }) {
    generatedMapping.putIfAbsent(
      TokenPairResponse,
      () => TokenPairResponse.fromJsonFactory,
    );

    return _apiAuthRegisterPost(body: body);
  }

  ///Register new user
  @POST(path: '/api/auth/register', optionalBody: true)
  Future<chopper.Response<TokenPairResponse>> _apiAuthRegisterPost({
    @Body() required UserCreate? body,
    @chopper.Tag()
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
  });

  ///Register new moderator
  Future<chopper.Response<TokenPairResponse>> apiAuthRegisterModeratorPost({
    required UserCreate? body,
  }) {
    generatedMapping.putIfAbsent(
      TokenPairResponse,
      () => TokenPairResponse.fromJsonFactory,
    );

    return _apiAuthRegisterModeratorPost(body: body);
  }

  ///Register new moderator
  @POST(path: '/api/auth/register/moderator', optionalBody: true)
  Future<chopper.Response<TokenPairResponse>> _apiAuthRegisterModeratorPost({
    @Body() required UserCreate? body,
    @chopper.Tag()
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
  });

  ///Login user
  Future<chopper.Response<TokenPairResponse>> apiAuthLoginPost({
    required LoginRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      TokenPairResponse,
      () => TokenPairResponse.fromJsonFactory,
    );

    return _apiAuthLoginPost(body: body);
  }

  ///Login user
  @POST(path: '/api/auth/login', optionalBody: true)
  Future<chopper.Response<TokenPairResponse>> _apiAuthLoginPost({
    @Body() required LoginRequest? body,
    @chopper.Tag()
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
  });

  ///Refresh tokens
  Future<chopper.Response<TokenPairResponse>> apiAuthRefreshPost({
    required RefreshTokenRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      TokenPairResponse,
      () => TokenPairResponse.fromJsonFactory,
    );

    return _apiAuthRefreshPost(body: body);
  }

  ///Refresh tokens
  @POST(path: '/api/auth/refresh', optionalBody: true)
  Future<chopper.Response<TokenPairResponse>> _apiAuthRefreshPost({
    @Body() required RefreshTokenRequest? body,
    @chopper.Tag()
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
  });

  ///Logout user
  Future<chopper.Response> apiAuthLogoutPost({
    required RefreshTokenRequest? body,
  }) {
    return _apiAuthLogoutPost(body: body);
  }

  ///Logout user
  @POST(path: '/api/auth/logout', optionalBody: true)
  Future<chopper.Response> _apiAuthLogoutPost({
    @Body() required RefreshTokenRequest? body,
    @chopper.Tag()
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
  });

  ///Get current user
  Future<chopper.Response<UserResponse>> apiAuthMeGet() {
    generatedMapping.putIfAbsent(
      UserResponse,
      () => UserResponse.fromJsonFactory,
    );

    return _apiAuthMeGet();
  }

  ///Get current user
  @GET(path: '/api/auth/me')
  Future<chopper.Response<UserResponse>> _apiAuthMeGet({
    @chopper.Tag()
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
  });

  ///Update current user
  Future<chopper.Response<UserResponse>> apiAuthMePatch({
    required UserUpdate? body,
  }) {
    generatedMapping.putIfAbsent(
      UserResponse,
      () => UserResponse.fromJsonFactory,
    );

    return _apiAuthMePatch(body: body);
  }

  ///Update current user
  @PATCH(path: '/api/auth/me', optionalBody: true)
  Future<chopper.Response<UserResponse>> _apiAuthMePatch({
    @Body() required UserUpdate? body,
    @chopper.Tag()
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
  });

  ///Get All Achievements
  ///@param limit
  ///@param offset
  Future<chopper.Response<AchievementPageResponse>> apiAchievementsGet({
    int? limit,
    int? offset,
  }) {
    generatedMapping.putIfAbsent(
      AchievementPageResponse,
      () => AchievementPageResponse.fromJsonFactory,
    );

    return _apiAchievementsGet(limit: limit, offset: offset);
  }

  ///Get All Achievements
  ///@param limit
  ///@param offset
  @GET(path: '/api/achievements')
  Future<chopper.Response<AchievementPageResponse>> _apiAchievementsGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @chopper.Tag()
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
  });

  ///Get My Achievements
  ///@param limit
  ///@param offset
  Future<chopper.Response<UserAchievementPageResponse>> apiAchievementsMeGet({
    int? limit,
    int? offset,
  }) {
    generatedMapping.putIfAbsent(
      UserAchievementPageResponse,
      () => UserAchievementPageResponse.fromJsonFactory,
    );

    return _apiAchievementsMeGet(limit: limit, offset: offset);
  }

  ///Get My Achievements
  ///@param limit
  ///@param offset
  @GET(path: '/api/achievements/me')
  Future<chopper.Response<UserAchievementPageResponse>> _apiAchievementsMeGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @chopper.Tag()
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
  });

  ///Upload Achievement Image
  ///@param achievement_id
  Future<chopper.Response<AchievementResponse>>
  apiAchievementsAchievementIdImagePost({
    required int? achievementId,
    required BodyUploadAchievementImageApiAchievementsAchievementIdImagePost
    body,
  }) {
    generatedMapping.putIfAbsent(
      AchievementResponse,
      () => AchievementResponse.fromJsonFactory,
    );

    return _apiAchievementsAchievementIdImagePost(
      achievementId: achievementId,
      body: body,
    );
  }

  ///Upload Achievement Image
  ///@param achievement_id
  @POST(path: '/api/achievements/{achievement_id}/image', optionalBody: true)
  @Multipart()
  Future<chopper.Response<AchievementResponse>>
  _apiAchievementsAchievementIdImagePost({
    @Path('achievement_id') required int? achievementId,
    @Part()
    required BodyUploadAchievementImageApiAchievementsAchievementIdImagePost
    body,
    @chopper.Tag()
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
  });

  ///Create Team
  Future<chopper.Response<TeamResponse>> apiTeamsPost({
    required TeamCreate? body,
  }) {
    generatedMapping.putIfAbsent(
      TeamResponse,
      () => TeamResponse.fromJsonFactory,
    );

    return _apiTeamsPost(body: body);
  }

  ///Create Team
  @POST(path: '/api/teams', optionalBody: true)
  Future<chopper.Response<TeamResponse>> _apiTeamsPost({
    @Body() required TeamCreate? body,
    @chopper.Tag()
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
  });

  ///Get My Team
  Future<chopper.Response<TeamResponse>> apiTeamsMeGet() {
    generatedMapping.putIfAbsent(
      TeamResponse,
      () => TeamResponse.fromJsonFactory,
    );

    return _apiTeamsMeGet();
  }

  ///Get My Team
  @GET(path: '/api/teams/me')
  Future<chopper.Response<TeamResponse>> _apiTeamsMeGet({
    @chopper.Tag()
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
  });

  ///Join Team
  Future<chopper.Response<TeamResponse>> apiTeamsJoinPost({
    required TeamJoinRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      TeamResponse,
      () => TeamResponse.fromJsonFactory,
    );

    return _apiTeamsJoinPost(body: body);
  }

  ///Join Team
  @POST(path: '/api/teams/join', optionalBody: true)
  Future<chopper.Response<TeamResponse>> _apiTeamsJoinPost({
    @Body() required TeamJoinRequest? body,
    @chopper.Tag()
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
  });

  ///Leave Team
  Future<chopper.Response> apiTeamsLeavePost() {
    return _apiTeamsLeavePost();
  }

  ///Leave Team
  @POST(path: '/api/teams/leave', optionalBody: true)
  Future<chopper.Response> _apiTeamsLeavePost({
    @chopper.Tag()
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
  });

  ///Kick Member
  ///@param member_id
  Future<chopper.Response<TeamResponse>> apiTeamsMembersMemberIdDelete({
    required int? memberId,
  }) {
    generatedMapping.putIfAbsent(
      TeamResponse,
      () => TeamResponse.fromJsonFactory,
    );

    return _apiTeamsMembersMemberIdDelete(memberId: memberId);
  }

  ///Kick Member
  ///@param member_id
  @DELETE(path: '/api/teams/members/{member_id}')
  Future<chopper.Response<TeamResponse>> _apiTeamsMembersMemberIdDelete({
    @Path('member_id') required int? memberId,
    @chopper.Tag()
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
  });

  ///Create Quest
  Future<chopper.Response<QuestResponse>> apiQuestsPost({
    required BodyCreateQuestApiQuestsPost body,
  }) {
    generatedMapping.putIfAbsent(
      QuestResponse,
      () => QuestResponse.fromJsonFactory,
    );

    return _apiQuestsPost(body: body);
  }

  ///Create Quest
  @POST(path: '/api/quests', optionalBody: true)
  @Multipart()
  Future<chopper.Response<QuestResponse>> _apiQuestsPost({
    @Part() required BodyCreateQuestApiQuestsPost body,
    @chopper.Tag()
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
  });

  ///Get All Quests
  ///@param limit
  ///@param offset
  ///@param min_duration_minutes
  ///@param max_duration_minutes
  ///@param difficulties
  ///@param city
  ///@param near_latitude Широта точки; вместе с near_longitude задаёт фильтр по радиусу 1 км (PostGIS)
  ///@param near_longitude Долгота точки; вместе с near_latitude задаёт фильтр по радиусу 1 км (PostGIS)
  Future<chopper.Response<QuestPageResponse>> apiQuestsGet({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
  }) {
    generatedMapping.putIfAbsent(
      QuestPageResponse,
      () => QuestPageResponse.fromJsonFactory,
    );

    return _apiQuestsGet(
      limit: limit,
      offset: offset,
      minDurationMinutes: minDurationMinutes,
      maxDurationMinutes: maxDurationMinutes,
      difficulties: difficulties,
      city: city,
      nearLatitude: nearLatitude,
      nearLongitude: nearLongitude,
    );
  }

  ///Get All Quests
  ///@param limit
  ///@param offset
  ///@param min_duration_minutes
  ///@param max_duration_minutes
  ///@param difficulties
  ///@param city
  ///@param near_latitude Широта точки; вместе с near_longitude задаёт фильтр по радиусу 1 км (PostGIS)
  ///@param near_longitude Долгота точки; вместе с near_latitude задаёт фильтр по радиусу 1 км (PostGIS)
  @GET(path: '/api/quests')
  Future<chopper.Response<QuestPageResponse>> _apiQuestsGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('min_duration_minutes') int? minDurationMinutes,
    @Query('max_duration_minutes') int? maxDurationMinutes,
    @Query('difficulties') List? difficulties,
    @Query('city') String? city,
    @Query('near_latitude') num? nearLatitude,
    @Query('near_longitude') num? nearLongitude,
    @chopper.Tag()
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
  });

  ///Get My Quests
  ///@param limit
  ///@param offset
  ///@param min_duration_minutes
  ///@param max_duration_minutes
  ///@param difficulties
  ///@param city
  ///@param near_latitude Широта точки; вместе с near_longitude задаёт фильтр по радиусу 1 км (PostGIS)
  ///@param near_longitude Долгота точки; вместе с near_latitude задаёт фильтр по радиусу 1 км (PostGIS)
  Future<chopper.Response<QuestPageResponse>> apiQuestsMyGet({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
  }) {
    generatedMapping.putIfAbsent(
      QuestPageResponse,
      () => QuestPageResponse.fromJsonFactory,
    );

    return _apiQuestsMyGet(
      limit: limit,
      offset: offset,
      minDurationMinutes: minDurationMinutes,
      maxDurationMinutes: maxDurationMinutes,
      difficulties: difficulties,
      city: city,
      nearLatitude: nearLatitude,
      nearLongitude: nearLongitude,
    );
  }

  ///Get My Quests
  ///@param limit
  ///@param offset
  ///@param min_duration_minutes
  ///@param max_duration_minutes
  ///@param difficulties
  ///@param city
  ///@param near_latitude Широта точки; вместе с near_longitude задаёт фильтр по радиусу 1 км (PostGIS)
  ///@param near_longitude Долгота точки; вместе с near_latitude задаёт фильтр по радиусу 1 км (PostGIS)
  @GET(path: '/api/quests/my')
  Future<chopper.Response<QuestPageResponse>> _apiQuestsMyGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('min_duration_minutes') int? minDurationMinutes,
    @Query('max_duration_minutes') int? maxDurationMinutes,
    @Query('difficulties') List? difficulties,
    @Query('city') String? city,
    @Query('near_latitude') num? nearLatitude,
    @Query('near_longitude') num? nearLongitude,
    @chopper.Tag()
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
  });

  ///Get Favorite Quests
  ///@param limit
  ///@param offset
  ///@param min_duration_minutes
  ///@param max_duration_minutes
  ///@param difficulties
  ///@param city
  ///@param near_latitude Широта точки; вместе с near_longitude задаёт фильтр по радиусу 1 км (PostGIS)
  ///@param near_longitude Долгота точки; вместе с near_latitude задаёт фильтр по радиусу 1 км (PostGIS)
  Future<chopper.Response<QuestPageResponse>> apiQuestsFavoritesGet({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
  }) {
    generatedMapping.putIfAbsent(
      QuestPageResponse,
      () => QuestPageResponse.fromJsonFactory,
    );

    return _apiQuestsFavoritesGet(
      limit: limit,
      offset: offset,
      minDurationMinutes: minDurationMinutes,
      maxDurationMinutes: maxDurationMinutes,
      difficulties: difficulties,
      city: city,
      nearLatitude: nearLatitude,
      nearLongitude: nearLongitude,
    );
  }

  ///Get Favorite Quests
  ///@param limit
  ///@param offset
  ///@param min_duration_minutes
  ///@param max_duration_minutes
  ///@param difficulties
  ///@param city
  ///@param near_latitude Широта точки; вместе с near_longitude задаёт фильтр по радиусу 1 км (PostGIS)
  ///@param near_longitude Долгота точки; вместе с near_latitude задаёт фильтр по радиусу 1 км (PostGIS)
  @GET(path: '/api/quests/favorites')
  Future<chopper.Response<QuestPageResponse>> _apiQuestsFavoritesGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('min_duration_minutes') int? minDurationMinutes,
    @Query('max_duration_minutes') int? maxDurationMinutes,
    @Query('difficulties') List? difficulties,
    @Query('city') String? city,
    @Query('near_latitude') num? nearLatitude,
    @Query('near_longitude') num? nearLongitude,
    @chopper.Tag()
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
  });

  ///Export Quest To Pdf
  ///@param quest_id
  Future<chopper.Response> apiQuestsQuestIdExportGet({required int? questId}) {
    return _apiQuestsQuestIdExportGet(questId: questId);
  }

  ///Export Quest To Pdf
  ///@param quest_id
  @GET(path: '/api/quests/{quest_id}/export')
  Future<chopper.Response> _apiQuestsQuestIdExportGet({
    @Path('quest_id') required int? questId,
    @chopper.Tag()
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
  });

  ///Get Quest
  ///@param quest_id
  Future<chopper.Response<QuestDetailResponse>> apiQuestsQuestIdGet({
    required int? questId,
  }) {
    generatedMapping.putIfAbsent(
      QuestDetailResponse,
      () => QuestDetailResponse.fromJsonFactory,
    );

    return _apiQuestsQuestIdGet(questId: questId);
  }

  ///Get Quest
  ///@param quest_id
  @GET(path: '/api/quests/{quest_id}')
  Future<chopper.Response<QuestDetailResponse>> _apiQuestsQuestIdGet({
    @Path('quest_id') required int? questId,
    @chopper.Tag()
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
  });

  ///Delete My Quest
  ///@param quest_id
  Future<chopper.Response> apiQuestsQuestIdDelete({required int? questId}) {
    return _apiQuestsQuestIdDelete(questId: questId);
  }

  ///Delete My Quest
  ///@param quest_id
  @DELETE(path: '/api/quests/{quest_id}')
  Future<chopper.Response> _apiQuestsQuestIdDelete({
    @Path('quest_id') required int? questId,
    @chopper.Tag()
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
  });

  ///Update My Quest Status
  ///@param quest_id
  Future<chopper.Response<QuestResponse>> apiQuestsQuestIdStatusPatch({
    required int? questId,
    required QuestArchiveStatusUpdateRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      QuestResponse,
      () => QuestResponse.fromJsonFactory,
    );

    return _apiQuestsQuestIdStatusPatch(questId: questId, body: body);
  }

  ///Update My Quest Status
  ///@param quest_id
  @PATCH(path: '/api/quests/{quest_id}/status', optionalBody: true)
  Future<chopper.Response<QuestResponse>> _apiQuestsQuestIdStatusPatch({
    @Path('quest_id') required int? questId,
    @Body() required QuestArchiveStatusUpdateRequest? body,
    @chopper.Tag()
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
  });

  ///Create Quest Complaint
  ///@param quest_id
  Future<chopper.Response<QuestComplaintResponse>>
  apiQuestsQuestIdComplaintsPost({
    required int? questId,
    required QuestComplaintCreateRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      QuestComplaintResponse,
      () => QuestComplaintResponse.fromJsonFactory,
    );

    return _apiQuestsQuestIdComplaintsPost(questId: questId, body: body);
  }

  ///Create Quest Complaint
  ///@param quest_id
  @POST(path: '/api/quests/{quest_id}/complaints', optionalBody: true)
  Future<chopper.Response<QuestComplaintResponse>>
  _apiQuestsQuestIdComplaintsPost({
    @Path('quest_id') required int? questId,
    @Body() required QuestComplaintCreateRequest? body,
    @chopper.Tag()
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
  });

  ///Add Quest To Favorites
  ///@param quest_id
  Future<chopper.Response> apiQuestsQuestIdFavoritePost({
    required int? questId,
  }) {
    return _apiQuestsQuestIdFavoritePost(questId: questId);
  }

  ///Add Quest To Favorites
  ///@param quest_id
  @POST(path: '/api/quests/{quest_id}/favorite', optionalBody: true)
  Future<chopper.Response> _apiQuestsQuestIdFavoritePost({
    @Path('quest_id') required int? questId,
    @chopper.Tag()
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
  });

  ///Remove Quest From Favorites
  ///@param quest_id
  Future<chopper.Response> apiQuestsQuestIdFavoriteDelete({
    required int? questId,
  }) {
    return _apiQuestsQuestIdFavoriteDelete(questId: questId);
  }

  ///Remove Quest From Favorites
  ///@param quest_id
  @DELETE(path: '/api/quests/{quest_id}/favorite')
  Future<chopper.Response> _apiQuestsQuestIdFavoriteDelete({
    @Path('quest_id') required int? questId,
    @chopper.Tag()
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
  });

  ///Get Active Quest Run
  Future<chopper.Response<QuestRunProgressResponse>> apiQuestRunsActiveGet() {
    generatedMapping.putIfAbsent(
      QuestRunProgressResponse,
      () => QuestRunProgressResponse.fromJsonFactory,
    );

    return _apiQuestRunsActiveGet();
  }

  ///Get Active Quest Run
  @GET(path: '/api/quest-runs/active')
  Future<chopper.Response<QuestRunProgressResponse>> _apiQuestRunsActiveGet({
    @chopper.Tag()
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
  });

  ///Submit Active Quest Run Answer
  Future<chopper.Response<QuestRunAnswerResponse>>
  apiQuestRunsActiveAnswerPost({required QuestRunAnswerRequest? body}) {
    generatedMapping.putIfAbsent(
      QuestRunAnswerResponse,
      () => QuestRunAnswerResponse.fromJsonFactory,
    );

    return _apiQuestRunsActiveAnswerPost(body: body);
  }

  ///Submit Active Quest Run Answer
  @POST(path: '/api/quest-runs/active/answer', optionalBody: true)
  Future<chopper.Response<QuestRunAnswerResponse>>
  _apiQuestRunsActiveAnswerPost({
    @Body() required QuestRunAnswerRequest? body,
    @chopper.Tag()
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
  });

  ///Abandon Active Quest Run
  Future<chopper.Response<QuestRunProgressResponse>>
  apiQuestRunsActiveAbandonPost() {
    generatedMapping.putIfAbsent(
      QuestRunProgressResponse,
      () => QuestRunProgressResponse.fromJsonFactory,
    );

    return _apiQuestRunsActiveAbandonPost();
  }

  ///Abandon Active Quest Run
  @POST(path: '/api/quest-runs/active/abandon', optionalBody: true)
  Future<chopper.Response<QuestRunProgressResponse>>
  _apiQuestRunsActiveAbandonPost({
    @chopper.Tag()
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
  });

  ///Start Quest Run
  Future<chopper.Response<QuestRunProgressResponse>> apiQuestRunsPost({
    required QuestRunStartRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      QuestRunProgressResponse,
      () => QuestRunProgressResponse.fromJsonFactory,
    );

    return _apiQuestRunsPost(body: body);
  }

  ///Start Quest Run
  @POST(path: '/api/quest-runs', optionalBody: true)
  Future<chopper.Response<QuestRunProgressResponse>> _apiQuestRunsPost({
    @Body() required QuestRunStartRequest? body,
    @chopper.Tag()
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
  });

  ///Get Quest Runs History
  Future<chopper.Response<List<QuestRunHistoryItem>>> apiQuestRunsHistoryGet() {
    generatedMapping.putIfAbsent(
      QuestRunHistoryItem,
      () => QuestRunHistoryItem.fromJsonFactory,
    );

    return _apiQuestRunsHistoryGet();
  }

  ///Get Quest Runs History
  @GET(path: '/api/quest-runs/history')
  Future<chopper.Response<List<QuestRunHistoryItem>>> _apiQuestRunsHistoryGet({
    @chopper.Tag()
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
  });

  ///Update Team Quest Run Readiness
  Future<chopper.Response> apiTeamQuestRunsPatch({
    required TeamQuestRunReadinessRequest? body,
  }) {
    return _apiTeamQuestRunsPatch(body: body);
  }

  ///Update Team Quest Run Readiness
  @PATCH(path: '/api/team-quest-runs', optionalBody: true)
  Future<chopper.Response> _apiTeamQuestRunsPatch({
    @Body() required TeamQuestRunReadinessRequest? body,
    @chopper.Tag()
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
  });

  ///Get Active Team Quest Run
  Future<chopper.Response<TeamQuestRunProgressResponse>>
  apiTeamQuestRunsActiveGet() {
    generatedMapping.putIfAbsent(
      TeamQuestRunProgressResponse,
      () => TeamQuestRunProgressResponse.fromJsonFactory,
    );

    return _apiTeamQuestRunsActiveGet();
  }

  ///Get Active Team Quest Run
  @GET(path: '/api/team-quest-runs/active')
  Future<chopper.Response<TeamQuestRunProgressResponse>>
  _apiTeamQuestRunsActiveGet({
    @chopper.Tag()
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
  });

  ///Submit Team Quest Checkpoint Answer
  ///@param checkpoint_id
  Future<chopper.Response<TeamQuestRunCheckpointAnswerResponse>>
  apiTeamQuestRunsActiveCheckpointsCheckpointIdAnswerPost({
    required int? checkpointId,
    required TeamQuestRunCheckpointAnswerRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      TeamQuestRunCheckpointAnswerResponse,
      () => TeamQuestRunCheckpointAnswerResponse.fromJsonFactory,
    );

    return _apiTeamQuestRunsActiveCheckpointsCheckpointIdAnswerPost(
      checkpointId: checkpointId,
      body: body,
    );
  }

  ///Submit Team Quest Checkpoint Answer
  ///@param checkpoint_id
  @POST(
    path: '/api/team-quest-runs/active/checkpoints/{checkpoint_id}/answer',
    optionalBody: true,
  )
  Future<chopper.Response<TeamQuestRunCheckpointAnswerResponse>>
  _apiTeamQuestRunsActiveCheckpointsCheckpointIdAnswerPost({
    @Path('checkpoint_id') required int? checkpointId,
    @Body() required TeamQuestRunCheckpointAnswerRequest? body,
    @chopper.Tag()
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
  });

  ///Get Users Rating
  ///@param limit
  ///@param offset
  Future<chopper.Response<UserRatingPageResponse>> apiRatingUsersGet({
    int? limit,
    int? offset,
  }) {
    generatedMapping.putIfAbsent(
      UserRatingPageResponse,
      () => UserRatingPageResponse.fromJsonFactory,
    );

    return _apiRatingUsersGet(limit: limit, offset: offset);
  }

  ///Get Users Rating
  ///@param limit
  ///@param offset
  @GET(path: '/api/rating/users')
  Future<chopper.Response<UserRatingPageResponse>> _apiRatingUsersGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @chopper.Tag()
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
  });

  ///Get Teams Rating
  ///@param limit
  ///@param offset
  Future<chopper.Response<TeamRatingPageResponse>> apiRatingTeamsGet({
    int? limit,
    int? offset,
  }) {
    generatedMapping.putIfAbsent(
      TeamRatingPageResponse,
      () => TeamRatingPageResponse.fromJsonFactory,
    );

    return _apiRatingTeamsGet(limit: limit, offset: offset);
  }

  ///Get Teams Rating
  ///@param limit
  ///@param offset
  @GET(path: '/api/rating/teams')
  Future<chopper.Response<TeamRatingPageResponse>> _apiRatingTeamsGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @chopper.Tag()
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
  });

  ///Get Quests On Moderation
  ///@param limit
  ///@param offset
  ///@param min_duration_minutes
  ///@param max_duration_minutes
  ///@param difficulties
  ///@param city
  ///@param near_latitude Широта точки; вместе с near_longitude задаёт фильтр по радиусу 1 км (PostGIS)
  ///@param near_longitude Долгота точки; вместе с near_latitude задаёт фильтр по радиусу 1 км (PostGIS)
  Future<chopper.Response<QuestPageResponse>> apiModerationQuestsGet({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
  }) {
    generatedMapping.putIfAbsent(
      QuestPageResponse,
      () => QuestPageResponse.fromJsonFactory,
    );

    return _apiModerationQuestsGet(
      limit: limit,
      offset: offset,
      minDurationMinutes: minDurationMinutes,
      maxDurationMinutes: maxDurationMinutes,
      difficulties: difficulties,
      city: city,
      nearLatitude: nearLatitude,
      nearLongitude: nearLongitude,
    );
  }

  ///Get Quests On Moderation
  ///@param limit
  ///@param offset
  ///@param min_duration_minutes
  ///@param max_duration_minutes
  ///@param difficulties
  ///@param city
  ///@param near_latitude Широта точки; вместе с near_longitude задаёт фильтр по радиусу 1 км (PostGIS)
  ///@param near_longitude Долгота точки; вместе с near_latitude задаёт фильтр по радиусу 1 км (PostGIS)
  @GET(path: '/api/moderation/quests')
  Future<chopper.Response<QuestPageResponse>> _apiModerationQuestsGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('min_duration_minutes') int? minDurationMinutes,
    @Query('max_duration_minutes') int? maxDurationMinutes,
    @Query('difficulties') List? difficulties,
    @Query('city') String? city,
    @Query('near_latitude') num? nearLatitude,
    @Query('near_longitude') num? nearLongitude,
    @chopper.Tag()
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
  });

  ///Publish Quest
  ///@param quest_id
  Future<chopper.Response<QuestResponse>>
  apiModerationQuestsQuestIdPublishPost({required int? questId}) {
    generatedMapping.putIfAbsent(
      QuestResponse,
      () => QuestResponse.fromJsonFactory,
    );

    return _apiModerationQuestsQuestIdPublishPost(questId: questId);
  }

  ///Publish Quest
  ///@param quest_id
  @POST(path: '/api/moderation/quests/{quest_id}/publish', optionalBody: true)
  Future<chopper.Response<QuestResponse>>
  _apiModerationQuestsQuestIdPublishPost({
    @Path('quest_id') required int? questId,
    @chopper.Tag()
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
  });

  ///Reject Quest
  ///@param quest_id
  Future<chopper.Response<QuestResponse>> apiModerationQuestsQuestIdRejectPost({
    required int? questId,
    required QuestRejectRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      QuestResponse,
      () => QuestResponse.fromJsonFactory,
    );

    return _apiModerationQuestsQuestIdRejectPost(questId: questId, body: body);
  }

  ///Reject Quest
  ///@param quest_id
  @POST(path: '/api/moderation/quests/{quest_id}/reject', optionalBody: true)
  Future<chopper.Response<QuestResponse>>
  _apiModerationQuestsQuestIdRejectPost({
    @Path('quest_id') required int? questId,
    @Body() required QuestRejectRequest? body,
    @chopper.Tag()
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
  });

  ///Delete Quest As Moderator
  ///@param quest_id
  Future<chopper.Response> apiModerationQuestsQuestIdDelete({
    required int? questId,
  }) {
    return _apiModerationQuestsQuestIdDelete(questId: questId);
  }

  ///Delete Quest As Moderator
  ///@param quest_id
  @DELETE(path: '/api/moderation/quests/{quest_id}')
  Future<chopper.Response> _apiModerationQuestsQuestIdDelete({
    @Path('quest_id') required int? questId,
    @chopper.Tag()
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
  });

  ///Get All Complaints
  ///@param limit
  ///@param offset
  Future<chopper.Response<QuestComplaintPageResponse>>
  apiModerationComplaintsGet({int? limit, int? offset}) {
    generatedMapping.putIfAbsent(
      QuestComplaintPageResponse,
      () => QuestComplaintPageResponse.fromJsonFactory,
    );

    return _apiModerationComplaintsGet(limit: limit, offset: offset);
  }

  ///Get All Complaints
  ///@param limit
  ///@param offset
  @GET(path: '/api/moderation/complaints')
  Future<chopper.Response<QuestComplaintPageResponse>>
  _apiModerationComplaintsGet({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @chopper.Tag()
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
  });

  ///Delete Complaint
  ///@param complaint_id
  Future<chopper.Response> apiModerationComplaintsComplaintIdDelete({
    required int? complaintId,
  }) {
    return _apiModerationComplaintsComplaintIdDelete(complaintId: complaintId);
  }

  ///Delete Complaint
  ///@param complaint_id
  @DELETE(path: '/api/moderation/complaints/{complaint_id}')
  Future<chopper.Response> _apiModerationComplaintsComplaintIdDelete({
    @Path('complaint_id') required int? complaintId,
    @chopper.Tag()
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
  });
}

@JsonSerializable(explicitToJson: true)
class AchievementPageResponse {
  const AchievementPageResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory AchievementPageResponse.fromJson(Map<String, dynamic> json) =>
      _$AchievementPageResponseFromJson(json);

  static const toJsonFactory = _$AchievementPageResponseToJson;
  Map<String, dynamic> toJson() => _$AchievementPageResponseToJson(this);

  @JsonKey(name: 'items', defaultValue: <AchievementResponse>[])
  final List<AchievementResponse> items;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'offset')
  final int offset;
  static const fromJsonFactory = _$AchievementPageResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AchievementPageResponse &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.offset, offset) ||
                const DeepCollectionEquality().equals(other.offset, offset)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(offset) ^
      runtimeType.hashCode;
}

extension $AchievementPageResponseExtension on AchievementPageResponse {
  AchievementPageResponse copyWith({
    List<AchievementResponse>? items,
    int? total,
    int? limit,
    int? offset,
  }) {
    return AchievementPageResponse(
      items: items ?? this.items,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  AchievementPageResponse copyWithWrapped({
    Wrapped<List<AchievementResponse>>? items,
    Wrapped<int>? total,
    Wrapped<int>? limit,
    Wrapped<int>? offset,
  }) {
    return AchievementPageResponse(
      items: (items != null ? items.value : this.items),
      total: (total != null ? total.value : this.total),
      limit: (limit != null ? limit.value : this.limit),
      offset: (offset != null ? offset.value : this.offset),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AchievementResponse {
  const AchievementResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.imageFileId,
  });

  factory AchievementResponse.fromJson(Map<String, dynamic> json) =>
      _$AchievementResponseFromJson(json);

  static const toJsonFactory = _$AchievementResponseToJson;
  Map<String, dynamic> toJson() => _$AchievementResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'image_file_id')
  final String? imageFileId;
  static const fromJsonFactory = _$AchievementResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AchievementResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.imageFileId, imageFileId) ||
                const DeepCollectionEquality().equals(
                  other.imageFileId,
                  imageFileId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageFileId) ^
      runtimeType.hashCode;
}

extension $AchievementResponseExtension on AchievementResponse {
  AchievementResponse copyWith({
    int? id,
    String? title,
    String? description,
    String? imageFileId,
  }) {
    return AchievementResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageFileId: imageFileId ?? this.imageFileId,
    );
  }

  AchievementResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? title,
    Wrapped<String>? description,
    Wrapped<String?>? imageFileId,
  }) {
    return AchievementResponse(
      id: (id != null ? id.value : this.id),
      title: (title != null ? title.value : this.title),
      description: (description != null ? description.value : this.description),
      imageFileId: (imageFileId != null ? imageFileId.value : this.imageFileId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class BodyCreateQuestApiQuestsPost {
  const BodyCreateQuestApiQuestsPost({
    this.image,
    required this.title,
    required this.description,
    required this.location,
    required this.difficulty,
    required this.durationMinutes,
    this.rulesAndWarnings,
    this.points,
  });

  factory BodyCreateQuestApiQuestsPost.fromJson(Map<String, dynamic> json) =>
      _$BodyCreateQuestApiQuestsPostFromJson(json);

  static const toJsonFactory = _$BodyCreateQuestApiQuestsPostToJson;
  Map<String, dynamic> toJson() => _$BodyCreateQuestApiQuestsPostToJson(this);

  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'location')
  final String location;
  @JsonKey(name: 'difficulty')
  final int difficulty;
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @JsonKey(name: 'rules_and_warnings')
  final String? rulesAndWarnings;
  @JsonKey(name: 'points')
  final String? points;
  static const fromJsonFactory = _$BodyCreateQuestApiQuestsPostFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BodyCreateQuestApiQuestsPost &&
            (identical(other.image, image) ||
                const DeepCollectionEquality().equals(other.image, image)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality().equals(
                  other.location,
                  location,
                )) &&
            (identical(other.difficulty, difficulty) ||
                const DeepCollectionEquality().equals(
                  other.difficulty,
                  difficulty,
                )) &&
            (identical(other.durationMinutes, durationMinutes) ||
                const DeepCollectionEquality().equals(
                  other.durationMinutes,
                  durationMinutes,
                )) &&
            (identical(other.rulesAndWarnings, rulesAndWarnings) ||
                const DeepCollectionEquality().equals(
                  other.rulesAndWarnings,
                  rulesAndWarnings,
                )) &&
            (identical(other.points, points) ||
                const DeepCollectionEquality().equals(other.points, points)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(image) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(difficulty) ^
      const DeepCollectionEquality().hash(durationMinutes) ^
      const DeepCollectionEquality().hash(rulesAndWarnings) ^
      const DeepCollectionEquality().hash(points) ^
      runtimeType.hashCode;
}

extension $BodyCreateQuestApiQuestsPostExtension
    on BodyCreateQuestApiQuestsPost {
  BodyCreateQuestApiQuestsPost copyWith({
    String? image,
    String? title,
    String? description,
    String? location,
    int? difficulty,
    int? durationMinutes,
    String? rulesAndWarnings,
    String? points,
  }) {
    return BodyCreateQuestApiQuestsPost(
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rulesAndWarnings: rulesAndWarnings ?? this.rulesAndWarnings,
      points: points ?? this.points,
    );
  }

  BodyCreateQuestApiQuestsPost copyWithWrapped({
    Wrapped<String?>? image,
    Wrapped<String>? title,
    Wrapped<String>? description,
    Wrapped<String>? location,
    Wrapped<int>? difficulty,
    Wrapped<int>? durationMinutes,
    Wrapped<String?>? rulesAndWarnings,
    Wrapped<String?>? points,
  }) {
    return BodyCreateQuestApiQuestsPost(
      image: (image != null ? image.value : this.image),
      title: (title != null ? title.value : this.title),
      description: (description != null ? description.value : this.description),
      location: (location != null ? location.value : this.location),
      difficulty: (difficulty != null ? difficulty.value : this.difficulty),
      durationMinutes: (durationMinutes != null
          ? durationMinutes.value
          : this.durationMinutes),
      rulesAndWarnings: (rulesAndWarnings != null
          ? rulesAndWarnings.value
          : this.rulesAndWarnings),
      points: (points != null ? points.value : this.points),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class BodyUploadAchievementImageApiAchievementsAchievementIdImagePost {
  const BodyUploadAchievementImageApiAchievementsAchievementIdImagePost({
    required this.image,
  });

  factory BodyUploadAchievementImageApiAchievementsAchievementIdImagePost.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$BodyUploadAchievementImageApiAchievementsAchievementIdImagePostFromJson(
        json,
      );

  static const toJsonFactory =
      _$BodyUploadAchievementImageApiAchievementsAchievementIdImagePostToJson;
  Map<String, dynamic> toJson() =>
      _$BodyUploadAchievementImageApiAchievementsAchievementIdImagePostToJson(
        this,
      );

  @JsonKey(name: 'image')
  final String image;
  static const fromJsonFactory =
      _$BodyUploadAchievementImageApiAchievementsAchievementIdImagePostFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BodyUploadAchievementImageApiAchievementsAchievementIdImagePost &&
            (identical(other.image, image) ||
                const DeepCollectionEquality().equals(other.image, image)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(image) ^ runtimeType.hashCode;
}

extension $BodyUploadAchievementImageApiAchievementsAchievementIdImagePostExtension
    on BodyUploadAchievementImageApiAchievementsAchievementIdImagePost {
  BodyUploadAchievementImageApiAchievementsAchievementIdImagePost copyWith({
    String? image,
  }) {
    return BodyUploadAchievementImageApiAchievementsAchievementIdImagePost(
      image: image ?? this.image,
    );
  }

  BodyUploadAchievementImageApiAchievementsAchievementIdImagePost
  copyWithWrapped({Wrapped<String>? image}) {
    return BodyUploadAchievementImageApiAchievementsAchievementIdImagePost(
      image: (image != null ? image.value : this.image),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CheckpointCurrentView {
  const CheckpointCurrentView({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.task,
    required this.hint,
    required this.pointRules,
  });

  factory CheckpointCurrentView.fromJson(Map<String, dynamic> json) =>
      _$CheckpointCurrentViewFromJson(json);

  static const toJsonFactory = _$CheckpointCurrentViewToJson;
  Map<String, dynamic> toJson() => _$CheckpointCurrentViewToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'task')
  final String task;
  @JsonKey(name: 'hint')
  final String? hint;
  @JsonKey(name: 'point_rules')
  final String? pointRules;
  static const fromJsonFactory = _$CheckpointCurrentViewFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CheckpointCurrentView &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality().equals(
                  other.latitude,
                  latitude,
                )) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality().equals(
                  other.longitude,
                  longitude,
                )) &&
            (identical(other.task, task) ||
                const DeepCollectionEquality().equals(other.task, task)) &&
            (identical(other.hint, hint) ||
                const DeepCollectionEquality().equals(other.hint, hint)) &&
            (identical(other.pointRules, pointRules) ||
                const DeepCollectionEquality().equals(
                  other.pointRules,
                  pointRules,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      const DeepCollectionEquality().hash(task) ^
      const DeepCollectionEquality().hash(hint) ^
      const DeepCollectionEquality().hash(pointRules) ^
      runtimeType.hashCode;
}

extension $CheckpointCurrentViewExtension on CheckpointCurrentView {
  CheckpointCurrentView copyWith({
    int? id,
    String? title,
    double? latitude,
    double? longitude,
    String? task,
    String? hint,
    String? pointRules,
  }) {
    return CheckpointCurrentView(
      id: id ?? this.id,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      task: task ?? this.task,
      hint: hint ?? this.hint,
      pointRules: pointRules ?? this.pointRules,
    );
  }

  CheckpointCurrentView copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? title,
    Wrapped<double>? latitude,
    Wrapped<double>? longitude,
    Wrapped<String>? task,
    Wrapped<String?>? hint,
    Wrapped<String?>? pointRules,
  }) {
    return CheckpointCurrentView(
      id: (id != null ? id.value : this.id),
      title: (title != null ? title.value : this.title),
      latitude: (latitude != null ? latitude.value : this.latitude),
      longitude: (longitude != null ? longitude.value : this.longitude),
      task: (task != null ? task.value : this.task),
      hint: (hint != null ? hint.value : this.hint),
      pointRules: (pointRules != null ? pointRules.value : this.pointRules),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CheckpointPassedView {
  const CheckpointPassedView({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  factory CheckpointPassedView.fromJson(Map<String, dynamic> json) =>
      _$CheckpointPassedViewFromJson(json);

  static const toJsonFactory = _$CheckpointPassedViewToJson;
  Map<String, dynamic> toJson() => _$CheckpointPassedViewToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  static const fromJsonFactory = _$CheckpointPassedViewFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CheckpointPassedView &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality().equals(
                  other.latitude,
                  latitude,
                )) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality().equals(
                  other.longitude,
                  longitude,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      runtimeType.hashCode;
}

extension $CheckpointPassedViewExtension on CheckpointPassedView {
  CheckpointPassedView copyWith({
    int? id,
    String? title,
    double? latitude,
    double? longitude,
  }) {
    return CheckpointPassedView(
      id: id ?? this.id,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  CheckpointPassedView copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? title,
    Wrapped<double>? latitude,
    Wrapped<double>? longitude,
  }) {
    return CheckpointPassedView(
      id: (id != null ? id.value : this.id),
      title: (title != null ? title.value : this.title),
      latitude: (latitude != null ? latitude.value : this.latitude),
      longitude: (longitude != null ? longitude.value : this.longitude),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class HTTPValidationError {
  const HTTPValidationError({this.detail});

  factory HTTPValidationError.fromJson(Map<String, dynamic> json) =>
      _$HTTPValidationErrorFromJson(json);

  static const toJsonFactory = _$HTTPValidationErrorToJson;
  Map<String, dynamic> toJson() => _$HTTPValidationErrorToJson(this);

  @JsonKey(name: 'detail', defaultValue: <ValidationError>[])
  final List<ValidationError>? detail;
  static const fromJsonFactory = _$HTTPValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HTTPValidationError &&
            (identical(other.detail, detail) ||
                const DeepCollectionEquality().equals(other.detail, detail)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(detail) ^ runtimeType.hashCode;
}

extension $HTTPValidationErrorExtension on HTTPValidationError {
  HTTPValidationError copyWith({List<ValidationError>? detail}) {
    return HTTPValidationError(detail: detail ?? this.detail);
  }

  HTTPValidationError copyWithWrapped({
    Wrapped<List<ValidationError>?>? detail,
  }) {
    return HTTPValidationError(
      detail: (detail != null ? detail.value : this.detail),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  static const toJsonFactory = _$LoginRequestToJson;
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$LoginRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginRequest &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $LoginRequestExtension on LoginRequest {
  LoginRequest copyWith({String? email, String? password}) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  LoginRequest copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<String>? password,
  }) {
    return LoginRequest(
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestArchiveStatusUpdateRequest {
  const QuestArchiveStatusUpdateRequest({required this.status});

  factory QuestArchiveStatusUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$QuestArchiveStatusUpdateRequestFromJson(json);

  static const toJsonFactory = _$QuestArchiveStatusUpdateRequestToJson;
  Map<String, dynamic> toJson() =>
      _$QuestArchiveStatusUpdateRequestToJson(this);

  @JsonKey(
    name: 'status',
    toJson: questArchiveStatusSchemaToJson,
    fromJson: questArchiveStatusSchemaFromJson,
  )
  final enums.QuestArchiveStatusSchema status;
  static const fromJsonFactory = _$QuestArchiveStatusUpdateRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestArchiveStatusUpdateRequest &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^ runtimeType.hashCode;
}

extension $QuestArchiveStatusUpdateRequestExtension
    on QuestArchiveStatusUpdateRequest {
  QuestArchiveStatusUpdateRequest copyWith({
    enums.QuestArchiveStatusSchema? status,
  }) {
    return QuestArchiveStatusUpdateRequest(status: status ?? this.status);
  }

  QuestArchiveStatusUpdateRequest copyWithWrapped({
    Wrapped<enums.QuestArchiveStatusSchema>? status,
  }) {
    return QuestArchiveStatusUpdateRequest(
      status: (status != null ? status.value : this.status),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestComplaintAuthorResponse {
  const QuestComplaintAuthorResponse({
    required this.id,
    required this.username,
  });

  factory QuestComplaintAuthorResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestComplaintAuthorResponseFromJson(json);

  static const toJsonFactory = _$QuestComplaintAuthorResponseToJson;
  Map<String, dynamic> toJson() => _$QuestComplaintAuthorResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'username')
  final String username;
  static const fromJsonFactory = _$QuestComplaintAuthorResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestComplaintAuthorResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality().equals(
                  other.username,
                  username,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(username) ^
      runtimeType.hashCode;
}

extension $QuestComplaintAuthorResponseExtension
    on QuestComplaintAuthorResponse {
  QuestComplaintAuthorResponse copyWith({int? id, String? username}) {
    return QuestComplaintAuthorResponse(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }

  QuestComplaintAuthorResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? username,
  }) {
    return QuestComplaintAuthorResponse(
      id: (id != null ? id.value : this.id),
      username: (username != null ? username.value : this.username),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestComplaintCreateRequest {
  const QuestComplaintCreateRequest({required this.reason});

  factory QuestComplaintCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$QuestComplaintCreateRequestFromJson(json);

  static const toJsonFactory = _$QuestComplaintCreateRequestToJson;
  Map<String, dynamic> toJson() => _$QuestComplaintCreateRequestToJson(this);

  @JsonKey(name: 'reason')
  final String reason;
  static const fromJsonFactory = _$QuestComplaintCreateRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestComplaintCreateRequest &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(reason) ^ runtimeType.hashCode;
}

extension $QuestComplaintCreateRequestExtension on QuestComplaintCreateRequest {
  QuestComplaintCreateRequest copyWith({String? reason}) {
    return QuestComplaintCreateRequest(reason: reason ?? this.reason);
  }

  QuestComplaintCreateRequest copyWithWrapped({Wrapped<String>? reason}) {
    return QuestComplaintCreateRequest(
      reason: (reason != null ? reason.value : this.reason),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestComplaintPageResponse {
  const QuestComplaintPageResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory QuestComplaintPageResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestComplaintPageResponseFromJson(json);

  static const toJsonFactory = _$QuestComplaintPageResponseToJson;
  Map<String, dynamic> toJson() => _$QuestComplaintPageResponseToJson(this);

  @JsonKey(name: 'items', defaultValue: <QuestComplaintResponse>[])
  final List<QuestComplaintResponse> items;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'offset')
  final int offset;
  static const fromJsonFactory = _$QuestComplaintPageResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestComplaintPageResponse &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.offset, offset) ||
                const DeepCollectionEquality().equals(other.offset, offset)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(offset) ^
      runtimeType.hashCode;
}

extension $QuestComplaintPageResponseExtension on QuestComplaintPageResponse {
  QuestComplaintPageResponse copyWith({
    List<QuestComplaintResponse>? items,
    int? total,
    int? limit,
    int? offset,
  }) {
    return QuestComplaintPageResponse(
      items: items ?? this.items,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  QuestComplaintPageResponse copyWithWrapped({
    Wrapped<List<QuestComplaintResponse>>? items,
    Wrapped<int>? total,
    Wrapped<int>? limit,
    Wrapped<int>? offset,
  }) {
    return QuestComplaintPageResponse(
      items: (items != null ? items.value : this.items),
      total: (total != null ? total.value : this.total),
      limit: (limit != null ? limit.value : this.limit),
      offset: (offset != null ? offset.value : this.offset),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestComplaintResponse {
  const QuestComplaintResponse({
    required this.id,
    required this.reason,
    required this.questId,
    required this.author,
  });

  factory QuestComplaintResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestComplaintResponseFromJson(json);

  static const toJsonFactory = _$QuestComplaintResponseToJson;
  Map<String, dynamic> toJson() => _$QuestComplaintResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'reason')
  final String reason;
  @JsonKey(name: 'quest_id')
  final int questId;
  @JsonKey(name: 'author')
  final QuestComplaintAuthorResponse author;
  static const fromJsonFactory = _$QuestComplaintResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestComplaintResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)) &&
            (identical(other.questId, questId) ||
                const DeepCollectionEquality().equals(
                  other.questId,
                  questId,
                )) &&
            (identical(other.author, author) ||
                const DeepCollectionEquality().equals(other.author, author)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(reason) ^
      const DeepCollectionEquality().hash(questId) ^
      const DeepCollectionEquality().hash(author) ^
      runtimeType.hashCode;
}

extension $QuestComplaintResponseExtension on QuestComplaintResponse {
  QuestComplaintResponse copyWith({
    int? id,
    String? reason,
    int? questId,
    QuestComplaintAuthorResponse? author,
  }) {
    return QuestComplaintResponse(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      questId: questId ?? this.questId,
      author: author ?? this.author,
    );
  }

  QuestComplaintResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? reason,
    Wrapped<int>? questId,
    Wrapped<QuestComplaintAuthorResponse>? author,
  }) {
    return QuestComplaintResponse(
      id: (id != null ? id.value : this.id),
      reason: (reason != null ? reason.value : this.reason),
      questId: (questId != null ? questId.value : this.questId),
      author: (author != null ? author.value : this.author),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestCreatorResponse {
  const QuestCreatorResponse({
    required this.id,
    required this.username,
    this.teamName,
  });

  factory QuestCreatorResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestCreatorResponseFromJson(json);

  static const toJsonFactory = _$QuestCreatorResponseToJson;
  Map<String, dynamic> toJson() => _$QuestCreatorResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'team_name')
  final String? teamName;
  static const fromJsonFactory = _$QuestCreatorResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestCreatorResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality().equals(
                  other.username,
                  username,
                )) &&
            (identical(other.teamName, teamName) ||
                const DeepCollectionEquality().equals(
                  other.teamName,
                  teamName,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(teamName) ^
      runtimeType.hashCode;
}

extension $QuestCreatorResponseExtension on QuestCreatorResponse {
  QuestCreatorResponse copyWith({int? id, String? username, String? teamName}) {
    return QuestCreatorResponse(
      id: id ?? this.id,
      username: username ?? this.username,
      teamName: teamName ?? this.teamName,
    );
  }

  QuestCreatorResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? username,
    Wrapped<String?>? teamName,
  }) {
    return QuestCreatorResponse(
      id: (id != null ? id.value : this.id),
      username: (username != null ? username.value : this.username),
      teamName: (teamName != null ? teamName.value : this.teamName),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestDetailResponse {
  const QuestDetailResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.difficulty,
    required this.durationMinutes,
    required this.rulesAndWarnings,
    required this.imageFileId,
    required this.rejectionReason,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.creator,
    this.isFavourite,
    this.isCompleted,
    required this.points,
  });

  factory QuestDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestDetailResponseFromJson(json);

  static const toJsonFactory = _$QuestDetailResponseToJson;
  Map<String, dynamic> toJson() => _$QuestDetailResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'location')
  final String location;
  @JsonKey(name: 'difficulty')
  final int difficulty;
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @JsonKey(name: 'rules_and_warnings')
  final String? rulesAndWarnings;
  @JsonKey(name: 'image_file_id')
  final String? imageFileId;
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @JsonKey(
    name: 'status',
    toJson: questStatusSchemaToJson,
    fromJson: questStatusSchemaFromJson,
  )
  final enums.QuestStatusSchema status;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'creator')
  final QuestCreatorResponse creator;
  @JsonKey(name: 'is_favourite', defaultValue: false)
  final bool? isFavourite;
  @JsonKey(name: 'is_completed', defaultValue: false)
  final bool? isCompleted;
  @JsonKey(name: 'points', defaultValue: <QuestPointResponse>[])
  final List<QuestPointResponse> points;
  static const fromJsonFactory = _$QuestDetailResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestDetailResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality().equals(
                  other.location,
                  location,
                )) &&
            (identical(other.difficulty, difficulty) ||
                const DeepCollectionEquality().equals(
                  other.difficulty,
                  difficulty,
                )) &&
            (identical(other.durationMinutes, durationMinutes) ||
                const DeepCollectionEquality().equals(
                  other.durationMinutes,
                  durationMinutes,
                )) &&
            (identical(other.rulesAndWarnings, rulesAndWarnings) ||
                const DeepCollectionEquality().equals(
                  other.rulesAndWarnings,
                  rulesAndWarnings,
                )) &&
            (identical(other.imageFileId, imageFileId) ||
                const DeepCollectionEquality().equals(
                  other.imageFileId,
                  imageFileId,
                )) &&
            (identical(other.rejectionReason, rejectionReason) ||
                const DeepCollectionEquality().equals(
                  other.rejectionReason,
                  rejectionReason,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality().equals(
                  other.latitude,
                  latitude,
                )) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality().equals(
                  other.longitude,
                  longitude,
                )) &&
            (identical(other.creator, creator) ||
                const DeepCollectionEquality().equals(
                  other.creator,
                  creator,
                )) &&
            (identical(other.isFavourite, isFavourite) ||
                const DeepCollectionEquality().equals(
                  other.isFavourite,
                  isFavourite,
                )) &&
            (identical(other.isCompleted, isCompleted) ||
                const DeepCollectionEquality().equals(
                  other.isCompleted,
                  isCompleted,
                )) &&
            (identical(other.points, points) ||
                const DeepCollectionEquality().equals(other.points, points)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(difficulty) ^
      const DeepCollectionEquality().hash(durationMinutes) ^
      const DeepCollectionEquality().hash(rulesAndWarnings) ^
      const DeepCollectionEquality().hash(imageFileId) ^
      const DeepCollectionEquality().hash(rejectionReason) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      const DeepCollectionEquality().hash(creator) ^
      const DeepCollectionEquality().hash(isFavourite) ^
      const DeepCollectionEquality().hash(isCompleted) ^
      const DeepCollectionEquality().hash(points) ^
      runtimeType.hashCode;
}

extension $QuestDetailResponseExtension on QuestDetailResponse {
  QuestDetailResponse copyWith({
    int? id,
    String? title,
    String? description,
    String? location,
    int? difficulty,
    int? durationMinutes,
    String? rulesAndWarnings,
    String? imageFileId,
    String? rejectionReason,
    enums.QuestStatusSchema? status,
    double? latitude,
    double? longitude,
    QuestCreatorResponse? creator,
    bool? isFavourite,
    bool? isCompleted,
    List<QuestPointResponse>? points,
  }) {
    return QuestDetailResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rulesAndWarnings: rulesAndWarnings ?? this.rulesAndWarnings,
      imageFileId: imageFileId ?? this.imageFileId,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      creator: creator ?? this.creator,
      isFavourite: isFavourite ?? this.isFavourite,
      isCompleted: isCompleted ?? this.isCompleted,
      points: points ?? this.points,
    );
  }

  QuestDetailResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? title,
    Wrapped<String>? description,
    Wrapped<String>? location,
    Wrapped<int>? difficulty,
    Wrapped<int>? durationMinutes,
    Wrapped<String?>? rulesAndWarnings,
    Wrapped<String?>? imageFileId,
    Wrapped<String?>? rejectionReason,
    Wrapped<enums.QuestStatusSchema>? status,
    Wrapped<double>? latitude,
    Wrapped<double>? longitude,
    Wrapped<QuestCreatorResponse>? creator,
    Wrapped<bool?>? isFavourite,
    Wrapped<bool?>? isCompleted,
    Wrapped<List<QuestPointResponse>>? points,
  }) {
    return QuestDetailResponse(
      id: (id != null ? id.value : this.id),
      title: (title != null ? title.value : this.title),
      description: (description != null ? description.value : this.description),
      location: (location != null ? location.value : this.location),
      difficulty: (difficulty != null ? difficulty.value : this.difficulty),
      durationMinutes: (durationMinutes != null
          ? durationMinutes.value
          : this.durationMinutes),
      rulesAndWarnings: (rulesAndWarnings != null
          ? rulesAndWarnings.value
          : this.rulesAndWarnings),
      imageFileId: (imageFileId != null ? imageFileId.value : this.imageFileId),
      rejectionReason: (rejectionReason != null
          ? rejectionReason.value
          : this.rejectionReason),
      status: (status != null ? status.value : this.status),
      latitude: (latitude != null ? latitude.value : this.latitude),
      longitude: (longitude != null ? longitude.value : this.longitude),
      creator: (creator != null ? creator.value : this.creator),
      isFavourite: (isFavourite != null ? isFavourite.value : this.isFavourite),
      isCompleted: (isCompleted != null ? isCompleted.value : this.isCompleted),
      points: (points != null ? points.value : this.points),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestPageResponse {
  const QuestPageResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory QuestPageResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestPageResponseFromJson(json);

  static const toJsonFactory = _$QuestPageResponseToJson;
  Map<String, dynamic> toJson() => _$QuestPageResponseToJson(this);

  @JsonKey(name: 'items', defaultValue: <QuestResponse>[])
  final List<QuestResponse> items;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'offset')
  final int offset;
  static const fromJsonFactory = _$QuestPageResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestPageResponse &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.offset, offset) ||
                const DeepCollectionEquality().equals(other.offset, offset)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(offset) ^
      runtimeType.hashCode;
}

extension $QuestPageResponseExtension on QuestPageResponse {
  QuestPageResponse copyWith({
    List<QuestResponse>? items,
    int? total,
    int? limit,
    int? offset,
  }) {
    return QuestPageResponse(
      items: items ?? this.items,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  QuestPageResponse copyWithWrapped({
    Wrapped<List<QuestResponse>>? items,
    Wrapped<int>? total,
    Wrapped<int>? limit,
    Wrapped<int>? offset,
  }) {
    return QuestPageResponse(
      items: (items != null ? items.value : this.items),
      total: (total != null ? total.value : this.total),
      limit: (limit != null ? limit.value : this.limit),
      offset: (offset != null ? offset.value : this.offset),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestPointResponse {
  const QuestPointResponse({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.task,
    required this.correctAnswer,
    required this.hint,
    required this.pointRules,
  });

  factory QuestPointResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestPointResponseFromJson(json);

  static const toJsonFactory = _$QuestPointResponseToJson;
  Map<String, dynamic> toJson() => _$QuestPointResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'task')
  final String task;
  @JsonKey(name: 'correct_answer')
  final String correctAnswer;
  @JsonKey(name: 'hint')
  final String? hint;
  @JsonKey(name: 'point_rules')
  final String? pointRules;
  static const fromJsonFactory = _$QuestPointResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestPointResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality().equals(
                  other.latitude,
                  latitude,
                )) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality().equals(
                  other.longitude,
                  longitude,
                )) &&
            (identical(other.task, task) ||
                const DeepCollectionEquality().equals(other.task, task)) &&
            (identical(other.correctAnswer, correctAnswer) ||
                const DeepCollectionEquality().equals(
                  other.correctAnswer,
                  correctAnswer,
                )) &&
            (identical(other.hint, hint) ||
                const DeepCollectionEquality().equals(other.hint, hint)) &&
            (identical(other.pointRules, pointRules) ||
                const DeepCollectionEquality().equals(
                  other.pointRules,
                  pointRules,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      const DeepCollectionEquality().hash(task) ^
      const DeepCollectionEquality().hash(correctAnswer) ^
      const DeepCollectionEquality().hash(hint) ^
      const DeepCollectionEquality().hash(pointRules) ^
      runtimeType.hashCode;
}

extension $QuestPointResponseExtension on QuestPointResponse {
  QuestPointResponse copyWith({
    int? id,
    String? title,
    double? latitude,
    double? longitude,
    String? task,
    String? correctAnswer,
    String? hint,
    String? pointRules,
  }) {
    return QuestPointResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      task: task ?? this.task,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      hint: hint ?? this.hint,
      pointRules: pointRules ?? this.pointRules,
    );
  }

  QuestPointResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? title,
    Wrapped<double>? latitude,
    Wrapped<double>? longitude,
    Wrapped<String>? task,
    Wrapped<String>? correctAnswer,
    Wrapped<String?>? hint,
    Wrapped<String?>? pointRules,
  }) {
    return QuestPointResponse(
      id: (id != null ? id.value : this.id),
      title: (title != null ? title.value : this.title),
      latitude: (latitude != null ? latitude.value : this.latitude),
      longitude: (longitude != null ? longitude.value : this.longitude),
      task: (task != null ? task.value : this.task),
      correctAnswer: (correctAnswer != null
          ? correctAnswer.value
          : this.correctAnswer),
      hint: (hint != null ? hint.value : this.hint),
      pointRules: (pointRules != null ? pointRules.value : this.pointRules),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestRejectRequest {
  const QuestRejectRequest({required this.reason});

  factory QuestRejectRequest.fromJson(Map<String, dynamic> json) =>
      _$QuestRejectRequestFromJson(json);

  static const toJsonFactory = _$QuestRejectRequestToJson;
  Map<String, dynamic> toJson() => _$QuestRejectRequestToJson(this);

  @JsonKey(name: 'reason')
  final String reason;
  static const fromJsonFactory = _$QuestRejectRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestRejectRequest &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(reason) ^ runtimeType.hashCode;
}

extension $QuestRejectRequestExtension on QuestRejectRequest {
  QuestRejectRequest copyWith({String? reason}) {
    return QuestRejectRequest(reason: reason ?? this.reason);
  }

  QuestRejectRequest copyWithWrapped({Wrapped<String>? reason}) {
    return QuestRejectRequest(
      reason: (reason != null ? reason.value : this.reason),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestResponse {
  const QuestResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.difficulty,
    required this.durationMinutes,
    required this.rulesAndWarnings,
    required this.imageFileId,
    required this.rejectionReason,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.creator,
    this.isFavourite,
    this.isCompleted,
  });

  factory QuestResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestResponseFromJson(json);

  static const toJsonFactory = _$QuestResponseToJson;
  Map<String, dynamic> toJson() => _$QuestResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'location')
  final String location;
  @JsonKey(name: 'difficulty')
  final int difficulty;
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @JsonKey(name: 'rules_and_warnings')
  final String? rulesAndWarnings;
  @JsonKey(name: 'image_file_id')
  final String? imageFileId;
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @JsonKey(
    name: 'status',
    toJson: questStatusSchemaToJson,
    fromJson: questStatusSchemaFromJson,
  )
  final enums.QuestStatusSchema status;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'creator')
  final QuestCreatorResponse creator;
  @JsonKey(name: 'is_favourite', defaultValue: false)
  final bool? isFavourite;
  @JsonKey(name: 'is_completed', defaultValue: false)
  final bool? isCompleted;
  static const fromJsonFactory = _$QuestResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality().equals(
                  other.location,
                  location,
                )) &&
            (identical(other.difficulty, difficulty) ||
                const DeepCollectionEquality().equals(
                  other.difficulty,
                  difficulty,
                )) &&
            (identical(other.durationMinutes, durationMinutes) ||
                const DeepCollectionEquality().equals(
                  other.durationMinutes,
                  durationMinutes,
                )) &&
            (identical(other.rulesAndWarnings, rulesAndWarnings) ||
                const DeepCollectionEquality().equals(
                  other.rulesAndWarnings,
                  rulesAndWarnings,
                )) &&
            (identical(other.imageFileId, imageFileId) ||
                const DeepCollectionEquality().equals(
                  other.imageFileId,
                  imageFileId,
                )) &&
            (identical(other.rejectionReason, rejectionReason) ||
                const DeepCollectionEquality().equals(
                  other.rejectionReason,
                  rejectionReason,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality().equals(
                  other.latitude,
                  latitude,
                )) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality().equals(
                  other.longitude,
                  longitude,
                )) &&
            (identical(other.creator, creator) ||
                const DeepCollectionEquality().equals(
                  other.creator,
                  creator,
                )) &&
            (identical(other.isFavourite, isFavourite) ||
                const DeepCollectionEquality().equals(
                  other.isFavourite,
                  isFavourite,
                )) &&
            (identical(other.isCompleted, isCompleted) ||
                const DeepCollectionEquality().equals(
                  other.isCompleted,
                  isCompleted,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(difficulty) ^
      const DeepCollectionEquality().hash(durationMinutes) ^
      const DeepCollectionEquality().hash(rulesAndWarnings) ^
      const DeepCollectionEquality().hash(imageFileId) ^
      const DeepCollectionEquality().hash(rejectionReason) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      const DeepCollectionEquality().hash(creator) ^
      const DeepCollectionEquality().hash(isFavourite) ^
      const DeepCollectionEquality().hash(isCompleted) ^
      runtimeType.hashCode;
}

extension $QuestResponseExtension on QuestResponse {
  QuestResponse copyWith({
    int? id,
    String? title,
    String? description,
    String? location,
    int? difficulty,
    int? durationMinutes,
    String? rulesAndWarnings,
    String? imageFileId,
    String? rejectionReason,
    enums.QuestStatusSchema? status,
    double? latitude,
    double? longitude,
    QuestCreatorResponse? creator,
    bool? isFavourite,
    bool? isCompleted,
  }) {
    return QuestResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rulesAndWarnings: rulesAndWarnings ?? this.rulesAndWarnings,
      imageFileId: imageFileId ?? this.imageFileId,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      creator: creator ?? this.creator,
      isFavourite: isFavourite ?? this.isFavourite,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  QuestResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? title,
    Wrapped<String>? description,
    Wrapped<String>? location,
    Wrapped<int>? difficulty,
    Wrapped<int>? durationMinutes,
    Wrapped<String?>? rulesAndWarnings,
    Wrapped<String?>? imageFileId,
    Wrapped<String?>? rejectionReason,
    Wrapped<enums.QuestStatusSchema>? status,
    Wrapped<double>? latitude,
    Wrapped<double>? longitude,
    Wrapped<QuestCreatorResponse>? creator,
    Wrapped<bool?>? isFavourite,
    Wrapped<bool?>? isCompleted,
  }) {
    return QuestResponse(
      id: (id != null ? id.value : this.id),
      title: (title != null ? title.value : this.title),
      description: (description != null ? description.value : this.description),
      location: (location != null ? location.value : this.location),
      difficulty: (difficulty != null ? difficulty.value : this.difficulty),
      durationMinutes: (durationMinutes != null
          ? durationMinutes.value
          : this.durationMinutes),
      rulesAndWarnings: (rulesAndWarnings != null
          ? rulesAndWarnings.value
          : this.rulesAndWarnings),
      imageFileId: (imageFileId != null ? imageFileId.value : this.imageFileId),
      rejectionReason: (rejectionReason != null
          ? rejectionReason.value
          : this.rejectionReason),
      status: (status != null ? status.value : this.status),
      latitude: (latitude != null ? latitude.value : this.latitude),
      longitude: (longitude != null ? longitude.value : this.longitude),
      creator: (creator != null ? creator.value : this.creator),
      isFavourite: (isFavourite != null ? isFavourite.value : this.isFavourite),
      isCompleted: (isCompleted != null ? isCompleted.value : this.isCompleted),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestRunAnswerRequest {
  const QuestRunAnswerRequest({required this.answer});

  factory QuestRunAnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$QuestRunAnswerRequestFromJson(json);

  static const toJsonFactory = _$QuestRunAnswerRequestToJson;
  Map<String, dynamic> toJson() => _$QuestRunAnswerRequestToJson(this);

  @JsonKey(name: 'answer')
  final String answer;
  static const fromJsonFactory = _$QuestRunAnswerRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestRunAnswerRequest &&
            (identical(other.answer, answer) ||
                const DeepCollectionEquality().equals(other.answer, answer)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(answer) ^ runtimeType.hashCode;
}

extension $QuestRunAnswerRequestExtension on QuestRunAnswerRequest {
  QuestRunAnswerRequest copyWith({String? answer}) {
    return QuestRunAnswerRequest(answer: answer ?? this.answer);
  }

  QuestRunAnswerRequest copyWithWrapped({Wrapped<String>? answer}) {
    return QuestRunAnswerRequest(
      answer: (answer != null ? answer.value : this.answer),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestRunAnswerResponse {
  const QuestRunAnswerResponse({
    required this.correct,
    required this.progress,
    this.pointsEarned,
  });

  factory QuestRunAnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestRunAnswerResponseFromJson(json);

  static const toJsonFactory = _$QuestRunAnswerResponseToJson;
  Map<String, dynamic> toJson() => _$QuestRunAnswerResponseToJson(this);

  @JsonKey(name: 'correct')
  final bool correct;
  @JsonKey(name: 'progress')
  final QuestRunProgressResponse progress;
  @JsonKey(name: 'points_earned')
  final int? pointsEarned;
  static const fromJsonFactory = _$QuestRunAnswerResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestRunAnswerResponse &&
            (identical(other.correct, correct) ||
                const DeepCollectionEquality().equals(
                  other.correct,
                  correct,
                )) &&
            (identical(other.progress, progress) ||
                const DeepCollectionEquality().equals(
                  other.progress,
                  progress,
                )) &&
            (identical(other.pointsEarned, pointsEarned) ||
                const DeepCollectionEquality().equals(
                  other.pointsEarned,
                  pointsEarned,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(correct) ^
      const DeepCollectionEquality().hash(progress) ^
      const DeepCollectionEquality().hash(pointsEarned) ^
      runtimeType.hashCode;
}

extension $QuestRunAnswerResponseExtension on QuestRunAnswerResponse {
  QuestRunAnswerResponse copyWith({
    bool? correct,
    QuestRunProgressResponse? progress,
    int? pointsEarned,
  }) {
    return QuestRunAnswerResponse(
      correct: correct ?? this.correct,
      progress: progress ?? this.progress,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }

  QuestRunAnswerResponse copyWithWrapped({
    Wrapped<bool>? correct,
    Wrapped<QuestRunProgressResponse>? progress,
    Wrapped<int?>? pointsEarned,
  }) {
    return QuestRunAnswerResponse(
      correct: (correct != null ? correct.value : this.correct),
      progress: (progress != null ? progress.value : this.progress),
      pointsEarned: (pointsEarned != null
          ? pointsEarned.value
          : this.pointsEarned),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestRunHistoryItem {
  const QuestRunHistoryItem({
    required this.runId,
    required this.questId,
    required this.questTitle,
    required this.status,
    required this.startedAt,
    required this.completedAt,
    required this.pointsAwarded,
  });

  factory QuestRunHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$QuestRunHistoryItemFromJson(json);

  static const toJsonFactory = _$QuestRunHistoryItemToJson;
  Map<String, dynamic> toJson() => _$QuestRunHistoryItemToJson(this);

  @JsonKey(name: 'run_id')
  final int runId;
  @JsonKey(name: 'quest_id')
  final int questId;
  @JsonKey(name: 'quest_title')
  final String questTitle;
  @JsonKey(
    name: 'status',
    toJson: questRunStatusSchemaToJson,
    fromJson: questRunStatusSchemaFromJson,
  )
  final enums.QuestRunStatusSchema status;
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @JsonKey(name: 'completed_at')
  final DateTime completedAt;
  @JsonKey(name: 'points_awarded')
  final int pointsAwarded;
  static const fromJsonFactory = _$QuestRunHistoryItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestRunHistoryItem &&
            (identical(other.runId, runId) ||
                const DeepCollectionEquality().equals(other.runId, runId)) &&
            (identical(other.questId, questId) ||
                const DeepCollectionEquality().equals(
                  other.questId,
                  questId,
                )) &&
            (identical(other.questTitle, questTitle) ||
                const DeepCollectionEquality().equals(
                  other.questTitle,
                  questTitle,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.startedAt, startedAt) ||
                const DeepCollectionEquality().equals(
                  other.startedAt,
                  startedAt,
                )) &&
            (identical(other.completedAt, completedAt) ||
                const DeepCollectionEquality().equals(
                  other.completedAt,
                  completedAt,
                )) &&
            (identical(other.pointsAwarded, pointsAwarded) ||
                const DeepCollectionEquality().equals(
                  other.pointsAwarded,
                  pointsAwarded,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(runId) ^
      const DeepCollectionEquality().hash(questId) ^
      const DeepCollectionEquality().hash(questTitle) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(startedAt) ^
      const DeepCollectionEquality().hash(completedAt) ^
      const DeepCollectionEquality().hash(pointsAwarded) ^
      runtimeType.hashCode;
}

extension $QuestRunHistoryItemExtension on QuestRunHistoryItem {
  QuestRunHistoryItem copyWith({
    int? runId,
    int? questId,
    String? questTitle,
    enums.QuestRunStatusSchema? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? pointsAwarded,
  }) {
    return QuestRunHistoryItem(
      runId: runId ?? this.runId,
      questId: questId ?? this.questId,
      questTitle: questTitle ?? this.questTitle,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
    );
  }

  QuestRunHistoryItem copyWithWrapped({
    Wrapped<int>? runId,
    Wrapped<int>? questId,
    Wrapped<String>? questTitle,
    Wrapped<enums.QuestRunStatusSchema>? status,
    Wrapped<DateTime>? startedAt,
    Wrapped<DateTime>? completedAt,
    Wrapped<int>? pointsAwarded,
  }) {
    return QuestRunHistoryItem(
      runId: (runId != null ? runId.value : this.runId),
      questId: (questId != null ? questId.value : this.questId),
      questTitle: (questTitle != null ? questTitle.value : this.questTitle),
      status: (status != null ? status.value : this.status),
      startedAt: (startedAt != null ? startedAt.value : this.startedAt),
      completedAt: (completedAt != null ? completedAt.value : this.completedAt),
      pointsAwarded: (pointsAwarded != null
          ? pointsAwarded.value
          : this.pointsAwarded),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestRunProgressResponse {
  const QuestRunProgressResponse({
    required this.runId,
    required this.questId,
    required this.status,
    required this.startedAt,
    required this.completedAt,
    required this.totalCheckpoints,
    required this.currentStepIndex,
    required this.previousCheckpoints,
    required this.currentCheckpoint,
    required this.pointsAwarded,
  });

  factory QuestRunProgressResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestRunProgressResponseFromJson(json);

  static const toJsonFactory = _$QuestRunProgressResponseToJson;
  Map<String, dynamic> toJson() => _$QuestRunProgressResponseToJson(this);

  @JsonKey(name: 'run_id')
  final int runId;
  @JsonKey(name: 'quest_id')
  final int questId;
  @JsonKey(
    name: 'status',
    toJson: questRunStatusSchemaToJson,
    fromJson: questRunStatusSchemaFromJson,
  )
  final enums.QuestRunStatusSchema status;
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @JsonKey(name: 'total_checkpoints')
  final int totalCheckpoints;
  @JsonKey(name: 'current_step_index')
  final int currentStepIndex;
  @JsonKey(name: 'previous_checkpoints', defaultValue: <CheckpointPassedView>[])
  final List<CheckpointPassedView> previousCheckpoints;
  @JsonKey(name: 'current_checkpoint')
  final CheckpointCurrentView? currentCheckpoint;
  @JsonKey(name: 'points_awarded')
  final int? pointsAwarded;
  static const fromJsonFactory = _$QuestRunProgressResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestRunProgressResponse &&
            (identical(other.runId, runId) ||
                const DeepCollectionEquality().equals(other.runId, runId)) &&
            (identical(other.questId, questId) ||
                const DeepCollectionEquality().equals(
                  other.questId,
                  questId,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.startedAt, startedAt) ||
                const DeepCollectionEquality().equals(
                  other.startedAt,
                  startedAt,
                )) &&
            (identical(other.completedAt, completedAt) ||
                const DeepCollectionEquality().equals(
                  other.completedAt,
                  completedAt,
                )) &&
            (identical(other.totalCheckpoints, totalCheckpoints) ||
                const DeepCollectionEquality().equals(
                  other.totalCheckpoints,
                  totalCheckpoints,
                )) &&
            (identical(other.currentStepIndex, currentStepIndex) ||
                const DeepCollectionEquality().equals(
                  other.currentStepIndex,
                  currentStepIndex,
                )) &&
            (identical(other.previousCheckpoints, previousCheckpoints) ||
                const DeepCollectionEquality().equals(
                  other.previousCheckpoints,
                  previousCheckpoints,
                )) &&
            (identical(other.currentCheckpoint, currentCheckpoint) ||
                const DeepCollectionEquality().equals(
                  other.currentCheckpoint,
                  currentCheckpoint,
                )) &&
            (identical(other.pointsAwarded, pointsAwarded) ||
                const DeepCollectionEquality().equals(
                  other.pointsAwarded,
                  pointsAwarded,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(runId) ^
      const DeepCollectionEquality().hash(questId) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(startedAt) ^
      const DeepCollectionEquality().hash(completedAt) ^
      const DeepCollectionEquality().hash(totalCheckpoints) ^
      const DeepCollectionEquality().hash(currentStepIndex) ^
      const DeepCollectionEquality().hash(previousCheckpoints) ^
      const DeepCollectionEquality().hash(currentCheckpoint) ^
      const DeepCollectionEquality().hash(pointsAwarded) ^
      runtimeType.hashCode;
}

extension $QuestRunProgressResponseExtension on QuestRunProgressResponse {
  QuestRunProgressResponse copyWith({
    int? runId,
    int? questId,
    enums.QuestRunStatusSchema? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? totalCheckpoints,
    int? currentStepIndex,
    List<CheckpointPassedView>? previousCheckpoints,
    CheckpointCurrentView? currentCheckpoint,
    int? pointsAwarded,
  }) {
    return QuestRunProgressResponse(
      runId: runId ?? this.runId,
      questId: questId ?? this.questId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalCheckpoints: totalCheckpoints ?? this.totalCheckpoints,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      previousCheckpoints: previousCheckpoints ?? this.previousCheckpoints,
      currentCheckpoint: currentCheckpoint ?? this.currentCheckpoint,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
    );
  }

  QuestRunProgressResponse copyWithWrapped({
    Wrapped<int>? runId,
    Wrapped<int>? questId,
    Wrapped<enums.QuestRunStatusSchema>? status,
    Wrapped<DateTime>? startedAt,
    Wrapped<DateTime?>? completedAt,
    Wrapped<int>? totalCheckpoints,
    Wrapped<int>? currentStepIndex,
    Wrapped<List<CheckpointPassedView>>? previousCheckpoints,
    Wrapped<CheckpointCurrentView?>? currentCheckpoint,
    Wrapped<int?>? pointsAwarded,
  }) {
    return QuestRunProgressResponse(
      runId: (runId != null ? runId.value : this.runId),
      questId: (questId != null ? questId.value : this.questId),
      status: (status != null ? status.value : this.status),
      startedAt: (startedAt != null ? startedAt.value : this.startedAt),
      completedAt: (completedAt != null ? completedAt.value : this.completedAt),
      totalCheckpoints: (totalCheckpoints != null
          ? totalCheckpoints.value
          : this.totalCheckpoints),
      currentStepIndex: (currentStepIndex != null
          ? currentStepIndex.value
          : this.currentStepIndex),
      previousCheckpoints: (previousCheckpoints != null
          ? previousCheckpoints.value
          : this.previousCheckpoints),
      currentCheckpoint: (currentCheckpoint != null
          ? currentCheckpoint.value
          : this.currentCheckpoint),
      pointsAwarded: (pointsAwarded != null
          ? pointsAwarded.value
          : this.pointsAwarded),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestRunStartRequest {
  const QuestRunStartRequest({required this.questId});

  factory QuestRunStartRequest.fromJson(Map<String, dynamic> json) =>
      _$QuestRunStartRequestFromJson(json);

  static const toJsonFactory = _$QuestRunStartRequestToJson;
  Map<String, dynamic> toJson() => _$QuestRunStartRequestToJson(this);

  @JsonKey(name: 'quest_id')
  final int questId;
  static const fromJsonFactory = _$QuestRunStartRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is QuestRunStartRequest &&
            (identical(other.questId, questId) ||
                const DeepCollectionEquality().equals(other.questId, questId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(questId) ^ runtimeType.hashCode;
}

extension $QuestRunStartRequestExtension on QuestRunStartRequest {
  QuestRunStartRequest copyWith({int? questId}) {
    return QuestRunStartRequest(questId: questId ?? this.questId);
  }

  QuestRunStartRequest copyWithWrapped({Wrapped<int>? questId}) {
    return QuestRunStartRequest(
      questId: (questId != null ? questId.value : this.questId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RatingEntry {
  const RatingEntry({
    required this.name,
    required this.points,
    required this.place,
  });

  factory RatingEntry.fromJson(Map<String, dynamic> json) =>
      _$RatingEntryFromJson(json);

  static const toJsonFactory = _$RatingEntryToJson;
  Map<String, dynamic> toJson() => _$RatingEntryToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'points')
  final int points;
  @JsonKey(name: 'place')
  final int place;
  static const fromJsonFactory = _$RatingEntryFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RatingEntry &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.points, points) ||
                const DeepCollectionEquality().equals(other.points, points)) &&
            (identical(other.place, place) ||
                const DeepCollectionEquality().equals(other.place, place)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(points) ^
      const DeepCollectionEquality().hash(place) ^
      runtimeType.hashCode;
}

extension $RatingEntryExtension on RatingEntry {
  RatingEntry copyWith({String? name, int? points, int? place}) {
    return RatingEntry(
      name: name ?? this.name,
      points: points ?? this.points,
      place: place ?? this.place,
    );
  }

  RatingEntry copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<int>? points,
    Wrapped<int>? place,
  }) {
    return RatingEntry(
      name: (name != null ? name.value : this.name),
      points: (points != null ? points.value : this.points),
      place: (place != null ? place.value : this.place),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RefreshTokenRequest {
  const RefreshTokenRequest({required this.refreshToken});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  static const toJsonFactory = _$RefreshTokenRequestToJson;
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);

  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  static const fromJsonFactory = _$RefreshTokenRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RefreshTokenRequest &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(refreshToken) ^ runtimeType.hashCode;
}

extension $RefreshTokenRequestExtension on RefreshTokenRequest {
  RefreshTokenRequest copyWith({String? refreshToken}) {
    return RefreshTokenRequest(refreshToken: refreshToken ?? this.refreshToken);
  }

  RefreshTokenRequest copyWithWrapped({Wrapped<String>? refreshToken}) {
    return RefreshTokenRequest(
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamCreate {
  const TeamCreate({required this.name, required this.description});

  factory TeamCreate.fromJson(Map<String, dynamic> json) =>
      _$TeamCreateFromJson(json);

  static const toJsonFactory = _$TeamCreateToJson;
  Map<String, dynamic> toJson() => _$TeamCreateToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  static const fromJsonFactory = _$TeamCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamCreate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $TeamCreateExtension on TeamCreate {
  TeamCreate copyWith({String? name, String? description}) {
    return TeamCreate(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  TeamCreate copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String>? description,
  }) {
    return TeamCreate(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamJoinRequest {
  const TeamJoinRequest({required this.code});

  factory TeamJoinRequest.fromJson(Map<String, dynamic> json) =>
      _$TeamJoinRequestFromJson(json);

  static const toJsonFactory = _$TeamJoinRequestToJson;
  Map<String, dynamic> toJson() => _$TeamJoinRequestToJson(this);

  @JsonKey(name: 'code')
  final String code;
  static const fromJsonFactory = _$TeamJoinRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamJoinRequest &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(code) ^ runtimeType.hashCode;
}

extension $TeamJoinRequestExtension on TeamJoinRequest {
  TeamJoinRequest copyWith({String? code}) {
    return TeamJoinRequest(code: code ?? this.code);
  }

  TeamJoinRequest copyWithWrapped({Wrapped<String>? code}) {
    return TeamJoinRequest(code: (code != null ? code.value : this.code));
  }
}

@JsonSerializable(explicitToJson: true)
class TeamMemberResponse {
  const TeamMemberResponse({
    required this.id,
    required this.username,
    required this.age,
  });

  factory TeamMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberResponseFromJson(json);

  static const toJsonFactory = _$TeamMemberResponseToJson;
  Map<String, dynamic> toJson() => _$TeamMemberResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'age')
  final int age;
  static const fromJsonFactory = _$TeamMemberResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamMemberResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality().equals(
                  other.username,
                  username,
                )) &&
            (identical(other.age, age) ||
                const DeepCollectionEquality().equals(other.age, age)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(age) ^
      runtimeType.hashCode;
}

extension $TeamMemberResponseExtension on TeamMemberResponse {
  TeamMemberResponse copyWith({int? id, String? username, int? age}) {
    return TeamMemberResponse(
      id: id ?? this.id,
      username: username ?? this.username,
      age: age ?? this.age,
    );
  }

  TeamMemberResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? username,
    Wrapped<int>? age,
  }) {
    return TeamMemberResponse(
      id: (id != null ? id.value : this.id),
      username: (username != null ? username.value : this.username),
      age: (age != null ? age.value : this.age),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamQuestRunCheckpointAnswerRequest {
  const TeamQuestRunCheckpointAnswerRequest({required this.answer});

  factory TeamQuestRunCheckpointAnswerRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$TeamQuestRunCheckpointAnswerRequestFromJson(json);

  static const toJsonFactory = _$TeamQuestRunCheckpointAnswerRequestToJson;
  Map<String, dynamic> toJson() =>
      _$TeamQuestRunCheckpointAnswerRequestToJson(this);

  @JsonKey(name: 'answer')
  final String answer;
  static const fromJsonFactory = _$TeamQuestRunCheckpointAnswerRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamQuestRunCheckpointAnswerRequest &&
            (identical(other.answer, answer) ||
                const DeepCollectionEquality().equals(other.answer, answer)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(answer) ^ runtimeType.hashCode;
}

extension $TeamQuestRunCheckpointAnswerRequestExtension
    on TeamQuestRunCheckpointAnswerRequest {
  TeamQuestRunCheckpointAnswerRequest copyWith({String? answer}) {
    return TeamQuestRunCheckpointAnswerRequest(answer: answer ?? this.answer);
  }

  TeamQuestRunCheckpointAnswerRequest copyWithWrapped({
    Wrapped<String>? answer,
  }) {
    return TeamQuestRunCheckpointAnswerRequest(
      answer: (answer != null ? answer.value : this.answer),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamQuestRunCheckpointAnswerResponse {
  const TeamQuestRunCheckpointAnswerResponse({
    required this.correct,
    required this.progress,
    this.pointsEarned,
  });

  factory TeamQuestRunCheckpointAnswerResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$TeamQuestRunCheckpointAnswerResponseFromJson(json);

  static const toJsonFactory = _$TeamQuestRunCheckpointAnswerResponseToJson;
  Map<String, dynamic> toJson() =>
      _$TeamQuestRunCheckpointAnswerResponseToJson(this);

  @JsonKey(name: 'correct')
  final bool correct;
  @JsonKey(name: 'progress')
  final TeamQuestRunProgressResponse progress;
  @JsonKey(name: 'points_earned')
  final int? pointsEarned;
  static const fromJsonFactory = _$TeamQuestRunCheckpointAnswerResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamQuestRunCheckpointAnswerResponse &&
            (identical(other.correct, correct) ||
                const DeepCollectionEquality().equals(
                  other.correct,
                  correct,
                )) &&
            (identical(other.progress, progress) ||
                const DeepCollectionEquality().equals(
                  other.progress,
                  progress,
                )) &&
            (identical(other.pointsEarned, pointsEarned) ||
                const DeepCollectionEquality().equals(
                  other.pointsEarned,
                  pointsEarned,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(correct) ^
      const DeepCollectionEquality().hash(progress) ^
      const DeepCollectionEquality().hash(pointsEarned) ^
      runtimeType.hashCode;
}

extension $TeamQuestRunCheckpointAnswerResponseExtension
    on TeamQuestRunCheckpointAnswerResponse {
  TeamQuestRunCheckpointAnswerResponse copyWith({
    bool? correct,
    TeamQuestRunProgressResponse? progress,
    int? pointsEarned,
  }) {
    return TeamQuestRunCheckpointAnswerResponse(
      correct: correct ?? this.correct,
      progress: progress ?? this.progress,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }

  TeamQuestRunCheckpointAnswerResponse copyWithWrapped({
    Wrapped<bool>? correct,
    Wrapped<TeamQuestRunProgressResponse>? progress,
    Wrapped<int?>? pointsEarned,
  }) {
    return TeamQuestRunCheckpointAnswerResponse(
      correct: (correct != null ? correct.value : this.correct),
      progress: (progress != null ? progress.value : this.progress),
      pointsEarned: (pointsEarned != null
          ? pointsEarned.value
          : this.pointsEarned),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamQuestRunCheckpointView {
  const TeamQuestRunCheckpointView({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.task,
    required this.hint,
    required this.pointRules,
    required this.isCompleted,
    required this.completedByUserId,
    required this.completedAt,
  });

  factory TeamQuestRunCheckpointView.fromJson(Map<String, dynamic> json) =>
      _$TeamQuestRunCheckpointViewFromJson(json);

  static const toJsonFactory = _$TeamQuestRunCheckpointViewToJson;
  Map<String, dynamic> toJson() => _$TeamQuestRunCheckpointViewToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'task')
  final String task;
  @JsonKey(name: 'hint')
  final String? hint;
  @JsonKey(name: 'point_rules')
  final String? pointRules;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @JsonKey(name: 'completed_by_user_id')
  final int? completedByUserId;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  static const fromJsonFactory = _$TeamQuestRunCheckpointViewFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamQuestRunCheckpointView &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality().equals(
                  other.latitude,
                  latitude,
                )) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality().equals(
                  other.longitude,
                  longitude,
                )) &&
            (identical(other.task, task) ||
                const DeepCollectionEquality().equals(other.task, task)) &&
            (identical(other.hint, hint) ||
                const DeepCollectionEquality().equals(other.hint, hint)) &&
            (identical(other.pointRules, pointRules) ||
                const DeepCollectionEquality().equals(
                  other.pointRules,
                  pointRules,
                )) &&
            (identical(other.isCompleted, isCompleted) ||
                const DeepCollectionEquality().equals(
                  other.isCompleted,
                  isCompleted,
                )) &&
            (identical(other.completedByUserId, completedByUserId) ||
                const DeepCollectionEquality().equals(
                  other.completedByUserId,
                  completedByUserId,
                )) &&
            (identical(other.completedAt, completedAt) ||
                const DeepCollectionEquality().equals(
                  other.completedAt,
                  completedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      const DeepCollectionEquality().hash(task) ^
      const DeepCollectionEquality().hash(hint) ^
      const DeepCollectionEquality().hash(pointRules) ^
      const DeepCollectionEquality().hash(isCompleted) ^
      const DeepCollectionEquality().hash(completedByUserId) ^
      const DeepCollectionEquality().hash(completedAt) ^
      runtimeType.hashCode;
}

extension $TeamQuestRunCheckpointViewExtension on TeamQuestRunCheckpointView {
  TeamQuestRunCheckpointView copyWith({
    int? id,
    String? title,
    double? latitude,
    double? longitude,
    String? task,
    String? hint,
    String? pointRules,
    bool? isCompleted,
    int? completedByUserId,
    DateTime? completedAt,
  }) {
    return TeamQuestRunCheckpointView(
      id: id ?? this.id,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      task: task ?? this.task,
      hint: hint ?? this.hint,
      pointRules: pointRules ?? this.pointRules,
      isCompleted: isCompleted ?? this.isCompleted,
      completedByUserId: completedByUserId ?? this.completedByUserId,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  TeamQuestRunCheckpointView copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? title,
    Wrapped<double>? latitude,
    Wrapped<double>? longitude,
    Wrapped<String>? task,
    Wrapped<String?>? hint,
    Wrapped<String?>? pointRules,
    Wrapped<bool>? isCompleted,
    Wrapped<int?>? completedByUserId,
    Wrapped<DateTime?>? completedAt,
  }) {
    return TeamQuestRunCheckpointView(
      id: (id != null ? id.value : this.id),
      title: (title != null ? title.value : this.title),
      latitude: (latitude != null ? latitude.value : this.latitude),
      longitude: (longitude != null ? longitude.value : this.longitude),
      task: (task != null ? task.value : this.task),
      hint: (hint != null ? hint.value : this.hint),
      pointRules: (pointRules != null ? pointRules.value : this.pointRules),
      isCompleted: (isCompleted != null ? isCompleted.value : this.isCompleted),
      completedByUserId: (completedByUserId != null
          ? completedByUserId.value
          : this.completedByUserId),
      completedAt: (completedAt != null ? completedAt.value : this.completedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamQuestRunProgressResponse {
  const TeamQuestRunProgressResponse({
    required this.runId,
    required this.teamId,
    required this.questId,
    required this.status,
    required this.readyMemberIds,
    required this.totalMembers,
    required this.startsAt,
    required this.startedAt,
    required this.completedAt,
    required this.totalCheckpoints,
    required this.completedCheckpoints,
    required this.checkpoints,
    required this.pointsAwarded,
  });

  factory TeamQuestRunProgressResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamQuestRunProgressResponseFromJson(json);

  static const toJsonFactory = _$TeamQuestRunProgressResponseToJson;
  Map<String, dynamic> toJson() => _$TeamQuestRunProgressResponseToJson(this);

  @JsonKey(name: 'run_id')
  final int runId;
  @JsonKey(name: 'team_id')
  final int teamId;
  @JsonKey(name: 'quest_id')
  final int questId;
  @JsonKey(
    name: 'status',
    toJson: teamQuestRunStatusSchemaToJson,
    fromJson: teamQuestRunStatusSchemaFromJson,
  )
  final enums.TeamQuestRunStatusSchema status;
  @JsonKey(name: 'ready_member_ids', defaultValue: <int>[])
  final List<int> readyMemberIds;
  @JsonKey(name: 'total_members')
  final int totalMembers;
  @JsonKey(name: 'starts_at')
  final DateTime? startsAt;
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @JsonKey(name: 'total_checkpoints')
  final int totalCheckpoints;
  @JsonKey(name: 'completed_checkpoints')
  final int completedCheckpoints;
  @JsonKey(name: 'checkpoints', defaultValue: <TeamQuestRunCheckpointView>[])
  final List<TeamQuestRunCheckpointView> checkpoints;
  @JsonKey(name: 'points_awarded')
  final int? pointsAwarded;
  static const fromJsonFactory = _$TeamQuestRunProgressResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamQuestRunProgressResponse &&
            (identical(other.runId, runId) ||
                const DeepCollectionEquality().equals(other.runId, runId)) &&
            (identical(other.teamId, teamId) ||
                const DeepCollectionEquality().equals(other.teamId, teamId)) &&
            (identical(other.questId, questId) ||
                const DeepCollectionEquality().equals(
                  other.questId,
                  questId,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.readyMemberIds, readyMemberIds) ||
                const DeepCollectionEquality().equals(
                  other.readyMemberIds,
                  readyMemberIds,
                )) &&
            (identical(other.totalMembers, totalMembers) ||
                const DeepCollectionEquality().equals(
                  other.totalMembers,
                  totalMembers,
                )) &&
            (identical(other.startsAt, startsAt) ||
                const DeepCollectionEquality().equals(
                  other.startsAt,
                  startsAt,
                )) &&
            (identical(other.startedAt, startedAt) ||
                const DeepCollectionEquality().equals(
                  other.startedAt,
                  startedAt,
                )) &&
            (identical(other.completedAt, completedAt) ||
                const DeepCollectionEquality().equals(
                  other.completedAt,
                  completedAt,
                )) &&
            (identical(other.totalCheckpoints, totalCheckpoints) ||
                const DeepCollectionEquality().equals(
                  other.totalCheckpoints,
                  totalCheckpoints,
                )) &&
            (identical(other.completedCheckpoints, completedCheckpoints) ||
                const DeepCollectionEquality().equals(
                  other.completedCheckpoints,
                  completedCheckpoints,
                )) &&
            (identical(other.checkpoints, checkpoints) ||
                const DeepCollectionEquality().equals(
                  other.checkpoints,
                  checkpoints,
                )) &&
            (identical(other.pointsAwarded, pointsAwarded) ||
                const DeepCollectionEquality().equals(
                  other.pointsAwarded,
                  pointsAwarded,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(runId) ^
      const DeepCollectionEquality().hash(teamId) ^
      const DeepCollectionEquality().hash(questId) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(readyMemberIds) ^
      const DeepCollectionEquality().hash(totalMembers) ^
      const DeepCollectionEquality().hash(startsAt) ^
      const DeepCollectionEquality().hash(startedAt) ^
      const DeepCollectionEquality().hash(completedAt) ^
      const DeepCollectionEquality().hash(totalCheckpoints) ^
      const DeepCollectionEquality().hash(completedCheckpoints) ^
      const DeepCollectionEquality().hash(checkpoints) ^
      const DeepCollectionEquality().hash(pointsAwarded) ^
      runtimeType.hashCode;
}

extension $TeamQuestRunProgressResponseExtension
    on TeamQuestRunProgressResponse {
  TeamQuestRunProgressResponse copyWith({
    int? runId,
    int? teamId,
    int? questId,
    enums.TeamQuestRunStatusSchema? status,
    List<int>? readyMemberIds,
    int? totalMembers,
    DateTime? startsAt,
    DateTime? startedAt,
    DateTime? completedAt,
    int? totalCheckpoints,
    int? completedCheckpoints,
    List<TeamQuestRunCheckpointView>? checkpoints,
    int? pointsAwarded,
  }) {
    return TeamQuestRunProgressResponse(
      runId: runId ?? this.runId,
      teamId: teamId ?? this.teamId,
      questId: questId ?? this.questId,
      status: status ?? this.status,
      readyMemberIds: readyMemberIds ?? this.readyMemberIds,
      totalMembers: totalMembers ?? this.totalMembers,
      startsAt: startsAt ?? this.startsAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalCheckpoints: totalCheckpoints ?? this.totalCheckpoints,
      completedCheckpoints: completedCheckpoints ?? this.completedCheckpoints,
      checkpoints: checkpoints ?? this.checkpoints,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
    );
  }

  TeamQuestRunProgressResponse copyWithWrapped({
    Wrapped<int>? runId,
    Wrapped<int>? teamId,
    Wrapped<int>? questId,
    Wrapped<enums.TeamQuestRunStatusSchema>? status,
    Wrapped<List<int>>? readyMemberIds,
    Wrapped<int>? totalMembers,
    Wrapped<DateTime?>? startsAt,
    Wrapped<DateTime?>? startedAt,
    Wrapped<DateTime?>? completedAt,
    Wrapped<int>? totalCheckpoints,
    Wrapped<int>? completedCheckpoints,
    Wrapped<List<TeamQuestRunCheckpointView>>? checkpoints,
    Wrapped<int?>? pointsAwarded,
  }) {
    return TeamQuestRunProgressResponse(
      runId: (runId != null ? runId.value : this.runId),
      teamId: (teamId != null ? teamId.value : this.teamId),
      questId: (questId != null ? questId.value : this.questId),
      status: (status != null ? status.value : this.status),
      readyMemberIds: (readyMemberIds != null
          ? readyMemberIds.value
          : this.readyMemberIds),
      totalMembers: (totalMembers != null
          ? totalMembers.value
          : this.totalMembers),
      startsAt: (startsAt != null ? startsAt.value : this.startsAt),
      startedAt: (startedAt != null ? startedAt.value : this.startedAt),
      completedAt: (completedAt != null ? completedAt.value : this.completedAt),
      totalCheckpoints: (totalCheckpoints != null
          ? totalCheckpoints.value
          : this.totalCheckpoints),
      completedCheckpoints: (completedCheckpoints != null
          ? completedCheckpoints.value
          : this.completedCheckpoints),
      checkpoints: (checkpoints != null ? checkpoints.value : this.checkpoints),
      pointsAwarded: (pointsAwarded != null
          ? pointsAwarded.value
          : this.pointsAwarded),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamQuestRunReadinessRequest {
  const TeamQuestRunReadinessRequest({
    required this.questId,
    required this.isReady,
  });

  factory TeamQuestRunReadinessRequest.fromJson(Map<String, dynamic> json) =>
      _$TeamQuestRunReadinessRequestFromJson(json);

  static const toJsonFactory = _$TeamQuestRunReadinessRequestToJson;
  Map<String, dynamic> toJson() => _$TeamQuestRunReadinessRequestToJson(this);

  @JsonKey(name: 'quest_id')
  final int questId;
  @JsonKey(name: 'is_ready')
  final bool isReady;
  static const fromJsonFactory = _$TeamQuestRunReadinessRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamQuestRunReadinessRequest &&
            (identical(other.questId, questId) ||
                const DeepCollectionEquality().equals(
                  other.questId,
                  questId,
                )) &&
            (identical(other.isReady, isReady) ||
                const DeepCollectionEquality().equals(other.isReady, isReady)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(questId) ^
      const DeepCollectionEquality().hash(isReady) ^
      runtimeType.hashCode;
}

extension $TeamQuestRunReadinessRequestExtension
    on TeamQuestRunReadinessRequest {
  TeamQuestRunReadinessRequest copyWith({int? questId, bool? isReady}) {
    return TeamQuestRunReadinessRequest(
      questId: questId ?? this.questId,
      isReady: isReady ?? this.isReady,
    );
  }

  TeamQuestRunReadinessRequest copyWithWrapped({
    Wrapped<int>? questId,
    Wrapped<bool>? isReady,
  }) {
    return TeamQuestRunReadinessRequest(
      questId: (questId != null ? questId.value : this.questId),
      isReady: (isReady != null ? isReady.value : this.isReady),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamRatingPageResponse {
  const TeamRatingPageResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
    required this.currentUserTeam,
  });

  factory TeamRatingPageResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamRatingPageResponseFromJson(json);

  static const toJsonFactory = _$TeamRatingPageResponseToJson;
  Map<String, dynamic> toJson() => _$TeamRatingPageResponseToJson(this);

  @JsonKey(name: 'items', defaultValue: <RatingEntry>[])
  final List<RatingEntry> items;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'offset')
  final int offset;
  @JsonKey(name: 'current_user_team')
  final RatingEntry? currentUserTeam;
  static const fromJsonFactory = _$TeamRatingPageResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamRatingPageResponse &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.offset, offset) ||
                const DeepCollectionEquality().equals(other.offset, offset)) &&
            (identical(other.currentUserTeam, currentUserTeam) ||
                const DeepCollectionEquality().equals(
                  other.currentUserTeam,
                  currentUserTeam,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(offset) ^
      const DeepCollectionEquality().hash(currentUserTeam) ^
      runtimeType.hashCode;
}

extension $TeamRatingPageResponseExtension on TeamRatingPageResponse {
  TeamRatingPageResponse copyWith({
    List<RatingEntry>? items,
    int? total,
    int? limit,
    int? offset,
    RatingEntry? currentUserTeam,
  }) {
    return TeamRatingPageResponse(
      items: items ?? this.items,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      currentUserTeam: currentUserTeam ?? this.currentUserTeam,
    );
  }

  TeamRatingPageResponse copyWithWrapped({
    Wrapped<List<RatingEntry>>? items,
    Wrapped<int>? total,
    Wrapped<int>? limit,
    Wrapped<int>? offset,
    Wrapped<RatingEntry?>? currentUserTeam,
  }) {
    return TeamRatingPageResponse(
      items: (items != null ? items.value : this.items),
      total: (total != null ? total.value : this.total),
      limit: (limit != null ? limit.value : this.limit),
      offset: (offset != null ? offset.value : this.offset),
      currentUserTeam: (currentUserTeam != null
          ? currentUserTeam.value
          : this.currentUserTeam),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TeamResponse {
  const TeamResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.creatorId,
    required this.membersCount,
    required this.totalPoints,
    required this.members,
  });

  factory TeamResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamResponseFromJson(json);

  static const toJsonFactory = _$TeamResponseToJson;
  Map<String, dynamic> toJson() => _$TeamResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'creator_id')
  final int creatorId;
  @JsonKey(name: 'members_count')
  final int membersCount;
  @JsonKey(name: 'total_points')
  final int totalPoints;
  @JsonKey(name: 'members', defaultValue: <TeamMemberResponse>[])
  final List<TeamMemberResponse> members;
  static const fromJsonFactory = _$TeamResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.creatorId, creatorId) ||
                const DeepCollectionEquality().equals(
                  other.creatorId,
                  creatorId,
                )) &&
            (identical(other.membersCount, membersCount) ||
                const DeepCollectionEquality().equals(
                  other.membersCount,
                  membersCount,
                )) &&
            (identical(other.totalPoints, totalPoints) ||
                const DeepCollectionEquality().equals(
                  other.totalPoints,
                  totalPoints,
                )) &&
            (identical(other.members, members) ||
                const DeepCollectionEquality().equals(other.members, members)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(creatorId) ^
      const DeepCollectionEquality().hash(membersCount) ^
      const DeepCollectionEquality().hash(totalPoints) ^
      const DeepCollectionEquality().hash(members) ^
      runtimeType.hashCode;
}

extension $TeamResponseExtension on TeamResponse {
  TeamResponse copyWith({
    int? id,
    String? name,
    String? description,
    String? code,
    int? creatorId,
    int? membersCount,
    int? totalPoints,
    List<TeamMemberResponse>? members,
  }) {
    return TeamResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      creatorId: creatorId ?? this.creatorId,
      membersCount: membersCount ?? this.membersCount,
      totalPoints: totalPoints ?? this.totalPoints,
      members: members ?? this.members,
    );
  }

  TeamResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? name,
    Wrapped<String>? description,
    Wrapped<String>? code,
    Wrapped<int>? creatorId,
    Wrapped<int>? membersCount,
    Wrapped<int>? totalPoints,
    Wrapped<List<TeamMemberResponse>>? members,
  }) {
    return TeamResponse(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      code: (code != null ? code.value : this.code),
      creatorId: (creatorId != null ? creatorId.value : this.creatorId),
      membersCount: (membersCount != null
          ? membersCount.value
          : this.membersCount),
      totalPoints: (totalPoints != null ? totalPoints.value : this.totalPoints),
      members: (members != null ? members.value : this.members),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TokenPairResponse {
  const TokenPairResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType,
    required this.user,
  });

  factory TokenPairResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenPairResponseFromJson(json);

  static const toJsonFactory = _$TokenPairResponseToJson;
  Map<String, dynamic> toJson() => _$TokenPairResponseToJson(this);

  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'user')
  final UserResponse user;
  static const fromJsonFactory = _$TokenPairResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TokenPairResponse &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality().equals(
                  other.accessToken,
                  accessToken,
                )) &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )) &&
            (identical(other.tokenType, tokenType) ||
                const DeepCollectionEquality().equals(
                  other.tokenType,
                  tokenType,
                )) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(refreshToken) ^
      const DeepCollectionEquality().hash(tokenType) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $TokenPairResponseExtension on TokenPairResponse {
  TokenPairResponse copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    UserResponse? user,
  }) {
    return TokenPairResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      user: user ?? this.user,
    );
  }

  TokenPairResponse copyWithWrapped({
    Wrapped<String>? accessToken,
    Wrapped<String>? refreshToken,
    Wrapped<String?>? tokenType,
    Wrapped<UserResponse>? user,
  }) {
    return TokenPairResponse(
      accessToken: (accessToken != null ? accessToken.value : this.accessToken),
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
      tokenType: (tokenType != null ? tokenType.value : this.tokenType),
      user: (user != null ? user.value : this.user),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserAchievementPageResponse {
  const UserAchievementPageResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory UserAchievementPageResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementPageResponseFromJson(json);

  static const toJsonFactory = _$UserAchievementPageResponseToJson;
  Map<String, dynamic> toJson() => _$UserAchievementPageResponseToJson(this);

  @JsonKey(name: 'items', defaultValue: <UserAchievementResponse>[])
  final List<UserAchievementResponse> items;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'offset')
  final int offset;
  static const fromJsonFactory = _$UserAchievementPageResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserAchievementPageResponse &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.offset, offset) ||
                const DeepCollectionEquality().equals(other.offset, offset)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(offset) ^
      runtimeType.hashCode;
}

extension $UserAchievementPageResponseExtension on UserAchievementPageResponse {
  UserAchievementPageResponse copyWith({
    List<UserAchievementResponse>? items,
    int? total,
    int? limit,
    int? offset,
  }) {
    return UserAchievementPageResponse(
      items: items ?? this.items,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  UserAchievementPageResponse copyWithWrapped({
    Wrapped<List<UserAchievementResponse>>? items,
    Wrapped<int>? total,
    Wrapped<int>? limit,
    Wrapped<int>? offset,
  }) {
    return UserAchievementPageResponse(
      items: (items != null ? items.value : this.items),
      total: (total != null ? total.value : this.total),
      limit: (limit != null ? limit.value : this.limit),
      offset: (offset != null ? offset.value : this.offset),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserAchievementResponse {
  const UserAchievementResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.imageFileId,
    required this.awardedAt,
  });

  factory UserAchievementResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementResponseFromJson(json);

  static const toJsonFactory = _$UserAchievementResponseToJson;
  Map<String, dynamic> toJson() => _$UserAchievementResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'image_file_id')
  final String? imageFileId;
  @JsonKey(name: 'awarded_at')
  final DateTime awardedAt;
  static const fromJsonFactory = _$UserAchievementResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserAchievementResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.imageFileId, imageFileId) ||
                const DeepCollectionEquality().equals(
                  other.imageFileId,
                  imageFileId,
                )) &&
            (identical(other.awardedAt, awardedAt) ||
                const DeepCollectionEquality().equals(
                  other.awardedAt,
                  awardedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageFileId) ^
      const DeepCollectionEquality().hash(awardedAt) ^
      runtimeType.hashCode;
}

extension $UserAchievementResponseExtension on UserAchievementResponse {
  UserAchievementResponse copyWith({
    int? id,
    String? title,
    String? description,
    String? imageFileId,
    DateTime? awardedAt,
  }) {
    return UserAchievementResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageFileId: imageFileId ?? this.imageFileId,
      awardedAt: awardedAt ?? this.awardedAt,
    );
  }

  UserAchievementResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? title,
    Wrapped<String>? description,
    Wrapped<String?>? imageFileId,
    Wrapped<DateTime>? awardedAt,
  }) {
    return UserAchievementResponse(
      id: (id != null ? id.value : this.id),
      title: (title != null ? title.value : this.title),
      description: (description != null ? description.value : this.description),
      imageFileId: (imageFileId != null ? imageFileId.value : this.imageFileId),
      awardedAt: (awardedAt != null ? awardedAt.value : this.awardedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserCreate {
  const UserCreate({
    required this.email,
    required this.username,
    required this.password,
    required this.birthdate,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) =>
      _$UserCreateFromJson(json);

  static const toJsonFactory = _$UserCreateToJson;
  Map<String, dynamic> toJson() => _$UserCreateToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'birthdate', toJson: _dateToJson)
  final DateTime birthdate;
  static const fromJsonFactory = _$UserCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserCreate &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality().equals(
                  other.username,
                  username,
                )) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.birthdate, birthdate) ||
                const DeepCollectionEquality().equals(
                  other.birthdate,
                  birthdate,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(birthdate) ^
      runtimeType.hashCode;
}

extension $UserCreateExtension on UserCreate {
  UserCreate copyWith({
    String? email,
    String? username,
    String? password,
    DateTime? birthdate,
  }) {
    return UserCreate(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  UserCreate copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<String>? username,
    Wrapped<String>? password,
    Wrapped<DateTime>? birthdate,
  }) {
    return UserCreate(
      email: (email != null ? email.value : this.email),
      username: (username != null ? username.value : this.username),
      password: (password != null ? password.value : this.password),
      birthdate: (birthdate != null ? birthdate.value : this.birthdate),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserRatingPageResponse {
  const UserRatingPageResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
    required this.currentUser,
  });

  factory UserRatingPageResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRatingPageResponseFromJson(json);

  static const toJsonFactory = _$UserRatingPageResponseToJson;
  Map<String, dynamic> toJson() => _$UserRatingPageResponseToJson(this);

  @JsonKey(name: 'items', defaultValue: <RatingEntry>[])
  final List<RatingEntry> items;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'offset')
  final int offset;
  @JsonKey(name: 'current_user')
  final RatingEntry currentUser;
  static const fromJsonFactory = _$UserRatingPageResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserRatingPageResponse &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.total, total) ||
                const DeepCollectionEquality().equals(other.total, total)) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.offset, offset) ||
                const DeepCollectionEquality().equals(other.offset, offset)) &&
            (identical(other.currentUser, currentUser) ||
                const DeepCollectionEquality().equals(
                  other.currentUser,
                  currentUser,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(total) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(offset) ^
      const DeepCollectionEquality().hash(currentUser) ^
      runtimeType.hashCode;
}

extension $UserRatingPageResponseExtension on UserRatingPageResponse {
  UserRatingPageResponse copyWith({
    List<RatingEntry>? items,
    int? total,
    int? limit,
    int? offset,
    RatingEntry? currentUser,
  }) {
    return UserRatingPageResponse(
      items: items ?? this.items,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  UserRatingPageResponse copyWithWrapped({
    Wrapped<List<RatingEntry>>? items,
    Wrapped<int>? total,
    Wrapped<int>? limit,
    Wrapped<int>? offset,
    Wrapped<RatingEntry>? currentUser,
  }) {
    return UserRatingPageResponse(
      items: (items != null ? items.value : this.items),
      total: (total != null ? total.value : this.total),
      limit: (limit != null ? limit.value : this.limit),
      offset: (offset != null ? offset.value : this.offset),
      currentUser: (currentUser != null ? currentUser.value : this.currentUser),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserResponse {
  const UserResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.birthdate,
    required this.role,
    this.teamName,
    this.totalPoints,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  static const toJsonFactory = _$UserResponseToJson;
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'birthdate', toJson: _dateToJson)
  final DateTime birthdate;
  @JsonKey(
    name: 'role',
    toJson: userRoleSchemaToJson,
    fromJson: userRoleSchemaFromJson,
  )
  final enums.UserRoleSchema role;
  @JsonKey(name: 'team_name')
  final String? teamName;
  @JsonKey(name: 'total_points')
  final int? totalPoints;
  static const fromJsonFactory = _$UserResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality().equals(
                  other.username,
                  username,
                )) &&
            (identical(other.birthdate, birthdate) ||
                const DeepCollectionEquality().equals(
                  other.birthdate,
                  birthdate,
                )) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)) &&
            (identical(other.teamName, teamName) ||
                const DeepCollectionEquality().equals(
                  other.teamName,
                  teamName,
                )) &&
            (identical(other.totalPoints, totalPoints) ||
                const DeepCollectionEquality().equals(
                  other.totalPoints,
                  totalPoints,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(birthdate) ^
      const DeepCollectionEquality().hash(role) ^
      const DeepCollectionEquality().hash(teamName) ^
      const DeepCollectionEquality().hash(totalPoints) ^
      runtimeType.hashCode;
}

extension $UserResponseExtension on UserResponse {
  UserResponse copyWith({
    int? id,
    String? email,
    String? username,
    DateTime? birthdate,
    enums.UserRoleSchema? role,
    String? teamName,
    int? totalPoints,
  }) {
    return UserResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      birthdate: birthdate ?? this.birthdate,
      role: role ?? this.role,
      teamName: teamName ?? this.teamName,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  UserResponse copyWithWrapped({
    Wrapped<int>? id,
    Wrapped<String>? email,
    Wrapped<String>? username,
    Wrapped<DateTime>? birthdate,
    Wrapped<enums.UserRoleSchema>? role,
    Wrapped<String?>? teamName,
    Wrapped<int?>? totalPoints,
  }) {
    return UserResponse(
      id: (id != null ? id.value : this.id),
      email: (email != null ? email.value : this.email),
      username: (username != null ? username.value : this.username),
      birthdate: (birthdate != null ? birthdate.value : this.birthdate),
      role: (role != null ? role.value : this.role),
      teamName: (teamName != null ? teamName.value : this.teamName),
      totalPoints: (totalPoints != null ? totalPoints.value : this.totalPoints),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UserUpdate {
  const UserUpdate({this.username, this.birthdate});

  factory UserUpdate.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateFromJson(json);

  static const toJsonFactory = _$UserUpdateToJson;
  Map<String, dynamic> toJson() => _$UserUpdateToJson(this);

  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'birthdate', toJson: _dateToJson)
  final DateTime? birthdate;
  static const fromJsonFactory = _$UserUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserUpdate &&
            (identical(other.username, username) ||
                const DeepCollectionEquality().equals(
                  other.username,
                  username,
                )) &&
            (identical(other.birthdate, birthdate) ||
                const DeepCollectionEquality().equals(
                  other.birthdate,
                  birthdate,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(birthdate) ^
      runtimeType.hashCode;
}

extension $UserUpdateExtension on UserUpdate {
  UserUpdate copyWith({String? username, DateTime? birthdate}) {
    return UserUpdate(
      username: username ?? this.username,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  UserUpdate copyWithWrapped({
    Wrapped<String?>? username,
    Wrapped<DateTime?>? birthdate,
  }) {
    return UserUpdate(
      username: (username != null ? username.value : this.username),
      birthdate: (birthdate != null ? birthdate.value : this.birthdate),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ValidationError {
  const ValidationError({
    required this.loc,
    required this.msg,
    required this.type,
    this.input,
    this.ctx,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  static const toJsonFactory = _$ValidationErrorToJson;
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @JsonKey(name: 'loc', defaultValue: <Object>[])
  final List<Object> loc;
  @JsonKey(name: 'msg')
  final String msg;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'input')
  final dynamic input;
  @JsonKey(name: 'ctx')
  final Object? ctx;
  static const fromJsonFactory = _$ValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidationError &&
            (identical(other.loc, loc) ||
                const DeepCollectionEquality().equals(other.loc, loc)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.input, input) ||
                const DeepCollectionEquality().equals(other.input, input)) &&
            (identical(other.ctx, ctx) ||
                const DeepCollectionEquality().equals(other.ctx, ctx)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(loc) ^
      const DeepCollectionEquality().hash(msg) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(input) ^
      const DeepCollectionEquality().hash(ctx) ^
      runtimeType.hashCode;
}

extension $ValidationErrorExtension on ValidationError {
  ValidationError copyWith({
    List<Object>? loc,
    String? msg,
    String? type,
    dynamic input,
    Object? ctx,
  }) {
    return ValidationError(
      loc: loc ?? this.loc,
      msg: msg ?? this.msg,
      type: type ?? this.type,
      input: input ?? this.input,
      ctx: ctx ?? this.ctx,
    );
  }

  ValidationError copyWithWrapped({
    Wrapped<List<Object>>? loc,
    Wrapped<String>? msg,
    Wrapped<String>? type,
    Wrapped<dynamic>? input,
    Wrapped<Object?>? ctx,
  }) {
    return ValidationError(
      loc: (loc != null ? loc.value : this.loc),
      msg: (msg != null ? msg.value : this.msg),
      type: (type != null ? type.value : this.type),
      input: (input != null ? input.value : this.input),
      ctx: (ctx != null ? ctx.value : this.ctx),
    );
  }
}

String? questArchiveStatusSchemaNullableToJson(
  enums.QuestArchiveStatusSchema? questArchiveStatusSchema,
) {
  return questArchiveStatusSchema?.value;
}

String? questArchiveStatusSchemaToJson(
  enums.QuestArchiveStatusSchema questArchiveStatusSchema,
) {
  return questArchiveStatusSchema.value;
}

enums.QuestArchiveStatusSchema questArchiveStatusSchemaFromJson(
  Object? questArchiveStatusSchema, [
  enums.QuestArchiveStatusSchema? defaultValue,
]) {
  return enums.QuestArchiveStatusSchema.values.firstWhereOrNull(
        (e) => e.value == questArchiveStatusSchema,
      ) ??
      defaultValue ??
      enums.QuestArchiveStatusSchema.swaggerGeneratedUnknown;
}

enums.QuestArchiveStatusSchema? questArchiveStatusSchemaNullableFromJson(
  Object? questArchiveStatusSchema, [
  enums.QuestArchiveStatusSchema? defaultValue,
]) {
  if (questArchiveStatusSchema == null) {
    return null;
  }
  return enums.QuestArchiveStatusSchema.values.firstWhereOrNull(
        (e) => e.value == questArchiveStatusSchema,
      ) ??
      defaultValue;
}

String questArchiveStatusSchemaExplodedListToJson(
  List<enums.QuestArchiveStatusSchema>? questArchiveStatusSchema,
) {
  return questArchiveStatusSchema?.map((e) => e.value!).join(',') ?? '';
}

List<String> questArchiveStatusSchemaListToJson(
  List<enums.QuestArchiveStatusSchema>? questArchiveStatusSchema,
) {
  if (questArchiveStatusSchema == null) {
    return [];
  }

  return questArchiveStatusSchema.map((e) => e.value!).toList();
}

List<enums.QuestArchiveStatusSchema> questArchiveStatusSchemaListFromJson(
  List? questArchiveStatusSchema, [
  List<enums.QuestArchiveStatusSchema>? defaultValue,
]) {
  if (questArchiveStatusSchema == null) {
    return defaultValue ?? [];
  }

  return questArchiveStatusSchema
      .map((e) => questArchiveStatusSchemaFromJson(e.toString()))
      .toList();
}

List<enums.QuestArchiveStatusSchema>?
questArchiveStatusSchemaNullableListFromJson(
  List? questArchiveStatusSchema, [
  List<enums.QuestArchiveStatusSchema>? defaultValue,
]) {
  if (questArchiveStatusSchema == null) {
    return defaultValue;
  }

  return questArchiveStatusSchema
      .map((e) => questArchiveStatusSchemaFromJson(e.toString()))
      .toList();
}

String? questRunStatusSchemaNullableToJson(
  enums.QuestRunStatusSchema? questRunStatusSchema,
) {
  return questRunStatusSchema?.value;
}

String? questRunStatusSchemaToJson(
  enums.QuestRunStatusSchema questRunStatusSchema,
) {
  return questRunStatusSchema.value;
}

enums.QuestRunStatusSchema questRunStatusSchemaFromJson(
  Object? questRunStatusSchema, [
  enums.QuestRunStatusSchema? defaultValue,
]) {
  return enums.QuestRunStatusSchema.values.firstWhereOrNull(
        (e) => e.value == questRunStatusSchema,
      ) ??
      defaultValue ??
      enums.QuestRunStatusSchema.swaggerGeneratedUnknown;
}

enums.QuestRunStatusSchema? questRunStatusSchemaNullableFromJson(
  Object? questRunStatusSchema, [
  enums.QuestRunStatusSchema? defaultValue,
]) {
  if (questRunStatusSchema == null) {
    return null;
  }
  return enums.QuestRunStatusSchema.values.firstWhereOrNull(
        (e) => e.value == questRunStatusSchema,
      ) ??
      defaultValue;
}

String questRunStatusSchemaExplodedListToJson(
  List<enums.QuestRunStatusSchema>? questRunStatusSchema,
) {
  return questRunStatusSchema?.map((e) => e.value!).join(',') ?? '';
}

List<String> questRunStatusSchemaListToJson(
  List<enums.QuestRunStatusSchema>? questRunStatusSchema,
) {
  if (questRunStatusSchema == null) {
    return [];
  }

  return questRunStatusSchema.map((e) => e.value!).toList();
}

List<enums.QuestRunStatusSchema> questRunStatusSchemaListFromJson(
  List? questRunStatusSchema, [
  List<enums.QuestRunStatusSchema>? defaultValue,
]) {
  if (questRunStatusSchema == null) {
    return defaultValue ?? [];
  }

  return questRunStatusSchema
      .map((e) => questRunStatusSchemaFromJson(e.toString()))
      .toList();
}

List<enums.QuestRunStatusSchema>? questRunStatusSchemaNullableListFromJson(
  List? questRunStatusSchema, [
  List<enums.QuestRunStatusSchema>? defaultValue,
]) {
  if (questRunStatusSchema == null) {
    return defaultValue;
  }

  return questRunStatusSchema
      .map((e) => questRunStatusSchemaFromJson(e.toString()))
      .toList();
}

String? questStatusSchemaNullableToJson(
  enums.QuestStatusSchema? questStatusSchema,
) {
  return questStatusSchema?.value;
}

String? questStatusSchemaToJson(enums.QuestStatusSchema questStatusSchema) {
  return questStatusSchema.value;
}

enums.QuestStatusSchema questStatusSchemaFromJson(
  Object? questStatusSchema, [
  enums.QuestStatusSchema? defaultValue,
]) {
  return enums.QuestStatusSchema.values.firstWhereOrNull(
        (e) => e.value == questStatusSchema,
      ) ??
      defaultValue ??
      enums.QuestStatusSchema.swaggerGeneratedUnknown;
}

enums.QuestStatusSchema? questStatusSchemaNullableFromJson(
  Object? questStatusSchema, [
  enums.QuestStatusSchema? defaultValue,
]) {
  if (questStatusSchema == null) {
    return null;
  }
  return enums.QuestStatusSchema.values.firstWhereOrNull(
        (e) => e.value == questStatusSchema,
      ) ??
      defaultValue;
}

String questStatusSchemaExplodedListToJson(
  List<enums.QuestStatusSchema>? questStatusSchema,
) {
  return questStatusSchema?.map((e) => e.value!).join(',') ?? '';
}

List<String> questStatusSchemaListToJson(
  List<enums.QuestStatusSchema>? questStatusSchema,
) {
  if (questStatusSchema == null) {
    return [];
  }

  return questStatusSchema.map((e) => e.value!).toList();
}

List<enums.QuestStatusSchema> questStatusSchemaListFromJson(
  List? questStatusSchema, [
  List<enums.QuestStatusSchema>? defaultValue,
]) {
  if (questStatusSchema == null) {
    return defaultValue ?? [];
  }

  return questStatusSchema
      .map((e) => questStatusSchemaFromJson(e.toString()))
      .toList();
}

List<enums.QuestStatusSchema>? questStatusSchemaNullableListFromJson(
  List? questStatusSchema, [
  List<enums.QuestStatusSchema>? defaultValue,
]) {
  if (questStatusSchema == null) {
    return defaultValue;
  }

  return questStatusSchema
      .map((e) => questStatusSchemaFromJson(e.toString()))
      .toList();
}

String? teamQuestRunStatusSchemaNullableToJson(
  enums.TeamQuestRunStatusSchema? teamQuestRunStatusSchema,
) {
  return teamQuestRunStatusSchema?.value;
}

String? teamQuestRunStatusSchemaToJson(
  enums.TeamQuestRunStatusSchema teamQuestRunStatusSchema,
) {
  return teamQuestRunStatusSchema.value;
}

enums.TeamQuestRunStatusSchema teamQuestRunStatusSchemaFromJson(
  Object? teamQuestRunStatusSchema, [
  enums.TeamQuestRunStatusSchema? defaultValue,
]) {
  return enums.TeamQuestRunStatusSchema.values.firstWhereOrNull(
        (e) => e.value == teamQuestRunStatusSchema,
      ) ??
      defaultValue ??
      enums.TeamQuestRunStatusSchema.swaggerGeneratedUnknown;
}

enums.TeamQuestRunStatusSchema? teamQuestRunStatusSchemaNullableFromJson(
  Object? teamQuestRunStatusSchema, [
  enums.TeamQuestRunStatusSchema? defaultValue,
]) {
  if (teamQuestRunStatusSchema == null) {
    return null;
  }
  return enums.TeamQuestRunStatusSchema.values.firstWhereOrNull(
        (e) => e.value == teamQuestRunStatusSchema,
      ) ??
      defaultValue;
}

String teamQuestRunStatusSchemaExplodedListToJson(
  List<enums.TeamQuestRunStatusSchema>? teamQuestRunStatusSchema,
) {
  return teamQuestRunStatusSchema?.map((e) => e.value!).join(',') ?? '';
}

List<String> teamQuestRunStatusSchemaListToJson(
  List<enums.TeamQuestRunStatusSchema>? teamQuestRunStatusSchema,
) {
  if (teamQuestRunStatusSchema == null) {
    return [];
  }

  return teamQuestRunStatusSchema.map((e) => e.value!).toList();
}

List<enums.TeamQuestRunStatusSchema> teamQuestRunStatusSchemaListFromJson(
  List? teamQuestRunStatusSchema, [
  List<enums.TeamQuestRunStatusSchema>? defaultValue,
]) {
  if (teamQuestRunStatusSchema == null) {
    return defaultValue ?? [];
  }

  return teamQuestRunStatusSchema
      .map((e) => teamQuestRunStatusSchemaFromJson(e.toString()))
      .toList();
}

List<enums.TeamQuestRunStatusSchema>?
teamQuestRunStatusSchemaNullableListFromJson(
  List? teamQuestRunStatusSchema, [
  List<enums.TeamQuestRunStatusSchema>? defaultValue,
]) {
  if (teamQuestRunStatusSchema == null) {
    return defaultValue;
  }

  return teamQuestRunStatusSchema
      .map((e) => teamQuestRunStatusSchemaFromJson(e.toString()))
      .toList();
}

String? userRoleSchemaNullableToJson(enums.UserRoleSchema? userRoleSchema) {
  return userRoleSchema?.value;
}

String? userRoleSchemaToJson(enums.UserRoleSchema userRoleSchema) {
  return userRoleSchema.value;
}

enums.UserRoleSchema userRoleSchemaFromJson(
  Object? userRoleSchema, [
  enums.UserRoleSchema? defaultValue,
]) {
  return enums.UserRoleSchema.values.firstWhereOrNull(
        (e) => e.value == userRoleSchema,
      ) ??
      defaultValue ??
      enums.UserRoleSchema.swaggerGeneratedUnknown;
}

enums.UserRoleSchema? userRoleSchemaNullableFromJson(
  Object? userRoleSchema, [
  enums.UserRoleSchema? defaultValue,
]) {
  if (userRoleSchema == null) {
    return null;
  }
  return enums.UserRoleSchema.values.firstWhereOrNull(
        (e) => e.value == userRoleSchema,
      ) ??
      defaultValue;
}

String userRoleSchemaExplodedListToJson(
  List<enums.UserRoleSchema>? userRoleSchema,
) {
  return userRoleSchema?.map((e) => e.value!).join(',') ?? '';
}

List<String> userRoleSchemaListToJson(
  List<enums.UserRoleSchema>? userRoleSchema,
) {
  if (userRoleSchema == null) {
    return [];
  }

  return userRoleSchema.map((e) => e.value!).toList();
}

List<enums.UserRoleSchema> userRoleSchemaListFromJson(
  List? userRoleSchema, [
  List<enums.UserRoleSchema>? defaultValue,
]) {
  if (userRoleSchema == null) {
    return defaultValue ?? [];
  }

  return userRoleSchema
      .map((e) => userRoleSchemaFromJson(e.toString()))
      .toList();
}

List<enums.UserRoleSchema>? userRoleSchemaNullableListFromJson(
  List? userRoleSchema, [
  List<enums.UserRoleSchema>? defaultValue,
]) {
  if (userRoleSchema == null) {
    return defaultValue;
  }

  return userRoleSchema
      .map((e) => userRoleSchemaFromJson(e.toString()))
      .toList();
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
    chopper.Response response,
  ) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
        body:
            DateTime.parse((response.body as String).replaceAll('"', ''))
                as ResultType,
      );
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
      body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType,
    );
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
