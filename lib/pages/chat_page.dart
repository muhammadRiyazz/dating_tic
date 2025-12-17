// chat_page.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      unreadCount: 3,
      isOnline: true,
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Chat(
      id: "2",
      name: "Emma",
      imageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?fit=crop&w=800&q=80",
      lastMessage: "That museum exhibit sounds amazing!",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      isOnline: false,
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    Chat(
      id: "3",
      name: "Mia",
      imageUrl: "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
      lastMessage: "What's your favorite playlist?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 1,
      isOnline: true,
      isVerified: false,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Chat(
      id: "4",
      name: "Amelia",
      imageUrl: "https://images.unsplash.com/photo-1517365830460-955ce3ccd263?fit=crop&w=800&q=80",
      lastMessage: "The sunset photos were incredible!",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 0,
      isOnline: false,
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Chat(
      id: "5",
      name: "Harper",
      imageUrl: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?fit=crop&w=800&q=80",
      lastMessage: "Ready for our hike this Saturday? 🏔️",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 5,
      isOnline: true,
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Chat(
      id: "6",
      name: "Olivia",
      imageUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?fit=crop&w=800&q=80",
      lastMessage: "Just listened to that song you recommended! 🎵",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 45)),
      unreadCount: 2,
      isOnline: false,
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
    ),
   
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryRed = const Color(0xFFFF3B30);
    
    // Theme colors
    final backgroundColor = isDarkMode ? const Color(0xFF0A0505) : const Color(0xFFFFF5F5);
    final cardColor = isDarkMode ? const Color(0xFF1A0A0A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2A0707);
    final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final searchBgColor = isDarkMode ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade100;
    final dividerColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(primaryRed, textColor),
            
            // Search Bar
            _buildSearchBar(searchBgColor, textColor, secondaryTextColor),
            
            // Online Now Section
            // _buildOnlineNowSection(primaryRed, cardColor, textColor),
            
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: dividerColor, height: 0),
            ),
            
            // Chats List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    'Recent Messages',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_chats.length}',
                    style: TextStyle(
                      color: primaryRed,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            
            // Chats List
            Expanded(
              child: _buildChatsList(cardColor, textColor, secondaryTextColor, primaryRed, dividerColor),
            ),
          ],
        ),
      ),
      
      // Floating Action Button for New Chat
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewChat,
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Iconsax.edit, size: 24),
      ),
    );
  }

  Widget _buildAppBar(Color primaryRed, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryRed.withOpacity(0.1),
                ),
                child: IconButton(
                  icon: Icon(Iconsax.arrow_left, color: primaryRed),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
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
            ],
          ),
          
          // Filter Button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryRed.withOpacity(0.1),
            ),
            child: IconButton(
              icon: Icon(Iconsax.filter, color: primaryRed),
              onPressed: _showFilterOptions,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Color bgColor, Color textColor, Color hintColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Iconsax.search_normal, color: hintColor, size: 20),
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
                  hintStyle: TextStyle(color: hintColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: Icon(Iconsax.close_circle, color: hintColor, size: 20),
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
    );
  }

  Widget _buildOnlineNowSection(Color primaryRed, Color cardColor, Color textColor) {
    final activeUsers = _chats.where((chat) => chat.isOnline).take(8).toList();
    
    return SizedBox(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Online Now',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${activeUsers.length}',
                    style: TextStyle(
                      color: primaryRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: activeUsers.length,
              itemBuilder: (context, index) {
                final chat = activeUsers[index];
                return GestureDetector(
                  onTap: () => _openChat(chat),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [primaryRed, Colors.pink.shade600],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryRed.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(chat.imageUrl),
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(Color cardColor, Color textColor, Color secondaryTextColor, Color primaryRed, Color dividerColor) {
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

    return RefreshIndicator(
      color: primaryRed,
      backgroundColor: cardColor,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: filteredChats.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(color: dividerColor, height: 16),
        ),
        itemBuilder: (context, index) {
          final chat = filteredChats[index];
          return _buildChatItem(chat, cardColor, textColor, secondaryTextColor, primaryRed);
        },
      ),
    );
  }

  Widget _buildChatItem(Chat chat, Color cardColor, Color textColor, Color secondaryTextColor, Color primaryRed) {
    final timeAgo = _getTimeAgo(chat.lastMessageTime);
    
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _openChat(chat),
          onLongPress: () => _showChatOptions(chat),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile Image
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: chat.unreadCount > 0 ? primaryRed : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
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
                
                const SizedBox(width: 12),
                
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
                          if (chat.isVerified)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(Iconsax.verify5, color: Colors.blue, size: 16),
                            ),
                          const Spacer(),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              color: secondaryTextColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Last Message Preview
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: TextStyle(
                                color: chat.unreadCount > 0 ? textColor : secondaryTextColor,
                                fontSize: 14,
                                fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
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
                        ],
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

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  void _showFilterOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A0A0A) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterOption('Unread Messages', Iconsax.messages),
            _buildFilterOption('Online Only', Iconsax.wifi),
            _buildFilterOption('Verified Users', Iconsax.verify),
            _buildFilterOption('With Media', Iconsax.gallery),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  ListTile _buildFilterOption(String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    
    return ListTile(
      leading: Icon(icon, color: primaryRed),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: false,
        onChanged: (value) {},
        activeColor: primaryRed,
      ),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  void _showChatOptions(Chat chat) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A0A0A) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildChatOption('Mark as Unread', Iconsax.message),
            _buildChatOption('Pin Chat', Iconsax.main_component),
            _buildChatOption('Mute Notifications', Iconsax.notification),
            _buildChatOption('Delete Chat', Iconsax.trash, color: Colors.red),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  ListTile _buildChatOption(String title, IconData icon, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    
    return ListTile(
      leading: Icon(icon, color: color ?? primaryRed),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Handle option
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  void _startNewChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Chat'),
        content: const Text('Select a match to start chatting'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _openChat(Chat chat) {
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
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool isVerified;
  final DateTime lastSeen;

  Chat({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
    required this.isVerified,
    required this.lastSeen,
  });
}

class ChatDetailPage extends StatefulWidget {
  final Chat chat;
  
  const ChatDetailPage({super.key, required this.chat});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load sample messages
    _messages.addAll([
      Message(
        id: '1',
        text: 'Hey there! How was your day?',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 30)),
        status: MessageStatus.read,
      ),
      Message(
        id: '2',
        text: 'It was great! Just finished some work and now relaxing ☕',
        isMe: true,
        time: DateTime.now().subtract(const Duration(minutes: 25)),
        status: MessageStatus.read,
      ),
      Message(
        id: '3',
        text: 'Want to grab coffee this weekend?',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 20)),
        status: MessageStatus.read,
      ),
      Message(
        id: '4',
        text: 'Definitely! How about Saturday afternoon?',
        isMe: true,
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        status: MessageStatus.read,
      ),
      Message(
        id: '5',
        text: 'Perfect! 3 PM at Blue Bottle?',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        status: MessageStatus.read,
      ),
      Message(
        id: '6',
        text: 'Sounds good! Looking forward to it 😊',
        isMe: true,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        status: MessageStatus.read,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryRed = const Color(0xFFFF3B30);
    
    // Theme colors
    final backgroundColor = isDarkMode ? const Color(0xFF0A0505) : const Color(0xFFFFF5F5);
    final appBarColor = isDarkMode ? const Color(0xFF1A0A0A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2A0707);
    final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(appBarColor, textColor, primaryRed),
      body: Column(
        children: [
          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${widget.chat.name} is typing...',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message, primaryRed, textColor, secondaryTextColor);
              },
            ),
          ),
          
          // Message Input
          _buildMessageInput(primaryRed, textColor, secondaryTextColor, appBarColor),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color appBarColor, Color textColor, Color primaryRed) {
    return AppBar(
      backgroundColor: appBarColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Iconsax.arrow_left, color: primaryRed),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        onTap: _showUserProfile,
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.chat.imageUrl),
                ),
                if (widget.chat.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: appBarColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.chat.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.chat.isVerified)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Iconsax.verify5, color: Colors.blue, size: 14),
                      ),
                  ],
                ),
                // Text(
                //   widget.chat.isOnline ? 'Online now' : 'Last seen ${_getTimeAgo(widget.chat.lastSeen)}',
                //   style: TextStyle(
                //     color: secondaryTextColor,
                //     fontSize: 12,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        // Voice Call Button
        IconButton(
          icon: Icon(Iconsax.call, color: primaryRed),
          onPressed: _startVoiceCall,
        ),
        // Video Call Button
        IconButton(
          icon: Icon(Iconsax.video, color: primaryRed),
          onPressed: _startVideoCall,
        ),
        // More Options
        PopupMenuButton<String>(
          icon: Icon(Iconsax.more, color: primaryRed),
          onSelected: (value) {
            if (value == 'profile') {
              _showUserProfile();
            } else if (value == 'block') {
              _blockUser();
            } else if (value == 'clear') {
              _clearChat();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(Iconsax.user),
                title: Text('View Profile'),
              ),
            ),
            const PopupMenuItem(
              value: 'block',
              child: ListTile(
                leading: Icon(Iconsax.profile_remove),
                title: Text('Block User'),
              ),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: ListTile(
                leading: Icon(Iconsax.trash),
                title: Text('Clear Chat'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Message message, Color primaryRed, Color textColor, Color secondaryTextColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(widget.chat.imageUrl),
              ),
            ),
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe
                    ? primaryRed
                    : isDark
                        ? const Color(0xFF1A0A0A)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isMe ? const Radius.circular(20) : const Radius.circular(4),
                  bottomRight: message.isMe ? const Radius.circular(4) : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : textColor,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(message.time),
                        style: TextStyle(
                          color: message.isMe ? Colors.white70 : secondaryTextColor,
                          fontSize: 10,
                        ),
                      ),
                      if (message.isMe) const SizedBox(width: 4),
                      if (message.isMe)
                        Icon(
                          message.status == MessageStatus.sent
                              ? Iconsax.tick_circle
                              : message.status == MessageStatus.delivered
                                  ? Iconsax.tick_circle
                                  : Iconsax.tick_circle,
                          size: 12,
                          color: message.status == MessageStatus.read
                              ? Colors.blue.shade300
                              : Colors.white70,
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
  }

  Widget _buildMessageInput(Color primaryRed, Color textColor, Color secondaryTextColor, Color appBarColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appBarColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Attachment Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryRed.withOpacity(0.1),
            ),
            child: IconButton(
              icon: Icon(Iconsax.add, color: primaryRed, size: 20),
              onPressed: _showAttachmentOptions,
              padding: EdgeInsets.zero,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Message Input Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: textColor, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: secondaryTextColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  // Handle typing indicator
                },
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Send Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primaryRed, Colors.red.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryRed.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Iconsax.send_2, color: Colors.white, size: 20),
              onPressed: _sendMessage,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  bool get _isTyping => false; // You can implement typing detection

  void _showUserProfile() {
    // Navigate to user profile page
  }

  void _startVoiceCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Call'),
        content: Text('Start voice call with ${widget.chat.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Start voice call
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _startVideoCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Call'),
        content: Text('Start video call with ${widget.chat.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Start video call
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _blockUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block ${widget.chat.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Block user
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear chat
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A0A0A) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentOption(Iconsax.gallery, 'Gallery'),
                  _buildAttachmentOption(Iconsax.camera, 'Camera'),
                  _buildAttachmentOption(Iconsax.microphone, 'Audio'),
                  _buildAttachmentOption(Iconsax.document, 'Document'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentOption(Iconsax.location, 'Location'),
                  _buildAttachmentOption(Iconsax.heart, 'GIF'),
                  _buildAttachmentOption(Iconsax.sticker, 'Sticker'),
                  _buildAttachmentOption(Iconsax.people, 'Contact'),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label) {
    final primaryRed = const Color(0xFFFF3B30);
    
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryRed.withOpacity(0.1),
          ),
          child: Icon(icon, color: primaryRed, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isMe: true,
          time: DateTime.now(),
          status: MessageStatus.sent,
        ));
      });
      _messageController.clear();
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final MessageStatus status;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    required this.status,
  });
}

enum MessageStatus {
  sent,
  delivered,
  read,
}