import 'dart:math' as math;
import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/registration%20pages/splash_screen.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/registration_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

// Import your providers
import 'package:dating/providers/profile_provider.dart';

// Your category page imports
import 'package:dating/pages/home/categories/categories_page_1.dart';
import 'package:dating/pages/home/categories/categories_page_2.dart';
import 'package:dating/pages/home/categories/categories_page_3.dart';
import 'package:dating/pages/home/categories/categories_page_4.dart';
import 'package:dating/pages/home/categories/categories_page_5.dart';

class WeekendHome extends StatefulWidget {
  const WeekendHome({super.key});

  @override
  State<WeekendHome> createState() => _WeekendHomeState();
}

class _WeekendHomeState extends State<WeekendHome> with TickerProviderStateMixin {
  late AnimationController _bgAnimationController;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    super.dispose();
  }

  Widget _buildCategoryContent(int index, List<Profile> profiles) {
    switch (index) {
      case 0: return CategoriesPage1(profiles: profiles);
      case 1: return CategoriesPage2(profiles: profiles);
      case 2: return CategoriesPage3(profiles: profiles);
      case 3: return CategoriesPage4(profiles: profiles);
      case 4: return CategoriesPage5(profiles: profiles);
      default: return CategoriesPage1(profiles: profiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final bool hasData = homeProvider.categories.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Stack(
        children: [
          _buildTopGlow(),
          _buildAnimatedBackground(),
          
          SafeArea(
            child: homeProvider.isLoading 
                ? _buildEliteShimmer() 
                : DefaultTabController(
                    // Ensure length is at least 1 to avoid TabController error
                    length: hasData ? homeProvider.categories.length : 1,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(child: _buildBrandedHeader()),
                          SliverToBoxAdapter(child: _buildSearchBar()),
                          // SliverToBoxAdapter(child: _buildBannerSlider()),
                          
                          // Only show TabBar if there is data
                          if (hasData)
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _StickyTabBarDelegate(
                                child: _buildCustomTabBar(homeProvider),
                              ),
                            ),
                        ];
                      },
                      body: hasData 
                          ? TabBarView(
                              physics: const BouncingScrollPhysics(),
                              children: homeProvider.categories.asMap().entries.map((entry) {
                                return _buildCategoryContent(entry.key, entry.value.profiles);
                              }).toList(),
                            )
                          : _buildEnhancedEmptyState(homeProvider),
                    ),
                  ),
          ),

          // Bottom Navigation
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNavBar()),
        ],
      ),
    );
  }

  // ===================== UI COMPONENTS =====================

  Widget _buildTopGlow() {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.neonGold.withOpacity(0.12),
              AppColors.deepBlack.withOpacity(0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedEmptyState(HomeProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          children: [
            // Glassmorphism Card
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  // Animated Outer Glow for Icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neonGold.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonGold.withOpacity(0.1),
                              blurRadius: 40,
                              spreadRadius: 10,
                            )
                          ],
                        ),
                      ),
                      const Icon(Iconsax.radar5, size: 60, color: AppColors.neonGold),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Expanding the Circle",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "We're currently scouting for more elite profiles that match your vibe. Try adjusting your filters or check back shortly.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Premium Outline Button
                  GestureDetector(
                    onTap: ()async => await fetchprofiles(context), // Trigger refresh
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.neonGold.withOpacity(0.5)),
                        color: AppColors.neonGold.withOpacity(0.05),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.refresh, size: 18, color: AppColors.neonGold),
                          SizedBox(width: 8),
                          Text(
                            "REFRESH DISCOVERY",
                            style: TextStyle(
                              color: AppColors.neonGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Subtext message
            Text(
              "THE SPOTLIGHT IS WAITING FOR YOU",
              style: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTabBar(HomeProvider provider) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: AppColors.deepBlack.withOpacity(0.7),
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorColor: AppColors.neonGold,
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                labelColor: AppColors.neonGold,
                unselectedLabelColor: Colors.grey.shade600,
                tabAlignment: TabAlignment.start,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                tabs: provider.categories.map((cat) => Tab(
                  child: Row(
                    children: [
                      Text(cat.goalEmoji),
                      const SizedBox(width: 8),
                      Text(cat.goalTitle.toUpperCase()),
                    ],
                  ),
                )).toList(),
              ),
              // Container(height: 1, color: Colors.white.withOpacity(0.05)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, AppColors.neonGold],
                ).createShader(bounds),
                child: const Text("WEEKEND", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2)),
              ),
              const Text("ELITE DATING EXPERIENCE", 
                style: TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold)),
            ],
          ),
          _buildBoostButton(),
        ],
      ),
    );
  }

  Widget _buildBoostButton() {
    return GestureDetector(
      onDoubleTap: ()async {
       await AuthService(). logout();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.neonGold, AppColors.richOrange]),
          borderRadius: BorderRadius.circular(25),
          // boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.2), blurRadius: 10)],
        ),
        child: const Row(
          children: [
            Icon(Iconsax.flash_15, color: Colors.black, size: 14),
            SizedBox(width: 4),
            Text("BOOST", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.search_normal_1, color: AppColors.neonGold, size: 18),
            const SizedBox(width: 12),
            Text("Search your vibe...", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            const Spacer(),
            Icon(Iconsax.setting_4, color: Colors.grey.shade600, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: PageView(
        controller: PageController(viewportFraction: 0.88),
        children: [
          _buildPremiumCard("Weekend Gold", "Unlimited likes & more", AppColors.neonGold, Iconsax.crown_15),
          _buildPremiumCard("Safety First", "Verify your profile now", AppColors.valentineRed, Iconsax.shield_tick),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(String title, String sub, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color.withOpacity(0.1)],
          begin: Alignment.topLeft, end: Alignment.bottomRight
        ),
        // border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          Positioned(right: -20, bottom: -20, child: Icon(icon, size: 120, color: Colors.white.withOpacity(0.03))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Text("GET STARTED", style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 10)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _bgAnimationController,
      builder: (context, child) {
        return Stack(
          children: [
            _buildFloatingBubble(80, 200, 150, AppColors.valentineRed.withOpacity(0.05), 0),
            _buildFloatingBubble(200, 450, 220, AppColors.neonGold.withOpacity(0.05), 3),
            _buildFloatingEmoji("✨", 0.5, 300, 100),
            _buildFloatingEmoji("❤️", 0.8, 50, 400),
          ],
        );
      },
    );
  }

  Widget _buildFloatingBubble(double x, double y, double size, Color color, double offset) {
    double move = math.sin((_bgAnimationController.value * 2 * math.pi) + offset) * 40;
    return Positioned(
      left: x + move, top: y + move,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), child: Container()),
      ),
    );
  }

  Widget _buildFloatingEmoji(String emoji, double tOffset, double x, double y) {
    double move = math.cos((_bgAnimationController.value * 2 * math.pi) + tOffset) * 25;
    return Positioned(
      left: x + move, top: y - move, 
      child: Opacity(opacity: 0.15, child: Text(emoji, style: const TextStyle(fontSize: 30)))
    );
  }

  Widget _buildEliteShimmer() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _shimmerBox(width: 150, height: 25),
          const SizedBox(height: 20),
          _shimmerBox(width: double.infinity, height: 50, radius: 15),
          const SizedBox(height: 20),
          _shimmerBox(width: double.infinity, height: 140, radius: 24),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.7
              ),
              itemCount: 4,
              itemBuilder: (_, __) => _shimmerBox(width: 0, height: 0, radius: 20),
            ),
          )
        ],
      ),
    );
  }

  Widget _shimmerBox({double? width, double? height, double radius = 8, EdgeInsets? margin}) {
    return Container(
      width: width, height: height, margin: margin,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 75,
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Iconsax.home_15, 0),
              _navItem(Iconsax.discover, 1),
              _navItem(Iconsax.heart5, 2, isMain: true),
              _navItem(Iconsax.message_notif, 3),
              _navItem(Iconsax.user, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, {bool isMain = false}) {
    bool isSelected = _navIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _navIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neonGold.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, 
          color: isSelected ? AppColors.neonGold : (isMain ? AppColors.valentineRed : Colors.white38), 
          size: isMain ? 28 : 24),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyTabBarDelegate({required this.child});
  @override double get minExtent => 48;
  @override double get maxExtent => 48;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;
  @override bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}