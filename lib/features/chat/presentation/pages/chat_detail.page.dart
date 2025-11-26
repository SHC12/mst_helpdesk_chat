import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mst_chat/core/theme/colors.dart';
import 'package:mst_chat/features/chat/domain/entities/chat_message.dart';
import 'package:mst_chat/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:mst_chat/features/chat/presentation/cubit/chat_state.dart';
import 'package:mst_chat/features/chat/presentation/widgets/chat_contact_header.widget.dart';
import 'package:mst_chat/features/chat/presentation/widgets/chat_input.widget.dart';
import 'package:mst_chat/features/chat/presentation/widgets/message_bubble.widget.dart';

class ChatDetailPage extends StatefulWidget {
  final String contactId;
  const ChatDetailPage({super.key, required this.contactId});
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().selectContact(widget.contactId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            buildWhen: (p, c) => p.contacts != c.contacts || p.selectedContactId != c.selectedContactId,
            builder: (context, state) {
              final contacts = state.contacts;
              if (contacts.isEmpty) {
                return const Text('Chat');
              }
              var contact = contacts.first;
              for (final c in contacts) {
                if (c.id == widget.contactId) {
                  contact = c;
                  break;
                }
              }
              if (contact.isOpen) {
                return Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.teal.shade100, borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    'Open',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.teal.shade800, fontWeight: FontWeight.w600),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
        title: Text('Helpdesk Chat'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ChatContactHeaderWidget(contactId: widget.contactId),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (p, c) => p.messages != c.messages || p.isLoadingMessages != c.isLoadingMessages,
                builder: (context, state) {
                  if (state.isLoadingMessages && state.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final List<ChatMessage> messages = state.messages;
                  if (messages.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return MessageBubble(message: msg);
                    },
                  );
                },
              ),
            ),
            BlocBuilder<ChatCubit, ChatState>(
              buildWhen: (p, c) => p.errorMessage != c.errorMessage,
              builder: (context, state) {
                if (state.errorMessage == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                );
              },
            ),
            const ChatInput(),
          ],
        ),
      ),
    );
  }
}
