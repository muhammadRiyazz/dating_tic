


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