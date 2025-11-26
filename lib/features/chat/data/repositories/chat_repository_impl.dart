import 'dart:math';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_contact_model.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;

  final _random = Random();

  ChatRepositoryImpl({required this.localDataSource, required this.remoteDataSource});

  Future<void> _ensureDummySeeded() async {
    final existing = await localDataSource.getContacts();
    if (existing.isNotEmpty) return;

    final now = DateTime.now();

    final contacts = [
      ChatContactModel(
        id: '1',
        name: 'Cameron Williamson',
        subtitle: "Can't log in",
        statusLabel: 'Open',
        isOpen: true,
        lastUpdated: now.subtract(const Duration(minutes: 5)),
        avatarUrl: null,
      ),
      ChatContactModel(
        id: '2',
        name: 'Kristin Watson',
        subtitle: 'Error message',
        statusLabel: 'Tue',
        isOpen: false,
        lastUpdated: now.subtract(const Duration(days: 1)),
        avatarUrl: null,
      ),
      ChatContactModel(
        id: '3',
        name: 'Kathryn Murphy',
        subtitle: 'Payment issue',
        statusLabel: 'Tue',
        isOpen: false,
        lastUpdated: now.subtract(const Duration(days: 1)),
        avatarUrl: null,
      ),
      ChatContactModel(
        id: '4',
        name: 'Ralph Edwards',
        subtitle: 'Account assistance',
        statusLabel: 'Mon',
        isOpen: false,
        lastUpdated: now.subtract(const Duration(days: 2)),
        avatarUrl: null,
      ),
    ];

    await localDataSource.saveContacts(contacts);

    final messages1 = <ChatMessageModel>[
      ChatMessageModel(
        id: _generateId(),
        contactId: '1',
        text: "I can't log in to the app.",
        sender: ChatSender.user,
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
      ChatMessageModel(
        id: _generateId(),
        contactId: '1',
        text: "Please send a screenshot of the error.",
        sender: ChatSender.bot,
        createdAt: now.subtract(const Duration(minutes: 8)),
      ),
      ChatMessageModel(
        id: _generateId(),
        contactId: '1',
        text: "log txt",
        sender: ChatSender.user,
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      ChatMessageModel(
        id: _generateId(),
        contactId: '1',
        text: "Thank you, we'll check this for you.",
        sender: ChatSender.bot,
        createdAt: now.subtract(const Duration(minutes: 4)),
      ),
    ];
    await localDataSource.saveMessages('1', messages1);

    for (final c in contacts.skip(1)) {
      final msgs = [
        ChatMessageModel(
          id: _generateId(),
          contactId: c.id,
          text: c.subtitle,
          sender: ChatSender.user,
          createdAt: c.lastUpdated,
        ),
      ];
      await localDataSource.saveMessages(c.id, msgs);
    }
  }

  @override
  Future<List<ChatContactModel>> getContacts() async {
    await _ensureDummySeeded();
    return localDataSource.getContacts();
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String contactId) async {
    await _ensureDummySeeded();
    return localDataSource.getMessages(contactId);
  }

  @override
  Future<ChatMessageModel> sendMessage({required String contactId, required String text}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Message text cannot be empty');
    }

    final existingMessages = await localDataSource.getMessages(contactId);
    final contacts = await localDataSource.getContacts();
    final now = DateTime.now();

    final userMessage = ChatMessageModel(
      id: _generateId(),
      contactId: contactId,
      text: trimmed,
      sender: ChatSender.user,
      createdAt: now,
    );

    final updatedMessages = [...existingMessages, userMessage];

    ChatMessageModel? botMessage;

    try {
      final replyText = await remoteDataSource.generateReply(trimmed);
      botMessage = ChatMessageModel(
        id: _generateId(),
        contactId: contactId,
        text: replyText,
        sender: ChatSender.bot,
        createdAt: DateTime.now(),
      );
      updatedMessages.add(botMessage);
    } catch (_) {}

    await localDataSource.saveMessages(contactId, updatedMessages);

    final updatedContacts = contacts.map((c) {
      if (c.id != contactId) return c;
      final lastText = botMessage?.text ?? userMessage.text;
      final lastTime = botMessage?.createdAt ?? userMessage.createdAt;

      return ChatContactModel(
        id: c.id,
        name: c.name,
        subtitle: lastText,
        statusLabel: c.statusLabel,
        isOpen: c.isOpen,
        lastUpdated: lastTime,
        avatarUrl: c.avatarUrl,
      );
    }).toList();

    await localDataSource.saveContacts(updatedContacts);

    return botMessage ?? userMessage;
  }

  String _generateId() => _random.nextInt(1 << 32).toString();
}
