import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';
import 'package:swb_advance/app/features/chat/data/repository/chat_repository.dart';

class WatchChatMessagesUseCase {
  final ChatRepository repository;

  WatchChatMessagesUseCase(this.repository);

  Stream<ChatMessageEntity> call() => repository.messagesStream;
}
