// profile_page.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0;
  
  // User profile data
  final Map<String, dynamic> _userProfile = {
    'name': 'Alex Johnson',
    'age': 28,
    'location': 'New York',
    'bio': 'Software engineer who loves hiking, coffee, and good conversations. Always up for an adventure!',
    'photos': [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=800&q=80',
    ],
    'interests': ['Hiking', 'Coffee', 'Tech', 'Music', 'Travel', 'Photography'],
    'stats': {
      'matches': 24,
      'likes': 156,
      // 'visits': 342,
    },
    'settings': [
      {'icon': Iconsax.edit, 'title': 'Edit Profile'},
      {'icon': Iconsax.setting_2, 'title': 'Settings'},
      {'icon': Iconsax.security_card, 'title': 'Privacy & Safety'},
      {'icon': Iconsax.notification, 'title': 'Notifications'},
      {'icon': Iconsax.money, 'title': 'Subscription'},
      {'icon': Iconsax.heart, 'title': 'My Likes'},
      {'icon': Iconsax.message_question, 'title': 'Help & Support'},
      {'icon': Iconsax.logout, 'title': 'Log Out', 'color': Colors.red},
    ],
  };

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

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: backgroundColor,
              elevation: 0,
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Profile Background Image
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: _userProfile['photos'][0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Profile Content
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Profile Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Picture
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryRed,
                                width: 0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: _userProfile['photos'][0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 20),
                          
                          // Name and Stats
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_userProfile['name']}, ${_userProfile['age']}',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                
                                Row(
                                  children: [
                                    Icon(Iconsax.location5, size: 16, color: secondaryTextColor),
                                    const SizedBox(width: 6),
                                    Text(
                                      _userProfile['location'],
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Stats Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildStatItem('Matches', _userProfile['stats']['matches'], primaryRed),
                                    SizedBox(width: 12,),
                                    _buildStatItem('Likes', _userProfile['stats']['likes'], primaryRed),
                                    // _buildStatItem('Visits', _userProfile['stats']['visits'], primaryRed),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Bio
                      Text(
                        _userProfile['bio'],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Interests
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interests',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _userProfile['interests']
                                .map<Widget>((interest) => _buildInterestChip(interest, primaryRed))
                                .toList(),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildProfileTab('Photos', 0),
                            ),
                            Expanded(
                              child: _buildProfileTab('Settings', 1),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Tab Content
                      _selectedTab == 0 ? _buildPhotosTab() : _buildSettingsTab(),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color primaryRed) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: primaryRed,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey.shade400 
                : Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInterestChip(String interest, Color primaryRed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryRed.withOpacity(0.3),
        ),
      ),
      child: Text(
        interest,
        style: TextStyle(
          color: primaryRed,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProfileTab(String title, int index) {
    final isSelected = _selectedTab == index;
    final primaryRed = const Color(0xFFFF3B30);
    final textColor = Theme.of(context).brightness == Brightness.dark 
        ? Colors.white 
        : const Color(0xFF2A0707);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryRed.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryRed.withOpacity(0.1) : Colors.transparent,

          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? primaryRed : textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosTab() {
    final primaryRed = const Color(0xFFFF3B30);
    final photos = _userProfile['photos'] as List<String>;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: photos.length + 1, // +1 for add button
      itemBuilder: (context, index) {
        if (index == photos.length) {
          // Add photo button
          return GestureDetector(
            onTap: _addPhoto,
            child: Container(
              decoration: BoxDecoration(
                color: primaryRed.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: primaryRed.withOpacity(0.1),
                  width: 1,
                  // style: BorderStyle.dashed,
                ),
              ),
              child: Icon(
                Iconsax.add,
                color: primaryRed,
                size: 30,
              ),
            ),
          );
        }
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: photos[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    final textColor = isDark ? Colors.white : const Color(0xFF2A0707);
    final settings = _userProfile['settings'] as List<dynamic>;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: settings.map<Widget>((setting) {
          final icon = setting['icon'] as IconData;
          final title = setting['title'] as String;
          final color = setting['color'] as Color? ?? primaryRed;
          
          return ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              Iconsax.arrow_right_3,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              size: 18,
            ),
            onTap: () => _handleSettingTap(title),
          );
        }).toList(),
      ),
    );
  }

  void _addPhoto() {
    // TODO: Implement photo upload
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Photo'),
        content: const Text('Choose a photo from your gallery'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _handleSettingTap(String title) {
    switch (title) {
      case 'Edit Profile':
        _editProfile();
        break;
      case 'Settings':
        _openSettings();
        break;
      case 'Privacy & Safety':
        _openPrivacy();
        break;
      case 'Notifications':
        _openNotifications();
        break;
      case 'Subscription':
        _openSubscription();
        break;
      case 'My Likes':
        _openMyLikes();
        break;
      case 'Help & Support':
        _openHelp();
        break;
      case 'Log Out':
        _logout();
        break;
    }
  }

  void _editProfile() {
    // TODO: Implement edit profile
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Edit your profile information'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openSettings() {
    // TODO: Implement settings
  }

  void _openPrivacy() {
    // TODO: Implement privacy
  }

  void _openNotifications() {
    // TODO: Implement notifications
  }

  void _openSubscription() {
    // TODO: Implement subscription
  }

  void _openMyLikes() {
    // TODO: Implement my likes
  }

  void _openHelp() {
    // TODO: Implement help
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}