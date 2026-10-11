import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';

abstract class ChatRepository {
  Future<Either<String, List<ChatMessageEntity>>> getMessages({
    required String otherUserId,
    int page = 0,
    int limit = 50,
  });

  Future<Either<String, ChatMessageEntity>> sendMessage({
    required String receiverId,
    required String content,
    MessageType messageType = MessageType.text,
  });

  Stream<ChatMessageEntity> get messagesStream;
}
