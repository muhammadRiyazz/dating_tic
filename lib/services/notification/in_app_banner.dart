// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:dating/main.dart'; 
// import 'package:dating/services/notification/in_app_notification.dart';

// class InAppBanner {
//   static OverlayEntry? _currentEntry;
  
//   static void show(InAppNotification notification, VoidCallback onTap) {
//     dismiss(); // Clear previous if exists
    
//     final overlayState = navigatorKey.currentState?.overlay;
//     if (overlayState == null) return;
    
//     _currentEntry = OverlayEntry(
//       builder: (context) => TweenAnimationBuilder<double>(
//         duration: const Duration(milliseconds: 600),
//         curve: Curves.easeOut,
//         tween: Tween(begin: -200.0, end: 0.0),
//         builder: (context, value, child) {
//           return Positioned(
//             top: MediaQuery.of(context).padding.top + 10 + value,
//             left: 12, right: 12,
//             child: child!,
//           );
//         },
//         child: _buildEliteGlassCard(notification, onTap),
//       ),
//     );
    
//     overlayState.insert(_currentEntry!);
//   }

//   static Widget _buildEliteGlassCard(InAppNotification notification, VoidCallback onTap) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(28),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: Material(
//           color: Colors.transparent,
//           child: GestureDetector(
//             onTap: () {
//               dismiss();
//               onTap();
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.75),
//                 borderRadius: BorderRadius.circular(28),
//                 // border: Border.all(
//                 //   color: _getTypeColor(notification.type).withOpacity(0.4),
//                 //   width: 1.5,
//                 // ),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   // Avatar with Ring
//                   Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: _getTypeColor(notification.type), width: 2),
//                     ),
//                     child: CircleAvatar(
//                       radius: 26,
//                       backgroundColor: Colors.white10,
//                       backgroundImage: (notification.senderImage != null) 
//                           ? NetworkImage(notification.senderImage!) : null,
//                       child: (notification.senderImage == null) 
//                           ? const Icon(Icons.person, color: Colors.white) : null,
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   // Content
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           notification.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w900,
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           notification.body,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.7),
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Close
//                   IconButton(
//                     icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 22),
//                     onPressed: dismiss,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   static Color _getTypeColor(String type) {
//     switch (type) {
//       case 'like': return const Color(0xFFFF4D67);
//       case 'match': return const Color(0xFF4CAF50);
//       case 'message': return const Color(0xFFFFD700);
//       default: return Colors.blueAccent;
//     }
//   }

//   static void dismiss() {
//     if (_currentEntry != null) {
//       _currentEntry!.remove();
//       _currentEntry = null;
//     }
//   }

// }



import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dating/main.dart'; 
import 'package:dating/services/notification/in_app_notification.dart';

class InAppBanner {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;
  
  static void show(InAppNotification notification, VoidCallback onTap) {
    dismiss(); // Clear previous if exists
    
    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;
    
    _currentEntry = OverlayEntry(
      builder: (context) => TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack, // Elastic feel
        tween: Tween(begin: -200.0, end: 0.0),
        builder: (context, value, child) {
          return Positioned(
            top: MediaQuery.of(context).padding.top + 10 + value,
            left: 12, right: 12,
            child: child!,
          );
        },
        child: _buildEliteGlassCard(notification, onTap),
      ),
    );
    
    overlayState.insert(_currentEntry!);

