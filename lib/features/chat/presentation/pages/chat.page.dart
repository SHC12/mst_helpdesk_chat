import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mst_chat/features/chat/presentation/pages/chat_detail.page.dart';
import 'package:mst_chat/features/chat/presentation/widgets/chat_header.widget.dart';
import 'package:mst_chat/features/chat/presentation/widgets/chat_input.widget.dart';
import 'package:mst_chat/features/chat/presentation/widgets/contact_list_item.widget.dart';
import 'package:mst_chat/features/chat/presentation/widgets/filtered_contacts.widget.dart';
import 'package:mst_chat/features/chat/presentation/widgets/message_bubble.widget.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return const ContactListDesktopPage();
        } else {
          return const ContactListPage();
        }
      },
    );
  }
}

class ContactListDesktopPage extends StatelessWidget {
  const ContactListDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helpdesk Chat'), centerTitle: true),
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 280,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                    child: FilteredContactsWidget(),
                  ),
                  Expanded(
                    child: BlocBuilder<ChatCubit, ChatState>(
                      buildWhen: (p, c) =>
                          p.filteredContacts != c.filteredContacts ||
                          p.selectedContactId != c.selectedContactId ||
                          p.isLoadingContacts != c.isLoadingContacts,
                      builder: (context, state) {
                        final contacts = state.filteredContacts;

                        if (state.isLoadingContacts && contacts.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (contacts.isEmpty) {
                          return const Center(child: Text('No conversations'));
                        }
                        return ListView.separated(
                          itemCount: contacts.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            final selected = contact.id == state.selectedContactId;
                            return ContactListItem(
                              contact: contact,
                              selected: selected,
                              onTap: () => context.read<ChatCubit>().selectContact(contact.id),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  const ChatHeaderWidget(),
                  const Divider(height: 1),
                  Expanded(
                    child: BlocBuilder<ChatCubit, ChatState>(
                      buildWhen: (p, c) => p.messages != c.messages || p.isLoadingMessages != c.isLoadingMessages,
                      builder: (context, state) {
                        if (state.selectedContactId == null) {
                          return const Center(child: Text('Select a conversation'));
                        }

                        if (state.isLoadingMessages && state.messages.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state.messages.isEmpty) {
                          return const Center(child: Text('No messages yet.'));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final msg = state.messages[index];
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
          ],
        ),
      ),
    );
  }
}

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helpdesk Chat'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: FilteredContactsWidget()),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (p, c) =>
                    p.filteredContacts != c.filteredContacts || p.isLoadingContacts != c.isLoadingContacts,
                builder: (context, state) {
                  final contacts = state.filteredContacts;

                  if (state.isLoadingContacts && contacts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (contacts.isEmpty) {
                    return const Center(child: Text('No conversations'));
                  }

                  return ListView.separated(
                    itemCount: contacts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ContactListItem(
                        contact: contact,
                        selected: false,
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (_) => ChatDetailPage(contactId: contact.id)));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
