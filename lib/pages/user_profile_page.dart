import 'dart:ui';
import 'package:dating/main.dart'; // Ensure AppColors are defined here
import 'package:dating/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProfileDetailsPage extends StatefulWidget {
  final Profile profiledata;

  const ProfileDetailsPage({super.key, required this.profiledata});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> with TickerProviderStateMixin {
  final ScrollController _mainScrollController = ScrollController();
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentImageIndex = 0;

  // Animation Controllers
  late AnimationController _appearanceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize Animation Controller
    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 2. Define Animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _appearanceController, curve: const Interval(0.0, 0.65, curve: Curves.easeOut)),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _appearanceController, curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuart)),
    );

    _scaleAnimation = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(parent: _appearanceController, curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)),
    );

    // 3. Start Animation
    _appearanceController.forward();
  }

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

  @override
  void dispose() {
    _mainScrollController.dispose();
    _appearanceController.dispose();
    super.dispose();
  }

  // Helper to wrap widgets in a staggered animation
  Widget _staggeredAnimation({required Widget child, required double delay}) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _appearanceController,
          curve: Interval(delay, (delay + 0.4).clamp(0.0, 1.0), curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _appearanceController,
            curve: Interval(delay, (delay + 0.4).clamp(0.0, 1.0), curve: Curves.easeOutBack),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. FIXED BACKGROUND (Animated Scale)
          Positioned.fill(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.network(
                widget.profiledata.photo,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. BLUR LAYER
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ),

          // 3. SCROLLABLE CONTENT
          CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildModernHeader(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      _staggeredAnimation(delay: 0.2, child: _buildMainBioSection()),
                      const SizedBox(height: 30),
                      _staggeredAnimation(delay: 0.3, child: _buildQuickInfoGrid()),
                      const SizedBox(height: 30),
                      _staggeredAnimation(delay: 0.4, child: _buildLifestylesSection()),
                      const SizedBox(height: 30),
                      _staggeredAnimation(delay: 0.5, child: _buildInterestsSection()),
                      const SizedBox(height: 30),
                      _staggeredAnimation(delay: 0.6, child: _buildGallerySection()),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.50,
      automaticallyImplyLeading: false,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.network(
                widget.profiledata.photo,
                fit: BoxFit.cover,
              ),
            ),
          
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0, 0.4, 0.7, 1],
                ),
              ),
            ),
           
          ],
        ),
      ),
      leadingWidth: 75,
      leading: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildCircleAction(Iconsax.arrow_left_2, () => Navigator.pop(context)),
      ),
      actions: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            children: [
              _buildCircleAction(Iconsax.share, () {}),
              const SizedBox(width: 10),
              _buildCircleAction(Iconsax.more, () {}),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBadge(),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.profiledata.userName,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
            ),
            const SizedBox(width: 10),
            Text(
              _calculateAge(widget.profiledata.dateOfBirth),
              style: TextStyle(color: AppColors.neonGold.withOpacity(0.9), fontSize: 28, fontWeight: FontWeight.w300),
            ),
            const SizedBox(width: 10),
            const Icon(Iconsax.verify5, color: AppColors.neonGold, size: 26),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          widget.profiledata.bio ?? "No bio provided yet.",
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, height: 1.6, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildQuickInfoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("PERSONAL STATS", 
          style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _infoTile(Iconsax.briefcase, widget.profiledata.job ?? "Professional", "Job")),
                  Container(height: 40, width: 1, color: Colors.white10),
                  Expanded(child: _infoTile(Iconsax.teacher, widget.profiledata.education.name, "Education")),
                ],
              ),
              const Divider(color: Colors.white10, height: 40),
              Row(
                children: [
                  Expanded(child: _infoTile(Iconsax.ruler, "${widget.profiledata.height ?? '175'} cm", "Height")),
                  Container(height: 40, width: 1, color: Colors.white10),
                  Expanded(child: _infoTile(Iconsax.location, widget.profiledata.city ?? "Unknown", "City")),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.neonGold.withOpacity(0.9), size: 22),
        const SizedBox(height: 8),
        Text(title, 
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildLifestylesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("LIFESTYLE HABITS", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _lifestyleChip("🚬", "Smoking", widget.profiledata.smokingHabit ?? "Non-smoker"),
            _lifestyleChip("🍻", "Drinking", widget.profiledata.drinkingHabit ?? "Social Drinker"),
          ],
        ),
      ],
    );
  }

  Widget _lifestyleChip(String emoji, String category, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.w700)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("INTERESTS & VIBES", 
          style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
        const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: widget.profiledata.interests.map((interest) => Container(
            padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(interest.emoji, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 10),
                Text(
                  interest.name, 
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildGallerySection() {
    if (widget.profiledata.photos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "GALLERY",
                style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_currentImageIndex + 1}/${widget.profiledata.photos.length}",
                  style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        CarouselSlider.builder(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 380,
            viewportFraction: 0.82,
            enlargeCenterPage: true,
            enlargeFactor: 0.22,
            onPageChanged: (index, reason) {
              setState(() => _currentImageIndex = index);
            },
            scrollPhysics: const BouncingScrollPhysics(),
          ),
          itemCount: widget.profiledata.photos.length,
          itemBuilder: (context, index, realIndex) => _buildGalleryCard(index),
        ),
        const SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.profiledata.photos.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentImageIndex == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentImageIndex == index ? AppColors.neonGold : Colors.white.withOpacity(0.2),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryCard(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.profiledata.photos[index], fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
          SizedBox(width: 6),
          Text("ACTIVE NOW", style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}