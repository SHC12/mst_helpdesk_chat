import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mst_chat/features/chat/domain/entities/chat_contact.dart';
import 'package:mst_chat/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:mst_chat/features/chat/presentation/cubit/chat_state.dart';

class ChatHeaderWidget extends StatelessWidget {
  const ChatHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (p, c) => p.selectedContactId != c.selectedContactId || p.contacts != c.contacts,
      builder: (context, state) {
        final id = state.selectedContactId;
        if (id == null) {
          return const SizedBox(height: 56);
        }

        final ChatContact contact = state.contacts.firstWhere((c) => c.id == id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(radius: 18, child: Text(contact.name.isNotEmpty ? contact.name[0] : '?')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              if (contact.isOpen)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.teal.shade100, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Open',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.teal.shade800),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
