import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String email;
  final bool isMe;
  final DateTime timestamp;
  final String userImage;

  const MessageBubble({
    super.key,
    required this.message,
    required this.email,
    required this.isMe,
    required this.timestamp,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(userImage),
            radius: 18,
          ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isMe ? Colors.deepPurple[200] : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: isMe
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
                bottomRight: isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: isMe ? TextAlign.right : TextAlign.left,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.Hm().format(timestamp),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isMe) const SizedBox(width: 8),
        if (isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(userImage),
            radius: 18,
          ),
      ],
    );
  }
}
