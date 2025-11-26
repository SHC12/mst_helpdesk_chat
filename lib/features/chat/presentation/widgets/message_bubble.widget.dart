import 'package:flutter/material.dart';
import 'package:mst_chat/core/theme/colors.dart';

import '../../domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  String _formatTime(DateTime dt) {
    final hRaw = dt.hour % 12;
    final hour = hRaw == 0 ? 12 : hRaw;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    final bubbleColor = isUser ? blueColor : whiteColor;
    final textColor = isUser ? whiteColor : Colors.black87;
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: bubbleColor, borderRadius: BorderRadius.circular(16)),
            child: Text(message.text, style: TextStyle(color: textColor)),
          ),
          const SizedBox(height: 2),
          Text(
            textAlign: TextAlign.right,
            _formatTime(message.createdAt),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
