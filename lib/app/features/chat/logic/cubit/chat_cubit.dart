import 'dart:async';
import 'package:swb_advance/app/core/helper/logger.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';
import 'package:swb_advance/app/features/chat/logic/cubit/chat_state.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/get_messages_usecase.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/send_message_usecase.dart';
import 'package:swb_advance/app/features/chat/logic/use_cases/watch_chat_messages_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final WatchChatMessagesUseCase watchChatMessagesUseCase;
  final String currentUserId;
  StreamSubscription<ChatMessageEntity>? _messagesSubscription;

  ChatCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.watchChatMessagesUseCase,
    required this.currentUserId,
  }) : super(ChatInitial());

  List<ChatMessageEntity> _messages = [];
  int _currentPage = 0;
  static const int _limit = 50;
  String? _currentOtherUserId;

  // Expose the currently opened chat other-user id so UI can use it.
  String? get currentOtherUserId => _currentOtherUserId;

  void startListening() {
    _messagesSubscription?.cancel();
    _messagesSubscription = watchChatMessagesUseCase().listen(
      (message) {
        if (isClosed) return;
        final otherUserId = _currentOtherUserId;
        if (otherUserId == null ||
            (message.senderId != otherUserId &&
                message.receiverId != otherUserId) ||
            _messages.any((existing) => existing.id == message.id)) {
          return;
        }

        _messages = _mergeMessages(_messages, [message]);
        emit(ChatLoaded(messages: _messages));
      },
      onError: (Object error, StackTrace stackTrace) {
        logger(
          'Chat realtime stream error: $error',
          name: 'ChatCubit',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  List<ChatMessageEntity> _mergeMessages(
    List<ChatMessageEntity> existing,
    List<ChatMessageEntity> incoming,
  ) {
    final messagesById = {for (final message in existing) message.id: message};
    for (final message in incoming) {
      messagesById[message.id] = message;
    }
    final messages = messagesById.values.toList()
      ..sort((left, right) {
        final leftDate = left.createdAt;
        final rightDate = right.createdAt;
        if (leftDate == null) return rightDate == null ? 0 : -1;
        if (rightDate == null) return 1;
        return leftDate.compareTo(rightDate);
      });
    return messages;
  }

  Future<void> getMessages(String otherUserId, {bool refresh = false}) async {
    if (otherUserId.trim().isEmpty) {
      emit(const ChatError('SUPPORT_USER_ID غير مضبوط في ملف .env'));
      return;
    }

    _currentOtherUserId = otherUserId;

    if (refresh) {
      _currentPage = 0;
      _messages = [];
    }

    if (_currentPage == 0) {
      emit(ChatLoading());
    }

    final result = await getMessagesUseCase.call(
      otherUserId: otherUserId,
      page: _currentPage,
      limit: _limit,
    );

    if (isClosed) return;

    result.fold((error) => emit(ChatError(error)), (messages) {
      // repository returns newest->oldest; convert to oldest->newest for UI
      final incoming = messages.reversed.toList();

      if (_currentPage == 0) {
        _messages = _mergeMessages(_messages, incoming);
      } else {
        _messages = _mergeMessages(_messages, incoming);
      }

      _currentPage++;
      emit(
        ChatLoaded(
          messages: _messages,
          hasReachedMax: messages.length < _limit,
        ),
      );
    });
  }

  Future<void> sendMessage({
    required String receiverId,
    required String content,
    MessageType messageType = MessageType.text,
  }) async {
    // emit(MessageSending());

    final result = await sendMessageUseCase.call(
      receiverId: receiverId,
      content: content,
      messageType: messageType,
    );

    if (isClosed) return;

    result.fold((error) => emit(ChatError(error)), (message) {
      _messages = _mergeMessages(_messages, [message]);
      emit(MessageSent(message));
      emit(ChatLoaded(messages: _messages));
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
