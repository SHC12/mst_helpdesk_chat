class ChatContact {
  final String id;
  final String name;
  final String subtitle;
  final String statusLabel;
  final bool isOpen;
  final DateTime lastUpdated;
  final String? avatarUrl;

  const ChatContact({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.statusLabel,
    required this.isOpen,
    required this.lastUpdated,
    this.avatarUrl,
  });

  ChatContact copyWith({String? subtitle, String? statusLabel, bool? isOpen, DateTime? lastUpdated}) {
    return ChatContact(
      id: id,
      name: name,
      subtitle: subtitle ?? this.subtitle,
      statusLabel: statusLabel ?? this.statusLabel,
      isOpen: isOpen ?? this.isOpen,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      avatarUrl: avatarUrl,
    );
  }
}
