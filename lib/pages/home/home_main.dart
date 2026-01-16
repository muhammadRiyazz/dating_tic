
// // ----------------------------------------
// // 3. MAIN HOME SCREEN
// // ----------------------------------------
// import 'dart:math';
// import 'dart:ui';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dating/main.dart';
// import 'package:flutter/material.dart' ;
// import 'package:flutter/services.dart';
// import 'package:iconsax/iconsax.dart';

// class WeekendHome extends StatefulWidget {
//   const WeekendHome({super.key});

//   @override
//   State<WeekendHome> createState() => _WeekendHomeState();
// }

// class _WeekendHomeState extends State<WeekendHome> with TickerProviderStateMixin {
//   late TabController _tabController;
//   int _navIndex = 0;

//   final List<Map<String, dynamic>> _categories = [
//     {'title': 'For You', 'icon': Iconsax.heart},
//     {'title': 'Elite', 'icon': Iconsax.crown},
//     {'title': 'Models', 'icon': Iconsax.camera},
//     {'title': 'Call Girls', 'icon': Iconsax.call},
//     {'title': 'Nearby', 'icon': Iconsax.radar_1},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: _categories.length, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.deepBlack,
//       body: Stack(
//         children: [
//           // Background Glow
//           Positioned(
//             top: -100, left: -50,
//             child: Container(
//               width: 300, height: 300,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.neonGold.withOpacity(0.12),
//               ),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//           ),

//           // Main Scroll View (Sticky Tabs)
//           NestedScrollView(
//             headerSliverBuilder: (context, innerBoxIsScrolled) {
//               return [
//                 SliverToBoxAdapter(child: _buildHeader()),
//                 SliverToBoxAdapter(child: const SizedBox(height: 10)),
//                 SliverToBoxAdapter(child: _buildBannerSlider()),
//                 SliverToBoxAdapter(child: const SizedBox(height: 15)),
//                 SliverPersistentHeader(
//                   delegate: _StickyTabBarDelegate(
//                     tabBar: _buildTabBar(),
//                   ),
//                   pinned: true,
//                 ),
//               ];
//             },
//             body: TabBarView(
//               controller: _tabController,
//               children: _categories.map((cat) {
//                 return _buildCategoryLayout(cat['title']);
//               }).toList(),
//             ),
//           ),

//           // Floating Navigation Bar
//           Positioned(
//             bottom: 10, left: 25, right: 25,
//             child: _buildBottomNav(),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- WIDGETS ---

