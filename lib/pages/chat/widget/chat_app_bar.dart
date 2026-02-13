import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/providers/chat%20providers/chat_provider.dart';
import 'package:dating/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Profile receiverProfile;
  final String chatId;

  const ChatAppBar({
    super.key,
    required this.receiverProfile,
    required this.chatId,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return StreamBuilder<DocumentSnapshot>(
          stream: ChatService().getChatInfo(chatId),
          builder: (context, snapshot) {
            bool isTyping = false;
            if (snapshot.hasData) {
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              final typingUsers = List<String>.from(data?['typingUsers'] ?? []);
              isTyping = typingUsers.contains(receiverProfile.uID);
            }

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      // Back button
                      _buildBackButton(context),
                      
                      const SizedBox(width: 8),
                      
                      // Profile picture with online status
                      _buildProfilePicture(context),
                      
                      const SizedBox(width: 12),
                      
                      // User info and typing status
                      _buildUserInfo(isTyping),
                      
                      const Spacer(),
                      
                      // Action buttons
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Iconsax.arrow_left,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showProfileBottomSheet(context);
      },
      child: StreamBuilder<bool>(
        stream: ChatService().getUserOnlineStatus(receiverProfile.uID!),
        builder: (context, snapshot) {
          final isOnline = snapshot.data ?? false;
          
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isOnline
                      ? const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF4D67)],
                        )
                      : null,
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  backgroundImage: CachedNetworkImageProvider(
                    receiverProfile.photo,
                  ),
                  onBackgroundImageError: (exception, stackTrace) {},
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
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
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(bool isTyping) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            receiverProfile.userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          StreamBuilder<DocumentSnapshot>(
            stream: ChatService().getChatInfo(chatId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data?.data() as Map<String, dynamic>?;
                final typingUsers = List<String>.from(data?['typingUsers'] ?? []);
                final isReceiverTyping = typingUsers.contains(receiverProfile.uID);
                
                if (isReceiverTyping) {
                  return _buildTypingIndicator();
                }
              }
              
              return StreamBuilder<bool>(
                stream: ChatService().getUserOnlineStatus(receiverProfile.uID!),
                builder: (context, onlineSnapshot) {
                  final isOnline = onlineSnapshot.data ?? false;
                  
                  return Text(
                    isOnline ? 'Online' : _getLastSeenText(),
                    style: TextStyle(
                      color: isOnline 
                          ? const Color(0xFFFFD700) 
                          : Colors.white.withOpacity(0.3),
                      fontSize: 12,
                    ),
                  );
                },
              );
            },
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
            fontSize: 12,
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
          onPlay: (controller) => controller.repeat(),
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

  String _getLastSeenText() {
    // This would be replaced with actual last seen logic
    return 'Offline';
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          icon: Iconsax.video,
          onTap: () {
            _showComingSoon(context, 'Video Call');
          },
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Iconsax.call,
          onTap: () {
            _showComingSoon(context, 'Voice Call');
          },
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Iconsax.more,
          onTap: () {
            _showChatOptions(context);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showProfileBottomSheet(BuildContext context) {
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
                        
                        // Profile image
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: CachedNetworkImageProvider(
                                receiverProfile.photo,
                              ),
                            ),
                            StreamBuilder<bool>(
                              stream: ChatService().getUserOnlineStatus(receiverProfile.uID!),
                              builder: (context, snapshot) {
                                final isOnline = snapshot.data ?? false;
                                if (!isOnline) return const SizedBox.shrink();
                                
                                return Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFD700),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF1A1A1A), 
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Name
                        Text(
                          receiverProfile.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Bio
                        if (receiverProfile.bio != null && receiverProfile.bio!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              receiverProfile.bio!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildProfileAction(
                              icon: Iconsax.message,
                              label: 'Message',
                              onTap: () => Navigator.pop(context),
                            ),
                            _buildProfileAction(
                              icon: Iconsax.video,
                              label: 'Video',
                              onTap: () {
                                Navigator.pop(context);
                                _showComingSoon(context, 'Video Call');
                              },
                            ),
                            _buildProfileAction(
                              icon: Iconsax.call,
                              label: 'Call',
                              onTap: () {
                                Navigator.pop(context);
                                _showComingSoon(context, 'Voice Call');
                              },
                            ),
                            _buildProfileAction(
                              icon: Iconsax.profile_2user,
                              label: 'Profile',
                              onTap: () {
                                Navigator.pop(context);
                                _navigateToFullProfile(context);
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Media section
                        _buildMediaSection(context),
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
            child: Icon(icon, color: const Color(0xFFFFD700), size: 24),
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

  Widget _buildMediaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shared Media',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all media
                },
                child: const Text(
                  'See All',
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: StreamBuilder<QuerySnapshot>(
            stream: ChatService().getMessagesStream(chatId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final mediaMessages = snapshot.data!.docs
                  .where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final type = data['type'];
                    return type == 'image' || type == 'video';
                  })
                  .take(5)
                  .toList();

              if (mediaMessages.isEmpty) {
                return Center(
                  child: Text(
                    'No media shared yet',
                    style: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: mediaMessages.length,
                itemBuilder: (context, index) {
                  final data = mediaMessages[index].data() as Map<String, dynamic>;
                  final mediaUrls = List<String>.from(data['mediaUrls'] ?? []);
                  final type = data['type'];
                  
                  if (mediaUrls.isEmpty) return const SizedBox.shrink();
                  
                  return GestureDetector(
                    onTap: () {
                      // Open media viewer
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(mediaUrls.first),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: type == 'video'
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.play_circle_filled,
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToFullProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailsPage(
          profiledata: receiverProfile,
          goalName: receiverProfile.relationshipGoal?.name ?? "",
          match: true,
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context) {
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
                title: const Text('View Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToFullProfile(context);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.search_normal, color: Color(0xFFFFD700)),
                title: const Text('Search in Conversation', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon(context, 'Search');
                },
              ),
              ListTile(
                leading:  Icon(Iconsax.sound5, color: Color(0xFFFFD700)),
                title: const Text('Mute Notifications', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _muteChat(context);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.trash, color: Colors.red),
                title: const Text('Delete Chat', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteChat(context);
                },
              ),
              ListTile(
                leading:  Icon(Iconsax.back_square, color: Colors.red),
                title: const Text('Block User', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _muteChat(BuildContext context) {
    // Implement mute functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat muted'),
        backgroundColor: Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Delete Chat?', style: TextStyle(color: Colors.white)),
        content: Text(
          'This will delete the chat with ${receiverProfile.userName}. This action cannot be undone.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              Navigator.pop(context); // Go back to chat list
              
              // Delete chat logic
              ChatService().deleteChat(chatId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _blockUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Block User?', style: TextStyle(color: Colors.white)),
        content: Text(
          '${receiverProfile.userName} will no longer be able to send you messages.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              Navigator.pop(context); // Go back to chat list
              
              // Block user logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User blocked'),
                  backgroundColor: Color(0xFF1A1A1A),
                ),
              );
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}