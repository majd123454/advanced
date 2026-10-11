import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';
import 'package:swb_advance/app/features/chat/data/repository/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<Either<String, List<ChatMessageEntity>>> call({
    required String otherUserId,
    int page = 0,
    int limit = 50,
  }) async {
    return repository.getMessages(
      otherUserId: otherUserId,
      page: page,
      limit: limit,
    );
  }
}
