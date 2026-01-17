import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

// Your existing imports
import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/services/auth_service.dart';
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
  late ScrollController _scrollController;
  TabController? _tabController; 
  int _navIndex = 0;
  bool _isNavVisible = true;
  
  // Adjusted height for the category tag (Slim & Standard)
  final double _categoryHeaderHeight = 35.0; 

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isNavVisible) setState(() => _isNavVisible = false);
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isNavVisible) setState(() => _isNavVisible = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  void _setupTabController(int length) {
    if (_tabController == null || _tabController!.length != length) {
      _tabController?.dispose();
      _tabController = TabController(length: length, vsync: this);
      _tabController!.addListener(() => setState(() {}));
    }
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

    if (hasData) {
      _setupTabController(homeProvider.categories.length);
    }

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      extendBody: true,
      body: Container(    decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.neonGold.withOpacity(0.1),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            
            SafeArea(
              bottom: false,
              child: homeProvider.isLoading 
                  ? _buildEliteShimmer() 
                  : NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(child: _buildBrandedHeader()),
                          SliverToBoxAdapter(child: _buildSearchBar()),
                          SliverToBoxAdapter(child: _buildBannerSlider()),
                          
                          if (hasData && _tabController != null)
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _StickyCategoryDelegate(
                                height: _categoryHeaderHeight,
                                child: _buildSlimCategoryHeader(homeProvider),
                              ),
                            ),
                        ];
                      },
                      body: (hasData && _tabController != null)
                          ? TabBarView(
                              controller: _tabController,
                              physics: const BouncingScrollPhysics(),
                              children: homeProvider.categories.asMap().entries.map((entry) {
                                return _buildCategoryContent(entry.key, entry.value.profiles);
                              }).toList(),
                            )
                          : _buildEnhancedEmptyState(homeProvider),
                    ),
            ),
        
            _buildAnimatedBottomNav(),
          ],
        ),
      ),
    );
  }

  // ===================== UPDATED UI COMPONENTS =====================

  // Widget _buildEliteTopGlow() {
  //   return Positioned(
  //     top: 0, left: 0, right: 0,
  //     child: Container(
  //       height: 330,
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           // center: const Alignment(0, -0.10),
  //           // radius: 1.2,
  //           colors: [
  //             AppColors.neonGold.withOpacity(0.15),
  //             AppColors.neonGold.withOpacity(0.05),
  //             Colors.transparent,
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBrandedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, AppColors.neonGold, Color(0xFFFFD700)],
                ).createShader(bounds),
                child: const Text("WEEKEND", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 3)),
              ),
              Text("ELITE DATING EXPERIENCE", 
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ],
          ),
          _buildBoostButton(),
        ],
      ),
    );
  }

  Widget _buildBoostButton() {
    return GestureDetector(
      onLongPress: () async => await AuthService().logout(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.neonGold, Color(0xFFFFB300), AppColors.richOrange],
            begin: Alignment.topLeft, end: Alignment.bottomRight
          ),
          borderRadius: BorderRadius.circular(30),
          // boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: const Row(
          children: [
            Icon(Iconsax.flash_15, color: Colors.black, size: 14),
            SizedBox(width: 6),
            Text("BOOST", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.search_normal_1, color: AppColors.neonGold, size: 20),
            const SizedBox(width: 15),
            Text("Search your vibe...", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            const Spacer(),
            Icon(Iconsax.setting_4, color: Colors.grey.shade600, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Container(
      height: 130,
      margin: const EdgeInsets.only(bottom: 5,top: 5),
      child: PageView(
        controller: PageController(viewportFraction: .89),
        children: [          _buildPremiumCard("Safety First", "Verify your elite status", AppColors.valentineRed, Iconsax.shield_tick),

          _buildPremiumCard("Weekend Gold", "Unlimited likes & spotlight", AppColors.neonGold, Iconsax.crown_15),
          _buildPremiumCard("Safety First", "Verify your elite status", AppColors.valentineRed, Iconsax.shield_tick),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(String title, String sub, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.5), color.withOpacity(0.08)],
          begin: Alignment.topLeft, end: Alignment.bottomRight
        ),
        // border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          Positioned(right: -10, bottom: -10, child: Icon(icon, size: 110, color: Colors.white.withOpacity(0.03))),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                  child: Text("GET STARTED", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 9)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlimCategoryHeader(HomeProvider provider) {
    final int idx = _tabController?.index ?? 0;
    final category = provider.categories[idx < provider.categories.length ? idx : 0];

    return Container(
      // height: _categoryHeaderHeight,
      color: AppColors.deepBlack.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 40),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "${category.goalTitle.toUpperCase()}",
              style:  TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: 1),
            ),
          ),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildAnimatedBottomNav() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      offset: _isNavVisible ? Offset.zero : const Offset(0, 2),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: _buildFloatingNavBar(),
        ),
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withOpacity(0.95),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30) ,topRight:  Radius.circular(30)),
        // border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 25, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Iconsax.home_1, 0),
          _navItem(Iconsax.discover, 1),
                    _navItem(Iconsax.heart, 2),

          // _buildMainHeartItem(2),
          _navItem(Iconsax.message_notif, 3),
          _navItem(Iconsax.user, 4),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    bool isSelected = _navIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _navIndex = index),
      child: Icon(icon, color: isSelected ? AppColors.neonGold : Colors.white24, size: 24),
    );
  }

  Widget _buildMainHeartItem(int index) {
    return GestureDetector(
      onTap: () => setState(() => _navIndex = index),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [AppColors.valentineRed, Color(0xFFFF4D4D)]),
          boxShadow: [BoxShadow(color: AppColors.valentineRed, blurRadius: 12, spreadRadius: -2)],
        ),
        child: const Icon(Iconsax.heart5, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildEnhancedEmptyState(HomeProvider provider) {
    return const Center(child: CircularProgressIndicator(color: AppColors.neonGold));
  }

  Widget _buildEliteShimmer() {
    return const Center(child: CircularProgressIndicator(color: AppColors.neonGold));
  }
}

// ===================== DELEGATE FIX =====================

class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  _StickyCategoryDelegate({required this.child, required this.height});

  @override double get minExtent => height;
  @override double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override bool shouldRebuild(_StickyCategoryDelegate oldDelegate) => true;
}