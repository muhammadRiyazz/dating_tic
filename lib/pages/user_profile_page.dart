import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/plans/plan_upgrade_sheet.dart'; // Ensure correct path
import 'package:dating/providers/permission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileDetailsPage extends StatefulWidget {
  final Profile profiledata;
  final String goalName;
  final bool match; // True if already matched, false for discovery

  const ProfileDetailsPage({
    super.key, 
    required this.profiledata, 
    required this.goalName, 
    required this.match,
  });

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final ScrollController _mainScrollController = ScrollController();
  int _currentImageIndex = 0;
  final PageController _galleryPageController = PageController();

  @override
  void dispose() {
    _mainScrollController.dispose();
    _galleryPageController.dispose();
    super.dispose();
  }

  // --- HELPERS ---

  String _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return "24";
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return "24";
    }
  }

  void _showPremiumUpgrade({String? feature, String? desc}) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumUpgradeSheet(),
    );
  }

  void _openGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => FullScreenGallery(
          photos: widget.profiledata.photos.isNotEmpty ? widget.profiledata.photos : [widget.profiledata.photo],
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(widget.profiledata.dateOfBirth);
    final photos = widget.profiledata.photos;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Image (Hero)
          Positioned.fill(
            child: Hero(
              tag: 'profile_image_${widget.profiledata.userId}',
              child: Image.network(
                widget.profiledata.photo,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Cinematic Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.7, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // 3. Scrollable Content
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGlassIcon(Iconsax.arrow_left_2, () => Navigator.pop(context)),
                        Row(
                          children: [
                            _buildGlassIcon(Iconsax.share, () {}),
                            const SizedBox(width: 10),
                            _buildGlassIcon(Iconsax.more, () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 280),
                        _buildFloatingBadges().animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 20),
                        _buildNameSection(age).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 25),
                        _buildAboutSection().animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 35),
                        _buildDetailsSection().animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 35),
                        _buildLifestyleSection().animate().fadeIn(delay: 400.ms),
                        const SizedBox(height: 35),
                        _buildInterestsSection().animate().fadeIn(delay: 500.ms),
                        const SizedBox(height: 35),
                        if (photos.isNotEmpty) _buildGallerySection().animate().fadeIn(delay: 600.ms),
                        const SizedBox(height: 150), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Fixed Premium Action Dock
          _buildFloatingActionDock(),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildFloatingActionDock() {
    return Consumer<PermissionProvider>(
      builder: (context, permissionProv, child) {
        final canLike = permissionProv.canLike;
        final hasChatPerm = permissionProv.permissions?.unlimitedChat ?? false;
        final isPremium = permissionProv.permissions?.isPremium ?? false;

        return Positioned(
          bottom: 30, left: 20, right: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.match 
                    ? [
                        // MATCHED VIEW: Focus on Engagement
                        _buildActionButton(Iconsax.user_remove, Colors.redAccent, Colors.white10, () {
                          HapticFeedback.mediumImpact();
                          // Logic to unmatch
                        }),
                        _buildActionButton(
                          Iconsax.message_text5, 
                          hasChatPerm ? AppColors.neonGold : Colors.white24, 
                          Colors.white10, 
                          () => hasChatPerm ? null : _showPremiumUpgrade()
                        ),
                        _buildActionButton(
                          Iconsax.video5, 
                          isPremium ? Colors.white : Colors.white24, 
                          Colors.white10, 
                          () => isPremium ? null : _showPremiumUpgrade()
                        ),
                      ]
                    : [
                        // DISCOVERY VIEW: Focus on Matching
                        _buildActionButton(Iconsax.close_circle, Colors.white, Colors.white10, () => Navigator.pop(context)),
                        
                        // Locked Message Icon
                        _buildActionButton(Iconsax.message_text5, Colors.white24, Colors.white10, () => _showPremiumUpgrade()),
                        
                        // Locked Video Icon
                        _buildActionButton(Iconsax.video5, Colors.white24, Colors.white10, () => _showPremiumUpgrade()),

                        // PRIMARY LIKE BUTTON (Logic controlled by Daily Limit)
                        GestureDetector(
                          onTap: () {
                            if (canLike) {
                              HapticFeedback.heavyImpact();
                              // Perform Like Action logic here
                            } else {
                              _showPremiumUpgrade();
                            }
                          },
                          child: Container(
                            height: 60, width: 60,
                            decoration: BoxDecoration(
                              gradient: canLike 
                                ? const LinearGradient(colors: [AppColors.neonGold, Color(0xFFFFB74D)])
                                : LinearGradient(colors: [Colors.grey.shade800, Colors.grey.shade900]),
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (canLike) BoxShadow(color: AppColors.neonGold.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
                              ],
                            ),
                            child: Icon(
                              canLike ? Iconsax.heart5 : Iconsax.lock, 
                              color: canLike ? Colors.black : Colors.white54, 
                              size: 30
                            ),
                          ),
                        ),
                      ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 800.ms).slideY(begin: 1, end: 0, curve: Curves.easeOutBack);
      },
    );
  }

  Widget _buildActionButton(IconData icon, Color iconColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52, width: 52,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }

  Widget _buildNameSection(String age) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "${widget.profiledata.userName}, $age",
                style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold, height: 1.1),
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(Iconsax.verify5, color: Colors.blueAccent, size: 28),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Iconsax.location, color: AppColors.neonGold, size: 16),
            const SizedBox(width: 6),
            Text(
              widget.profiledata.city ?? "Nearby",
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingBadges() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.neonGold, width: 1)),
          child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(widget.profiledata.photo)),
        ),
        const SizedBox(width: 12),
        _buildGlassTextBadge(widget.goalName, icon: Iconsax.heart5, color: AppColors.neonGold),
      ],
    );
  }

  Widget _buildGlassTextBadge(String text, {IconData? icon, Color? color}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, color: color ?? Colors.white, size: 14), const SizedBox(width: 6)],
              Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(
          widget.profiledata.bio ?? "No bio provided yet.",
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      children: [
        if (widget.profiledata.job?.isNotEmpty ?? false)
          _buildDetailRow(Iconsax.briefcase, "Occupation", widget.profiledata.job!),
        if (widget.profiledata.height != null)
          _buildDetailRow(Iconsax.ruler, "Height", "${widget.profiledata.height} cm"),
        _buildDetailRow(Iconsax.home, "Residence", widget.profiledata.city ?? "Nearby"),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.neonGold.withOpacity(0.7), size: 18),
          const SizedBox(width: 12),
          Text("$title: ", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildLifestyleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Lifestyle", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: [
            if (widget.profiledata.smokingHabit != null)
              _buildLifestyleChip("🚬", widget.profiledata.smokingHabit!),
            if (widget.profiledata.drinkingHabit != null)
              _buildLifestyleChip("🍻", widget.profiledata.drinkingHabit!),
          ],
        ),
      ],
    );
  }

  Widget _buildLifestyleChip(String emoji, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.08))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    final interests = widget.profiledata.interests;
    if (interests.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Interests", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10, runSpacing: 10,
          children: interests.map((i) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(15)),
            child: Text("${i.emoji} ${i.name}", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildGallerySection() {
    final photos = widget.profiledata.photos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gallery", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 450,
          child: PageView.builder(
            controller: _galleryPageController,
            itemCount: photos.length,
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _openGallery(context, index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  image: DecorationImage(image: NetworkImage(photos[index]), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(photos.length, (index) => AnimatedContainer(
            duration: 300.ms,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 4, width: _currentImageIndex == index ? 24 : 8,
            decoration: BoxDecoration(color: _currentImageIndex == index ? AppColors.neonGold : Colors.white24, borderRadius: BorderRadius.circular(10)),
          )),
        ),
      ],
    );
  }

  Widget _buildGlassIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

// --- FULL SCREEN GALLERY ---

class FullScreenGallery extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;
  const FullScreenGallery({super.key, required this.photos, required this.initialIndex});

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            itemBuilder: (context, index) => InteractiveViewer(child: Center(child: Image.network(widget.photos[index], fit: BoxFit.contain))),
          ),
          Positioned(
            top: 50, left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Iconsax.close_circle5, color: Colors.white, size: 35),
            ),
          ),
        ],
      ),
    );
  }
}