    // Auto-dismiss after 5 seconds
    _dismissTimer = Timer(const Duration(seconds: 5), () {
      dismiss();
    });
  }

  static Widget _buildEliteGlassCard(InAppNotification notification, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              dismiss();
              onTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)
                ],
              ),
              child: Row(
                children: [
                  // Avatar with Ring & Error Handling
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getTypeColor(notification.type), 
                        width: 2
                      ),
                    ),
                    child: ClipOval(
                      child: (notification.senderImage != null && notification.senderImage!.isNotEmpty)
                          ? Image.network(
                              notification.senderImage!,
                              fit: BoxFit.cover,
                              // Handles broken URLs
                              errorBuilder: (context, error, stackTrace) => _buildStaticPlaceholder(),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                              },
                            )
                          : _buildStaticPlaceholder(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close Icon
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 22),
                    onPressed: dismiss,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Static Fallback Image / Icon
  static Widget _buildStaticPlaceholder() {
    return Container(
      color: Colors.white.withOpacity(0.1),
      child: const Icon(
        Icons.person_rounded, 
        color: Colors.white54, 
        size: 30
      ),
    );
    // OR use a local asset:
    // return Image.asset('assets/images/default_user.png', fit: BoxFit.cover);
  }

  static Color _getTypeColor(String type) {
    switch (type) {
      case 'like': return const Color(0xFFFF4D67);
      case 'match': return const Color(0xFF4CAF50);
      case 'message': return const Color(0xFFFFD700);
      default: return Colors.blueAccent;
    }
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    if (_currentEntry != null) {
      _currentEntry!.remove();
      _currentEntry = null;
    }
  }
}




// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:dating/main.dart'; 
// import 'package:dating/services/notification/in_app_notification.dart';

// class InAppBanner {
//   static OverlayEntry? _currentEntry;
//   static Timer? _dismissTimer;
//   static Completer<void>? _animationCompleter;
  
//   static void show(InAppNotification notification, VoidCallback onTap) {
//     dismiss(); // Clear previous if exists
    
//     final overlayState = navigatorKey.currentState?.overlay;
//     if (overlayState == null) {
//       log("⚠️ No overlay state available");
//       return;
//     }
    
//     _animationCompleter = Completer<void>();
    
//     _currentEntry = OverlayEntry(
//       builder: (context) => _NotificationBanner(
//         notification: notification,
//         onTap: () {
//           dismiss();
//           onTap();
//         },
//         onDismiss: dismiss,
//         onAnimationComplete: () => _animationCompleter?.complete(),
//       ),
//     );
    
//     overlayState.insert(_currentEntry!);

//     // Auto-dismiss after 6 seconds
//     _dismissTimer = Timer(const Duration(seconds: 6), () {
//       dismiss();
//     });
//   }

//   static Widget _buildStaticPlaceholder() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         shape: BoxShape.circle,
//       ),
//       child: const Icon(
//         Icons.person_rounded, 
//         color: Colors.white54, 
//         size: 30
//       ),
//     );
//   }

//   static Color _getTypeColor(String type) {
//     switch (type) {
//       case 'like': return const Color(0xFFFF4D67);
//       case 'match': return const Color(0xFF4CAF50);
//       case 'message': return const Color(0xFFFFD700);
//       default: return const Color(0xFF2196F3);
//     }
//   }

//   static Future<void> dismiss() async {
//     _dismissTimer?.cancel();
    
//     if (_currentEntry != null && _currentEntry!.mounted) {
//       // Wait for animation to complete if in progress
//       if (_animationCompleter != null && !_animationCompleter!.isCompleted) {
//         await _animationCompleter!.future;
//       }
      
//       _currentEntry!.remove();
//       _currentEntry = null;
//       _animationCompleter = null;
//     }
//   }
// }

// class _NotificationBanner extends StatefulWidget {
//   final InAppNotification notification;
//   final VoidCallback onTap;
//   final VoidCallback onDismiss;
//   final VoidCallback onAnimationComplete;

//   const _NotificationBanner({
//     required this.notification,
//     required this.onTap,
//     required this.onDismiss,
//     required this.onAnimationComplete,
//   });

//   @override
//   _NotificationBannerState createState() => _NotificationBannerState();
// }

// class _NotificationBannerState extends State<_NotificationBanner> 
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _slideAnimation;
//   late Animation<double> _fadeAnimation;
  
