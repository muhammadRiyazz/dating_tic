import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dating/main.dart'; 
import 'package:dating/services/notification/in_app_notification.dart';

class InAppBanner {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;
  static bool _isVisible = false;
  
  static void show(InAppNotification notification, VoidCallback onTap) {
    dismiss(); // Remove existing
    
    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;
    
    _isVisible = true;
    _currentEntry = OverlayEntry(
      builder: (context) => _BannerWidget(
        notification: notification,
        onTap: onTap,
        onDismiss: dismiss,
      ),
    );
    
    overlayState.insert(_currentEntry!);

    _dismissTimer = Timer(const Duration(seconds: 6), () {
      dismiss();
    });
  }

  static void dismiss() {
    if (!_isVisible) return;
    _isVisible = false;
    _dismissTimer?.cancel();
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _BannerWidget extends StatelessWidget {
  final InAppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _BannerWidget({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      tween: Tween(begin: -150.0, end: 0.0),
      builder: (context, value, child) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 10 + value,
          left: 12, right: 12,
          child: child!,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                onDismiss();
                onTap();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                  boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20)],
                ),
                child: Row(
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            notification.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            notification.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white38, size: 20),
                      onPressed: onDismiss,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _getColor(), width: 2),
        image: notification.senderImage != null 
          ? DecorationImage(image: NetworkImage(notification.senderImage!), fit: BoxFit.cover)
          : null,
      ),
      child: notification.senderImage == null 
        ? const Icon(Icons.person, color: Colors.white24) 
        : null,
    );
  }

  Color _getColor() {
    if (notification.type == 'match') return Colors.greenAccent;
    if (notification.type == 'like') return Colors.pinkAccent;
    return Colors.amber;
  }
}