import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_tokens.dart';
import 'token_storage.dart';

class SecureTokenStorage implements TokenStorage {
  static const _sessionKey = 'auth_session';

  final FlutterSecureStorage _storage;

  const SecureTokenStorage({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  @override
  Future<void> save(AuthTokens tokens) {
    return _storage.write(key: _sessionKey, value: jsonEncode(tokens.toJson()));
  }

  @override
  Future<AuthTokens?> read() async {
    final storedSession = await _storage.read(key: _sessionKey);
    if (storedSession == null) return null;

    try {
      final decoded = jsonDecode(storedSession);
      if (decoded is Map<String, dynamic>) {
        return AuthTokens.fromJson(decoded);
      }
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
    return null;
  }

  @override
  Future<void> clear() => _storage.delete(key: _sessionKey);
}
