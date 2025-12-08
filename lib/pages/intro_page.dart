import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class Profile {
  final String name;
  final int age;
  final String imageUrl;
  final String location;
  final List<String> interests;
  final String bio;
  final List<String> photos;

  Profile({
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.location,
    required this.interests,
    required this.bio,
    required this.photos,
  });
}

final List<Profile> _profileData = [
  Profile(
    name: "Sophia",
    age: 26,
    imageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
    location: "2 km away",
    interests: ["Yoga", "Reading", "Travel", "Photography"],
    bio: "Digital marketer who loves sunrise yoga and capturing beautiful moments. Coffee dates are my favorite!",
    photos: [
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1517841905240-472988babdf9?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1494790108755-2616b786d4d1?fit=crop&w=800&q=80",
    ],
  ),
  Profile(
    name: "Emma",
    age: 24,
    imageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?fit=crop&w=800&q=80",
    location: "4 km away",
    interests: ["Art", "Hiking", "Cooking", "Music"],
    bio: "Art director who believes in living life to the fullest. Let's explore museums and try new restaurants!",
    photos: [
      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
    ],
  ),
  Profile(
    name: "Mia",
    age: 25,
    imageUrl: "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
    location: "3 km away",
    interests: ["Music", "Wine", "Gardening", "Writing"],
    bio: "Journalist by day, poet by night. Let's exchange playlists and share stories over a glass of wine.",
    photos: [
      "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1517070208541-6ddc4d3efbcb?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1517841905240-472988babdf9?fit=crop&w=800&q=80",
    ],
  ),
  Profile(
    name: "Amelia",
    age: 26,
    imageUrl: "https://images.unsplash.com/photo-1517365830460-955ce3ccd263?fit=crop&w=800&q=80",
    location: "4 km away",
    interests: ["Travel", "Photography", "Surfing", "Food"],
    bio: "Travel photographer chasing sunsets around the world. Next stop? Wherever adventure takes us!",
    photos: [
      "https://images.unsplash.com/photo-1517365830460-955ce3ccd263?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1494790108755-2616b786d4d1?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?fit=crop&w=800&q=80",
    ],
  ),
  Profile(
    name: "Harper",
    age: 27,
    imageUrl: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?fit=crop&w=800&q=80",
    location: "3 km away",
    interests: ["Fitness", "Reading", "Wine", "Music"],
    bio: "Doctor who believes in work-life balance. Weekends are for hiking, books, and good wine.",
    photos: [
      "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1542103749-8ef59b94f47e?fit=crop&w=800&q=80",
    ],
  ),
  Profile(
    name: "Evelyn",
    age: 25,
    imageUrl: "https://images.unsplash.com/photo-1542740348-39501cd6e2b4?fit=crop&w=800&q=80",
    location: "1 km away",
    interests: ["Dancing", "Cooking", "Movies", "Fashion"],
    bio: "Event planner who loves organizing spontaneous adventures. Let's create beautiful memories together!",
    photos: [
      "https://images.unsplash.com/photo-1542740348-39501cd6e2b4?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?fit=crop&w=800&q=80",
    ],
  ),
  Profile(
    name: "Abigail",
    age: 24,
    imageUrl: "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?fit=crop&w=800&q=80",
    location: "5 km away",
    interests: ["Music", "Art", "Coffee", "Travel"],
    bio: "Musician and coffee shop wanderer. Looking for someone to share melodies and meaningful conversations with.",
    photos: [
      "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?fit=crop&w=800&q=80",
    ],
  ),
  Profile(
    name: "Emily",
    age: 26,
    imageUrl: "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?fit=crop&w=800&q=80",
    location: "2 km away",
    interests: ["Yoga", "Reading", "Travel", "Cooking"],
    bio: "Yoga instructor with a passion for healthy living and adventure. Let's find balance together.",
    photos: [
      "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1517841905240-472988babdf9?fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1542103749-8ef59b94f47e?fit=crop&w=800&q=80",
    ],
  ),
];

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final CardSwiperController _cardController = CardSwiperController();
  int _selectedIndex = 0;
  double _cardOpacity = 1.0;

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // Red theme colors based on brightness
    final primaryRed = const Color(0xFFFF3B30);
    final backgroundColor = isDarkMode ? const Color(0xFF0A0505) : const Color(0xFFFFF5F5);
    final cardColor = isDarkMode ? const Color(0xFF1A0A0A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2A0707);
    final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final dividerColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with red theme
            _buildAppBar(context, themeProvider, primaryRed, textColor, cardColor),
            const SizedBox(height: 12),
            
            // Profile Progress Indicator with red theme
            _buildProgressIndicator(primaryRed, secondaryTextColor, dividerColor),
            const SizedBox(height: 10),
            
            // Main Swiping Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCardSwiper(primaryRed),
              ),
            ),
            
            // Like and Pass Buttons (Only 2 buttons)
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //   child: _buildActionButtons(primaryRed, isDarkMode),
            // ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      
      // Bottom Navigation Bar with red theme
      // bottomNavigationBar: _buildBottomNavigationBar(primaryRed, textColor, secondaryTextColor, cardColor),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeProvider themeProvider, Color primaryRed, Color textColor, Color cardColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryRed.withOpacity(0.1),
            ),
            child: IconButton(
              icon: Icon(
                Iconsax.menu_1,
                size: 22,
                color: primaryRed,
              ),
              onPressed: () => _showMenu(context),
              padding: EdgeInsets.zero,
            ),
          ),
          
          // Logo/Title
          Text(
            'MatchFindr',
            style: TextStyle(
              color: primaryRed,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          
          // Theme Toggle & Notification
          Row(
            children: [
              // Theme Toggle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? primaryRed.withOpacity(0.1) : Colors.red.shade100,
                ),
                child: IconButton(
                  icon: Icon(
                    isDark ? Iconsax.sun_1 : Iconsax.moon,
                    size: 22,
                    color: primaryRed,
                  ),
                  onPressed: themeProvider.toggleTheme,
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 12),
              
              // Notification Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Iconsax.notification,
                        size: 22,
                        color: primaryRed,
                      ),
                      onPressed: () => _showNotifications(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryRed,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(Color primaryRed, Color secondaryTextColor, Color dividerColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Profiles Nearby',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: dividerColor,
            color: primaryRed,
            borderRadius: BorderRadius.circular(10),
            minHeight: 4,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discovering matches',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '6/10',
                  style: TextStyle(
                    color: primaryRed,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSwiper(Color primaryRed) {
    return Stack(
      children: [
        CardSwiper(
          cardsCount: _profileData.length,
          cardBuilder: (context, index, percent, secondPercent) {
            return _buildProfileCard(_profileData[index], primaryRed);
          },
          controller: _cardController,
          isDisabled: false,
          isLoop: true,
          numberOfCardsDisplayed: 2,
          scale: 0.95,
          padding: const EdgeInsets.all(0),
          onSwipe: (previousIndex, currentIndex, direction) {
            if (direction == CardSwiperDirection.right) {
              _showLikeAnimation(context, primaryRed);
            } else if (direction == CardSwiperDirection.left) {
              _showDislikeAnimation(context);
            }
            return true;
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard(Profile profile, Color primaryRed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.4) : Colors.red.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: profile.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark ? const Color(0xFF1A0A0A) : Colors.white,
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark ? const Color(0xFF1A0A0A) : Colors.white,
                  child: Icon(
                    Iconsax.user,
                    size: 50,
                    color: primaryRed.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            
            // Top Right Match Percentage (Like button)
            Positioned(
              top: 20,
              right: 20,
              child: _buildMatchPercentage(primaryRed),
            ),
            
            // Bottom Gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            
            // Profile Info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and Age
                            Text(
                              '${profile.name}, ${profile.age}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            
                            // Location
                            Row(
                              children: [
                                Icon(Iconsax.location5, color: Colors.white70, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  profile.location,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        // Photos Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.gallery5, size: 14, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                '${profile.photos.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Bio
                    Text(
                      profile.bio,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Interests
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: profile.interests
                          .map((interest) => _buildInterestChip(interest, primaryRed))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchPercentage(Color primaryRed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryRed.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Iconsax.heart5, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            '86%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String interest, Color primayRed) {
    return Container(

      decoration: BoxDecoration(
        color:primayRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        interest,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Widget _buildInterestChip(BuildContext context, String label) {
  //   return Chip(
  //     label: Text(
  //       label,
  //       style: TextStyle(
  //         color: Theme.of(context).scaffoldBackgroundColor, // Text color contrasts with chip background
  //         fontWeight: FontWeight.w600,
  //         fontSize: 14,
  //       ),
  //     ),
  //     backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
  //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  //   );
  // }

  Widget _buildActionButtons(Color primaryRed, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pass Button
        _buildActionButton(
          icon: Iconsax.close_circle,
          color: Colors.red.shade700,
          iconSize: 28,
          label: 'Pass',
          onTap: () {
            _cardController.swipe(CardSwiperDirection.left);
            _showDislikeAnimation(context);
          },
          isDark: isDarkMode,
        ),
        
        // Like Button
        _buildActionButton(
          icon: Iconsax.heart5,
          color: Colors.green.shade700,
          iconSize: 28,
          label: 'Like',
          onTap: () {
            _cardController.swipe(CardSwiperDirection.right);
            _showLikeAnimation(context, primaryRed);
          },
          isDark: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double iconSize,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(isDark ? 0.3 : 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              splashColor: color.withOpacity(0.2),
              child: Icon(
                icon,
                color: color,
                size: iconSize,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(Color primaryRed, Color textColor, Color secondaryTextColor, Color cardColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: secondaryTextColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavItem(
                icon: Iconsax.home5,
                label: 'Discover',
                index: 0,
                primaryRed: primaryRed,
                secondaryTextColor: secondaryTextColor,
              ),
              _buildBottomNavItem(
                icon: Iconsax.flash_1,
                label: 'Matches',
                index: 1,
                primaryRed: primaryRed,
                secondaryTextColor: secondaryTextColor,
              ),
              _buildBottomNavItem(
                icon: Iconsax.message_text5,
                label: 'Chat',
                index: 2,
                primaryRed: primaryRed,
                secondaryTextColor: secondaryTextColor,
              ),
              _buildBottomNavItem(
                icon: Iconsax.user_octagon5,
                label: 'Profile',
                index: 3,
                primaryRed: primaryRed,
                secondaryTextColor: secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color primaryRed,
    required Color secondaryTextColor,
  }) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryRed : secondaryTextColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryRed : secondaryTextColor,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLikeAnimation(BuildContext context, Color primaryRed) {
    // Show like animation overlay
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primaryRed.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Iconsax.heart5,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 500), () {
      overlayEntry?.remove();
    });
  }

  void _showDislikeAnimation(BuildContext context) {
    // Show dislike animation overlay
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red.shade700.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Iconsax.close_circle,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 500), () {
      overlayEntry?.remove();
    });
  }

  void _showMenu(BuildContext context) {
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
            _buildMenuItem(context, Iconsax.filter, 'Filters & Preferences', primaryRed),
            _buildMenuItem(context, Iconsax.setting_2, 'Settings', primaryRed),
            _buildMenuItem(context, Iconsax.security_card, 'Privacy', primaryRed),
            _buildMenuItem(context, Iconsax.info_circle, 'Help & Support', primaryRed),
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            const SizedBox(height: 20),
            _buildMenuItem(context, Iconsax.logout, 'Log Out', Colors.red),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Iconsax.arrow_right_3,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        size: 18,
      ),
      onTap: () => Navigator.pop(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  void _showNotifications(BuildContext context) {
    // TODO: Implement notifications
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A0A0A) : Colors.white,
        title: Row(
          children: [
            Icon(Iconsax.notification, color: primaryRed),
            const SizedBox(width: 10),
            Text(
              'Notifications',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          'No new notifications',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: primaryRed),
            ),
          ),
        ],
      ),
    );
  }
}
  Widget _buildInterestChip(BuildContext context, String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).scaffoldBackgroundColor, // Text color contrasts with chip background
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
