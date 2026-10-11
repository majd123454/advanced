import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swb_advance/app/core/services/auth/secure_token_storage.dart';
import 'package:swb_advance/app/core/services/auth/token_storage.dart';
import 'package:swb_advance/app/core/services/supabase/supabase_config.dart';
import 'package:swb_advance/app/core/services/supabase/supabase_table.dart';
import 'package:swb_advance/app/core/helper/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'auth_interceptor.dart';

class ApiService {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  factory ApiService.fromEnvironment({TokenStorage? tokenStorage}) {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final usesSupabaseDefaults = baseUrl == null;

    return ApiService(
      tokenStorage: tokenStorage,
      baseUrl: baseUrl,
      apiKey:
          dotenv.env['API_KEY'] ??
          (usesSupabaseDefaults ? SupabaseConfig.supabaseAnonKey : null),
      loginPath:
          dotenv.env['LOGIN_PATH'] ??
          (usesSupabaseDefaults ? '/auth/v1/token' : '/auth/login'),
      refreshTokenPath: dotenv.env['REFRESH_TOKEN_PATH'] ?? '/auth/v1/token',
      useSupabaseGrantType:
          dotenv.env['USE_SUPABASE_GRANT_TYPE']?.toLowerCase() != 'false',
    );
  }

  ApiService({
    Dio? dio,
    TokenStorage? tokenStorage,
    String? baseUrl,
    String? apiKey,
    this.loginPath = '/auth/v1/token',
    this.refreshTokenPath = '/auth/v1/token',
    this.useSupabaseGrantType = true,
  }) : _tokenStorage = tokenStorage ?? const SecureTokenStorage(),
       _dio =
           dio ??
           Dio(
             _baseOptions(
               baseUrl: baseUrl,
               apiKey: apiKey,
               useSupabaseGrantType: useSupabaseGrantType,
             ),
           ) {
    final authInterceptor = AuthInterceptor(
      _tokenStorage,
      refreshTokenPath: refreshTokenPath,
      useSupabaseGrantType: useSupabaseGrantType,
    );
    authInterceptor.setDio(_dio);
    _dio.interceptors.add(authInterceptor);
  }

  final String loginPath;
  final String refreshTokenPath;
  final bool useSupabaseGrantType;

