import 'package:swb_advance/app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({super.key});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  void _send() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _sending = true);

    final cubit = context.read<ChatCubit>();
    final receiverId = cubit.currentOtherUserId ?? '';

    // If no receiver id is available, don't attempt to send.
    if (receiverId.isEmpty) {
      setState(() => _sending = false);
      return;
    }

    await cubit.sendMessage(
      content: _controller.text.trim(),
      receiverId: receiverId,
    );

    _controller.clear();
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !_sending,
              decoration: const InputDecoration(hintText: 'اكتب رسالة...'),
              onSubmitted: (_) => _send(),
            ),
          ),
          IconButton(
            icon: _sending
                ? const CircularProgressIndicator()
                : const Icon(Iconsax.send_1),
            onPressed: _sending ? null : _send,
          ),
        ],
      ),
    );
  }
}
