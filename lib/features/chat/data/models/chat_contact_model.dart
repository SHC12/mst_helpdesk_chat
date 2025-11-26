import '../../domain/entities/chat_contact.dart';

class ChatContactModel extends ChatContact {
  const ChatContactModel({
    required super.id,
    required super.name,
    required super.subtitle,
    required super.statusLabel,
    required super.isOpen,
    required super.lastUpdated,
    super.avatarUrl,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      statusLabel: json['statusLabel'] as String? ?? '',
      isOpen: json['isOpen'] as bool? ?? false,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'statusLabel': statusLabel,
      'isOpen': isOpen,
      'lastUpdated': lastUpdated.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }
}
