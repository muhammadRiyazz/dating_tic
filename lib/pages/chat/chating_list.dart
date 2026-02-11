// // pages/matches/ChatListPage.dart
// import 'dart:developer';
// import 'dart:ui';
// import 'package:dating/models/profile_model.dart';
// import 'package:dating/pages/maches/widgets/matches_shimmer.dart';
// import 'package:dating/providers/matches_provider.dart';
// import 'package:dating/services/auth_service.dart';
// import 'package:dating/services/chat_service.dart';
// import 'package:dating/pages/chat/chat_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatListPage extends StatefulWidget {
//   const ChatListPage({super.key});

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> with SingleTickerProviderStateMixin {
//   late AnimationController _refreshController;
//   bool _isRefreshing = false;
//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();
  
//   // IMPORTANT: Two different IDs
//   String? _currentUserId; // PHP Database ID (from MySQL)
//   String? _currentUseruID; // Firebase Auth UID
//   // User? _currentFirebaseUser; // Firebase User object
  
//   Map<String, Stream<DocumentSnapshot>> _chatStreams = {};
//   Map<String, int> _unreadCounts = {};

//   @override
//   void initState() {
//     super.initState();
//     _refreshController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _initUser();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
//   }

//   Future<void> _initUser() async {
//     // Get PHP Database ID
//     _currentUserId = await _authService.getUserId();
    
//     // Get Firebase User
//     _currentUseruID = await _authService.getUId();
    
//     log('PHP User ID: $_currentUserId');
//     log('Firebase UID: $_currentUseruID');
//   }

//   Future<void> _loadData() async {
//     if (_isRefreshing) return;
//     _isRefreshing = true;
//     _refreshController.forward();
    
//     final userId = await _authService.getUserId();
//     if (mounted) {
//       await context.read<MatchesProvider>().fetchMatches(userId.toString());
//     }
    
//     if (mounted) {
//       _refreshController.reverse();
//       _isRefreshing = false;
//     }
//   }

//   // IMPORTANT: Get chat stream using FIREBASE UIDs
//   Stream<DocumentSnapshot> _getChatStream(String user1uID, String user2uID) {
//     String chatId = _chatService.generateChatId(user1uID, user2uID);
//     if (!_chatStreams.containsKey(chatId)) {
//       _chatStreams[chatId] = _chatService.getChatInfo(chatId);
//     }
//     return _chatStreams[chatId]!;
//   }

//   // IMPORTANT: Get unread count stream using FIREBASE UIDs
//   Stream<int> _getUnreadCountStream(String user1uID, String user2uID) {
//     String chatId = _chatService.generateChatId(user1uID, user2uID);
//     return _chatService.getMessages(chatId).map((snapshot) {
//       int count = 0;
//       for (var doc in snapshot.docs) {
//         var data = doc.data() as Map<String, dynamic>;
//         if (data['senderId'] != _currentUseruID && 
//             !(data['readBy'] ?? []).contains(_currentUseruID)) {
//           count++;
//         }
//       }
//       return count;
//     });
//   }

//   @override
//   void dispose() {
//     _refreshController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: Stack(
//         children: [
//           _buildTopGradient(),
//           SafeArea(
//             child: Consumer<MatchesProvider>(
//               builder: (context, provider, _) {
//                 return RefreshIndicator(
//                   backgroundColor: const Color(0xFF1A1A1A),
//                   color: const Color(0xFFFFD700),
//                   onRefresh: _loadData,
//                   child: CustomScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     slivers: [
//                       _buildHeader(),
//                       _buildSectionDivider('MESSAGES'),

//                       if (provider.isLoading)
//                         const SliverToBoxAdapter(child: MatchesShimmer())
//                       else if (provider.matches.isEmpty)
//                         SliverFillRemaining(
//                           hasScrollBody: false,
//                           child: _buildEmptyState(),
//                         )
//                       else
//                         SliverPadding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           sliver: SliverList(
//                             delegate: SliverChildBuilderDelegate(
//                               (context, index) {
//                                 final profile = provider.matches[index];
                                
//                                 // IMPORTANT: Check if we have both Firebase UIDs
//                                 if (_currentUseruID == null || profile.uID == null) {
//                                   return SizedBox.shrink();
//                                 }
                                
//                                 return StreamBuilder<DocumentSnapshot>(
//                                   stream: _getChatStream(
//                                     _currentUseruID!,
//                                     profile.uID!,
//                                   ),
//                                   builder: (context, chatSnapshot) {
//                                     return StreamBuilder<int>(
//                                       stream: _getUnreadCountStream(
//                                         _currentUseruID!,
//                                         profile.uID!,
//                                       ),
//                                       builder: (context, unreadSnapshot) {
//                                         int unreadCount = unreadSnapshot.data ?? 0;
//                                         return _buildChatTile(
//                                           profile, 
//                                           index, 
//                                           chatSnapshot.data,
//                                           unreadCount
//                                         ).animate()
//                                           .fadeIn(delay: (index * 100).ms)
//                                           .slideX(begin: 0.1, end: 0);
//                                       },
//                                     );
//                                   },
//                                 );
//                               },
//                               childCount: provider.matches.length,
//                             ),
//                           ),
//                         ),
//                       const SliverToBoxAdapter(child: SizedBox(height: 100)),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChatTile(Profile profile, int index, DocumentSnapshot? chatData, int unreadCount) {
//     String lastMessage = '';
//     String lastMessageTime = '';
//     bool isTyping = false;
//     bool isMessageRead = false;
    
//     if (chatData != null && chatData.exists) {
//       final data = chatData.data() as Map<String, dynamic>;
//       lastMessage = data['lastMessage'] ?? '';
      
//       // Format last message time
//       if (data['lastMessageTime'] != null) {
//         final timestamp = data['lastMessageTime'] as Timestamp;
//         lastMessageTime = _formatTime(timestamp.toDate());
//       }
      
//       // Check if other user is typing
//       final typingUsers = List<String>.from(data['typingUsers'] ?? []);
//       isTyping = typingUsers.contains(profile.uID);
      
//       // Check if last message was read
//       final lastMessageSender = data['lastMessageSender'];
//       if (lastMessageSender == _currentUseruID) {
//         // Message sent by me, check if other user read it
//         final lastSeen = data['lastSeen']?[profile.uID];
//         final lastMessageTimestamp = data['lastMessageTime'] as Timestamp?;
        
//         if (lastSeen != null && lastMessageTimestamp != null) {
//           final lastSeenDate = (lastSeen as Timestamp).toDate();
//           final lastMessageDate = lastMessageTimestamp.toDate();
//           isMessageRead = lastSeenDate.isAfter(lastMessageDate);
//         }
//       }
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.03),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: unreadCount > 0 
//             ? const Color(0xFFFFD700).withOpacity(0.3)
//             : Colors.white.withOpacity(0.05)
//         ),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         onTap: () async {
//           HapticFeedback.lightImpact();
          