//   Widget _buildHeader() {
//     return SafeArea(
//       bottom: false,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Good Evening,", style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
//                 ShaderMask(
//                   shaderCallback: (bounds) => const LinearGradient(
//                     colors: [Colors.white, AppColors.neonGold],
//                   ).createShader(bounds),
//                   child: const Text("WEEKEND", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
//                 ),
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(colors: [AppColors.neonGold, AppColors.richOrange]),
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.4), blurRadius: 12)],
//               ),
//               child: Row(
//                 children: const [
//                   Icon(Iconsax.flash_1, color: Colors.black, size: 16),
//                   SizedBox(width: 4),
//                   Text("BOOST", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBannerSlider() {
//     return SizedBox(
//       height: 160,
//       child: PageView(
//         controller: PageController(viewportFraction: 0.9),
//         padEnds: false,
//         children: [
//           _buildBannerItem(
//             title: "Valentine's\nExclusive",
//             subtitle: "Find your date tonight",
//             colors: [AppColors.valentineRed, Colors.purple],
//             icon: Iconsax.heart5,
//             isStart: true,
//           ),
//           _buildBannerItem(
//             title: "Gold Access\nUnlocked",
//             subtitle: "See who likes you",
//             colors: [AppColors.neonGold, Colors.orange],
//             icon: Iconsax.crown1,
//             isDarkText: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBannerItem({required String title, required String subtitle, required List<Color> colors, required IconData icon, bool isDarkText = false, bool isStart = false}) {
//     return Container(
//       margin: EdgeInsets.only(left: isStart ? 24 : 10, right: 10),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Stack(
//         children: [
//           Positioned(right: -10, bottom: -10, child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.2))),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(title, style: TextStyle(color: isDarkText ? Colors.black : Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.1)),
//               const SizedBox(height: 5),
//               Text(subtitle, style: TextStyle(color: isDarkText ? Colors.black54 : Colors.white70, fontSize: 12)),
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text("Explore", style: TextStyle(color: isDarkText ? Colors.black : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   TabBar _buildTabBar() {
//     return TabBar(
//       controller: _tabController,
//       isScrollable: true,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       indicatorColor: Colors.transparent,
//       dividerColor: Colors.transparent,
//       labelPadding: const EdgeInsets.symmetric(horizontal: 6),
//       tabs: _categories.map((cat) {
//         return Tab(
//           child: AnimatedBuilder(
//             animation: _tabController,
//             builder: (context, child) {
//               final isSelected = _categories.indexOf(cat) == _tabController.index;
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: isSelected ? AppColors.neonGold : AppColors.cardBlack,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: isSelected ? Colors.transparent : Colors.white12),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(cat['icon'], size: 16, color: isSelected ? Colors.black : Colors.white54),
//                     const SizedBox(width: 6),
//                     Text(
//                       cat['title'],
//                       style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildBottomNav() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           height: 70,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.7),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _navBtn(Iconsax.home_2, 0),
//               _navBtn(Iconsax.discover_1, 1),
//               // ADDED CALL ICON IN NAVIGATION BAR
//               _navBtn(Iconsax.call, 2),
//               _navBtn(Iconsax.message, 3),
//               _navBtn(Iconsax.profile_circle, 4),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _navBtn(IconData icon, int index) {
//     bool isSelected = _navIndex == index;
//     return GestureDetector(
//       onTap: () => setState(() => _navIndex = index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.neonGold.withOpacity(0.2) : Colors.transparent,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, color: isSelected ? AppColors.neonGold : Colors.grey, size: 24),
//       ),
//     );
//   }

//   // ----------------------------------------
//   // CATEGORY LAYOUT SWITCHER
//   // ----------------------------------------
//   Widget _buildCategoryLayout(String title) {
//     var profiles = profileData.where((p) => p.category == title).toList();
//     if (title == "For You") profiles = profileData; 

//     // Add extra padding at bottom for Nav Bar
//     EdgeInsets bottomPad = const EdgeInsets.only(bottom: 110, top: 10, left: 20, right: 20);

//     if (title == 'For You') {
//       return ListView.builder(
//         padding: bottomPad,
//         itemCount: profiles.length,
//         itemBuilder: (ctx, i) => ImmersiveProfileCard(profile: profiles[i]),
//       );
//     } else if (title == 'Elite') {
//       return ListView.builder(
//         padding: bottomPad,
//         itemCount: profiles.length,
//         itemBuilder: (ctx, i) => _buildEliteCard(profiles[i]),
//       );
//     } else if (title == 'Models') {
//       return GridView.builder(
//         padding: const EdgeInsets.only(bottom: 110, top: 10, left: 16, right: 16),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 15, mainAxisSpacing: 15,
//         ),
//         itemCount: profiles.length,
//         itemBuilder: (ctx, i) => _buildModelGridCard(profiles[i]),
//       );
//     } else if (title == 'Call Girls') {
//       return ListView.builder(
//         padding: bottomPad,
//         itemCount: profiles.length,
//         itemBuilder: (ctx, i) => _buildCallGirlCard(profiles[i]),
//       );
//     } else if (title == 'Nearby') {
//       return _buildNearbySection(profiles);
//     }
//     return const SizedBox();
//   }

//   // --- 1. ELITE CARD (VIP Style) - PRICING REMOVED ---
//   Widget _buildEliteCard(Profile profile) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF000000)]),
//         borderRadius: BorderRadius.circular(24),
//         // border: Border.all(color: AppColors.neonGold.withOpacity(0.4), width: 1),
//         boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.05), blurRadius: 15)],
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(23), bottomLeft: Radius.circular(23)),
//                 child: CachedNetworkImage(imageUrl: profile.imageUrl, width: 110, height: 140, fit: BoxFit.cover),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                             decoration: BoxDecoration(color: AppColors.neonGold, borderRadius: BorderRadius.circular(4)),
//                             child: const Text("BLACK CARD", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
//                           ),
//                           Icon(Iconsax.verify5, color: AppColors.neonGold, size: 16),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(profile.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//                       Text("${profile.location} • Active", style: const TextStyle(color: Colors.grey, fontSize: 12)), // PRICING REMOVED
//                       const SizedBox(height: 8),
//                       // Tags
//                       Wrap(
//                         spacing: 8,
//                         children: profile.tags.take(2).map((tag) => 
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text("#$tag", style: const TextStyle(color: Colors.white70, fontSize: 10)),
//                           )
//                         ).toList(),
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           _smallActionBtn(Iconsax.message, Colors.blue),
//                           const SizedBox(width: 10),
//                           _smallActionBtn(Iconsax.call, Colors.green),
//                           const SizedBox(width: 10),
//                           _smallActionBtn(Iconsax.video, Colors.purple),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _smallActionBtn(IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
//       child: Icon(icon, color: color, size: 18),
//     );
//   }

//   // --- 2. MODEL GRID CARD (Content Heavy) ---
//   Widget _buildModelGridCard(Profile profile) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         image: DecorationImage(image: CachedNetworkImageProvider(profile.imageUrl), fit: BoxFit.cover),
//       ),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(24),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter, end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 10, right: 10,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
//               child: const Text("Available", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
//             ),
//           ),
//           Positioned(
//             bottom: 12, left: 12, right: 12,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(profile.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//                 const SizedBox(height: 4),
//                 Wrap(
//                   spacing: 4,
//                   children: profile.tags.take(2).map((t) => 
//                     Text("#$t", style: TextStyle(color: AppColors.neonGold, fontSize: 10))
//                   ).toList(),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- 3. CALL GIRL CARD (High Energy) - PRICING REMOVED ---
//   Widget _buildCallGirlCard(Profile profile) {
//     return Container(
//       height: 220,
//       margin: const EdgeInsets.only(bottom: 24),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(28),
//         image: DecorationImage(image: CachedNetworkImageProvider(profile.imageUrl), fit: BoxFit.cover),
//       ),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(28),
//               gradient: LinearGradient(
//                 begin: Alignment.topRight, end: Alignment.bottomLeft,
//                 colors: [Colors.purple.withOpacity(0.2), Colors.black],
//                 stops: [0.0, 0.9]
//               ),
//             ),
//           ),
//           // Live Indicator
//           if(profile.isOnline)
//           Positioned(
//             top: 20, left: 20,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 10)]),
//               child: const Row(children: [
//                 Icon(Icons.circle, color: Colors.white, size: 8),
//                 SizedBox(width: 4),
//                 Text("LIVE NOW", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//               ]),
//             ),
//           ),
//           Positioned(
//             bottom: 20, left: 20, right: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(profile.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
//                               if(profile.isVerified) const SizedBox(width: 8),
//                               if(profile.isVerified) const Icon(Iconsax.verify, color: AppColors.neonGold, size: 18),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Text(profile.location, style: const TextStyle(color: AppColors.neonGold, fontSize: 14, fontWeight: FontWeight.bold)), // PRICING REMOVED
//                         ],
//                       ),
//                     ),
//                     // Action Buttons
//                     Row(
//                       children: [
//                         _callGirlActionBtn(Iconsax.close_circle, Colors.red.withOpacity(0.3), "Pass"),
//                         const SizedBox(width: 10),
//                         _callGirlActionBtn(Iconsax.message, Colors.blue.withOpacity(0.3), "Msg"),
//                         const SizedBox(width: 10),
//                         _callGirlActionBtn(Iconsax.call, Colors.green.withOpacity(0.3), "Call"),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 // Tags
//                 Wrap(
//                   spacing: 8,
//                   children: profile.tags.map((tag) => 
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text("#$tag", style: const TextStyle(color: Colors.white70, fontSize: 11)),
//                     )
//                   ).toList(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _callGirlActionBtn(IconData icon, Color bgColor, String label) {
//     return Column(
//       children: [
//         Container(
//           height: 45,
//           width: 45,
//           decoration: BoxDecoration(
//             color: bgColor,
//             shape: BoxShape.circle,
//             boxShadow: [BoxShadow(color: bgColor.withOpacity(0.4), blurRadius: 8)],
//           ),
//           child: Icon(icon, color: Colors.white, size: 22),
//         ),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
//       ],
//     );
//   }

//   // --- 4. NEARBY SECTION - UPDATED TO ATTRACTIVE CARDS WITH CALL ICON ---
//   Widget _buildNearbySection(List<Profile> profiles) {
//     return Column(
//       children: [
//         // Section Header
//         Padding(
//           padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Nearby Matches", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//                   Text("${profiles.length} people nearby", style: TextStyle(color: Colors.grey, fontSize: 10)),
//                 ],
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white10),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Iconsax.filter, color: AppColors.neonGold, size: 14),
//                     const SizedBox(width: 4),
//                     Text("Filter", style: TextStyle(color: Colors.white70, fontSize: 11)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
        
