import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

// First, update the Match class to include more profile details
class Match {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final String location;
  final String matchedTime;
  final List<String> commonInterests;
  final bool isOnline;
  final bool hasUnreadMessage;
  final int unreadCount;
  final String lastMessage;
  final String lastMessageTime;
  final String bio;
  final List<String> photos;
  final String occupation;
  final String education;
  final String height;
  final String relationshipType;
  final bool isVerified;
  final int distance;
  final List<String> lifestyle;
  final List<String> values;

  Match({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.location,
    required this.matchedTime,
    required this.commonInterests,
    required this.isOnline,
    required this.hasUnreadMessage,
    required this.unreadCount,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.bio,
    required this.photos,
    required this.occupation,
    required this.education,
    required this.height,
    required this.relationshipType,
    required this.isVerified,
    required this.distance,
    required this.lifestyle,
    required this.values,
  });
}

// Update your matches list with more details
final List<Match> _matchesList = [
  Match(
    id: "1",
    name: "Sophia",
    age: 26,
    imageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
    location: "2 km away",
    matchedTime: "2 hours ago",
    commonInterests: ["Yoga", "Travel", "Coffee", "Photography"],
    isOnline: true,
    hasUnreadMessage: true,
    unreadCount: 3,
    lastMessage: "Hey! Want to grab coffee this weekend? ☕",
    lastMessageTime: "10:24 AM",
    bio: "Digital marketer who loves sunrise yoga and capturing beautiful moments. Coffee dates are my favorite! Looking for someone who appreciates the little things in life.",
    photos: [
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1517841905240-472988babdf9?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1494790108755-2616b786d4d1?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
    ],
    occupation: "Digital Marketer",
    education: "MBA, Stanford University",
    height: "5'7\"",
    relationshipType: "Looking for Long-term",
    isVerified: true,
    distance: 2,
    lifestyle: ["Non-smoker", "Social drinker", "Vegetarian", "Fitness Enthusiast"],
    values: ["Family-oriented", "Spiritual", "Ambitious", "Adventurous"],
  ),
  // ... update other matches similarly
];

// User Profile Page
class UserProfilePage extends StatefulWidget {
  
  const UserProfilePage({super.key, });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _selectedPhotoIndex = 0;
  bool _isLiked = false;
  bool _showFullBio = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryRed = const Color(0xFFFF3B30);
    
