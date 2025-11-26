import 'package:hive_flutter/hive_flutter.dart';

import '../models/chat_contact_model.dart';
import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatContactModel>> getContacts();
  Future<void> saveContacts(List<ChatContactModel> contacts);

  Future<List<ChatMessageModel>> getMessages(String contactId);
  Future<void> saveMessages(String contactId, List<ChatMessageModel> messages);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Box<Map> contactsBox;
  final Box<Map> messagesBox;

  ChatLocalDataSourceImpl({required this.contactsBox, required this.messagesBox});

  @override
  Future<List<ChatContactModel>> getContacts() async {
    final list = contactsBox.values.map((e) => ChatContactModel.fromJson(Map<String, dynamic>.from(e))).toList();

    list.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    return list;
  }

  @override
  Future<void> saveContacts(List<ChatContactModel> contacts) async {
    await contactsBox.clear();
    for (final c in contacts) {
      await contactsBox.put(c.id, c.toJson());
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String contactId) async {
    final result = <ChatMessageModel>[];

    for (final value in messagesBox.values) {
      final map = Map<String, dynamic>.from(value);
      if (map['contactId'] == contactId) {
        result.add(ChatMessageModel.fromJson(map));
      }
    }

    result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return result;
  }

  @override
  Future<void> saveMessages(String contactId, List<ChatMessageModel> messages) async {
    final keysToDelete = <dynamic>[];
    for (final key in messagesBox.keys) {
      final raw = messagesBox.get(key);
      if (raw == null) continue;
      final map = Map<String, dynamic>.from(raw);
      if (map['contactId'] == contactId) {
        keysToDelete.add(key);
      }
    }
    if (keysToDelete.isNotEmpty) {
      await messagesBox.deleteAll(keysToDelete);
    }

    for (final m in messages) {
      await messagesBox.put(m.id, m.toJson());
    }
  }
}