  static BaseOptions _baseOptions({
    String? baseUrl,
    String? apiKey,
    required bool useSupabaseGrantType,
  }) {
    final resolvedApiKey =
        apiKey ?? (baseUrl == null ? SupabaseConfig.supabaseAnonKey : null);

    return BaseOptions(
      baseUrl: baseUrl ?? SupabaseConfig.supabaseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'apikey': ?resolvedApiKey,
        if (resolvedApiKey != null && useSupabaseGrantType)
          'Authorization': 'Bearer $resolvedApiKey',
      },
      responseType: ResponseType.json,
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    );
  }

  Dio get dio => _dio;

  String get _chatMessagesUrl => Uri.parse(
    SupabaseConfig.supabaseUrl,
  ).resolve('/rest/v1/${SupabaseTables.chatMessages}').toString();

  Options get _supabaseRestOptions => Options(
    headers: {
      'apikey': SupabaseConfig.supabaseAnonKey,
      'Authorization': 'Bearer ${SupabaseConfig.supabaseAnonKey}',
      'Accept': 'application/json',
    },
  );

  Future<Response<Map<String, dynamic>>> getSupabaseCurrentUser() {
    final userUrl = Uri.parse(
      SupabaseConfig.supabaseUrl,
    ).resolve('/auth/v1/user').toString();
    return _dio.get<Map<String, dynamic>>(
      userUrl,
      options: _supabaseRestOptions,
    );
  }

  Future<Response<dynamic>> getChatMessages({
    required String otherUserId,
    required int page,
    required int limit,
  }) {
    return _dio.get(
      _chatMessagesUrl,
      queryParameters: {
        'select': '*',
        'or': '(sender_id.eq.$otherUserId,receiver_id.eq.$otherUserId)',
        'order': 'created_at.desc',
        'offset': page * limit,
        'limit': limit,
      },
      options: _supabaseRestOptions,
    );
  }

  Future<Response<dynamic>> sendChatMessage({
    required String senderId,
    required String receiverId,
    required String content,
    required String messageType,
  }) {
    return _dio.post(
      _chatMessagesUrl,
      data: {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
        'message_type': messageType,
      },
      options: _supabaseRestOptions.copyWith(
        headers: {
          ..._supabaseRestOptions.headers ?? {},
          'Prefer': 'return=representation',
        },
      ),
    );
  }

  Stream<Map<String, dynamic>> watchChatMessages() async* {
    final baseUri = Uri.parse(SupabaseConfig.supabaseUrl);
    final socketUri = baseUri.replace(
      scheme: baseUri.scheme == 'https' ? 'wss' : 'ws',
      path: '/realtime/v1/websocket',
      queryParameters: {
        'apikey': SupabaseConfig.supabaseAnonKey,
        'vsn': '1.0.0',
      },
    );
    final topic = 'realtime:public:${SupabaseTables.chatMessages}';

    while (true) {
      WebSocketChannel? channel;
      Timer? heartbeat;

      try {
        // This REST request refreshes an expired access token through the auth interceptor.
        await getSupabaseCurrentUser();
        final tokens = await _tokenStorage.read();
        if (tokens == null) {
          throw StateError('No authenticated Supabase session is available');
        }

        channel = WebSocketChannel.connect(socketUri);
        await channel.ready.timeout(const Duration(seconds: 15));
        logger(
          'Supabase Realtime WebSocket connected; joining $topic',
          name: 'ChatRealtime',
        );
        channel.sink.add(
          jsonEncode({
            'topic': topic,
            'event': 'phx_join',
            'payload': {
              'config': {
                'broadcast': {'ack': false, 'self': false},
                'presence': {'key': ''},
                'postgres_changes': [
                  {
                    'event': 'INSERT',
                    'schema': 'public',
                    'table': SupabaseTables.chatMessages,
                  },
                ],
                'private': false,
              },
              'access_token': tokens.accessToken,
            },
            'ref': '1',
            'join_ref': '1',
          }),
        );

        var heartbeatRef = 1;
        final activeChannel = channel;
        heartbeat = Timer.periodic(const Duration(seconds: 25), (_) {
          heartbeatRef++;
          activeChannel.sink.add(
            jsonEncode({
              'topic': 'phoenix',
              'event': 'heartbeat',
              'payload': <String, dynamic>{},
              'ref': '$heartbeatRef',
            }),
          );
        });

        await for (final rawMessage in channel.stream) {
          if (rawMessage is! String) continue;
          final decoded = jsonDecode(rawMessage);
          if (decoded is! Map) continue;

          final event = decoded['event'];
          final payload = decoded['payload'];
          if (event == 'phx_reply' && decoded['topic'] == topic) {
            if (payload is Map && payload['status'] == 'ok') {
              logger(
                'Supabase Realtime subscription accepted for $topic',
                name: 'ChatRealtime',
              );
            } else if (payload is Map && payload['status'] == 'error') {
              throw StateError('Supabase Realtime join failed: $payload');
            }
          }
          if (event != 'postgres_changes' || payload is! Map) continue;

          final change = payload['data'];
          if (change is! Map || change['type'] != 'INSERT') continue;
          final record = change['record'];
          if (record is Map) {
            logger(
              'Supabase Realtime INSERT received: '
              'id=${record['id']}, sender=${record['sender_id']}, '
              'receiver=${record['receiver_id']}',
              name: 'ChatRealtime',
            );
            yield Map<String, dynamic>.from(record);
          }
        }
      } catch (error, stackTrace) {
        logger(
          'Supabase Realtime chat disconnected; retrying: $error',
          name: 'ChatRealtime',
          error: error,
          stackTrace: stackTrace,
        );
      } finally {
        heartbeat?.cancel();
        await channel?.sink.close();
      }

      await Future<void>.delayed(const Duration(seconds: 3));
    }
  }

  Future<Response<Map<String, dynamic>>> signIn({
    required String email,
    required String password,
  }) {
    return _dio.post<Map<String, dynamic>>(
      loginPath,
      queryParameters: useSupabaseGrantType ? {'grant_type': 'password'} : null,
      data: {'email': email, 'password': password},
      options: Options(extra: {'skipAuthToken': true}),
    );
  }

  Future<Response<Map<String, dynamic>>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String address,
  }) {
    final signupPath = dotenv.env['SIGNUP_PATH'] ?? '/auth/v1/signup';
    return _dio.post<Map<String, dynamic>>(
      signupPath,
      data: {
        'email': email,
        'password': password,
        'user_metadata': {
          'full_name': fullName,
          'phone': phone,
          'address': address,
        },
      },
      options: Options(extra: {'skipAuthToken': true}),
    );
  }

  Future<Response<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) {
    return _dio.post<Map<String, dynamic>>(
      refreshTokenPath,
      queryParameters: useSupabaseGrantType
          ? {'grant_type': 'refresh_token'}
          : null,
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skipAuthToken': true}),
    );
  }
}
