import 'auth_tokens.dart';

abstract interface class TokenStorage {
  Future<void> save(AuthTokens tokens);

  Future<AuthTokens?> read();

  Future<void> clear();
}