//         // Nearby Cards Grid
//         Padding(
//           padding: const EdgeInsets.only(left: 15, right: 15, bottom: 110),
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.75,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//             ),
//             itemCount: profiles.length,
//             itemBuilder: (context, index) => _buildNearbyCard(profiles[index]),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildNearbyCard(Profile profile) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.cardBlack,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Image with Pulse Animation
//           Expanded(
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: profile.imageUrl,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 // Pulse Animation Overlay
//                 Positioned(
//                   bottom: 10,
//                   right: 10,
//                   child: PulseAnimationSmall(),
//                 ),
//                 // Distance Badge
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Iconsax.location, color: AppColors.neonGold, size: 10),
//                         const SizedBox(width: 4),
//                         Text(profile.location, style: const TextStyle(color: Colors.white, fontSize: 10)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Online Indicator
//                 if (profile.isOnline)
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: Container(
//                     width: 10,
//                     height: 10,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       shape: BoxShape.circle,
//                       boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 8)],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Profile Info
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(profile.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//                     if(profile.isVerified)
//                     Icon(Iconsax.verify5, color: AppColors.neonGold, size: 14),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text("${profile.age} • ${profile.bio}", 
//                   maxLines: 1, 
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(color: Colors.grey, fontSize: 11)),
//                 const SizedBox(height: 8),
//                 // Action Buttons - ADDED CALL ICON HERE
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Message Button
//                     Expanded(
//                       child: Container(
//                         height: 30,
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Iconsax.message, color: Colors.blue, size: 12),
//                             const SizedBox(width: 4),
//                             Text("Message", style: TextStyle(color: Colors.blue, fontSize: 11)),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     // Call Button - ADDED
//                     Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(Iconsax.call, color: Colors.green, size: 14),
//                     ),
//                     const SizedBox(width: 8),
//                     // Heart Button
//                     Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                         color: Colors.pink.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(Iconsax.heart, color: Colors.pink, size: 14),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ----------------------------------------
// // IMMERSIVE CARD (FOR YOU) - Updated with bio and interests
// // ----------------------------------------
// class ImmersiveProfileCard extends StatefulWidget {
//   final Profile profile;
//   const ImmersiveProfileCard({super.key, required this.profile});