//           // IMPORTANT: Get fresh Firebase user data

//       final uid=    await _authService.getUId();
//           // final currentFirebaseUser = await _authService.getCurrentUser();
//           // final currentPHPUserId = await _authService.getUserId();
          
//           // if (currentFirebaseUser == null || profile.uID == null) {
//           //   log('Error: Missing Firebase UID');
//           //   return;
//           // }
          
//           // Create/get chat room using FIREBASE UIDs
//           String chatId = await _chatService.getOrCreateChatRoom(
//             uid??'',           // Current user's Firebase UID
//             profile.uID!,              // Other user's Firebase UID
//            ' My name You',  // Current user's name
//             profile.userName,                  // Other user's name
//             profile.photo ,        // Current user's photo
//             profile.photo,                    // Other user's photo
//           );
          
//           // Navigate to chat screen
//           // if (mounted) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatScreen(
//                   chatId: chatId,
//                   otherUserId: profile.uID!, // Pass Firebase UID
//                   // otherPHPUserId: profile.id,        // Pass PHP ID for profile fetch
//                   otherUserName: profile.userName,
//                   otherUserImage: profile.photo,
//                 ),
//               ),
//             );
//           },
//         // },
//         leading: Stack(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundImage: CachedNetworkImageProvider(profile.photo),
//             ),
//             // Positioned(
//             //   bottom: 2,
//             //   right: 2,
//             //   child: Container(
//             //     width: 14,
//             //     height: 14,
//             //     decoration: BoxDecoration(
//             //       color: _isOnline(profile) ? const Color(0xFF00FF00) : Colors.grey,
//             //       shape: BoxShape.circle,
//             //       border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//         title: Row(
//           children: [
//             Text(
//               profile.userName,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: unreadCount > 0 ? FontWeight.w800 : FontWeight.w700,
//               ),
//             ),
//             // if (profile.isVerified) ...[
//             //   const SizedBox(width: 6),
//             //   Icon(Iconsax.verify5, size: 16, color: const Color(0xFFFFD700)),
//             // ],
//           ],
//         ),
//         subtitle: Row(
//           children: [
//             if (isTyping)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFD700).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   "Typing...",
//                   style: TextStyle(
//                     color: Color(0xFFFFD700),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               )
//             else if (lastMessage.isNotEmpty)
//               Expanded(
//                 child: Row(
//                   children: [
//                     if (chatData != null) 
//                       Icon(
//                         isMessageRead ? Iconsax.tick_circle : Iconsax.tick_circle,
//                         size: 14,
//                         color: isMessageRead 
//                           ? const Color(0xFF4CAF50)
//                           : Colors.white.withOpacity(0.4),
//                       ),
//                     const SizedBox(width: 5),
//                     Expanded(
//                       child: Text(
//                         lastMessage,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: unreadCount > 0 
//                             ? Colors.white
//                             : Colors.white.withOpacity(0.4),
//                           fontSize: 13,
//                           fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Expanded(
//                 child: Text(
//                   "Matched with ${profile.userName}! Say hi 👋",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.4),
//                     fontSize: 13,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               lastMessageTime,
//               style: TextStyle(
//                 color: unreadCount > 0 
//                   ? const Color(0xFFFFD700)
//                   : Colors.white.withOpacity(0.3),
//                 fontSize: 10,
//                 fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//             const SizedBox(height: 5),
//             if (unreadCount > 0)
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFD700),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFFFFD700).withOpacity(0.3),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   unreadCount > 9 ? '9+' : unreadCount.toString(),
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // bool _isOnline(Profile profile) {
//   //   // You can implement online status checking here
//   //   // For now, random
//   //   // return Random().nextBool();
//   // }

