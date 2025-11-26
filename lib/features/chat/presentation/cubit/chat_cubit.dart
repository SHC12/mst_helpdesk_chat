import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mst_chat/features/chat/domain/entities/chat_contact.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_contacts.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetContacts getContactsUseCase;
  final GetMessages getMessagesUseCase;
  final SendMessage sendMessageUseCase;

  ChatCubit({required this.getContactsUseCase, required this.getMessagesUseCase, required this.sendMessageUseCase})
    : super(ChatState.initial());

  Future<void> loadInitial() async {
    emit(state.copyWith(isLoadingContacts: true, errorMessage: null, searchQuery: ''));

    try {
      final contacts = await getContactsUseCase();
      String? selectedId = state.selectedContactId;

      if (selectedId == null && contacts.isNotEmpty) {
        selectedId = contacts.first.id;
      }

      List<ChatMessage> messages = state.messages;
      if (selectedId != null) {
        messages = await getMessagesUseCase(selectedId);
      }
      final filtered = _applySearchFilter(contacts, state.searchQuery);

      emit(
        state.copyWith(
          filteredContacts: filtered,
          searchQuery: state.searchQuery,
          contacts: contacts,
          selectedContactId: selectedId,
          messages: messages,
          isLoadingContacts: false,
          isLoadingMessages: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoadingContacts: false, isLoadingMessages: false, errorMessage: e.toString(), searchQuery: ''),
      );
    }
  }

  Future<void> selectContact(String contactId) async {
    if (contactId == state.selectedContactId) return;

    emit(state.copyWith(selectedContactId: contactId, isLoadingMessages: true, errorMessage: null, searchQuery: ''));

    try {
      final msgs = await getMessagesUseCase(contactId);
      emit(state.copyWith(messages: msgs, isLoadingMessages: false, searchQuery: ''));
    } catch (e) {
      emit(state.copyWith(isLoadingMessages: false, errorMessage: e.toString(), searchQuery: ''));
    }
  }

  Future<void> send(String text) async {
    final contactId = state.selectedContactId;
    if (contactId == null) return;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    emit(state.copyWith(isSending: true, errorMessage: null, searchQuery: ''));

    try {
      await sendMessageUseCase(contactId: contactId, text: trimmed);
      final msgs = await getMessagesUseCase(contactId);

      emit(state.copyWith(messages: msgs, isSending: false, searchQuery: ''));
    } catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.toString(), searchQuery: ''));
    }
  }

  List<ChatContact> _applySearchFilter(List<ChatContact> contacts, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return List<ChatContact>.from(contacts);
    }

    return contacts.where((c) {
      final name = c.name.toLowerCase();
      final subtitle = c.subtitle.toLowerCase();
      return name.contains(q) || subtitle.contains(q);
    }).toList();
  }

  void updateSearchQuery(String query) {
    final filtered = _applySearchFilter(state.contacts, query);
    emit(state.copyWith(searchQuery: query, filteredContacts: filtered));
  }
}
