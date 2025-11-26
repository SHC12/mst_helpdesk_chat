import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mst_chat/core/theme/colors.dart';
import 'package:mst_chat/features/chat/domain/entities/chat_contact.dart';
import 'package:mst_chat/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:mst_chat/features/chat/presentation/cubit/chat_state.dart';

class ChatContactHeaderWidget extends StatelessWidget {
  final String contactId;

  const ChatContactHeaderWidget({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (p, c) => p.contacts != c.contacts,
      builder: (context, state) {
        final contacts = state.contacts;
        if (contacts.isEmpty) {
          return const SizedBox.shrink();
        }

        ChatContact contact = contacts.first;
        for (final c in contacts) {
          if (c.id == contactId) {
            contact = c;
            break;
          }
        }

        return Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(radius: 20, child: Text(contact.name.isNotEmpty ? contact.name[0] : '?')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