//   @override
//   State<ImmersiveProfileCard> createState() => _ImmersiveProfileCardState();
// }

// class _ImmersiveProfileCardState extends State<ImmersiveProfileCard> {
//   final List<Widget> _particles = [];

//   void _triggerHeartExplosion() {
//     for (int i = 0; i < 15; i++) {
//       _addParticle();
//     }
//   }

//   void _addParticle() {
//     final random = Random();
//     final double angle = -pi / 2 + (random.nextDouble() - 0.5);
//     final double speed = 100 + random.nextDouble() * 200;
//     final key = UniqueKey();
    
//     final widget = HeartParticle(
//       key: key,
//       angle: angle,
//       speed: speed,
//       onComplete: () {
//         if (mounted) setState(() => _particles.removeWhere((element) => element.key == key));
//       },
//     );
//     setState(() => _particles.add(widget));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 580, // Increased height for bio and tags
//       margin: const EdgeInsets.only(bottom: 30),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         color: AppColors.cardBlack,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.5), 
//             blurRadius: 20, 
//             offset: const Offset(0, 10)
//           )
//         ],
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           // Profile Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(25),
//             child: CachedNetworkImage(
//               imageUrl: widget.profile.imageUrl,
//               height: 580, 
//               width: double.infinity, 
//               fit: BoxFit.cover,
//             ),
//           ),
          
