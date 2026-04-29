import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:chopper/chopper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/services/auth.dart';
import 'package:techarrow_2026_app/util/quest_cover_upload.dart';

class ApiService {
  ApiService._();
  static final ApiService _instance = ApiService._();
  static ApiService get instance => _instance;

  late final Swagger _client;
  late final FutureOr<String?> Function() _getToken;
  late final StreamAuth _auth;
  Future<bool>? _refreshInFlight;
  Swagger get client => _client;
  static const _defaultBaseUrl = 'http://localhost:8000';
  static Uri get baseUrl {
    final value = dotenv.isInitialized
        ? dotenv.maybeGet('API_BASE_URL', fallback: _defaultBaseUrl)
        : _defaultBaseUrl;
    return Uri.parse(value ?? _defaultBaseUrl);
  }

  void init(StreamAuth auth) {
    _auth = auth;
    _getToken = () async => auth.accessToken;
    _client = Swagger.create(
      baseUrl: baseUrl,
      interceptors: [AuthInterceptor(getToken: _getToken)],
    );
  }

  Future<bool> refreshAccessTokenSingleFlight() {
    final existing = _refreshInFlight;
    if (existing != null) return existing;
    final f = _auth.refreshAccessToken();
    _refreshInFlight = f;
    f.whenComplete(() {
      if (identical(_refreshInFlight, f)) _refreshInFlight = null;
    });
    return f;
  }

  Future<http.Response> createQuest({
    required BodyCreateQuestApiQuestsPost body,
    Uint8List? imageBytes,
  }) async {
    final uploadImage = await prepareQuestCoverForUpload(imageBytes);
    final token = await _getToken();
    final request = http.MultipartRequest(
      'POST',
      baseUrl.replace(path: '/api/quests'),
    );

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.fields['title'] = body.title;
    request.fields['description'] = body.description;
    request.fields['location'] = body.location;
    request.fields['difficulty'] = body.difficulty.toString();
    request.fields['duration_minutes'] = body.durationMinutes.toString();
    if (body.rulesAndWarnings != null && body.rulesAndWarnings!.isNotEmpty) {
      request.fields['rules_and_warnings'] = body.rulesAndWarnings!;
    }
    if (body.points != null && body.points!.isNotEmpty) {
      request.fields['points'] = body.points!;
    }
    if (uploadImage != null && uploadImage.isNotEmpty) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          uploadImage,
          filename: 'cover.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamed = await request.send();
    return http.Response.fromStream(streamed);
  }

  Future<QuestPageResponse> getQuests({
    int? limit,
    int? offset,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    List? difficulties,
    String? city,
    num? nearLatitude,
    num? nearLongitude,
    String? search,
  }) async {
    final token = await _getToken();
    final params = <String, dynamic>{
      if (limit != null) 'limit': '$limit',
      if (offset != null) 'offset': '$offset',
      if (minDurationMinutes != null)
        'min_duration_minutes': '$minDurationMinutes',
      if (maxDurationMinutes != null)
        'max_duration_minutes': '$maxDurationMinutes',
      if (difficulties != null && difficulties.isNotEmpty)
        'difficulties': difficulties.map((e) => '$e').toList(),
      if (city != null && city.isNotEmpty) 'city': city,
      if (nearLatitude != null) 'near_latitude': '$nearLatitude',
      if (nearLongitude != null) 'near_longitude': '$nearLongitude',
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final uri = baseUrl.replace(path: '/api/quests', queryParameters: params);
    final response = await http.get(
      uri,
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load quests: ${response.statusCode}');
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw Exception('Invalid quests response format');
    }
    return QuestPageResponse.fromJsonFactory(body);
  }
}

class AuthInterceptor implements Interceptor {
  final FutureOr<String?> Function() getToken;

  AuthInterceptor({required this.getToken});

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final originalRequest = chain.request;
    final isAuthPath = originalRequest.url.path.startsWith('/api/auth');
    final alreadyRetried = originalRequest.headers['x-auth-retry'] == '1';
    final token = await getToken();

    if (token != null && token.isNotEmpty) {
      final res = await chain.proceed(
        originalRequest.copyWith(
          headers: {
            ...originalRequest.headers,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (res.statusCode == 401 && !isAuthPath && !alreadyRetried) {
        final refreshed = await ApiService.instance
            .refreshAccessTokenSingleFlight();
        if (refreshed) {
          final newToken = await getToken();
          if (newToken != null && newToken.isNotEmpty) {
            return chain.proceed(
              originalRequest.copyWith(
                headers: {
                  ...originalRequest.headers,
                  'Authorization': 'Bearer $newToken',
                  'x-auth-retry': '1',
                },
              ),
            );
          }
        }
      }
      print(res);
      return res;
    }

    final res = await chain.proceed(originalRequest);
    if (res.statusCode == 401 && !isAuthPath && !alreadyRetried) {
      final refreshed = await ApiService.instance
          .refreshAccessTokenSingleFlight();
      if (refreshed) {
        final newToken = await getToken();
        if (newToken != null && newToken.isNotEmpty) {
          return chain.proceed(
            originalRequest.copyWith(
              headers: {
                ...originalRequest.headers,
                'Authorization': 'Bearer $newToken',
                'x-auth-retry': '1',
              },
            ),
          );
        }
      }
    }
    print(res);
    return res;
  }
}
