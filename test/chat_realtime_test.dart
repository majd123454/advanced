import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';
import 'package:swb_advance/app/features/chat/data/repository/chat_repository.dart';
import 'package:swb_advance/app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:swb_advance/app/features/chat/logic/cubit/chat_state.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/get_messages_usecase.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/send_message_usecase.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/watch_chat_messages_usecase.dart';

void main() {
  test('realtime insert updates the chat without refetching history', () async {
    final repository = FakeChatRepository();
    final cubit = ChatCubit(
      getMessagesUseCase: GetMessagesUseCase(repository),
      sendMessageUseCase: SendMessageUseCase(repository),
      watchChatMessagesUseCase: WatchChatMessagesUseCase(repository),
      currentUserId: 'customer-id',
    );
    final liveMessageReceived = Completer<void>();
    final subscription = cubit.stream.listen((state) {
      if (state is ChatLoaded &&
          state.messages.any((message) => message.id == 'realtime-message') &&
          !liveMessageReceived.isCompleted) {
        liveMessageReceived.complete();
      }
    });

    cubit.startListening();
    await cubit.getMessages('support-id');
    repository.realtimeMessages.add(
      const ChatMessageEntity(
        id: 'realtime-message',
        senderId: 'support-id',
        receiverId: 'customer-id',
        content: 'وصلت الرسالة مباشرة',
      ),
    );

    await liveMessageReceived.future.timeout(const Duration(seconds: 1));
    expect(repository.getMessagesCalls, 1);
    expect((cubit.state as ChatLoaded).messages, hasLength(1));

    await subscription.cancel();
    await cubit.close();
    await repository.realtimeMessages.close();
  });
}

class FakeChatRepository implements ChatRepository {
  final StreamController<ChatMessageEntity> realtimeMessages =
      StreamController<ChatMessageEntity>.broadcast();
  int getMessagesCalls = 0;

  @override
  Stream<ChatMessageEntity> get messagesStream => realtimeMessages.stream;

  @override
  Future<Either<String, List<ChatMessageEntity>>> getMessages({
    required String otherUserId,
    int page = 0,
    int limit = 50,
  }) async {
    getMessagesCalls++;
    return Right([]);
  }

  @override
  Future<Either<String, ChatMessageEntity>> sendMessage({
    required String receiverId,
    required String content,
    MessageType messageType = MessageType.text,
  }) async => throw UnimplementedError();
}
