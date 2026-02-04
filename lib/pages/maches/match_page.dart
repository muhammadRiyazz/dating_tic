import 'dart:math';
import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/maches/Likers_List_Page.dart';
import 'package:dating/pages/maches/widgets/matches_shimmer.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/likers_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> with SingleTickerProviderStateMixin {
  late AnimationController _refreshController;
  double _refreshOffset = 0.0;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    if (_isRefreshing) return;
    
    _isRefreshing = true;
    _refreshController.forward();
    
    final userId = await AuthService().getUserId();
    if (mounted) {
      await Future.wait([
        context.read<MatchesProvider>().fetchMatches(userId.toString()),
        context.read<LikersProvider>().fetchLikers(userId.toString()),
      ]);
    }
    
    if (mounted) {
      _refreshController.reverse();
      _isRefreshing = false;
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels < -100 && !_isRefreshing) {
              _loadData();
              return true;
            }
            setState(() {
              _refreshOffset = min(max(-notification.metrics.pixels, 0), 150); // FIXED: Ensures non-negative
            });
          }
          return false;
        },
        child: Stack(
          children: [
            _buildTopGradient(),
            SafeArea(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // Custom Refresh Indicator
                  SliverToBoxAdapter(
                    child: _buildCustomRefreshIndicator(),
                  ),
                  _buildHeader(),
                  Consumer<LikersProvider>(
                    builder: (context, provider, _) => _buildPremiumLikedSection(provider.likers),
                  ),
                  _buildSectionDivider('MATCHES'),
                  Consumer<MatchesProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const MatchesShimmer();
                      }
                      if (provider.matches.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final profile = provider.matches[index];
                              return _buildHighStandardGridCard(profile)
                                  .animate()
                                  .fadeIn(delay: (index * 50).ms)
                                  .scale(begin: const Offset(0.9, 0.9), curve: Curves.decelerate);
                            },
                            childCount: provider.matches.length,
                          ),
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CUSTOM REFRESH INDICATOR ---
  Widget _buildCustomRefreshIndicator() {
    // Ensure height is non-negative
    final indicatorHeight = max(_refreshOffset, 0.0);
    final progress = indicatorHeight > 0 ? min(indicatorHeight / 150, 1.0) : 0.0;
    
    return Container(
      height: indicatorHeight, // FIXED: Always non-negative
      // width: double.infinity,
      // decoration: BoxDecoration(
      //   // gradient: LinearGradient(
      //   //   colors: [AppColors.neonPink, Colors.black],
      //   //   begin: Alignment.centerLeft,
      //   //   end: Alignment.centerRight,
      //   // ),
      // ),
      // child: indicatorHeight > 50 
      //     ? LinearProgressIndicator(
      //         backgroundColor: Colors.transparent,
      //         color:AppColors.neonPink .withOpacity(0.8),
      //       )
      //     : null,
    );
  }

  // --- REDESIGNED PREMIUM CARD UI ---
  Widget _buildHighStandardGridCard(Profile profile) {
    return
    
    
     InkWell( 
onTap: () {
  
  HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProfileDetailsPage(profiledata: profile,goalName:profile.relationshipGoal!.name,match: true,);
          },));

},     
       child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: profile.photo,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.white.withOpacity(0.05),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFF161616),
                    child: const Icon(Iconsax.user, color: Colors.white10, size: 40),
                  ),
                ),
              ),
       
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
       
              Positioned(
                top: 12,
                right: 12,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Iconsax.heart5, color: Color(0xFFFFD700), size: 14),
                    ),
                  ),
                ),
              ),
       
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.job ?? "Active nearby",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Flexible(
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: BackdropFilter(
                          //       filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          //       child: Container(
                          //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          //         decoration: BoxDecoration(
                          //           color: Colors.white.withOpacity(0.1),
                          //           borderRadius: BorderRadius.circular(10),
                          //           border: Border.all(color: Colors.white10),
                          //         ),
                          //         child: Text(
                          //           "${profile.relationshipGoal?.emoji ?? "✨"} Match",
                          //           style: const TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 9,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Iconsax.call, color: Colors.white, size: 16),
                          ),
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFA500).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Iconsax.message_text5, color: Colors.black, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
           ),
     );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFF4D67).withOpacity(0.2), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: 
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Matches",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  "People who sparked with you",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            _glassButton(Iconsax.lovely),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumLikedSection(List<Profile> likers) {
    if (likers.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LikersListPage()),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 75,
                height: 40,
                child: Stack(
                  children: List.generate(likers.length > 3 ? 3 : likers.length, (index) {
                    return Positioned(
                      left: index * 18.0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: .5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: CachedNetworkImage(
                              imageUrl: likers[index].photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${likers.length} People liked you",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Tap to see who swiped right",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LikersListPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String label) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            const SizedBox(width: 24),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

Widget _buildEmptyState() {
  return  Container(
// color: Colors.amber,

child: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    
    children: [  const Text(
            "Your spark is waiting",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
  
          const SizedBox(height: 12),
  
          // 3. Descriptive Subtext
          Text(
            "Don't let the silence fool you. Someone special is just a swipe away. Keep exploring profiles or refresh to see new connections.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
  
          const SizedBox(height: 40),
  
  ]),
)

  );
}

  Widget _glassButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}

// import 'dart:math';
// import 'dart:ui';
// import 'package:dating/main.dart';
// import 'package:dating/models/profile_model.dart';
// import 'package:dating/pages/maches/Likers_List_Page.dart';
// import 'package:dating/pages/maches/widgets/matches_shimmer.dart';
// import 'package:dating/pages/plans/plan_upgrade_sheet.dart'; // Ensure this is imported
// import 'package:dating/pages/user_profile_page.dart';
// import 'package:dating/providers/matches_provider.dart';
// import 'package:dating/providers/likers_provider.dart';
// import 'package:dating/providers/permission_provider.dart'; // Permission Provider
// import 'package:dating/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class MatchesPage extends StatefulWidget {
//   const MatchesPage({super.key});

//   @override
//   State<MatchesPage> createState() => _MatchesPageState();
// }

// class _MatchesPageState extends State<MatchesPage> with SingleTickerProviderStateMixin {
//   late AnimationController _refreshController;
//   double _refreshOffset = 0.0;
//   bool _isRefreshing = false;

//   @override
//   void initState() {
//     super.initState();
//     _refreshController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
//   }

//   Future<void> _loadData() async {
//     if (_isRefreshing) return;
    
//     _isRefreshing = true;
//     _refreshController.forward();
    
//     final userId = await AuthService().getUserId();
//     if (userId == null) return;

//     if (mounted) {
//       await Future.wait([
//         context.read<MatchesProvider>().fetchMatches(userId.toString()),
//         context.read<LikersProvider>().fetchLikers(userId.toString()),
//         context.read<PermissionProvider>().loadPermissions(userId.toString(), forceRefresh: true),
//       ]);
//     }
    
//     if (mounted) {
//       _refreshController.reverse();
//       _isRefreshing = false;
//     }
//   }

//   // Logic to handle navigation or upgrade
//   void _handleLikersAccess(bool hasPermission) {
//     HapticFeedback.lightImpact();
//     if (hasPermission) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const LikersListPage()),
//       );
//     } else {
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (context) => const PremiumUpgradeSheet(),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _refreshController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: NotificationListener<ScrollNotification>(
//         onNotification: (notification) {
//           if (notification is ScrollUpdateNotification) {
//             if (notification.metrics.pixels < -100 && !_isRefreshing) {
//               _loadData();
//               return true;
//             }
//             setState(() {
//               _refreshOffset = min(max(-notification.metrics.pixels, 0), 150);
//             });
//           }
//           return false;
//         },
//         child: Stack(
//           children: [
//             _buildTopGradient(),
//             SafeArea(
//               child: CustomScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
//                 slivers: [
//                   SliverToBoxAdapter(child: SizedBox(height: max(_refreshOffset, 0.0))),
//                   _buildHeader(),
                  
//                   // Premium Liked Section with Permission Check
//                   Consumer2<LikersProvider, PermissionProvider>(
//                     builder: (context, likersProv, permProv, _) => 
//                         _buildPremiumLikedSection(likersProv.likers, permProv.canSeeLikedMe),
//                   ),
                  
//                   _buildSectionDivider('MATCHES'),
                  
//                   Consumer<MatchesProvider>(
//                     builder: (context, provider, _) {
//                       if (provider.isLoading) return const MatchesShimmer();
//                       if (provider.matches.isEmpty) {
//                         return SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState());
//                       }

//                       return SliverPadding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         sliver: SliverGrid(
//                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 16,
//                             crossAxisSpacing: 16,
//                             childAspectRatio: 0.72,
//                           ),
//                           delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                               final profile = provider.matches[index];
//                               return _buildHighStandardGridCard(profile)
//                                   .animate()
//                                   .fadeIn(delay: (index * 50).ms)
//                                   .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
//                             },
//                             childCount: provider.matches.length,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const SliverToBoxAdapter(child: SizedBox(height: 120)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPremiumLikedSection(List<Profile> likers, bool hasPermission) {
//     if (likers.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

//     return SliverToBoxAdapter(
//       child: GestureDetector(
//         onTap: () => _handleLikersAccess(hasPermission),
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.03),
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: Colors.white.withOpacity(0.05)),
//           ),
//           child: Row(
//             children: [
//               // Avatar Stack with Blur if no permission
//               SizedBox(
//                 width: 75,
//                 height: 40,
//                 child: Stack(
//                   children: List.generate(likers.length > 3 ? 3 : likers.length, (index) {
//                     return Positioned(
//                       left: index * 18.0,
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: ImageFiltered(
//                             imageFilter: ImageFilter.blur(
//                               sigmaX: hasPermission ? 0 : 4, 
//                               sigmaY: hasPermission ? 0 : 4
//                             ),
//                             child: CachedNetworkImage(
//                               imageUrl: likers[index].photo,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${likers.length} People liked you",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w900,
//                         fontSize: 15,
//                       ),
//                     ),
//                     Text(
//                       hasPermission ? "See who swiped right" : "Upgrade to reveal who likes you",
//                       style: TextStyle(
//                         color: hasPermission ? Colors.white.withOpacity(0.4) : AppColors.neonGold.withOpacity(0.8),
//                         fontSize: 11,
//                         fontWeight: hasPermission ? FontWeight.normal : FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Action Button / Lock Icon
//               Container(
//                 height: 36,
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(18),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                   ),
//                 ),
//                 child: Center(
//                   child: hasPermission 
//                     ? const Text("See All", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11))
//                     : const Icon(Iconsax.lock5, color: Colors.black, size: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ).animate().fadeIn().slideX(begin: 0.1, end: 0),
//     );
//   }

//   Widget _buildHighStandardGridCard(Profile profile) {
//     return InkWell( 
//       onTap: () {
//         HapticFeedback.lightImpact();
//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return ProfileDetailsPage(profiledata: profile, goalName: profile.relationshipGoal?.name ?? "", match: true);
//         }));
//       },     
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(28),
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: CachedNetworkImage(
//                   imageUrl: profile.photo,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Container(color: Colors.white.withOpacity(0.05)),
//                 ),
//               ),
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
//                       stops: const [0.5, 1.0],
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 12,
//                 left: 12,
//                 right: 12,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       profile.userName,
//                       style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
//                       maxLines: 1,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(Iconsax.message_text5, color: Colors.white, size: 16),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 4),
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(Iconsax.call5, color: Colors.black, size: 16),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopGradient() {
//     return Positioned(
//       top: 0, left: 0, right: 0,
//       height: MediaQuery.of(context).size.height * 0.45,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [const Color(0xFFFF4D67).withOpacity(0.15), Colors.transparent],
//             begin: Alignment.topCenter, end: Alignment.bottomCenter,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Matches", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
//                 Text("Your recent connections", style: TextStyle(color: Colors.white38, fontSize: 13)),
//               ],
//             ),
//             _glassButton(Iconsax.setting_4),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionDivider(String label) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
//         child: Row(
//           children: [
//             Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
//             const SizedBox(width: 10),
//             Expanded(child: Divider(color: Colors.white.withOpacity(0.05))),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Padding(
//       padding: const EdgeInsets.all(40.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Iconsax.heart_add, size: 64, color: Colors.white.withOpacity(0.1)),
//           const SizedBox(height: 20),
//           const Text("No matches yet", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           const Text("Keep swiping to find your perfect match!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white38)),
//         ],
//       ),
//     );
//   }

//   Widget _glassButton(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
//       child: Icon(icon, color: Colors.white, size: 22),
//     );
//   }
// }