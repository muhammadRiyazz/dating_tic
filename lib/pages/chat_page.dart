// chat_page.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Sample chat data
  final List<Chat> _chats = [
    Chat(
      id: "1",
      name: "Sophia",
      imageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
      lastMessage: "Hey! Want to grab coffee this weekend? ☕",
      lastMessageTime: "10:24 AM",
      unreadCount: 3,
      isOnline: true,
    ),
    Chat(
      id: "2",
      name: "Emma",
      imageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?fit=crop&w=800&q=80",
      lastMessage: "That museum exhibit sounds amazing!",
      lastMessageTime: "Yesterday",
      unreadCount: 0,
      isOnline: false,
    ),
    Chat(
      id: "3",
      name: "Mia",
      imageUrl: "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
      lastMessage: "What's your favorite playlist?",
      lastMessageTime: "9:15 AM",
      unreadCount: 1,
      isOnline: true,
    ),
    Chat(
      id: "4",
      name: "Amelia",
      imageUrl: "https://images.unsplash.com/photo-1517365830460-955ce3ccd263?fit=crop&w=800&q=80",
      lastMessage: "The sunset photos were incredible!",
      lastMessageTime: "3 days ago",
      unreadCount: 0,
      isOnline: false,
    ),
    Chat(
      id: "5",
      name: "Harper",
      imageUrl: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?fit=crop&w=800&q=80",
      lastMessage: "Ready for our hike this Saturday? 🏔️",
      lastMessageTime: "11:30 AM",
      unreadCount: 5,
      isOnline: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    
    // Theme colors
    final backgroundColor = isDark ? const Color(0xFF0A0505) : const Color(0xFFFFF5F5);
    final cardColor = isDark ? const Color(0xFF1A0A0A) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2A0707);
    final secondaryTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final searchBgColor = isDark ? Colors.grey.shade900 : Colors.grey.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(Iconsax.message_text5, color: primaryRed, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Messages',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryRed.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: Icon(Iconsax.edit, size: 22, color: primaryRed),
                      onPressed: (){},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: searchBgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(Iconsax.search_normal, color: secondaryTextColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: TextStyle(color: textColor, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search messages...',
                          hintStyle: TextStyle(color: secondaryTextColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: Icon(Iconsax.close_circle, color: secondaryTextColor, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            
            // Active Now Sectioncf
            // _buildActiveNowSection(primaryRed, cardColor, textColor),
            
            // Chats List
            Expanded(
              child: _buildChatsList(cardColor, textColor, secondaryTextColor, primaryRed),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveNowSection(Color primaryRed, Color cardColor, Color textColor) {
    final activeUsers = _chats.where((chat) => chat.isOnline).take(5).toList();
    
    return SizedBox(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Active Now',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: activeUsers.length,
              itemBuilder: (context, index) {
                final chat = activeUsers[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryRed.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CachedNetworkImage(
                                imageUrl: chat.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: cardColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat.name.split(' ')[0],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildChatsList(Color cardColor, Color textColor, Color secondaryTextColor, Color primaryRed) {
    final filteredChats = _chats.where((chat) {
      return chat.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             chat.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredChats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.message_text,
              size: 80,
              color: secondaryTextColor.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              'No messages found',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation with your matches!',
              style: TextStyle(
                color: secondaryTextColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return _buildChatItem(chat, cardColor, textColor, secondaryTextColor, primaryRed);
      },
    );
  }

  Widget _buildChatItem(Chat chat, Color cardColor, Color textColor, Color secondaryTextColor, Color primaryRed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openChat(chat),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Image
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: chat.unreadCount > 0 ? primaryRed : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: chat.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (chat.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cardColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Message Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            chat.name,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (chat.unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: primaryRed,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${chat.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          const Spacer(),
                          Text(
                            chat.lastMessageTime,
                            style: TextStyle(
                              color: secondaryTextColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Last Message Preview
                      Text(
                        chat.lastMessage,
                        style: TextStyle(
                          color: chat.unreadCount > 0 ? textColor : secondaryTextColor,
                          fontSize: 14,
                          fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _startNewChat() {
  //   // TODO: Implement new chat
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('New Chat'),
  //       content: const Text('Select a match to start chatting'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Start'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _openChat(Chat chat) {
    // TODO: Navigate to chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(chat: chat),
      ),
    );
  }
}

class Chat {
  final String id;
  final String name;
  final String imageUrl;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  Chat({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
  });
}

class ChatDetailPage extends StatelessWidget {
  final Chat chat;
  
  const ChatDetailPage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chat.imageUrl),
              radius: 18,
            ),
            const SizedBox(width: 12),
            Text(chat.name),
            if (chat.isOnline)
              Container(
                margin: const EdgeInsets.only(left: 6),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Iconsax.call),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: const Icon(Iconsax.more),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Chat messages would go here
                _buildMessage(
                  'Hey there! How was your day?',
                  false,
                  '10:24 AM',
                ),
                _buildMessage(
                  'It was great! Just finished some work and now relaxing ☕',
                  true,
                  '10:25 AM',
                ),
                _buildMessage(
                  'Want to grab coffee this weekend?',
                  false,
                  '10:26 AM',
                ),
              ],
            ),
          ),
          _buildMessageInput( context),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFF3B30) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Iconsax.add_circle),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Iconsax.send_2, color: const Color(0xFFFF3B30)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}