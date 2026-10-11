import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  // ignore: use_super_parameters
  const ChatMessageModel({
    required String id,
    required String senderId,
    required String receiverId,
    required String content,
    MessageType messageType = MessageType.text,
    bool isRead = false,
    DateTime? createdAt,
    String? senderName,
    String? senderAvatar,
  }) : super(
         id: id,
         senderId: senderId,
         receiverId: receiverId,
         content: content,
         messageType: messageType,
         isRead: isRead,
         createdAt: createdAt,
         senderName: senderName,
         senderAvatar: senderAvatar,
       );

  /// من Supabase → Model
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      content: json['content'] as String,
      messageType: _parseMessageType(json['message_type'] ?? json['type']),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      senderName: json['sender']?['full_name'],
      senderAvatar: json['sender']?['avatar_url'],
    );
  }

  /// Model → Supabase
  @override
  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'message_type': messageType.name,
      'is_read': isRead,
    };
  }

  static MessageType _parseMessageType(dynamic type) {
    switch (type) {
      case 'image':
        return MessageType.image;
      case 'system':
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }
}
