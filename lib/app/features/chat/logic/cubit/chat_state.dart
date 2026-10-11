import 'package:equatable/equatable.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessageEntity> messages;
  final bool hasReachedMax;

  const ChatLoaded({required this.messages, this.hasReachedMax = false});

  @override
  List<Object?> get props => [messages, hasReachedMax];

  ChatLoaded copyWith({
    List<ChatMessageEntity>? messages,
    bool? hasReachedMax,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSent extends ChatState {
  final ChatMessageEntity message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}
