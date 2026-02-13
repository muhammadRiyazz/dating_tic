import 'package:dating/providers/chat%20providers/reply_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ReplyPreview extends StatelessWidget {
  const ReplyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReplyProvider>(
      builder: (context, provider, child) {
        if (provider.replyMessage == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4D67),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Replying to ${provider.replyMessage!.senderId}',
                      style: const TextStyle(
                        color: Color(0xFFFF4D67),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.replyMessage!.text,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Iconsax.close_circle, color: Colors.white54),
                onPressed: provider.clearReply,
              ),
            ],
          ),
        );
      },
    );
  }
}