//           // Gradient Overlay
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter, 
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.transparent, 
//                   Colors.black.withOpacity(0.1), 
//                   Colors.black.withOpacity(0.95)
//                 ],
//                 stops: const [0.0, 0.5, 1.0],
//               ),
//             ),
//           ),
          
//           // Location Badge
//           Positioned(
//             top: 25, left: 25,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.3), 
//                     borderRadius: BorderRadius.circular(20), 
//                     border: Border.all(color: Colors.white10)
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Iconsax.location, color: AppColors.neonGold, size: 14), 
//                       const SizedBox(width: 6), 
//                       Text(
//                         widget.profile.location, 
//                         style: const TextStyle(
//                           color: Colors.white, 
//                           fontSize: 12, 
//                           fontWeight: FontWeight.bold
//                         )
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
          
//           // Online Status Indicator
//           if (widget.profile.isOnline)
//           Positioned(
//             top: 25, right: 25,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.3), 
//                     borderRadius: BorderRadius.circular(20), 
//                     border: Border.all(color: Colors.green.withOpacity(0.5))
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 8, height: 8,
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(4),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.green.withOpacity(0.5),
//                               blurRadius: 8,
//                             )
//                           ]
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "Online", 
//                         style: TextStyle(
//                           color: Colors.white, 
//                           fontSize: 12, 
//                           fontWeight: FontWeight.bold
//                         )
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
          
//           // Bottom Info Card
//           Positioned(
//             bottom: 20, left: 10, right: 10,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(25),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1E1E1E).withOpacity(0.6), 
//                     border: Border.all(color: Colors.white12), 
//                     borderRadius: BorderRadius.circular(25)
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Name and Verification
//                       Row(
//                         children: [
//                           Text(
//                             "${widget.profile.name}, ${widget.profile.age}", 
//                             style: const TextStyle(
//                               color: Colors.white, 
//                               fontSize: 18, 
//                               fontWeight: FontWeight.w900
//                             )
//                           ), 
//                           // const SizedBox(width: 4), 
//                           if(widget.profile.isVerified) 
//                           const Icon(Icons.verified, color: AppColors.neonGold, size: 22)
//                         ],
//                       ),
                      
//                       const SizedBox(height: 2),
                      
//                       // Bio
//                       Text(
//                         widget.profile.bio, 
//                         maxLines: 2, 
//                         overflow: TextOverflow.ellipsis, 
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9), 
//                           fontSize: 10, 
//                           height: 1.4,
//                           fontWeight: FontWeight.w500
//                         )
//                       ),
                      
//                       const SizedBox(height: 12),
                      
//                       // Interests Tags
//                       if (widget.profile.tags.isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
                        
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 6,
//                             children: widget.profile.tags.map((tag) {
//                               return Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.neonGold.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(15),
//                                   border: Border.all(
//                                     color: AppColors.neonGold.withOpacity(0.3),
//                                     width: 1
//                                   ),
//                                 ),
//                                 child: Text(
//                                   "#$tag",
//                                   style: TextStyle(
//                                     color: AppColors.neonGold,
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                           const SizedBox(height: 15),
//                         ],
//                       ),
                      
