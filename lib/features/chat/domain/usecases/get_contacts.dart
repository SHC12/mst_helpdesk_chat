import '../entities/chat_contact.dart';
import '../repositories/chat_repository.dart';

class GetContacts {
  final ChatRepository repository;

  GetContacts(this.repository);

  Future<List<ChatContact>> call() => repository.getContacts();
}
