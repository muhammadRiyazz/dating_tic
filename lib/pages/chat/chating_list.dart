// // pages/chat/chat_list_page.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:dating/models/profile_model.dart';
// import 'package:dating/providers/matches_provider.dart';
// import 'package:dating/services/auth_service.dart';
// import 'package:dating/services/chat_service.dart';
// import 'package:dating/pages/chat/chat_screen.dart';
// import 'package:dating/pages/user_profile_page.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class ChatListPage extends StatefulWidget {
//   const ChatListPage({super.key});

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> with SingleTickerProviderStateMixin {
//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();
//   String? _currentUserUid;
//   String? _currentUserId;
//   late AnimationController _animationController;
//   final ScrollController _scrollController = ScrollController();
//   bool _isRefreshing = false;
//   Map<String, bool> _pinnedChats = {};
//   Timer? _onlineStatusTimer;
//   bool _isMounted = false;

//   @override
//   void initState() {
//     super.initState();
//     _isMounted = true;
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _initUser();
//     _updateOnlineStatus();
//   }

//   Future<void> _initUser() async {
//     if (!_isMounted) return;
//     _currentUserUid = await _authService.getUId();
//     _currentUserId = await _authService.getUserId();
//     if (_isMounted) setState(() {});
//     _loadData();
//   }

//   Future<void> _updateOnlineStatus() async {
//     if (!_isMounted) return;
//     await _chatService.updateOnlineStatus(true);
    
//     _onlineStatusTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
//       if (_isMounted) {
//         await _chatService.updateOnlineStatus(true);
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   Future<void> _loadData() async {
//     if (!_isMounted) return;
//     if (_currentUserId == null) return;
//     await context.read<MatchesProvider>().fetchMatches(_currentUserId!);
//   }

//   Future<void> _refreshData() async {
//     if (!_isMounted) return;
//     setState(() => _isRefreshing = true);
//     await _loadData();
//     if (_isMounted) setState(() => _isRefreshing = false);
//   }

//   @override
//   void dispose() {
//     _isMounted = false;
//     _onlineStatusTimer?.cancel();
//     _chatService.updateOnlineStatus(false);
//     _animationController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: Stack(
//         children: [
//           // Animated background gradient
//           _buildAnimatedBackground(),
          
//           SafeArea(
//             child: Consumer<MatchesProvider>(
//               builder: (context, provider, _) {
//                 if (provider.isLoading && provider.matches.isEmpty) {
//                   return _buildShimmerLoading();
//                 }

//                 return RefreshIndicator(
//                   onRefresh: _refreshData,
//                   backgroundColor: const Color(0xFF1A1A1A),
//                   color: const Color(0xFFFFD700),
//                   child: CustomScrollView(
//                     controller: _scrollController,
//                     physics: const BouncingScrollPhysics(),
//                     slivers: [
//                       _buildHeader(),
//                       _buildSearchBar(),
//                       _buildActiveNowSection(provider.matches),
//                       _buildSectionDivider('CHATS'),
                      
//                       if (provider.matches.isEmpty)
//                         _buildEmptyState()
//                       else
//                         SliverPadding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           sliver: SliverList(
//                             delegate: SliverChildBuilderDelegate(
//                               (context, index) {
//                                 final match = provider.matches[index];
//                                 if (_currentUserUid == null || match.uID == null) {
//                                   return const SizedBox.shrink();
//                                 }
//                                 return _buildChatTile(match, index);
//                               },
//                               childCount: provider.matches.length,
//                             ),
//                           ),
//                         ),
//                       const SliverToBoxAdapter(child: SizedBox(height: 20)),
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

//   Widget _buildAnimatedBackground() {
//     return
//     //  Positioned(
//     //   top: 0,
//     //   left: 0,
//     //   right: 0,
//     //   height: MediaQuery.of(context).size.height * 0.45,
//     //   child: Container(
//     //     decoration: BoxDecoration(
//     //       gradient: LinearGradient(
//     //         colors: [
              
//     //           const Color(0xFFFF4D67).withOpacity(0.2), 
//     //             const Color(0xFFFF4D67).withOpacity(0.05),
//     //           Colors.transparent],
//     //         begin: Alignment.topCenter,
//     //         end: Alignment.bottomCenter,
//     //       ),
//     //     ),
//     //   ),
//     // );
  

//      Positioned(
//               top: 0, left: 0, right: 0,
//               height: MediaQuery.of(context).size.height * 1,
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color(0xFFFF4D67).withOpacity(0.18),
//                       const Color(0xFFFF4D67).withOpacity(0.04),
//                       Colors.transparent,
//                       // const Color(0xFFFF4D67).withOpacity(0.08),
//                     ],
//                     begin: Alignment.topCenter, end: Alignment.bottomCenter,
//                   ),
//                 ),
//               ),
//             );
    
//     // Positioned(
//     //   top: 0,
//     //   left: 0,
//     //   right: 0,
//     //   height: MediaQuery.of(context).size.height * 0.9,
//     //   child: Container(
//     //     decoration: BoxDecoration(
//     //       gradient: LinearGradient(
//     //         colors: [
//     //           const Color(0xFFFF4D67).withOpacity(0.2),
//     //           const Color(0xFFFFD700).withOpacity(0.1),
//     //           Colors.transparent,
//     //         ],
//     //         begin: Alignment.topLeft,
//     //         end: Alignment.bottomRight,
//     //       ),
//     //     ),
//     //   ).animate(
//     //     onPlay: (controller) {
//     //       if (_isMounted) controller.repeat(reverse: true);
//     //     },
//     //   ).moveY(
//     //     begin: -20, 
//     //     end: 0, 
//     //     duration: 3000.ms, 
//     //     curve: Curves.easeInOut,
//     //   ),
//     // );
//   }

//   Widget _buildHeader() {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
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
//                 const SizedBox(height: 4),
//                 Text(
//                   "Your conversations",
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.5),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 _buildHeaderIcon(Iconsax.camera, onTap: () {
//                   // TODO: Open camera/status
//                 }),
//                 const SizedBox(width: 12),
//                 _buildHeaderIcon(Iconsax.edit, onTap: () {
//                   // TODO: New message/compose
//                 }),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderIcon(IconData icon, {required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.05),
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.white.withOpacity(0.1)),
//         ),
//         child: Icon(icon, color: Colors.white, size: 20),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
//         child: Container(
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: TextField(
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: "Search messages...",
//               hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 15),
//               prefixIcon: Icon(Iconsax.search_normal, color: Colors.white.withOpacity(0.5), size: 20),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActiveNowSection(List<Profile> matches) {
//     // TODO: Implement online status in Profile model
//     return const SliverToBoxAdapter(child: SizedBox.shrink());
//   }

//   Widget _buildChatTile(Profile profile, int index) {
//     if (_currentUserUid == null || profile.uID == null) {
//       return const SizedBox.shrink();
//     }
    
//     final chatId = _chatService.generateChatId(_currentUserUid!, profile.uID!);

//     return StreamBuilder<DocumentSnapshot>(
//       stream: _chatService.getChatInfo(chatId),
//       builder: (context, chatSnapshot) {
//         // Handle loading state
//         if (chatSnapshot.connectionState == ConnectionState.waiting) {
//           return _buildShimmerTile();
//         }

//         // Handle error state
//         if (chatSnapshot.hasError) {
//           return _buildErrorTile(profile);
//         }

//         final chatData = chatSnapshot.data?.data() as Map<String, dynamic>?;
//         final isMuted = (chatData?['mutedBy'] ?? []).contains(_currentUserUid);
//         final isPinned = (chatData?['pinnedBy'] ?? []).contains(_currentUserUid);
//         final unreadCount = chatData?['unreadCount']?[_currentUserUid] ?? 0;
        
//         String lastMessage = chatData?['lastMessage'] ?? "No messages yet";
//         String lastMessageType = chatData?['lastMessageType'] ?? 'text';
//         bool isTyping = (chatData?['typingUsers'] ?? []).contains(profile.uID);
//         Timestamp? lastMessageTime = chatData?['lastMessageTime'];

//         return _buildAnimatedChatTile(
//           profile: profile,
//           chatId: chatId,
//           lastMessage: isTyping ? 'typing...' : _getMessagePreview(lastMessage, lastMessageType),
//           lastMessageTime: lastMessageTime,
//           unreadCount: unreadCount,
//           isTyping: isTyping,
//           isMuted: isMuted,
//           isPinned: isPinned,
//           index: index,
//         );
//       },
//     );
//   }

//   Widget _buildShimmerTile() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.03),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 120,
//                   height: 16,
//                   color: Colors.white.withOpacity(0.05),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   width: 180,
//                   height: 12,
//                   color: Colors.white.withOpacity(0.03),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorTile(Profile profile) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.red.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.red.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 32,
//             backgroundColor: Colors.white.withOpacity(0.1),
//             backgroundImage: CachedNetworkImageProvider(profile.photo),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   profile.userName,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Tap to retry",
//                   style: TextStyle(
//                     color: Colors.red.withOpacity(0.7),
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnimatedChatTile({
//     required Profile profile,
//     required String chatId,
//     required String lastMessage,
//     required Timestamp? lastMessageTime,
//     required int unreadCount,
//     required bool isTyping,
//     required bool isMuted,
//     required bool isPinned,
//     required int index,
//   }) {
//     return GestureDetector(
//    onTap: () async {
//   if (!_isMounted) return;
//   HapticFeedback.mediumImpact();
  
//   try {
//     // 1. Get or Create the Chat Room ID
//     final chatId = await _chatService.getOrCreateChatRoom(
//       user1Id: _currentUserUid!,
//       user2Id: profile.uID!,
//       user1Name: 'You', // Ideally fetch your own name from a provider
//       user2Name: profile.userName,
//       user1Photo: '',   // Ideally fetch your own photo
//       user2Photo: profile.photo,
//     );

//     // 2. Navigate to ChatScreen
//     if (_isMounted && context.mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatScreen(
//             chatId: chatId,
//             receiverProfile: profile,
//             currentUserId: _currentUserUid!,
//           ),
//         ),
//       ).then((_) {
//         // 3. Mark as read when coming back from the chat
//         _chatService.markAsRead(chatId, _currentUserUid!);
//       });
//     }
//   } catch (e) {
//     if (_isMounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to open chat: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: unreadCount > 0 
//               ? const Color(0xFFFFD700).withOpacity(0.05)
//               : Colors.white.withOpacity(0.02),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color:  Colors.white.withOpacity(0.02),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Profile picture with online status
//             _buildProfilePicture(profile),
            
//             const SizedBox(width: 16),
            
//             // Chat details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           profile.userName,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: unreadCount > 0 ? FontWeight.w800 : FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       if (isPinned)
//                         Container(
//                           margin: const EdgeInsets.only(right: 8),
//                           child: Icon(
//                             Iconsax.arrow_up_3,
//                             size: 14,
//                             color: const Color(0xFFFFD700),
//                           ),
//                         ),
//                       if (isMuted)
//                         Container(
//                           margin: const EdgeInsets.only(right: 8),
//                           child: Icon(
//                             Iconsax.volume_slash,
//                             size: 14,
//                             color: Colors.white.withOpacity(0.3),
//                           ),
//                         ),
//                       Text(
//                         lastMessageTime != null
//                             ? _formatTime(lastMessageTime.toDate())
//                             : '',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.3),
//                           fontSize: 11,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       if (isTyping)
//                         _buildTypingIndicator()
//                       else
//                         Expanded(
//                           child: Text(
//                             lastMessage,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: isTyping
//                                   ? const Color(0xFFFFD700)
//                                   : unreadCount > 0
//                                       ? Colors.white
//                                       : Colors.white.withOpacity(0.5),
//                               fontSize: 13,
//                               fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
//                             ),
//                           ),
//                         ),
//                       if (unreadCount > 0)
//                         Container(
//                           margin: const EdgeInsets.only(left: 8),
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFFD700),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0xFFFFD700).withOpacity(0.3),
//                                 blurRadius: 8,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                           child: Text(
//                             unreadCount > 99 ? '99+' : unreadCount.toString(),
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ).animate(
//         onPlay: (controller) {
//           if (_isMounted) controller.forward();
//         },
//       ).fadeIn(
//         duration: 400.ms, 
//         delay: (index * 50).ms,
//       ).slideX(
//         begin: 0.1, 
//         end: 0, 
//         curve: Curves.easeOutQuad,
//       ),
//     );
//   }

//   Widget _buildProfilePicture(Profile profile) {
//     return GestureDetector(
//       onTap: () {
//         if (!_isMounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProfileDetailsPage(
//               profiledata: profile,
//               goalName: profile.relationshipGoal?.name ?? "",
//               match: true,
//             ),
//           ),
//         );
//       },
//       child: Stack(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(2),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//             ),
//             child: CircleAvatar(
//               radius: 32,
//               backgroundColor: Colors.white.withOpacity(0.1),
//               backgroundImage: CachedNetworkImageProvider(
//                 profile.photo,
//                 // errorListener: () {
//                 //   // Handle image error silently
//                 // },
//               ),
//               onBackgroundImageError: (exception, stackTrace) {
//                 // Handle image error silently
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypingIndicator() {
//     return Row(
//       children: [
//         Text(
//           "typing",
//           style: TextStyle(
//             color: const Color(0xFFFFD700),
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(width: 4),
//         ...List.generate(3, (i) => Container(
//           margin: const EdgeInsets.symmetric(horizontal: 1),
//           width: 4,
//           height: 4,
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFD700),
//             shape: BoxShape.circle,
//           ),
//         ).animate(
//           onPlay: (controller) {
//             if (_isMounted) controller.repeat();
//           },
//         ).shake(
//           delay: (i * 200).ms,
//           duration: 800.ms,
//           curve: Curves.easeInOut,
//         )),
//       ],
//     );
//   }

//   String _getMessagePreview(String message, String type) {
//     switch (type) {
//       case 'image':
//         return '📷 Photo';
//       case 'voice':
//         return '🎤 Voice message';
//       case 'video':
//         return '🎥 Video';
//       case 'gif':
//         return '🎯 GIF';
//       case 'location':
//         return '📍 Location';
//       default:
//         return message;
//     }
//   }

//   String _formatTime(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
    
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
//       return '${date.day}/${date.month}';
//     }
//   }

//   Widget _buildShimmerLoading() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: 8,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.03),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 64,
//                 height: 64,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.05),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 120,
//                       height: 16,
//                       color: Colors.white.withOpacity(0.05),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       width: 180,
//                       height: 12,
//                       color: Colors.white.withOpacity(0.03),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSectionDivider(String label) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
//         child: Row(
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.3),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.5,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Divider(
//                 color: Colors.white.withOpacity(0.1),
//                 thickness: 0.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return SliverFillRemaining(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.03),
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: Icon(
//               Iconsax.message_favorite,
//               size: 60,
//               color: Colors.white.withOpacity(0.1),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             "👋 Matched! Say hi",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               "When you match with someone, your conversations will appear here",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.4),
//                 fontSize: 14,
//                 height: 1.5,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFFF4D67), Color(0xFFFFD700)],
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
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/chat%20providers/chat_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/chat_service.dart';
import 'package:dating/pages/chat/chat_screen.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with SingleTickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  String? _currentUserUid;
  String? _currentUserId;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isRefreshing = false;
  Map<String, bool> _pinnedChats = {};
  Timer? _onlineStatusTimer;
  bool _isMounted = false;
  String _searchQuery = '';
  List<Profile> _filteredMatches = [];
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _initUser();
    _updateOnlineStatus();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initUser() async {
    if (!_isMounted) return;
    _currentUserUid = await _authService.getUId();
    _currentUserId = await _authService.getUserId();
    if (_isMounted) setState(() {});
    _loadData();
  }

  Future<void> _updateOnlineStatus() async {
    if (!_isMounted) return;
    await _chatService.updateOnlineStatus(true);
    
    _onlineStatusTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (_isMounted) {
        await _chatService.updateOnlineStatus(true);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _loadData() async {
    if (!_isMounted) return;
    if (_currentUserId == null) return;
    await context.read<MatchesProvider>().fetchMatches(_currentUserId!);
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (_isMounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase();
        });
      }
    });
  }

  Future<void> _refreshData() async {
    if (!_isMounted) return;
    setState(() => _isRefreshing = true);
    HapticFeedback.mediumImpact();
    await _loadData();
    if (_isMounted) setState(() => _isRefreshing = false);
  }

  void _filterMatches(List<Profile> matches) {
    if (_searchQuery.isEmpty) {
      _filteredMatches = matches;
    } else {
      _filteredMatches = matches.where((match) {
        return match.userName.toLowerCase().contains(_searchQuery) ||
            (match.bio?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _onlineStatusTimer?.cancel();
    _chatService.updateOnlineStatus(false);
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          
          SafeArea(
            child: Consumer<MatchesProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.matches.isEmpty) {
                  return _buildShimmerLoading();
                }

                _filterMatches(provider.matches);

                return RefreshIndicator(
                  onRefresh: _refreshData,
                  backgroundColor: const Color(0xFF1A1A1A),
                  color: const Color(0xFFFFD700),
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildHeader(),
                      _buildSearchBar(),
                      _buildActiveNowSection(provider.matches),
                      _buildPinnedChatsSection(provider.matches),
                      _buildSectionDivider('RECENT CHATS'),
                      
                      if (provider.matches.isEmpty)
                        _buildEmptyState()
                      else if (_filteredMatches.isEmpty && _searchQuery.isNotEmpty)
                        _buildNoSearchResults()
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final match = _filteredMatches[index];
                                if (_currentUserUid == null || match.uID == null) {
                                  return const SizedBox.shrink();
                                }
                                return _buildChatTile(match, index);
                              },
                              childCount: _filteredMatches.length,
                            ),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Top gradient
        Positioned(
          top: 0, left: 0, right: 0,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF4D67).withOpacity(0.18),
                  const Color(0xFFFF4D67).withOpacity(0.04),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        
        // Animated floating particles
        ...List.generate(5, (index) {
          return Positioned(
            top: (index * 100.0) % 300,
            left: (index * 80.0) % MediaQuery.of(context).size.width,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).moveY(
              begin: -10,
              end: 10,
              duration: (2000 + index * 500).ms,
              curve: Curves.easeInOut,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Messages",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_filteredMatches.length} conversations",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _buildHeaderIcon(Iconsax.camera, onTap: () {
                  _showCameraOptions();
                }),
                const SizedBox(width: 12),
                _buildHeaderIcon(Iconsax.edit, onTap: () {
                  _showNewChatOptions();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search messages...",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 15),
              prefixIcon: Icon(Iconsax.search_normal, color: Colors.white.withOpacity(0.5), size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Iconsax.close_circle, color: Colors.white.withOpacity(0.5), size: 18),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveNowSection(List<Profile> matches) {
    final activeNow = matches.where((m) => m.isLive ).take(5).toList();
    
    if (activeNow.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ACTIVE NOW',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: activeNow.length,
                itemBuilder: (context, index) {
                  final profile = activeNow[index];
                  return _buildActiveNowItem(profile, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveNowItem(Profile profile, int index) {
    return GestureDetector(
      onTap: () => _openChat(profile),
      child: Container(
        width: 70,
        // margin: EdgeInsets.only(right: index == activeNow.length - 1 ? 0 : 12),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  backgroundImage: CachedNetworkImageProvider(profile.photo),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              profile.userName.split(' ').first,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms),
    );
  }

  Widget _buildPinnedChatsSection(List<Profile> matches) {
    if (_pinnedChats.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Iconsax.arrow_up_3, size: 12, color: Color(0xFFFFD700)),
                const SizedBox(width: 8),
                Text(
                  'PINNED',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  if (!_pinnedChats.containsKey(match.uID)) return const SizedBox.shrink();
                  return _buildPinnedItem(match);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedItem(Profile profile) {
    return GestureDetector(
      onTap: () => _openChat(profile),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withOpacity(0.1),
              backgroundImage: CachedNetworkImageProvider(profile.photo),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                const Icon(Iconsax.arrow_up_3, size: 10, color: Color(0xFFFFD700)),
              ],
            ),
          ],
        ).animate().scale(duration: 200.ms),
      ),
    );
  }

  Widget _buildChatTile(Profile profile, int index) {
    if (_currentUserUid == null || profile.uID == null) {
      return const SizedBox.shrink();
    }
    
    final chatId = _chatService.generateChatId(_currentUserUid!, profile.uID!);

    return StreamBuilder<DocumentSnapshot>(
      stream: _chatService.getChatInfo(chatId),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerTile();
        }

        if (chatSnapshot.hasError) {
          return _buildErrorTile(profile);
        }

        final chatData = chatSnapshot.data?.data() as Map<String, dynamic>?;
        final isMuted = (chatData?['mutedBy'] ?? []).contains(_currentUserUid);
        final isPinned = (chatData?['pinnedBy'] ?? []).contains(_currentUserUid);
        final unreadCount = chatData?['unreadCount']?[_currentUserUid] ?? 0;
        
        String lastMessage = chatData?['lastMessage'] ?? "No messages yet";
        String lastMessageType = chatData?['lastMessageType'] ?? 'text';
        bool isTyping = (chatData?['typingUsers'] ?? []).contains(profile.uID);
        Timestamp? lastMessageTime = chatData?['lastMessageTime'];

        // Update pinned state
        if (isPinned && !_pinnedChats.containsKey(profile.uID)) {
          _pinnedChats[profile.uID!] = true;
        } else if (!isPinned && _pinnedChats.containsKey(profile.uID)) {
          _pinnedChats.remove(profile.uID);
        }

        return _buildAnimatedChatTile(
          profile: profile,
          chatId: chatId,
          lastMessage: isTyping ? 'typing...' : _getMessagePreview(lastMessage, lastMessageType),
          lastMessageTime: lastMessageTime,
          unreadCount: unreadCount,
          isTyping: isTyping,
          isMuted: isMuted,
          isPinned: isPinned,
          index: index,
        );
      },
    );
  }

  Widget _buildShimmerTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 16,
                  color: Colors.white.withOpacity(0.05),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 12,
                  color: Colors.white.withOpacity(0.03),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorTile(Profile profile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.1),
            backgroundImage: CachedNetworkImageProvider(profile.photo),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tap to retry",
                  style: TextStyle(
                    color: Colors.red.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedChatTile({
    required Profile profile,
    required String chatId,
    required String lastMessage,
    required Timestamp? lastMessageTime,
    required int unreadCount,
    required bool isTyping,
    required bool isMuted,
    required bool isPinned,
    required int index,
  }) {
    return Dismissible(
      key: Key(profile.uID!),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Iconsax.trash, color: Colors.red),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFD700).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Iconsax.archive, color: Color(0xFFFFD700)),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showArchiveConfirmation(profile);
        } else {
          return await _showDeleteConfirmation(profile);
        }
      },
      child: GestureDetector(
        onTap: () => _openChat(profile),
        onLongPress: () => _showChatOptions(profile, chatId, isMuted, isPinned),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: unreadCount > 0
                ? LinearGradient(
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.05),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: unreadCount > 0
                  ? const Color(0xFFFFD700).withOpacity(0.2)
                  : Colors.white.withOpacity(0.02),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile picture with online status
              _buildProfilePicture(profile),
              
              const SizedBox(width: 16),
              
              // Chat details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: unreadCount > 0 ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isPinned)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Iconsax.arrow_up_3,
                              size: 14,
                              color: const Color(0xFFFFD700),
                            ),
                          ),
                        if (isMuted)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Iconsax.volume_slash,
                              size: 14,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        Text(
                          lastMessageTime != null
                              ? _formatTime(lastMessageTime.toDate())
                              : '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (isTyping)
                          _buildTypingIndicator()
                        else
                          Expanded(
                            child: Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isTyping
                                    ? const Color(0xFFFFD700)
                                    : unreadCount > 0
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                fontSize: 13,
                                fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        if (unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFF4D67)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate(
          onPlay: (controller) {
            if (_isMounted) controller.forward();
          },
        ).fadeIn(
          duration: 400.ms, 
          delay: (index * 50).ms,
        ).slideX(
          begin: 0.1, 
          end: 0, 
          curve: Curves.easeOutQuad,
        ),
      ),
    );
  }

  Widget _buildProfilePicture(Profile profile) {
    return GestureDetector(
      onTap: () {
        _showProfilePreview(profile);
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: profile.isLive 
                  ? const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF4D67)],
                    )
                  : null,
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white.withOpacity(0.1),
              backgroundImage: CachedNetworkImageProvider(
                profile.photo,
              ),
              onBackgroundImageError: (exception, stackTrace) {},
            ),
          ),
          if (profile.isLive )
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        Text(
          "typing",
          style: TextStyle(
            color: const Color(0xFFFFD700),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        ...List.generate(3, (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700),
            shape: BoxShape.circle,
          ),
        ).animate(
          onPlay: (controller) {
            if (_isMounted) controller.repeat();
          },
        ).moveY(
          begin: 0,
          end: -3,
          duration: 400.ms,
          delay: (i * 100).ms,
          curve: Curves.easeInOut,
        ).then().moveY(
          begin: -3,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeInOut,
        )),
      ],
    );
  }

  String _getMessagePreview(String message, String type) {
    switch (type) {
      case 'image':
        return '📷 Photo';
      case 'video':
        return '🎥 Video';
      case 'audio':
        return '🎤 Voice message';
      case 'location':
        return '📍 Location';
      case 'document':
        return '📄 Document';
      case 'viewOnce':
        return '👁️ View once media';
      default:
        return message;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  Future<void> _openChat(Profile profile) async {
    if (!_isMounted || _currentUserUid == null) return;
    
    HapticFeedback.mediumImpact();
    
    try {
      final chatId = await _chatService.getOrCreateChatRoom(
        user1Id: _currentUserUid!,
        user2Id: profile.uID!,
        user1Name: 'You',
        user2Name: profile.userName,
        user1Photo: '',
        user2Photo: profile.photo,
      );

      if (_isMounted && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chatId,
              receiverProfile: profile,
              currentUserId: _currentUserUid!,
            ),
          ),
        ).then((_) {
          _chatService.markMessagesAsRead(chatId, _currentUserUid!);
        });
      }
    } catch (e) {
      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open chat: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showProfilePreview(Profile profile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: CachedNetworkImageProvider(profile.photo),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile.bio ?? 'Hi, I\'m using this app',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildProfileAction(
                              icon: Iconsax.message,
                              label: 'Message',
                              onTap: () {
                                Navigator.pop(context);
                                _openChat(profile);
                              },
                            ),
                            _buildProfileAction(
                              icon: Iconsax.video,
                              label: 'Video',
                              onTap: () {
                                // TODO: Start video call
                              },
                            ),
                            _buildProfileAction(
                              icon: Iconsax.call,
                              label: 'Call',
                              onTap: () {
                                // TODO: Start voice call
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFFD700)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showChatOptions(Profile profile, String chatId, bool isMuted, bool isPinned) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  isPinned ? Iconsax.arrow_down_1 : Iconsax.arrow_up_3,
                  color: const Color(0xFFFFD700),
                ),
                title: Text(
                  isPinned ? 'Unpin chat' : 'Pin chat',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  if (isPinned) {
                    await _chatService.updateChatSettings(chatId, _currentUserUid!, 'unpin');
                  } else {
                    await _chatService.updateChatSettings(chatId, _currentUserUid!, 'pin');
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  isMuted ? Iconsax.volume_high : Iconsax.volume_slash,
                  color: const Color(0xFFFFD700),
                ),
                title: Text(
                  isMuted ? 'Unmute notifications' : 'Mute notifications',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  if (isMuted) {
                    await _chatService.updateChatSettings(chatId, _currentUserUid!, 'unmute');
                  } else {
                    await _chatService.updateChatSettings(chatId, _currentUserUid!, 'mute');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.archive, color: Color(0xFFFFD700)),
                title: const Text('Archive chat', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _archiveChat(profile, chatId);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.trash, color: Colors.red),
                title: const Text('Delete chat', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteChat(profile, chatId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmation(Profile profile) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Delete chat?', style: TextStyle(color: Colors.white)),
        content: Text(
          'This will delete the chat with ${profile.userName}. This action cannot be undone.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<bool> _showArchiveConfirmation(Profile profile) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Archive chat?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Archive chat with ${profile.userName}?',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _archiveChat(Profile profile, String chatId) async {
    HapticFeedback.mediumImpact();
    await _chatService.updateChatSettings(chatId, _currentUserUid!, 'archive');
    if (_isMounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chat with ${profile.userName} archived'),
          backgroundColor: const Color(0xFF1A1A1A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteChat(Profile profile, String chatId) async {
    HapticFeedback.mediumImpact();
    await _chatService.deleteChat(chatId);
    if (_isMounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chat with ${profile.userName} deleted'),
          backgroundColor: const Color(0xFF1A1A1A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showCameraOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Iconsax.camera, color: Color(0xFFFFD700)),
                title: const Text('Take photo', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Open camera
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.video, color: Color(0xFFFFD700)),
                title: const Text('Record video', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Record video
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Iconsax.user, color: Color(0xFFFFD700)),
                title: const Text('New chat', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showContactsList();
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.people, color: Color(0xFFFFD700)),
                title: const Text('New group', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Create new group
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showContactsList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Select Contact',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<MatchesProvider>(
                    builder: (context, provider, _) {
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: provider.matches.length,
                        itemBuilder: (context, index) {
                          final match = provider.matches[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(match.photo),
                            ),
                            title: Text(
                              match.userName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              match.isLive ? 'Online' : 'Offline',
                              style: TextStyle(
                                color: (match.isLive) ? const Color(0xFFFFD700) : Colors.white54,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _openChat(match);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 16,
                      color: Colors.white.withOpacity(0.05),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 12,
                      color: Colors.white.withOpacity(0.03),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionDivider(String label) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.1),
                thickness: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(
              Iconsax.message_favorite,
              size: 60,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No messages yet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "When you match with someone, your conversations will appear here",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              // TODO: Navigate to discover page
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF4D67), Color(0xFFFFD700)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4D67).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Text(
                "Find Matches",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.search_normal_1,
            size: 60,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 24),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No conversations match "$_searchQuery"',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}