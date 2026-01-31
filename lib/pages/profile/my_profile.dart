import 'dart:ui';
import 'dart:math';

import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/home/widgets/profile_shimmer.dart';
import 'package:dating/providers/my_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class MyDetailedProfilePage extends StatelessWidget {
  const MyDetailedProfilePage({super.key});

  int _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return 0;
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      final monthDiff = now.month - birthDate.month;
      if (monthDiff < 0 || (monthDiff == 0 && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<MyProfileProvider>();
    if (profileProvider.isLoading) return const ProfileShimmer();
    if (profileProvider.error != null) return _buildErrorState(profileProvider.error!);

    final userProfile = profileProvider.userProfile;
    if (userProfile == null) return const ProfileShimmer();

    final String bgImg = userProfile.photo;
    final List<Photo> photos = userProfile.photos;
    final int age = _calculateAge(userProfile.dateOfBirth);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image (Tappable to view full screen)
          if (bgImg.isNotEmpty)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _openGallery(context, photos, 0),
                child: Image.network(bgImg, fit: BoxFit.cover),
              ),
            ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.7, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildTopBar(context, age)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 250),
                        _buildFloatingBadges(bgImg, userProfile),
                        const SizedBox(height: 20),
                        _buildNameSection(userProfile, age),
                        const SizedBox(height: 15),
                        _buildAboutSection(userProfile),
                        const SizedBox(height: 20),
                        _buildDetailsSection(userProfile),
                        const SizedBox(height: 25),
                        _buildSubscriptionCards(),
                        const SizedBox(height: 25),
                        _buildTagsScroll(userProfile),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
                
                if (photos.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => GestureDetector(
                          onTap: () => _openGallery(context, photos, index),
                          child: _buildGridItem(photos, index),
                        ),
                        childCount: photos.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openGallery(BuildContext context, List<Photo> photos, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => FullScreenGallery(
          photos: photos,
          initialIndex: initialIndex,
        ),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  // --- UI Components remain mostly the same but integrated ---
  
  Widget _buildTopBar(BuildContext context, int age) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _glassIcon(Iconsax.arrow_left_2, () => Navigator.pop(context)),
          Row(
            children: [
              _glassIcon(Iconsax.radar, () {}),
              const SizedBox(width: 10),
              _glassTextBadge(age.toString()),
              const SizedBox(width: 10),
              _glassIcon(Iconsax.more, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(List<Photo> photos, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: NetworkImage(photos[index].photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: index == 0
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.crown_1, color: Colors.amber, size: 12),
                      SizedBox(width: 4),
                      Text("PRIMARY", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
            )
          : null,
    ).animate().fadeIn(delay: (index * 50).ms);
  }

  // Helper widgets (_glassIcon, _glassTextBadge, etc.) are required here as per original code...
  Widget _glassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _glassIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: _glassContainer(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _glassTextBadge(String text, {IconData? icon}) {
    return _glassContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, color: Colors.white, size: 14), const SizedBox(width: 6)],
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBadges(String img, Profile userProfile) {
    return Row(
      children: [
        Hero(
          tag: 'profile_pic',
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: CircleAvatar(radius: 25, backgroundImage: NetworkImage(img)),
          ),
        ),
        const SizedBox(width: 10),
        if (userProfile.education.name.isNotEmpty) _glassTextBadge(userProfile.education.name, icon: Iconsax.book),
        const SizedBox(width: 10),
        if (userProfile.relationshipGoal != null) _glassTextBadge(userProfile.relationshipGoal!.name, icon: Iconsax.heart),
      ],
    ).animate().fadeIn().slideX(begin: -0.2);
  }

  Widget _buildNameSection(Profile userProfile, int age) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(userProfile.userName, style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold, height: 1.05)),
            const SizedBox(width: 12),
            Icon(Iconsax.verify5, color: Colors.blue.shade400, size: 28),
          ],
        ),
        const SizedBox(height: 5),
        Text("${age > 0 ? "$age years • " : ""}${userProfile.city ?? ""}", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
      ],
    );
  }

  Widget _buildAboutSection(Profile userProfile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About me", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(userProfile.bio ?? "No bio added.", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, height: 1.4)),
      ],
    );
  }

  Widget _buildDetailsSection(Profile userProfile) {
    return Column(
      children: [
        if (userProfile.job != null) _detailItem(Iconsax.briefcase, "Occupation", userProfile.job!),
        if (userProfile.height != null) _detailItem(Iconsax.ruler, "Height", "${userProfile.height} cm"),
      ],
    );
  }

  Widget _detailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          Text("$title: ", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCards() {
    return Row(
      children: [
        Expanded(child: _subscriptionCard("Free Plan", "Basic access", Iconsax.tick_circle, Colors.greenAccent)),
        const SizedBox(width: 12),
        Expanded(child: _subscriptionCard("Platinum", "DMs & More", Iconsax.medal_star, Colors.amber)),
      ],
    );
  }

  Widget _subscriptionCard(String title, String sub, IconData icon, Color color) {
    return _glassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            Text(sub, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsScroll(Profile userProfile) {
    final tags = userProfile.interests;
    if (tags.isEmpty) return const SizedBox();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) => Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
          child: Text("${tag.emoji} ${tag.name}", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        )).toList(),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Scaffold(backgroundColor: Colors.black, body: Center(child: Text(error, style: const TextStyle(color: Colors.white))));
  }
}

// --- FULL SCREEN GALLERY WIDGET ---

class FullScreenGallery extends StatefulWidget {
  final List<Photo> photos;
  final int initialIndex;

  const FullScreenGallery({super.key, required this.photos, required this.initialIndex});

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Swipeable Content
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Center(
                  child: Image.network(
                    widget.photos[index].photoUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),

          // Top Bar (Close Button)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white.withOpacity(0.1),
                    child: const Icon(Iconsax.close_circle, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Indicator (Swipe Indicator)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.photos.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 4,
                  width: _currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.white : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}