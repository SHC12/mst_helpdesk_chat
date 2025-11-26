enum ChatSender { user, bot }

class ChatMessage {
  final String id;
  final String contactId;
  final String text;
  final ChatSender sender;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.contactId,
    required this.text,
    required this.sender,
    required this.createdAt,
  });
}