//   String _formatTime(DateTime time) {
//     final now = DateTime.now();
//     final difference = now.difference(time);
    
//     if (difference.inMinutes < 1) {
//       return 'Now';
//     } else if (difference.inHours < 1) {
//       return '${difference.inMinutes}m';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h';
//     } else if (difference.inDays == 1) {
//       return 'Yesterday';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays}d';
//     } else {
//       return '${time.day}/${time.month}';
//     }
//   }

//   Widget _buildTopGradient() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       height: MediaQuery.of(context).size.height * 0.45,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [const Color(0xFFFF4D67).withOpacity(0.15), Colors.transparent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Messages",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.w900,
//                     letterSpacing: -1,
//                   ),
//                 ),
//                 Text(
//                   "Your conversations and matches",
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.4),
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//             _glassButton(Iconsax.setting_4),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionDivider(String label) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: Row(
//           children: [
//             const SizedBox(width: 24),
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.2),
//                 fontSize: 11,
//                 letterSpacing: 2,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(child: Divider(color: Colors.white.withOpacity(0.05))),
//             const SizedBox(width: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.03),
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white.withOpacity(0.05)),
//             ),
//             child: const Icon(
//               Iconsax.message_favorite,
//               size: 50,
//               color: Colors.white24,
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             "No Conversations Yet",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "Matches will appear here once you both swipe right. Go find your spark!",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.4),
//               fontSize: 14,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 30),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   const Color(0xFFFF4D67),
//                   const Color(0xFFFFD700).withOpacity(0.8),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFFFF4D67).withOpacity(0.3),
//                   blurRadius: 12,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: const Text(
//               "Find Matches",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _glassButton(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Icon(icon, color: Colors.white, size: 22),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/chat_service.dart';
import 'package:dating/pages/chat/chat_screen.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  String? _currentUseruID;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    _currentUseruID = await _authService.getUId();
    if (mounted) setState(() {});
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = await _authService.getUserId();
    if (mounted) {
      await context.read<MatchesProvider>().fetchMatches(userId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          _buildTopGradient(),
          SafeArea(
            child: Consumer<MatchesProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)));
                
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildHeader(),
                    _buildSectionDivider('MESSAGES'),
                    provider.matches.isEmpty 
                      ? SliverFillRemaining(child: _buildEmptyState())
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildMatchItem(provider.matches[index], index),
                              childCount: provider.matches.length,
                            ),
                          ),
                        ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchItem(Profile profile, int index) {
    if (_currentUseruID == null || profile.uID == null) return const SizedBox();
    final chatId = _chatService.generateChatId(_currentUseruID!, profile.uID!);

    return StreamBuilder<DocumentSnapshot>(
      stream: _chatService.getChatInfo(chatId),
      builder: (context, chatSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: _chatService.getMessages(chatId),
          builder: (context, msgSnap) {
            int unreadCount = 0;
            if (msgSnap.hasData) {
              unreadCount = msgSnap.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['senderId'] != _currentUseruID && 
                       !(data['readBy'] ?? []).contains(_currentUseruID);
              }).length;
            }

            return _buildChatTile(profile, chatSnap.data, unreadCount)
                .animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
          },
        );
      },
    );
  }

  Widget _buildChatTile(Profile profile, DocumentSnapshot? chatData, int unread) {
    String lastMsg = "No messages yet";
    String time = "";
    bool isTyping = false;

    if (chatData != null && chatData.exists) {
      final data = chatData.data() as Map<String, dynamic>;
      lastMsg = data['lastMessage'] ?? "";
      if (data['lastMessageTime'] != null) {
        time = _formatTime((data['lastMessageTime'] as Timestamp).toDate());
      }
      isTyping = (data['typingUsers'] ?? []).contains(profile.uID);
    }

    return GestureDetector(
      onTap: () async {
        HapticFeedback.mediumImpact();
        String chatId = await _chatService.getOrCreateChatRoom(
          _currentUseruID!, profile.uID!, "Me", profile.userName, "photo", profile.photo
        );
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (c) => ChatScreen(
          chatId: chatId, otherUserId: profile.uID!, otherUserName: profile.userName, otherUserImage: profile.photo,
        )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(unread > 0 ? 0.08 : 0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: unread > 0 ? const Color(0xFFFFD700).withOpacity(0.3) : Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: CachedNetworkImageProvider(profile.photo)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    isTyping ? "typing..." : lastMsg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: isTyping ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.5), fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10)),
                const SizedBox(height: 5),
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
                    child: Text('$unread', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return "${diff.inDays}d";
    if (diff.inHours > 0) return "${diff.inHours}h";
    return "${diff.inMinutes}m";
  }

  Widget _buildTopGradient() => Positioned(top: 0, left: 0, right: 0, height: 300, child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFFFF4D67).withOpacity(0.15), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter))));
  Widget _buildHeader() => SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(24), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Messages", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)), Text("Your conversations", style: TextStyle(color: Colors.white24, fontSize: 13))]), Icon(Iconsax.setting_4, color: Colors.white.withOpacity(0.5))])));
  Widget _buildSectionDivider(String label) => SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Row(children: [const SizedBox(width: 24), Text(label, style: const TextStyle(color: Colors.white24, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)), const SizedBox(width: 10), Expanded(child: Divider(color: Colors.white.withOpacity(0.05))), const SizedBox(width: 24)])));
  Widget _buildEmptyState() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Iconsax.message_favorite, size: 50, color: Colors.white.withOpacity(0.1)), const SizedBox(height: 20), const Text("No matches yet", style: TextStyle(color: Colors.white24))]));
}