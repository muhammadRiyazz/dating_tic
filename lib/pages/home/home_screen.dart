import 'dart:developer';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating/pages/chat/chating_list.dart';
import 'package:dating/pages/home/categories/categories_page_6.dart';
import 'package:dating/pages/home/for_you%20list.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/services/suppoting_data_service.dart/active_status.dart';
import 'package:dating/services/suppoting_data_service.dart/age_calculater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// Assuming these are your local imports
import 'package:dating/pages/home/search%20page/search_page.dart';
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
    // Show nav if we are near the top, otherwise hide/show based on direction
    if (_scrollController.offset <= 50) {
      if (!_isNavVisible) setState(() => _isNavVisible = true);
      return;
    }

    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isNavVisible) setState(() => _isNavVisible = false); // Scrolling Down
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isNavVisible) setState(() => _isNavVisible = true); // Scrolling Up
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

  // --- CORE CONTENT WRAPPER ---
  Widget _buildHomeContent() {
    final homeProvider = context.watch<HomeProvider>();
    
    if (!homeProvider.isLoading && homeProvider.categories.isNotEmpty) {
      _setupTabController(homeProvider.categories.length);
    }

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 10)),
          SliverToBoxAdapter(child: _buildBrandedHeader()),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: buildForYouCarousel(homeProvider.forYouProfiles)),


          
          if (!homeProvider.isLoading && homeProvider.categories.isNotEmpty && _tabController != null)
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyCategoryDelegate(
                height: _categoryHeaderHeight,
                child: _buildSlimCategoryHeader(homeProvider),
              ),
            ),

        ];
      },
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildBodyContent(homeProvider),
      ),
    );
  }

// Helper for Side Actions (Refined for alignment)

  Widget _buildBodyContent(HomeProvider homeProvider) {
    if (homeProvider.isLoading) return _buildEliteShimmerBody();
    if (homeProvider.categories.isEmpty) return _buildEnhancedEmptyState();

    return TabBarView(
      key: const ValueKey('tab_view'),
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      children: homeProvider.categories.asMap().entries.map((entry) {
        switch (entry.key) {
          case 0: return CategoriesPage1(profiles: entry.value.profiles, goal: entry.value.goalTitle);
          case 1: return CategoriesPage2(profiles: entry.value.profiles, goal: entry.value.goalTitle);
          case 2: return CategoriesPage3(profiles: entry.value.profiles, goal: entry.value.goalTitle);
          case 3: return CategoriesPage4(profiles: entry.value.profiles,goal: entry.value.goalTitle);
          case 4: return CategoriesPage6(profiles: entry.value.profiles,goal:entry.value.goalTitle ,);
          default: return CategoriesPage1(profiles: entry.value.profiles, goal: entry.value.goalTitle);
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _navIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _navIndex != 0) setState(() => _navIndex = 0);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        extendBody: true,
        body: Stack(
          children: [
            // Top Glow Background
            Positioned(
              top: 0, left: 0, right: 0,
              height: MediaQuery.of(context).size.height * 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF4D67).withOpacity(0.18),
                      const Color(0xFFFF4D67).withOpacity(0.04),
                      Colors.transparent,
                      const Color(0xFFFF4D67).withOpacity(0.08),
                    ],
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

      // inside your _WeekendHomeState -> build method -> IndexedStack

IndexedStack(
  index: _navIndex,
  children: [
    _buildHomeContent(),
    const MatchesPage(),
    ChatListPage(),
    // Updated Chat Page
    // const EliteWorkInProgress(
    //   icon: Iconsax.message_notif5,
    //   title: "Elite Conversations",
    //   description: "We are perfecting the art of private communication. Your secure vibe room is launching very soon.",
    // ),
    
    // Updated Call Page
    const EliteWorkInProgress(
      icon: Iconsax.call_calling5,
      title: "Direct Connection",
      description: "High-definition voice and video connections for our premium members are currently in final testing.",
    ),
    
    const ProfilePage(),
  ],
),
            _buildAnimatedBottomNav(),
          ],
        ),
      ),
    );
  }

  // --- REFINED UI WIDGETS ---

  Widget _buildBrandedHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          InkWell
          (
            onTap: ()async {
          final userId = await AuthService().getUserId();


                    Provider.of<HomeProvider>(context, listen: false).fetchHomeData(userId??'');

            },
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weekend", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
                Text("ELITE DATING EXPERIENCE", style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            ),
          ),
          const Spacer(),
          _buildBoostButton(),
          // const SizedBox(width: 8),
          // _iconCircle(Iconsax.notification),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DiscoverySearchPage())),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(25),
            // border: Border.all(color: Colors.white.withOpacity(0.05)),
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
      ),
    );
  }

  Widget _buildSlimCategoryHeader(HomeProvider provider) {
    if (_tabController == null) return const SizedBox.shrink();
    final int idx = _tabController!.index;
    final category = provider.categories[idx < provider.categories.length ? idx : 0];

    return Container(
      // color: const Color(0xFF0A0A0A), // Solid background for sticky header
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

  // --- UPDATED NAVIGATION BAR ---

  Widget _buildAnimatedBottomNav() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      bottom: _isNavVisible ? 25 : -100, // Moves out of view
      left: 20, right: 20,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isNavVisible ? 1.0 : 0.0,
        child: _buildFloatingNavBar(),
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 75,
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161616).withOpacity(0.5),
        borderRadius: BorderRadius.circular(40),
        // border: Border.all(color: Colors.white.withOpacity(0.1)),
        // boxShadow: [
        //   BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 25, offset: const Offset(0, 10))
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
        HapticFeedback.lightImpact(); // Elite feel haptics
        setState(() => _navIndex = index);
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // THE YELLOW CIRCLE DESIGN
          color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2
            )
          ] : [],
        ),
        child: Icon(
          icon, 
          color: isSelected ? Colors.black : Colors.white54, 
          size: isSelected ? 24 : 22
        ),
      ),
    );
  }

  // --- HELPERS ---

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
          gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFB300)]),
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

  Widget _buildEliteShimmerBody() {
    return Shimmer.fromColors(
      key: const ValueKey('shimmer_body'),
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(height: 420, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30))),
          ],
        ),
      ),
    );
  }
Widget buildSideAction(IconData icon, String label, VoidCallback onTap, {bool isSmall = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(isSmall ? 10 : 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12),
              ),
              child: Icon(icon, color: Colors.white, size: isSmall ? 18 : 22),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
  Widget _buildEnhancedEmptyState() {
    return Center(
      child: Text("No Vibe Found", style: TextStyle(color: Colors.white38)),
    );
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










class EliteWorkInProgress extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const EliteWorkInProgress({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing Icon Header
          Stack(
            alignment: Alignment.center,
            children: [
              // Subtle background glow
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // The Icon
              Icon(icon, size: 80, color: const Color(0xFFFFD700)),
            ],
          ),
          const SizedBox(height: 30),
          
          // Title
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 15),
          
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // "Stay Tuned" Glass Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.timer_1, color: Color(0xFFFFD700), size: 16),
                SizedBox(width: 10),
                Text(
                  "COMING SOON",
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}