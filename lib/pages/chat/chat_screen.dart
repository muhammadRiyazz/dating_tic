import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dating/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatId, otherUserId, otherUserName, otherUserImage;
  const ChatScreen({super.key, required this.chatId, required this.otherUserId, required this.otherUserName, required this.otherUserImage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  late String _uid;

  @override
   initState()  {
    super.initState();
    getuid();
    _chatService.markMessagesAsRead(widget.chatId);
  }
 Future<String>  getuid()async 
{
  return        _uid = (await AuthService().getUserId())??'';

}  void _send() {
    if (_controller.text.trim().isEmpty) return;
    _chatService.sendMessage(widget.chatId, _controller.text.trim());
    _controller.clear();
    _chatService.setTyping(widget.chatId, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundImage: CachedNetworkImageProvider(widget.otherUserImage)),
            const SizedBox(width: 10),
            Text(widget.otherUserName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessages(widget.chatId),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox();
                final msgs = snap.data!.docs;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: msgs.length,
                  itemBuilder: (context, i) {
                    final data = msgs[i].data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == _uid;
                    return _buildBubble(data['text'], isMe, data['readBy'] ?? []);
                  },
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildBubble(String text, bool isMe, List readBy) {
    bool isRead = readBy.contains(widget.otherUserId);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isMe ? const LinearGradient(colors: [Color(0xFFFF4D67), Color(0xFFFFD700)]) : null,
          color: isMe ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
            if (isMe) Icon(Icons.done_all, size: 12, color: isRead ? Colors.blue : Colors.white60),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
      color: const Color(0xFF1A1A1A),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => _chatService.setTyping(widget.chatId, v.isNotEmpty),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.send1, color: Color(0xFFFFD700)),
            onPressed: _send,
          ),
        ],
      ),
    );
  }
}