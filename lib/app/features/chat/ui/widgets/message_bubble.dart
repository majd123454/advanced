import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/helper/spacing.dart';
import 'package:swb_advance/app/features/chat/data/models/chat_message_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isFromCurrentUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isFromCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
      child: Align(
        alignment: isFromCurrentUser
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.md,
            vertical: TSizes.sm,
          ),
          decoration: BoxDecoration(
            color: isFromCurrentUser
                ? Theme.of(context).primaryColor
                : (dark ? Colors.grey[700] : Colors.grey[300]),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(TSizes.cardRadiusMd),
              topRight: const Radius.circular(TSizes.cardRadiusMd),
              bottomLeft: Radius.circular(
                isFromCurrentUser ? TSizes.cardRadiusMd : 0,
              ),
              bottomRight: Radius.circular(
                isFromCurrentUser ? 0 : TSizes.cardRadiusMd,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message content
              if (message.messageType == MessageType.text)
                Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isFromCurrentUser ? Colors.white : null,
                  ),
                )
              else if (message.messageType == MessageType.image)
                GestureDetector(
                  onTap: () {
                    // Show image in full screen
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                    child: Image.network(
                      message.content,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: 200,
                          color: Colors.grey,
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                )
              else
                Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isFromCurrentUser ? Colors.white : null,
                    fontStyle: FontStyle.italic,
                  ),
                ),

              // Message time
              const SizedBox(height: TSizes.xs),
              Text(
                _formatTime(message.createdAt),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isFromCurrentUser
                      ? Colors.white70
                      : (dark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} د';
    } else if (difference.inHours < 24) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('dd/MM').format(dateTime);
    }
  }
}
