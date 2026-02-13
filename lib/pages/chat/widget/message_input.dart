
import 'package:dating/pages/chat/widget/media_preview.dart';
import 'package:dating/pages/chat/widget/voice_recorder.dart';
import 'package:dating/providers/chat%20providers/chat_provider.dart';
import 'package:dating/providers/chat%20providers/reply_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class MessageInput extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String receiverId;
  final FocusNode focusNode;
  final VoidCallback onMessageSent;

  const MessageInput({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.receiverId,
    required this.focusNode,
    required this.onMessageSent,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _showMediaOptions = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.onTextChanged(
      widget.chatId,
      widget.currentUserId,
      _controller.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, ReplyProvider>(
      builder: (context, chatProvider, replyProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          child: Column(
            children: [
              if (chatProvider.selectedMedia.isNotEmpty)
                MediaPreview(
                  mediaList: chatProvider.selectedMedia,
                  onRemove: chatProvider.removeMedia,
                ),
           // In the build method, update the voice recorder section:

if (chatProvider.isRecording)
  VoiceRecorder(
    duration: chatProvider.recordingDuration,
    isPaused: chatProvider.isPaused,
    onStop: () => chatProvider.stopRecording(
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      receiverId: widget.receiverId,
    ),
    onCancel: chatProvider.cancelRecording,
    onPause: chatProvider.pauseRecording,
    onResume: chatProvider.resumeRecording,
  ),
if (!chatProvider.isRecording) 
  _buildInputArea(chatProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea(ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildMediaButton(chatProvider),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: widget.focusNode,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: chatProvider.replyToMessage != null
                            ? 'Reply to ${chatProvider.replyToMessage!.senderId == widget.currentUserId ? "yourself" : "message"}...'
                            : 'Type a message...',
                        hintStyle: const TextStyle(color: Colors.white30),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Iconsax.send_1, color: Color(0xFFFF4D67)),
                      onPressed: () => _sendMessage(chatProvider),
                    ),
                  // if (_controller.text.isEmpty)
                    IconButton(
                      icon: const Icon(Iconsax.microphone, color: Colors.white54),
                      onPressed: _startVoiceRecording,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton(ChatProvider chatProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        offset: const Offset(0, -100),
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onSelected: (value) async {
          switch (value) {
            case 'gallery':
              await chatProvider.pickImages();
              break;
            case 'camera':
              await chatProvider.takePhoto();
              break;
            case 'video':
              await chatProvider.pickVideo();
              break;
            case 'record':
              await chatProvider.recordVideo();
              break;
            case 'location':
              _showLocationPicker();
              break;
            case 'document':
              // Pick document
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'gallery',
            child: Row(
              children: [
                Icon(Iconsax.gallery, color: Color(0xFFFFD700)),
                SizedBox(width: 8),
                Text('Gallery', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'camera',
            child: Row(
              children: [
                Icon(Iconsax.camera, color: Color(0xFFFFD700)),
                SizedBox(width: 8),
                Text('Camera', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'video',
            child: Row(
              children: [
                Icon(Iconsax.video, color: Color(0xFFFFD700)),
                SizedBox(width: 8),
                Text('Video', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'record',
            child: Row(
              children: [
                Icon(Iconsax.video_play, color: Color(0xFFFFD700)),
                SizedBox(width: 8),
                Text('Record Video', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'location',
            child: Row(
              children: [
                Icon(Iconsax.location, color: Color(0xFFFFD700)),
                SizedBox(width: 8),
                Text('Location', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'document',
            child: Row(
              children: [
                Icon(Iconsax.document, color: Color(0xFFFFD700)),
                SizedBox(width: 8),
                Text('Document', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'viewonce',
            child: Row(
              children: [
                Icon(
                  Iconsax.eye_slash,
                  color: chatProvider.isViewOnce ? const Color(0xFFFF4D67) : const Color(0xFFFFD700),
                ),
                const SizedBox(width: 8),
                Text(
                  'View Once',
                  style: TextStyle(
                    color: chatProvider.isViewOnce ? const Color(0xFFFF4D67) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
        child: IconButton(
          icon: const Icon(Iconsax.add, color: Colors.white),
          onPressed: null,
        ),
      ),
    );
  }

  void _sendMessage(ChatProvider chatProvider) {
    if (_controller.text.trim().isEmpty && chatProvider.selectedMedia.isEmpty) return;

    chatProvider.sendMessage(
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      receiverId: widget.receiverId,
      text: _controller.text,
    );

    _controller.clear();
    widget.onMessageSent();
  }

  void _startVoiceRecording() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.startRecording();
  }

  void _showLocationPicker() {
    // Navigate to location picker
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }
}