//                       // Action Buttons
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _glassActionBtn(Iconsax.close_circle, Colors.white70, "Pass"),
//                           _glassActionBtn(Iconsax.message, Colors.white70, "Message"),
//                           _glassActionBtn(Iconsax.call, Colors.white70, "Call"),
//                           GestureDetector(
//                             onTap: () { 
//                               _triggerHeartExplosion(); 
//                               HapticFeedback.mediumImpact(); 
//                             },
//                             child: Container(
//                               height: 50, 
//                               width: 50,
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [AppColors.neonGold, AppColors.richOrange]
//                                 ), 
//                                 borderRadius: BorderRadius.circular(22), 
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: AppColors.neonGold.withOpacity(0.5), 
//                                     blurRadius: 20
//                                   )
//                                 ]
//                               ),
//                               child: Stack(
//                                 alignment: Alignment.center, 
//                                 clipBehavior: Clip.none, 
//                                 children: [
//                                   const Icon(Iconsax.heart5, color: Colors.black, size: 26),
//                                   ..._particles
//                                 ]
//                               ),
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
  
//   Widget _glassActionBtn(IconData icon, Color color, String label) {
//     return Column(
//       children: [
//         Container(
//           height: 50, 
//           width: 50,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.4), 
//             borderRadius: BorderRadius.circular(22), 
//             border: Border.all(color: Colors.white.withOpacity(0.2))
//           ),
//           child: Icon(icon, color: color, size: 26),
//         ),
      
//       ],
//     );
//   }
// }

// // ---------Color.fromARGB(255, 38, 23, 23)-------------------
// // ANIMATIONS
// // ----------------------------------------
// class HeartParticle extends StatefulWidget {
//   final double angle;
//   final double speed;
//   final VoidCallback onComplete;
//   const HeartParticle({super.key, required this.angle, required this.speed, required this.onComplete});
//   @override
//   State<HeartParticle> createState() => _HeartParticleState();
// }

// class _HeartParticleState extends State<HeartParticle> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
//     _controller.forward().then((_) => widget.onComplete());
//   }
//   @override
//   void dispose() { _controller.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         final double dist = widget.speed * _animation.value;
//         return Transform.translate(
//           offset: Offset(dist * cos(widget.angle), dist * sin(widget.angle) - 50),
//           child: Transform.scale(scale: 1.0 - _animation.value, child: Opacity(opacity: 1.0 - _animation.value, child: const Icon(Icons.favorite, color: AppColors.neonGold, size: 20))),
//         );
//       },
//     );
//   }
// }

// class PulseAnimation extends StatefulWidget {
//   @override
//   State<PulseAnimation> createState() => _PulseAnimationState();
// }
// class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
//   }
//   @override
//   void dispose() { _controller.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Container(
//           width: 70, height: 70,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: AppColors.neonGold.withOpacity(1 - _controller.value), width: 2),
//           ),
//         );
//       },
//     );
//   }
// }

// // Small Pulse Animation for Nearby Cards
// class PulseAnimationSmall extends StatefulWidget {
//   @override
//   State<PulseAnimationSmall> createState() => _PulseAnimationSmallState();
// }
// class _PulseAnimationSmallState extends State<PulseAnimationSmall> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
//   }
//   @override
//   void dispose() { _controller.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Container(
//           width: 20, height: 20,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.green.withOpacity(1 - _controller.value), width: 1.5),
//           ),
//           child: Center(
//             child: Container(
//               width: 6, height: 6,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.green,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;
//   _StickyTabBarDelegate({required this.tabBar});
//   @override
//   double get minExtent => tabBar.preferredSize.height + 20; // + padding
//   @override
//   double get maxExtent => tabBar.preferredSize.height + 20;
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: AppColors.deepBlack,
//       padding: const EdgeInsets.only(top: 10, bottom: 10),
//       child: tabBar,
//     );
//   }
//   @override
//   bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
// }