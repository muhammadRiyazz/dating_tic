import 'package:dating/models/message_models.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MessageOptions extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final String chatId;
  final String currentUserId;
  final VoidCallback onReply;
  final VoidCallback onCopy;
  final VoidCallback onDelete;
  final VoidCallback onForward;
  final Function(String) onReact;

  const MessageOptions({
    super.key,
    required this.message,
    required this.isMe,
    required this.chatId,
    required this.currentUserId,
    required this.onReply,
    required this.onCopy,
    required this.onDelete,
    required this.onForward,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reactions
          _buildReactionsRow(),
          const Divider(color: Colors.white24),
          
          // Options
          _buildOption(
            icon: Iconsax.activity,
            label: 'Reply',
            onTap: onReply,
          ),
          if (message.type == MessageType.text)
            _buildOption(
              icon: Iconsax.copy,
              label: 'Copy',
              onTap: onCopy,
            ),
          _buildOption(
            icon: Iconsax.forward,
            label: 'Forward',
            onTap: onForward,
          ),
          if (isMe)
            _buildOption(
              icon: Iconsax.trash,
              label: 'Delete',
              onTap: onDelete,
              color: Colors.red,
            ),
        ],
      ),
    );
  }

  Widget _buildReactionsRow() {
    final reactions = ['❤️', '😂', '😮', '😢', '😡', '👍'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: reactions.map((reaction) {
          return GestureDetector(
            onTap: () => onReact(reaction),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Text(
                reaction,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color),
      ),
      onTap: onTap,
    );
  }
}