import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.contactId,
    required super.text,
    required super.sender,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      contactId: json['contactId'] as String,
      text: json['text'] as String,
      sender: (json['sender'] as String) == 'user' ? ChatSender.user : ChatSender.bot,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'text': text,
      'sender': sender == ChatSender.user ? 'user' : 'bot',
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
