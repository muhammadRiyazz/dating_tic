import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/models/message_models.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/chat/widget/chat_app_bar.dart';
import 'package:dating/pages/chat/widget/message_bubble.dart';
import 'package:dating/pages/chat/widget/message_input.dart';
import 'package:dating/pages/chat/widget/reply_preview.dart';

import 'package:dating/providers/chat%20providers/chat_provider.dart';
import 'package:dating/providers/chat%20providers/reply_provider.dart';
import 'package:dating/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final Profile receiverProfile;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.receiverProfile,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  void _markMessagesAsRead() {
    _chatService.markMessagesAsRead(widget.chatId, widget.currentUserId);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ReplyProvider()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: Column(
          children: [
            ChatAppBar(
              receiverProfile: widget.receiverProfile,
              chatId: widget.chatId, 
            ),
            Expanded(
              child: _buildMessageList(),
            ),
            const ReplyPreview(),
            MessageInput(
              chatId: widget.chatId,
              currentUserId: widget.currentUserId,
              receiverId: widget.receiverProfile.uID!,
              focusNode: _focusNode,
              onMessageSent: _scrollToBottom,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessagesStream(widget.chatId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading messages',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF4D67)),
          );
        }

        final messages = snapshot.data!.docs.map((doc) {
          return MessageModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        if (messages.isEmpty) {
          return _buildEmptyState();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isMe = message.senderId == widget.currentUserId;
            
            return MessageBubble(
              message: message,
              isMe: isMe,
              chatId: widget.chatId,
              currentUserId: widget.currentUserId,
              receiverProfile: widget.receiverProfile,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4D67), Color(0xFFFFD700)],
              ),
              shape: BoxShape.circle,
            ),
            child:  Icon(
              Iconsax.message,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Say hi to ${widget.receiverProfile.userName}!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No messages yet. Start the conversation!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}