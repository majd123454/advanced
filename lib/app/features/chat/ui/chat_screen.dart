import 'package:swb_advance/app/core/helper/logger.dart';
import 'package:swb_advance/app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:swb_advance/app/features/chat/logic/cubit/chat_state.dart';
import 'package:swb_advance/app/features/chat/ui/widgets/message_bubble.dart';
import 'package:swb_advance/app/features/chat/ui/widgets/message_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    try {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدعم الفني')),
      body: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );
          }
        },
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ChatError) {
              logger(state.message);
              return Center(child: Text(state.message));
            }
            if (state is ChatLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: state.messages.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد رسائل',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              reverse: false,
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                final currentUserId = context
                                    .read<ChatCubit>()
                                    .currentUserId;
                                final isFromCurrentUser =
                                    message.senderId == currentUserId;

                                return MessageBubble(
                                  message: message,
                                  isFromCurrentUser: isFromCurrentUser,
                                );
                              },
                            ),
                    ),
                    const MessageInputField(),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
