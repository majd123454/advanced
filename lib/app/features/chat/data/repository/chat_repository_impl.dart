import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:swb_advance/app/core/helper/logger.dart';
import 'package:swb_advance/app/core/services/network/api_service.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_model.dart';
import 'package:swb_advance/app/features/chat/data/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiService apiService;

  ChatRepositoryImpl({required this.apiService});

  Map<String, dynamic> _extractPayload(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }
    if (responseData is Map) {
      return Map<String, dynamic>.from(responseData);
    }
    return {'data': responseData};
  }

  List<dynamic> _extractListPayload(dynamic responseData) {
    final payload = _extractPayload(responseData);
    final source =
        payload['data'] ?? payload['messages'] ?? payload['result'] ?? [];
    if (source is List) return source;
    return [];
  }

  String _getErrorMessage(DioException error, String fallback) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['message'] ?? data['msg'] ?? data['error'];
      if (message != null) return message.toString();
    }
    if (data is String && data.isNotEmpty) {
      final body = data.trimLeft().toLowerCase();
      if (body.startsWith('<') || body.startsWith('/*!')) return fallback;
      return data;
    }
    return error.message ?? fallback;
  }

  void _logDioError(String operation, DioException error) {
    final responseBody = error.response?.data?.toString() ?? '<empty>';
    final bodyPreview = responseBody.length > 1200
        ? '${responseBody.substring(0, 1200)}...'
        : responseBody;

    logger(
      'Chat API $operation failed\n'
      'Request: ${error.requestOptions.method} ${error.requestOptions.uri}\n'
      'Dio type: ${error.type}\n'
      'HTTP status: ${error.response?.statusCode ?? '<no response>'}\n'
      'Dio message: ${error.message ?? '<none>'}\n'
      'Response body: $bodyPreview',
      error: error,
      stackTrace: error.stackTrace,
    );
  }

  void _logUnexpectedError(
    String operation,
    Object error,
    StackTrace stackTrace,
  ) {
    logger(
      'Chat API $operation failed while processing the response: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<Either<String, List<ChatMessageEntity>>> getMessages({
    required String otherUserId,
    int page = 0,
    int limit = 50,
  }) async {
    try {
      final response = await apiService.getChatMessages(
        otherUserId: otherUserId,
        page: page,
        limit: limit,
      );

      final rows = _extractListPayload(response.data);
      final messages = rows
          .map(
            (item) =>
                ChatMessageModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      return Right(messages);
    } on DioException catch (e) {
      _logDioError('getMessages', e);
      return Left(_getErrorMessage(e, 'فشل تحميل الرسائل'));
    } catch (e, stackTrace) {
      _logUnexpectedError('getMessages', e, stackTrace);
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ChatMessageEntity>> sendMessage({
    required String receiverId,
    required String content,
    MessageType messageType = MessageType.text,
  }) async {
    try {
      final userResponse = await apiService.getSupabaseCurrentUser();
      final senderId = userResponse.data?['id'];
      if (senderId is! String || senderId.isEmpty) {
        throw const FormatException(
          'Supabase Auth response did not include the user id',
        );
      }

      final response = await apiService.sendChatMessage(
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        messageType: messageType.name,
      );

      final payload = _extractPayload(response.data);
      final data = payload['data'] ?? payload['message'] ?? payload;
      final messageData = data is List && data.isNotEmpty ? data.first : data;
      final message = ChatMessageModel.fromJson(
        Map<String, dynamic>.from(messageData),
      );
      return Right(message);
    } on DioException catch (e) {
      _logDioError('sendMessage', e);
      return Left(_getErrorMessage(e, 'فشل إرسال الرسالة'));
    } catch (e, stackTrace) {
      _logUnexpectedError('sendMessage', e, stackTrace);
      return Left(e.toString());
    }
  }

  @override
  Stream<ChatMessageEntity> get messagesStream =>
      apiService.watchChatMessages().map(ChatMessageModel.fromJson);
}
