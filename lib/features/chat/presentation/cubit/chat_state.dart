import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_contact.dart';
import '../../domain/entities/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatContact> contacts;
  final List<ChatContact> filteredContacts;
  final String searchQuery;
  final String? selectedContactId;
  final List<ChatMessage> messages;
  final bool isLoadingContacts;
  final bool isLoadingMessages;
  final bool isSending;
  final String? errorMessage;

  const ChatState({
    required this.contacts,
    required this.filteredContacts,
    required this.searchQuery,
    required this.selectedContactId,
    required this.messages,
    required this.isLoadingContacts,
    required this.isLoadingMessages,
    required this.isSending,
    required this.errorMessage,
  });

  factory ChatState.initial() {
    return const ChatState(
      contacts: [],
      filteredContacts: [],
      searchQuery: '',
      selectedContactId: null,
      messages: [],
      isLoadingContacts: false,
      isLoadingMessages: false,
      isSending: false,
      errorMessage: null,
    );
  }

  ChatState copyWith({
    List<ChatContact>? contacts,
    List<ChatContact>? filteredContacts,
    String? searchQuery,
    String? selectedContactId,
    List<ChatMessage>? messages,
    bool? isLoadingContacts,
    bool? isLoadingMessages,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatState(
      contacts: contacts ?? this.contacts,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedContactId: selectedContactId ?? this.selectedContactId,
      messages: messages ?? this.messages,
      isLoadingContacts: isLoadingContacts ?? this.isLoadingContacts,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    contacts,
    filteredContacts,
    searchQuery,
    selectedContactId,
    messages,
    isLoadingContacts,
    isLoadingMessages,
    isSending,
    errorMessage,
  ];
}
