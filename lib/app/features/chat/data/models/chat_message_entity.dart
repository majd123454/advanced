import 'package:equatable/equatable.dart';

enum MessageType { text, image, system }

class ChatMessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType messageType;
  final bool isRead;
  final DateTime? createdAt;

  // Optional joined data
  final String? senderName;
  final String? senderAvatar;

  const ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.messageType = MessageType.text,
    this.isRead = false,
    this.createdAt,
    this.senderName,
    this.senderAvatar,
  });

  /// 👤 هل الرسالة من المستخدم الحالي؟
  bool isFromUser(String userId) => senderId == userId;

  /// 🔁 Supabase → Entity
  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      id: json['id'].toString(),
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      messageType: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      senderName: json['sender_name'],
      senderAvatar: json['sender_avatar'],
    );
  }

  /// 🔁 Entity → Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'type': messageType.name,
      'is_read': isRead,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ChatMessageEntity copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    MessageType? messageType,
    bool? isRead,
    DateTime? createdAt,
    String? senderName,
    String? senderAvatar,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
    );
  }

  @override
  List<Object?> get props => [
    id,
    senderId,
    receiverId,
    content,
    messageType,
    isRead,
    createdAt,
  ];
}
