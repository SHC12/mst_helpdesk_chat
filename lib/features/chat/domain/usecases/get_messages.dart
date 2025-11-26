import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<List<ChatMessage>> call(String contactId) => repository.getMessages(contactId);
}