    // Theme colors
    final backgroundColor = isDarkMode ? const Color(0xFF0A0505) : const Color(0xFFFFF5F5);
    final cardColor = isDarkMode ? Colors.white.withOpacity(0.03) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2A0707);
    final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final dividerColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Profile Header with Photos
                SliverAppBar(
                  expandedHeight: 500,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildProfilePhotos(primaryRed),
                  ),
                  leading: _buildBackButton(primaryRed, cardColor),
                  actions: [
                    _buildActionButton(
                      icon: Iconsax.more,
                      onPressed: _showProfileOptions,
                      color: primaryRed,
                      bgColor: cardColor,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: _isLiked ? Iconsax.heart5 : Iconsax.heart,
                      onPressed: _toggleLike,
                      color: _isLiked ? Colors.red : primaryRed,
                      bgColor: cardColor,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                
                // Profile Details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and Basic Info
                        _buildBasicInfo(textColor, secondaryTextColor, primaryRed),
                        
                        const SizedBox(height: 20),
                        
                        // About Me Section
                        _buildAboutSection(textColor, secondaryTextColor),
                        
                        const SizedBox(height: 20),
                        
                        // Photos Gallery
                        _buildPhotosGallery(textColor),
                        
                        const SizedBox(height: 20),
                        
                        // Interests Section
                        _buildInterestsSection(primaryRed, textColor),
                        
                        const SizedBox(height: 20),
                        
                        // Details Section
                        _buildDetailsSection(textColor, secondaryTextColor),
                        
                        const SizedBox(height: 20),
                        
                        // Lifestyle & Values
                        _buildLifestyleSection(primaryRed, textColor),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Floating Action Buttons at Bottom
            // Positioned(
            //   bottom: 20,
            //   left: 20,
            //   right: 20,
            //   child: _buildActionButtons(primaryRed, isDarkMode),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhotos(Color primaryRed) {
    return Stack(
      children: [
        // Main Photo
        PageView.builder(
          itemCount:_matchesList[0].photos.length,
          onPageChanged: (index) {
            setState(() {
              _selectedPhotoIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: _matchesList[0].photos[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade300,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Iconsax.gallery, size: 50),
              ),
            );
          },
        ),
        
        // Gradient Overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
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
        
        // Photo Indicator
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _matchesList[0].photos.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedPhotoIndex == index 
                      ? primaryRed 
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
        
        // Photo Count
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Iconsax.gallery5, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  '${_selectedPhotoIndex + 1}/${_matchesList[0].photos.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(Color primaryRed, Color bgColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Iconsax.arrow_left_2, color: primaryRed),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      width: 44,
      height: 44,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildBasicInfo(Color textColor, Color secondaryTextColor, Color primaryRed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${_matchesList[0].name}, ${_matchesList[0].age}',
              style: TextStyle(
                color: textColor,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            if (_matchesList[0].isVerified)
              Icon(Iconsax.verify5, color: Colors.blue, size: 24),
          ],
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            Icon(Iconsax.location5, size: 18, color: secondaryTextColor),
            const SizedBox(width: 6),
            Text(
              '${_matchesList[0].distance} km away',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _matchesList[0].isOnline 
                    ? Colors.green.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _matchesList[0].isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _matchesList[0].isOnline ? 'Online Now' : 'Offline',
                    style: TextStyle(
                      color: _matchesList[0].isOnline ? Colors.green : secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            _buildInfoChip(
              icon: Iconsax.briefcase,
              text: _matchesList[0].occupation,
              color: primaryRed,
            ),
            const SizedBox(width: 12),
            _buildInfoChip(
              icon: Iconsax.book,
              text: _matchesList[0].education,
              color: primaryRed,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Color textColor, Color secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _matchesList[0].bio,
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 15,
            height: 1.5,
          ),
          maxLines: _showFullBio ? null : 4,
          overflow: _showFullBio ? null : TextOverflow.ellipsis,
        ),
        if (!_showFullBio)
          TextButton(
            onPressed: () {
              setState(() {
                _showFullBio = true;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Read more',
              style: TextStyle(
                color: const Color(0xFFFF3B30),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhotosGallery(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Photos',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${_matchesList[0].photos.length}',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _matchesList[0].photos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPhotoIndex = index;
                  });
                  // Scroll to photo section
                },
                child: Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(right: index == _matchesList[0].photos.length - 1 ? 0 : 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(_matchesList[0].photos[index]),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: _selectedPhotoIndex == index 
                          ? const Color(0xFFFF3B30) 
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsSection(Color primaryRed, Color textColor) {
    return Column(
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
          children: _matchesList[0].commonInterests.map((interest) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: primaryRed.withOpacity(0.01),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primaryRed.withOpacity(0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getInterestIcon(interest),
                    size: 16,
                    color: primaryRed,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    interest,
                    style: TextStyle(
                      color: primaryRed,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getInterestIcon(String interest) {
    final Map<String, IconData> iconMap = {
      'Yoga': Iconsax.activity,
      'Travel': Iconsax.airplane,
      'Coffee': Iconsax.coffee,
      'Photography': Iconsax.camera,
      'Art': Iconsax.paintbucket,
      'Music': Iconsax.music,
      'Reading': Iconsax.book_1,
      'Hiking': Iconsax.hashtag_up,
      // Add more mappings as needed
    };
    return iconMap[interest] ?? Iconsax.heart;
  }

  Widget _buildDetailsSection(Color textColor, Color secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Height', _matchesList[0].height, Iconsax.rulerpen, textColor, secondaryTextColor),
        _buildDetailRow('Relationship', _matchesList[0].relationshipType, Iconsax.heart, textColor, secondaryTextColor),
        _buildDetailRow('Education', _matchesList[0].education, Iconsax.book, textColor, secondaryTextColor),
        _buildDetailRow('Occupation', _matchesList[0].occupation, Iconsax.briefcase, textColor, secondaryTextColor),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, Color textColor, Color secondaryTextColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: secondaryTextColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyleSection(Color primaryRed, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lifestyle & Values',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        
        // Lifestyle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lifestyle',
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _matchesList[0].lifestyle.map((item) {
                return Chip(
                  label: Text(
                    item,
                    style: TextStyle(
                      color: primaryRed,
                      fontSize: 13,
                    ),
                  ), 
              
                  backgroundColor:primaryRed.withOpacity(0.00),
                  side: BorderSide(
 color: primaryRed.withOpacity(0.1),                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // // Values
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       'Values',
        //       style: TextStyle(
        //         color: textColor.withOpacity(0.8),
        //         fontSize: 16,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //     const SizedBox(height: 8),
        //     Wrap(
        //       spacing: 8,
        //       runSpacing: 8,
        //       children: _matchesList[0].values.map((value) {
        //         return Chip(
        //           label: Text(
        //             value,
        //             style: TextStyle(
        //               color: Colors.purple.shade700,
        //               fontSize: 13,
        //             ),
        //           ),
        //           backgroundColor: Colors.purple.shade50,
        //           side: BorderSide(
        //             color: Colors.purple.shade100,
        //             width: 1,
        //           ),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //         );
        //       }).toList(),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  // Widget _buildActionButtons(Color primaryRed, bool isDarkMode) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //     decoration: BoxDecoration(
  //       color: isDarkMode ? const Color(0xFF1A0A0A) : Colors.white,
  //       borderRadius: BorderRadius.circular(25),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 20,
  //           spreadRadius: 5,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: _buildProfileActionButton(
  //             icon: Iconsax.close_circle,
  //             label: 'Pass',
  //             color: Colors.red.shade700,
  //             onPressed: _passProfile,
  //           ),
  //         ),
  //         const SizedBox(width: 20),
  //         Expanded(
  //           child: _buildProfileActionButton(
  //             icon: Iconsax.heart5,
  //             label: 'Like',
  //             color: Colors.green.shade700,
  //             onPressed: _likeProfile,
  //             isGradient: true,
  //           ),
  //         ),
  //         const SizedBox(width: 20),
  //         Expanded(
  //           child: _buildProfileActionButton(
  //             icon: Iconsax.message,
  //             label: 'Chat',
  //             color: primaryRed,
  //             onPressed: _startChat,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildProfileActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isGradient = false,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isGradient ? null : color.withOpacity(0.1),
            gradient: isGradient
                ? LinearGradient(
                    colors: [color, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            shape: BoxShape.circle,
            boxShadow: isGradient
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              splashColor: color.withOpacity(0.2),
              child: Icon(
                icon,
                color: isGradient ? Colors.white : color,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    
    // Show animation or snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLiked 
              ? '❤️ Added ${_matchesList[0].name} to your favorites'
              : 'Removed ${_matchesList[0].name} from favorites',
        ),
        backgroundColor: _isLiked ? Colors.green : Colors.grey,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showProfileOptions() {
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
            _buildProfileOption('Report Profile', Iconsax.warning_2, Colors.red),
            _buildProfileOption('Block User', Iconsax.profile_remove, Colors.orange),
            _buildProfileOption('Share Profile', Iconsax.share),
            // _buildProfileOption('View All Photos', Iconsax.gallery),
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  ListTile _buildProfileOption(String title, IconData icon, [Color? color]) {
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
      trailing: Icon(Iconsax.arrow_right_3, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
      onTap: () {
        Navigator.pop(context);
        // Handle option selection
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  void _passProfile() {
    Navigator.pop(context);
    // Add logic to pass on this profile
  }

  void _likeProfile() {
    setState(() {
      _isLiked = true;
    });
    
    // Show success animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Iconsax.heart5,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'You liked ${_matchesList[0].name}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
      Navigator.pop(context); // Go back to matches page
    });
  }

  void _startChat() {
    // Navigate to chat page or show chat interface
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start chat with ${_matchesList[0].name}'),
        content: const Text('This would open the chat interface'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to actual chat page
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }
}

// Update the _openMatchProfile function in MatchesPage to navigate to UserProfilePage
void _openMatchProfile(BuildContext context, Match match) {
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => UserProfilePage(match: match),
  //   ),
  // );
}

// Update the _buildMatchCard function in MatchesPage
Widget _buildMatchCard(Match match, Color cardColor, Color textColor, Color secondaryTextColor, Color primaryRed ,BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openMatchProfile(context, match), // Updated this line
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image with Online Indicator
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryRed.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: CachedNetworkImage(
                        imageUrl: match.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: secondaryTextColor.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                  if (match.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
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
              
              // Match Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Age with verified badge
                    Row(
                      children: [
                        Text(
                          match.name,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${match.age}',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (match.isVerified)
                          const SizedBox(width: 4),
                        if (match.isVerified)
                          Icon(Iconsax.verify5, color: Colors.blue, size: 16),
                        const Spacer(),
                        Text(
                          match.matchedTime,
                          style: TextStyle(
                            color: secondaryTextColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Location
                    Row(
                      children: [
                        Icon(Iconsax.location5, size: 14, color: secondaryTextColor),
                        const SizedBox(width: 4),
                        Text(
                          match.location,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Common Interests
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: match.commonInterests.take(3).map((interest) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              color: primaryRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => 
                            
                            _openMatchProfile(context, match),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryRed,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.eye, size: 16),
                                SizedBox(width: 6),
                                Text('View Profile'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: secondaryTextColor.withOpacity(0.3),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Iconsax.message,
                              size: 20,
                              color: primaryRed,
                            ),
                            onPressed: () => null,
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