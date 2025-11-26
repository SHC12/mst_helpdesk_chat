import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<ChatMessage> call({required String contactId, required String text}) {
    return repository.sendMessage(contactId: contactId, text: text);
  }
}
