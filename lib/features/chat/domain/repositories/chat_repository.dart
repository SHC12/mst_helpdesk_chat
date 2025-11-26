import '../entities/chat_contact.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatContact>> getContacts();
  Future<List<ChatMessage>> getMessages(String contactId);
  Future<ChatMessage> sendMessage({required String contactId, required String text});
}
