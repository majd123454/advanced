import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';
import 'package:swb_advance/app/features/chat/data/repository/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<String, ChatMessageEntity>> call({
    required String receiverId,
    required String content,
    MessageType messageType = MessageType.text,
  }) async {
    return repository.sendMessage(
      receiverId: receiverId,
      content: content,
      messageType: messageType,
    );
  }
}
