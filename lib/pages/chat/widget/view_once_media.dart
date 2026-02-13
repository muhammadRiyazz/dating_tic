import 'package:dating/models/message_models.dart';
import 'package:dating/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewOnceMedia extends StatefulWidget {
  final MessageModel message;
  final String currentUserId;
  final String chatId;

  const ViewOnceMedia({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.chatId,
  });

  @override
  State<ViewOnceMedia> createState() => _ViewOnceMediaState();
}

class _ViewOnceMediaState extends State<ViewOnceMedia>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isViewed = false;
  int _secondsRemaining = 5;
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _markAsViewed();
        Navigator.pop(context);
      }
    });

    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _secondsRemaining--;
        });
        if (_secondsRemaining > 0) {
          _startTimer();
        }
      }
    });
  }

  void _markAsViewed() async {
    if (!_isViewed && widget.message.receiverId == widget.currentUserId) {
      _isViewed = true;
      // Mark as viewed in Firestore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: widget.message.mediaUrls.first,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                _markAsViewed();
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_secondsRemaining',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 32,
            right: 32,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _controller.value,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF4D67)),
                );
              },
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'View Once',
                  style: TextStyle(color: Color(0xFFFFD700), fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}