//   @override
//   void initState() {
//     super.initState();
    
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 700),
//       vsync: this,
//     );
    
//     _slideAnimation = Tween<double>(
//       begin: -150.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     ));
    
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
    
//     // Start animation
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _controller.forward().then((_) {
//         widget.onAnimationComplete();
//       });
//     });
//   }
  
//   Future<void> _exitAnimation() async {
//     await _controller.reverse();
//   }
  
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Positioned(
//           top: MediaQuery.of(context).padding.top + 10 + _slideAnimation.value,
//           left: 12, 
//           right: 12,
//           child: Opacity(
//             opacity: _fadeAnimation.value,
//             child: child,
//           ),
//         );
//       },
//       child: GestureDetector(
//         onTap: () async {
//           await _exitAnimation();
//           widget.onTap();
//         },
//         onVerticalDragEnd: (details) {
//           if (details.primaryVelocity! > 100) {
//             // Swipe up to dismiss
//             _exitAnimation().then((_) => widget.onDismiss());
//           }
//         },
//         child: _buildNotificationCard(),
//       ),
//     );
//   }
  
//   Widget _buildNotificationCard() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(28),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.85),
//             borderRadius: BorderRadius.circular(28),
//             border: Border.all(
//               color: InAppBanner._getTypeColor(widget.notification.type).withOpacity(0.3),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.5),
//                 blurRadius: 30,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Avatar with Type Indicator
//               _buildAvatar(),
//               const SizedBox(width: 15),
              
//               // Content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       widget.notification.title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                         fontSize: 15,
//                         letterSpacing: -0.3,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       widget.notification.body,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 12.5,
//                         height: 1.3,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Close Button
//               IconButton(
//                 icon: Icon(
//                   Icons.close_rounded,
//                   color: Colors.white.withOpacity(0.6),
//                   size: 20,
//                 ),
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(
//                   minWidth: 36,
//                   minHeight: 36,
//                 ),
//                 onPressed: () async {
//                   await _exitAnimation();
//                   widget.onDismiss();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget _buildAvatar() {
//     final color = InAppBanner._getTypeColor(widget.notification.type);
    
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           width: 52,
//           height: 52,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: color.withOpacity(0.5), width: 2),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 color.withOpacity(0.3),
//                 color.withOpacity(0.1),
//               ],
//             ),
//           ),
//         ),
        
//         Container(
//           width: 48,
//           height: 48,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: color, width: 1.5),
//           ),
//           child: ClipOval(
//             child: _buildAvatarImage(),
//           ),
//         ),
        
//         // Type indicator icon in bottom right
//         Positioned(
//           right: 0,
//           bottom: 0,
//           child: Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.black, width: 2),
//             ),
//             child: Icon(
//               _getTypeIcon(widget.notification.type),
//               size: 10,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildAvatarImage() {
//     final imageUrl = widget.notification.senderImage;
    
//     if (imageUrl == null || imageUrl.isEmpty) {
//       return InAppBanner._buildStaticPlaceholder();
//     }
    
//     // Fix duplicate URLs
//     String cleanedUrl = imageUrl;
//     final lastHttpIndex = imageUrl.lastIndexOf('http');
//     if (lastHttpIndex > 0) {
//       cleanedUrl = imageUrl.substring(lastHttpIndex);
//     }
    
//     return Image.network(
//       cleanedUrl,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) {
//         return InAppBanner._buildStaticPlaceholder();
//       },
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Center(
//           child: SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               valueColor: AlwaysStoppedAnimation(
//                 InAppBanner._getTypeColor(widget.notification.type),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
  
//   IconData _getTypeIcon(String type) {
//     switch (type) {
//       case 'like': return Icons.favorite;
//       case 'match': return Icons.people;
//       case 'message': return Icons.message;
//       default: return Icons.notifications;
//     }
//   }
// }

// void log(String message) {
//   print('[InAppBanner] $message');
// }