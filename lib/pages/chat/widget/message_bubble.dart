import 'package:dating/models/message_models.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/chat/widget/helpers.dart';
import 'package:dating/pages/chat/widget/media_viewer.dart';
import 'package:dating/pages/chat/widget/message_options.dart';
import 'package:dating/pages/chat/widget/view_once_media.dart';

import 'package:dating/providers/chat%20providers/chat_provider.dart';
import 'package:dating/providers/chat%20providers/reply_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';

class MessageBubble extends StatefulWidget {
  final MessageModel message;
  final bool isMe;
  final String chatId;
  final String currentUserId;
  final Profile receiverProfile;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.chatId,
    required this.currentUserId,
    required this.receiverProfile,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.message.isDeleted) {
      return _buildDeletedMessage();
    }

    return GestureDetector(
      onLongPress: () {
        _showMessageOptions(context);
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.isMe ? 50 : 0,
          right: widget.isMe ? 0 : 50,
        ),
        child: Column(
          crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (widget.message.replyToId != null)
              _buildReplyPreview(),
            if (widget.message.type == MessageType.text)
              _buildTextMessage(),
            if (widget.message.type == MessageType.image)
              _buildImageMessage(),
            if (widget.message.type == MessageType.video)
              _buildVideoMessage(),
            if (widget.message.type == MessageType.audio)
              _buildAudioMessage(),
            if (widget.message.type == MessageType.location)
              _buildLocationMessage(),
            if (widget.message.type == MessageType.viewOnce)
              _buildViewOnceMessage(),
            if (widget.message.type == MessageType.document)
              _buildDocumentMessage(),
            _buildMessageFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: widget.isMe
            ? const LinearGradient(
                colors: [Color(0xFFFF4D67), Color(0xFFFF8A9B)],
              )
            : null,
        color: widget.isMe ? null : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20).copyWith(
          bottomLeft: Radius.circular(widget.isMe ? 20 : 4),
          bottomRight: Radius.circular(widget.isMe ? 4 : 20),
        ),
      ),
      child: Text(
        widget.message.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildImageMessage() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MediaViewer(
              mediaUrls: widget.message.mediaUrls,
              initialIndex: 0,
              heroTag: widget.message.messageId, isVideo: false,
            ),
          ),
        );
      },
      child: Hero(
        tag: widget.message.messageId,
        child: Container(
          width: 200,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.message.mediaUrls.first),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildUploadProgress(),
        ),
      ),
    );
  }

  Widget _buildVideoMessage() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MediaViewer(
              mediaUrls: widget.message.mediaUrls,
              initialIndex: 0,
              isVideo: true,
              heroTag: widget.message.messageId,
            ),
          ),
        );
      },
      child: Hero(
        tag: widget.message.messageId,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.message.metadata?['thumbnail'] ?? '',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            _buildUploadProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioMessage() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: widget.isMe
            ? const LinearGradient(
                colors: [Color(0xFFFF4D67), Color(0xFFFF8A9B)],
              )
            : null,
        color: widget.isMe ? null : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
           Icon(
            Iconsax.voice_cricle,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Voice message',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            Helpers.formatDuration(widget.message.metadata?['duration'] ?? 0),
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMessage() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Icon(
                Iconsax.location,
                size: 40,
                color: Colors.white54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(
                  Iconsax.location,
                  size: 16,
                  color: Color(0xFFFF4D67),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.message.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewOnceMessage() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewOnceMedia(
              message: widget.message,
              currentUserId: widget.currentUserId,
              chatId: widget.chatId,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[900],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Iconsax.eye_slash,
              size: 40,
              color: Color(0xFFFFD700),
            ),
            const SizedBox(height: 8),
            Text(
              'View Once Media',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            if (widget.message.viewOnceData?['viewed'] == true)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Opened',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentMessage() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: widget.isMe
            ? const LinearGradient(
                colors: [Color(0xFFFF4D67), Color(0xFFFF8A9B)],
              )
            : null,
        color: widget.isMe ? null : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Iconsax.document,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.metadata?['fileName'] ?? 'Document',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  Helpers.formatFileSize(widget.message.metadata?['fileSize'] ?? 0),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isMe ? const Color(0xFFFF4D67) : Colors.white24,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3,
            height: 30,
            decoration: BoxDecoration(
              color: widget.isMe ? const Color(0xFFFF4D67) : Colors.white54,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying',
                  style: TextStyle(
                    color: (widget.isMe ? Colors.white : const Color(0xFFFFD700)),
                    fontSize: 10,
                  ),
                ),
                Text(
                  widget.message.replyToMessage?.text ?? 'Original message',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadProgress() {
    if (widget.message.uploadProgress != null && widget.message.uploadProgress! < 1.0) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: widget.message.uploadProgress,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                '${(widget.message.uploadProgress! * 100).toInt()}%',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDeletedMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'This message was deleted',
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildMessageFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Helpers.formatTime(widget.message.timestamp),
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 10,
            ),
          ),
          if (widget.isMe) ...[
            const SizedBox(width: 4),
            _buildStatusIcon(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (widget.message.status) {
      case MessageStatus.sending:
        return const Icon(Iconsax.clock, size: 12, color: Colors.white30);
      case MessageStatus.sent:
        return const Icon(Icons.done, size: 12, color: Colors.white30);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 12, color: Colors.white30);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 12, color: Color(0xFFFFD700));
      case MessageStatus.error:
        return const Icon(Icons.error, size: 12, color: Colors.red);
    }
  }

  void _showMessageOptions(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final replyProvider = Provider.of<ReplyProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MessageOptions(
        message: widget.message,
        isMe: widget.isMe,
        chatId: widget.chatId,
        currentUserId: widget.currentUserId,
        onReply: () {
          replyProvider.setReply(widget.message);
          Navigator.pop(context);
        },
        onCopy: () {
          Helpers.copyToClipboard(widget.message.text);
          Navigator.pop(context);
        },
        onDelete: () {
          chatProvider.deleteMessage(widget.chatId, widget.message);
          Navigator.pop(context);
        },
        onForward: () {
          // Show forward screen
          Navigator.pop(context);
        },
        onReact: (reaction) {
          chatProvider.addReaction(widget.chatId, widget.message.messageId, reaction);
          Navigator.pop(context);
        },
      ),
    );
  }
}