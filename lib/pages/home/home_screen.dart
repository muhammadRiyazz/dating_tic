import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/providers/matches_provider.dart'; 
import 'package:dating/providers/likers_provider.dart'; 
import 'package:dating/pages/maches/match_page.dart';
import 'package:dating/pages/profile/profile_page.dart';

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
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

  Widget _buildHomeContent() {

    log('_buildHomeContent -----');
    final homeProvider = context.watch<HomeProvider>();
    final bool hasData = homeProvider.categories.isNotEmpty;
    log(hasData.toString());

    if (hasData) {
      _setupTabController(homeProvider.categories.length);
    }

    if (homeProvider.isLoading) return _buildEliteShimmer();

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 10)),
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
                switch (entry.key) {
                  case 0: return CategoriesPage1(profiles: entry.value.profiles,goal:  entry.value.goalTitle,);
                  case 1: return CategoriesPage2(profiles: entry.value.profiles,goal: entry.value.goalTitle,);
                  case 2: return CategoriesPage3(profiles: entry.value.profiles,goal:  entry.value.goalTitle);
                  case 3: return CategoriesPage4(profiles: entry.value.profiles);
                  case 4: return CategoriesPage5(profiles: entry.value.profiles);
                  default: return CategoriesPage1(profiles: entry.value.profiles,goal: entry.value.goalTitle,);
                }
              }).toList(),
            )
          : _buildEnhancedEmptyState(homeProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _navIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _navIndex != 0) {
          setState(() => _navIndex = 0);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        extendBody: true,
        body: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFFF4D67).withOpacity(0.25), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            IndexedStack(
              index: _navIndex,
              children: [
                _buildHomeContent(),
                const MatchesPage(),
                Container(color: Colors.black, child: const Center(child: Text("Chat", style: TextStyle(color: Colors.white)))),
                Container(color: Colors.black, child: const Center(child: Text("Call", style: TextStyle(color: Colors.white)))),
                const ProfilePage(),
              ],
            ),

            _buildAnimatedBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBottomNav() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
      bottom: _isNavVisible ? 20 : -100,
      left: 20,
      right: 20,
      child: _buildFloatingNavBar(),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFF161616).withOpacity(0.85),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
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
      onTap: () async {
        setState(() => _navIndex = index);
        
        // Refresh when tapping Match Tab
        if (index == 1) {
          final userId = await AuthService().getUserId();
          if (mounted) {
            context.read<MatchesProvider>().fetchMatches(userId.toString());
            context.read<LikersProvider>().fetchLikers(userId.toString());
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFFD700) : Colors.white54,
              size: isSelected ? 24 : 22,
            ),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                height: 4, width: 4,
                decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
              )
            else
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 8)),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildBrandedHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Weekend", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
              Text("ELITE DATING EXPERIENCE", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ],
          ),
          const Spacer(),
          _buildBoostButton(),
          const SizedBox(width: 8),
          _iconCircle(Iconsax.notification),
        ],
      ),
    );
  }

  Widget _iconCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildBoostButton() {
    return GestureDetector(
      onLongPress: () async => await AuthService().logout(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFB300), Color(0xFFFF8C00)],
              begin: Alignment.topLeft, end: Alignment.bottomRight
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.3), blurRadius: 10)]
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
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.search_normal_1, color: Color(0xFFFFD700), size: 20),
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
      color: Colors.transparent,
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(category.goalTitle.toUpperCase(), style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: 2)),
          ),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildEliteShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(height: 30, width: 150, color: Colors.white),
              Container(height: 40, width: 40, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            ]),
            const SizedBox(height: 30),
            Container(height: 55, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25))),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedEmptyState(HomeProvider provider) {
    return const Center(child: Text("Finding your matches...", style: TextStyle(color: Colors.white24)));
  }
}

class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  _StickyCategoryDelegate({required this.child, required this.height});
  @override double get minExtent => height;
  @override double get maxExtent => height;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);
  @override bool shouldRebuild(_StickyCategoryDelegate oldDelegate) => true;
}