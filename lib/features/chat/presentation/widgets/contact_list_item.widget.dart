import 'package:flutter/material.dart';

import '../../domain/entities/chat_contact.dart';

class ContactListItem extends StatelessWidget {
  final ChatContact contact;
  final bool selected;
  final VoidCallback onTap;

  const ContactListItem({super.key, required this.contact, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = selected ? Colors.grey.shade200 : Colors.transparent;

    return Material(
      color: bgColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(radius: 18, child: Text(contact.name.isNotEmpty ? contact.name[0] : '?')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      contact.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (contact.isOpen)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.teal.shade100, borderRadius: BorderRadius.circular(12)),
                  child: Text('Open', style: theme.textTheme.labelSmall?.copyWith(color: Colors.teal.shade800)),
                )
              else
                Text(contact.statusLabel, style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}
