import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/util/storage_consts.dart';

class UserData {
  final UserResponse user;
  final DateTime accessTokenExpiresAt;

  UserData({required this.user, required this.accessTokenExpiresAt});

  bool get isAccessTokenExpired => DateTime.now().isAfter(accessTokenExpiresAt);

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'accessTokenExpiresAt': accessTokenExpiresAt.toIso8601String(),
  };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    accessTokenExpiresAt: DateTime.parse(
      json['accessTokenExpiresAt'] as String,
    ),
  );

  factory UserData.fromTokenResponse(TokenPairResponse response) {
    final payload = JwtDecoder.decode(response.accessToken);
    final exp = payload['exp'] as int;
    return UserData(
      user: response.user,
      accessTokenExpiresAt: DateTime.fromMillisecondsSinceEpoch(exp * 1000),
    );
  }
}

class StreamAuthScope extends InheritedNotifier<StreamAuthNotifier> {
  StreamAuthScope({super.key, required super.child})
    : super(notifier: StreamAuthNotifier());

  static StreamAuth of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StreamAuthScope>()!
        .notifier!
        .streamAuth;
  }
}

class StreamAuthNotifier extends ChangeNotifier {
  StreamAuthNotifier() : streamAuth = StreamAuth() {
    streamAuth.onUserDataChanged.listen((_) => notifyListeners());
  }

  final StreamAuth streamAuth;
}

class StreamAuth {
  StreamAuth()
    : _userStreamController = StreamController<UserData?>.broadcast() {
    _userStreamController.stream.listen((UserData? data) {
      _userData = data;
    });
    _storageLoadFuture = _loadStoredUserData();
    ApiService.instance.init(this);
  }

  /// Completes after secure storage has been read so [isSignedIn] is accurate for routing.
  late final Future<void> _storageLoadFuture;

  UserData? get userData => _userData;
  UserData? _userData;

  final _secureStorage = const FlutterSecureStorage();
  static const _userDataKey = 'user_data';

  Future<void> _loadStoredUserData() async {
    final userDataJson = await _secureStorage.read(key: _userDataKey);
    if (userDataJson != null) {
      try {
        _userData = UserData.fromJson(jsonDecode(userDataJson));
        _userStreamController.add(_userData);
      } catch (_) {}
    }
  }

  Future<void> _persistTokens(TokenPairResponse response) async {
    await _secureStorage.write(
      key: STORAGE.ACCESS_TOKEN,
      value: response.accessToken,
    );
    await _secureStorage.write(
      key: STORAGE.REFRESH_TOKEN,
      value: response.refreshToken,
    );
  }

  Future<void> _storeUserData(UserData data) async {
    await _secureStorage.write(
      key: _userDataKey,
      value: jsonEncode(data.toJson()),
    );
  }

  Future<void> _clearStoredUserData() async {
    await _secureStorage.delete(key: _userDataKey);
    await _secureStorage.delete(key: STORAGE.ACCESS_TOKEN);
    await _secureStorage.delete(key: STORAGE.REFRESH_TOKEN);
  }

  Future<bool> isSignedIn() async {
    await _storageLoadFuture;
    if (_userData == null) return false;
    final access = await _secureStorage.read(key: STORAGE.ACCESS_TOKEN);
    if (access == null || access.isEmpty) {
      // Legacy session: user JSON was stored without tokens — treat as signed out.
      _userData = null;
      await _secureStorage.delete(key: _userDataKey);
      return false;
    }
    if (_userData!.isAccessTokenExpired) {
      return await refreshAccessToken();
    }
    return true;
  }

  Stream<UserData?> get onUserDataChanged => _userStreamController.stream;
  final StreamController<UserData?> _userStreamController;

  Future<bool> refreshAccessToken() async {
    if (_userData == null) return false;

    try {
      final response = await ApiService.instance.client.apiAuthRefreshPost(
        body: RefreshTokenRequest(
          refreshToken:
              await _secureStorage.read(key: STORAGE.REFRESH_TOKEN) ?? "",
        ),
      );

      if (response.isSuccessful && response.body != null) {
        final body = response.body!;
        await _persistTokens(body);
        final newData = UserData.fromTokenResponse(body);
        _userData = newData;
        await _storeUserData(newData);
        _userStreamController.add(newData);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final response = await ApiService.instance.client.apiAuthLoginPost(
        body: LoginRequest(email: email, password: password),
      );

      if (response.isSuccessful && response.body != null) {
        final body = response.body!;
        await _persistTokens(body);
        final data = UserData.fromTokenResponse(body);
        _userData = data;
        await _storeUserData(data);
        _userStreamController.add(data);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> signOn(
    String email,
    String password,
    String username,
    DateTime birthdate,
  ) async {
    try {
      final response = await ApiService.instance.client.apiAuthRegisterPost(
        body: UserCreate(
          email: email,
          password: password,
          username: username,
          birthdate: birthdate,
        ),
      );

      if (response.isSuccessful && response.body != null) {
        final body = response.body!;
        await _persistTokens(body);
        final data = UserData.fromTokenResponse(body);
        _userData = data;
        await _storeUserData(data);
        _userStreamController.add(data);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<void> signOut() async {
    try {
      if (_userData != null) {
        await ApiService.instance.client.apiAuthLogoutPost(
          body: RefreshTokenRequest(
            refreshToken:
                await _secureStorage.read(key: STORAGE.REFRESH_TOKEN) ?? "",
          ),
        );
      }
    } catch (_) {}
    _userData = null;
    await _clearStoredUserData();
    _userStreamController.add(null);
  }

  Future<String>? get accessToken async {
    final token = await _secureStorage.read(key: STORAGE.ACCESS_TOKEN) ?? "";
    print(token);
    return token;
  }

  UserResponse? get currentUser => _userData?.user;

  /// Re-fetches `/api/auth/me` and updates local cached user (does not touch tokens).
  Future<bool> refreshMe() async {
    if (_userData == null) return false;
    try {
      final res = await ApiService.instance.client.apiAuthMeGet();
      final user = res.body;
      if (res.isSuccessful && user != null) {
        final next = UserData(user: user, accessTokenExpiresAt: _userData!.accessTokenExpiresAt);
        _userData = next;
        await _storeUserData(next);
        _userStreamController.add(next);
        return true;
      }
    } catch (_) {}
    return false;
  }
}
