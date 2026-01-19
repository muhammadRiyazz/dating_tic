import 'dart:math' as math;
import 'dart:ui';
import 'package:dating/pages/maches/match_page.dart';
import 'package:dating/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Add this

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

  Widget _getCurrentPage() {
    switch (_navIndex) {
      case 0: // Home Page
        final homeProvider = context.watch<HomeProvider>();
        final bool hasData = homeProvider.categories.isNotEmpty;

        if (hasData) {
          _setupTabController(homeProvider.categories.length);
        }

        // Return Shimmer if loading
        if (homeProvider.isLoading) return _buildEliteShimmer();

        return NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: _buildBrandedHeader()),
              SliverToBoxAdapter(child: _buildSearchBar()),
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
        );
      
      case 1: return MatchesPage();
      case 2: return Container();
      case 3: return Container();
      case 4: return ProfilePage();
      default: return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep black background
      extendBody: true,

      body: Container(
        child: Stack(
          children: [
            Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Container(
        decoration: BoxDecoration(
       gradient: LinearGradient(
            colors: [
              const Color(0xFFFF4D67).withOpacity(0.25), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ),
            SafeArea(bottom: false, child: _getCurrentPage()),
            _buildAnimatedBottomNav(),
          ],
        ),
      ),
    );
  }

  // ===================== GLASSY SHIMMER LOADING =====================

  Widget _buildEliteShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.15),
      period: const Duration(milliseconds: 1500),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header Shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 25, width: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 8),
                      Container(height: 10, width: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                    ],
                  ),
                  Container(height: 35, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
                ],
              ),
              const SizedBox(height: 30),
              // Search Bar Shimmer
              Container(height: 55, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
              const SizedBox(height: 25),
              // Banner Shimmer
              Container(height: 130, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28))),
              const SizedBox(height: 30),
              // Category Tab Shimmer
              Center(child: Container(height: 2, width: 200, color: Colors.white)),
              const SizedBox(height: 20),
              // Grid Shimmer (Profile Cards)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: 4,
                itemBuilder: (_, __) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== NAVIGATION & UI COMPONENTS =====================

  Widget _buildAnimatedBottomNav() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      offset: _isNavVisible ? Offset.zero : const Offset(0, 2),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _buildFloatingNavBar(),
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withOpacity(0.9),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 25, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Iconsax.home_1, 0, "Home"),
                            _navItem(Iconsax.lovely, 1, "Match"),
              _navItem(Iconsax.message_notif, 2, "Chat"),

              _navItem(Iconsax.call, 3, "Call"),
              _navItem(Iconsax.user, 4, "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, String label) {
    bool isSelected = _navIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _navIndex = index),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.neonGold : Colors.white54, size: isSelected ? 26 : 22),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: isSelected ? AppColors.neonGold : Colors.white54, fontSize: 8, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 15, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Text(
                  "Weekend",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
                ),
                SizedBox(height: 4,),
              //  Text("WEEKEND", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 3)),
              // ShaderMask(
              //   // shaderCallback: (bounds) => const LinearGradient(
              //   //   colors: [Colors.white, AppColors.neonGold, Color(0xFFFFD700)],
              //   // ).createShader(bounds),
              //   child: const Text("WEEKEND", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 3)),
              // ),
              Text("ELITE DATING EXPERIENCE", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ],
          ),
          Spacer(),
          _buildBoostButton(),
          SizedBox(width: 6,),
          Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(Iconsax.notification, color: Colors.white, size: 16),
    ),
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
          // color: const Color(0xFF1E1E1E),
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

  Widget _buildSlimCategoryHeader(HomeProvider provider) {
    final int idx = _tabController?.index ?? 0;
    final category = provider.categories[idx < provider.categories.length ? idx : 0];

    return Container(
      // color: AppColors.deepBlack.withOpacity(0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 40),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              category.goalTitle.toUpperCase(),
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: 1),
            ),
          ),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildEnhancedEmptyState(HomeProvider provider) {
    return Center(
      child: Text("No profiles found", style: TextStyle(color: Colors.white.withOpacity(0.5))),
    );
  }
}

// ===================== STICKY DELEGATE =====================

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