// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dating/pages/dummy.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';

// // --- THEME COLOR (ELITE YELLOW) ---
// const Color kEliteGold = Color(0xFFFFD166);
// const Color kCardDark = Color(0xFF1E1E1E);
// const Color kBgDark = Color(0xFF0F0F0F);

// // --- DATA MODEL ---
// class Profile {
//   final String name;
//   final int age;
//   final String imageUrl;
//   final String location;
//   final List<String> interests;
//     final List<String> photos;

//   final String bio;
//   final bool isVerified;
//   final bool isOnline;
//   final String category;
//   final String callRate;
//   final double rating;
//      bool? isPremium;


//   Profile({

//         required this.photos,
//          this.isPremium,

//     required this.name,
//     required this.age,
//     required this.imageUrl,
//     required this.location,
//     required this.interests,
//     required this.bio,
//     this.isVerified = false,
//     this.isOnline = false,
//     required this.category,
//     this.callRate = "Free",
//     this.rating = 4.5,
//   });
// }



// class DiscoverPage extends StatefulWidget {
//   const DiscoverPage({super.key});

//   @override
//   State<DiscoverPage> createState() => _DiscoverPageState();
// }

// class _DiscoverPageState extends State<DiscoverPage> with TickerProviderStateMixin {
//   late TabController _tabController;

//   final List<Map<String, dynamic>> _categories = [
//     {'title': 'For You', 'icon': Iconsax.heart},
//         {'title': 'Elite', 'icon': Iconsax.crown},

//     {'title': 'Models', 'icon': Iconsax.camera},
//     // {'title': 'Travel', 'icon': Iconsax.airplane},
//         {'title': 'Call Girls', 'icon': Iconsax.call},

//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: _categories.length, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor = isDark ? kBgDark : const Color(0xFFF5F7FA);

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // 1. Header with Boost Button
//             _buildHeader(isDark),

//             // 2. Swipeable Tab Bar
//             _buildTabBar(isDark),

//             // 3. Different Layouts based on Category
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 physics: const BouncingScrollPhysics(),
//                 children: _categories.map((cat) {
//                   return _buildCategoryLayout(cat, isDark);
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- WIDGETS ---

//   Widget _buildHeader(bool isDark) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       child: Row(
//         children: [
//           // Title
//         RichText(
//             text: const TextSpan(
//               children: [
//                 TextSpan(text: "WEEK", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1)),
//                 TextSpan(text: "END", style: TextStyle(color: kEliteGold, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1)),
//               ],
//             ),
//           ),
          
//           const Spacer(),

//           // Boost Button
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: kEliteGold,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(color: kEliteGold.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
//               ],
//             ),
//             child: Row(
//               children: [
//                 const Icon(Iconsax.flash_15, color: Colors.black, size: 15),
//                 const SizedBox(width: 4),
//                 const Text(
//                   "Boost",
//                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(width: 12),

//           // Notification Icon
//           Stack(
//             children: [
//               Icon(Iconsax.notification, color: isDark ? Colors.white : Colors.black87, size: 20),
//               Positioned(
//                 right: 0, top: 0,
//                 child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabBar(bool isDark) {
//     return Container(
//       height: 45,
//       margin: const EdgeInsets.only(bottom: 10),
//       width: double.infinity,
//       child: TabBar(
//         controller: _tabController,
//         isScrollable: true,
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         labelColor: kEliteGold, // Selected color
//         unselectedLabelColor: isDark ? Colors.white54 : Colors.grey,
//         indicatorColor: kEliteGold,
//         indicatorSize: TabBarIndicatorSize.label,
//         dividerColor: Colors.transparent,
//         labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
//         tabs: _categories.map((cat) => Tab(text: cat['title'])).toList(),
//       ),
//     );
//   }

//   // --- LAYOUT SWITCHER ---
//   Widget _buildCategoryLayout(Map<String, dynamic> category, bool isDark) {
//     final title = category['title'];
//     var profiles = profileData.where((p) => p.category == title).toList();
//     if (profiles.isEmpty) profiles = profileData; // Fallback

//     // 1. FOR YOU: Standard Big Vertical Cards
//     if (title == 'For You') {
//       return ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: profiles.length,
//         itemBuilder: (ctx, i) => _buildStandardBigCard(profiles[i], isDark),
//       );
//     }
//     // 2. MODELS: Grid Layout
//     else if (title == 'Elite') {
//       return  _buildEliteMembershipLayout(profiles
//       );
//     }

//      else if (title == 'Models') {
//       return GridView.builder(
//         padding: const EdgeInsets.all(16),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.7,
//           crossAxisSpacing: 15,
//           mainAxisSpacing: 15,
//         ),
//         itemCount: profiles.length,
//         itemBuilder: (ctx, i) => _buildModelGridCard(profiles[i], isDark),
//       );
//     }
//     // 3. CALL GIRLS: Large Interaction Cards
//     else  {
//       return PageView.builder(
//         scrollDirection:Axis.vertical ,
//         // padding: const EdgeInsets.all(20),
//         itemCount: profiles.length,
//         itemBuilder: (ctx, i) => 
//         // _buildCallGirlCardEnhanced(profiles[i], isDark)
//         _buildMinimalistCard(profiles[i], isDark),
//       );
//     }
//     // // 4. STUDENTS: Compact List (Small cards)
//     // else
//     //  if (title == 'Students') {
//     //   return ListView.builder(
//     //     padding: const EdgeInsets.all(20),
//     //     itemCount: profiles.length,
//     //     itemBuilder: (ctx, i) => _buildStudentSmallCard(profiles[i], isDark),
//     //   );
//     // }
//     // 5. TRAVEL: Landscape Cards
//     // else {
//     //   return ListView.builder(
//     //     padding: const EdgeInsets.all(20),
//     //     itemCount: profiles.length,
//     //     itemBuilder: (ctx, i) => _buildTravelLandscapeCard(profiles[i], isDark),
//     //   );
//     // }
//   }

//   // --- CARD DESIGNS ---
// Widget _buildCallGirlCardEnhanced(Profile profile, bool isDark) {
//   return Container(
//     height: 300,
//     margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(28),
//       image: DecorationImage(
//         image: CachedNetworkImageProvider(profile.imageUrl),
//         fit: BoxFit.cover,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.3),
//           blurRadius: 20,
//           spreadRadius: 2,
//           offset: const Offset(0, 10),
//         ),
//       ],
//     ),
//     child: Stack(
//       children: [
//         // Gradient Overlay
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(28),
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.transparent,
//                 Colors.black.withOpacity(0.2),
//                 Colors.black.withOpacity(0.8),
//               ],
//             ),
//           ),
//         ),
        
//         // Rate Badge with animation
//         Positioned(
//           top: 20,
//           right: 20,
//           child: TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0.0, end: 1.0),
//             duration: const Duration(milliseconds: 500),
//             builder: (context, value, child) {
//               return Transform.scale(
//                 scale: value,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [kEliteGold, Color(0xFFD4AF37)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: kEliteGold.withOpacity(0.5),
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Iconsax.dollar_circle,
//                           color: Colors.white, size: 18),
//                       const SizedBox(width: 6),
//                       Text(
//                         profile.callRate,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         '/hr',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
        
//         // Top Action Icons
//         Positioned(
//           top: 20,
//           left: 20,
//           child: Row(
//             children: [
//               // Favorite
//               _buildFloatingAction(
//                 icon: Iconsax.heart5,
//                 color: Colors.red,
//                 onTap: () {},
//               ),
//               const SizedBox(width: 10),
//               // Share
//               _buildFloatingAction(
//                 icon: Iconsax.share,
//                 color: Colors.blue,
//                 onTap: () {},
//               ),
//             ],
//           ),
//         ),
        
//         // Main Content Bottom
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(28),
//                 bottomRight: Radius.circular(28),
//               ),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.transparent,
//                   Colors.black.withOpacity(0.9),
//                 ],
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Profile Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         profile.name,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           const Icon(Iconsax.location,
//                               color: Colors.white70, size: 16),
//                           const SizedBox(width: 6),
//                           Text(
//                             profile.location,
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 15,
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           const Icon(Iconsax.star1,
//                               color: Colors.yellow, size: 16),
//                           const SizedBox(width: 4),
//                           Text(
//                             profile.rating.toString(),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(width: 15),
                
//                 // Call Button with pulse animation
//                 _buildPulseCallButton(),
//               ],
//             ),
//           ),
//         ),
        
//         // Tags Overlay
//         Positioned(
//           bottom: 120,
//           left: 20,
//           child: Wrap(
//             spacing: 8,
//             children: profile.interests.take(2).map((tag) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.3),
//                   ),
//                 ),
//                 child: Text(
//                   tag,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildFloatingAction({
//   required IconData icon,
//   required Color color,
//   required VoidCallback onTap,
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.4),
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white.withOpacity(0.2)),
//       ),
//       child: Icon(icon, color: color, size: 20),
//     ),
//   );
// }

// Widget _buildPulseCallButton() {
//   return Stack(
//     alignment: Alignment.center,
//     children: [
//       // Pulsing ring
//       Container(
//         width: 70,
//         height: 70,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.green.withOpacity(0.2),
//         ),
//       ),
      
//       // Call button
//       Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.green, Colors.lightGreen],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.green.withOpacity(0.4),
//               blurRadius: 15,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: const Icon(
//           Iconsax.call,
//           color: Colors.white,
//           size: 28,
//         ),
//       ),
//     ],
//   );
// }
//   // 1. STANDARD BIG CARD (For You)
//   Widget _buildStandardBigCard(Profile profile, bool isDark) {
//     return Container(
//       height: 400,
//       margin: const EdgeInsets.only(bottom: 25),
//       decoration: BoxDecoration(
//         color: isDark ? kCardDark : Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
//       ),
//       child: Column(
//         children: [
//           // Image Section
//           Expanded(
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//                   child: CachedNetworkImage(imageUrl: profile.imageUrl, fit: BoxFit.cover),
//                 ),
//                 if (profile.isVerified)
//                   Positioned(
//                     top: 15, left: 15,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(color: kEliteGold, borderRadius: BorderRadius.circular(20)),
//                       child: const Row(children: [Icon(Iconsax.verify5, size: 12), SizedBox(width: 4), Text("Verified", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
//                     ),
//                   )
//               ],
//             ),
//           ),
//           // Info Section
//           Padding(
//             padding: const EdgeInsets.all(15),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("${profile.name}, ${profile.age}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
//                       const SizedBox(height: 4),
//                       Row(children: [const Icon(Iconsax.location, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(profile.location, style: const TextStyle(color: Colors.grey))]),
//                     ],
//                   ),
//                 ),
//                 // Quick Actions
//                 Row(
//                   children: [
//                     _circleBtn(Iconsax.close_circle, isDark ? Colors.white12 : Colors.grey[200]!, Colors.grey),
//                     const SizedBox(width: 10),
//                     _circleBtn(Iconsax.call, kEliteGold.withOpacity(0.2), kEliteGold), // Call Icon
//                     const SizedBox(width: 10),
//                     _circleBtn(Iconsax.heart5, kEliteGold, Colors.black),
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     ).animate().fadeIn().slideY(begin: 0.1);
//   }
// Widget _buildEliteMembershipLayout(List<Profile> profiles) {
//   return ListView.builder(
//     padding: const EdgeInsets.all(16),
//     itemCount: profiles.length,
//     itemBuilder: (context, index) {
//       final profile = profiles[index];
//       return GestureDetector(
//         onTap: () {
//           // Optional: Add haptic feedback
//           HapticFeedback.lightImpact();
//         },
//         child: Container(
//           height: 230,
//           margin: const EdgeInsets.only(bottom: 15),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: const LinearGradient(
//               colors: [Color(0xFF2C2C2C), Color(0xFF000000)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             // boxShadow: [
//             //   BoxShadow(
//             //     color: kEliteGold.withOpacity(0.1),
//             //     blurRadius: 10,
//             //     spreadRadius: 1,
//             //   ),
//             //   BoxShadow(
//             //     color: Colors.black.withOpacity(0.3),
//             //     blurRadius: 5,
//             //     offset: const Offset(0, 3),
//             //   ),
//             // ],
//           ),
//           child: Stack(
//             children: [
//               // Animated border on hover
//               Positioned.fill(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           kEliteGold.withOpacity(0),
//                           kEliteGold.withOpacity(0.1),
//                           kEliteGold.withOpacity(0),
//                         ],
//                         stops: const [0.0, 0.5, 1.0],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
              
//               Row(
//                 children: [
//                   // Left Image with subtle shine effect
//                   Container(
//                     width: 140,
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(19),
//                         bottomLeft: Radius.circular(19),
//                       ),
//                       image: DecorationImage(
//                         image: CachedNetworkImageProvider(profile.imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                       // boxShadow: [
//                       //   BoxShadow(
//                       //     color: Colors.black.withOpacity(0.5),
//                       //     blurRadius: 5,
//                       //     offset: const Offset(2, 0),
//                       //   ),
//                       // ],
//                     ),
//                   ),
                  
//                   // Right Content
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Iconsax.crown_1,
//                                   color: kEliteGold, size: 16),
//                               const SizedBox(width: 5),
//                               Text("ELITE MEMBER",
//                                   style: TextStyle(
//                                       color: kEliteGold.withOpacity(0.8),
//                                       fontSize: 10,
//                                       letterSpacing: 1.5,
//                                       fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Text(profile.name,
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold)),
//                           Text(profile.bio,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                   color: Colors.grey, fontSize: 12)),
//                           const Spacer(),
                          
//                           // Action buttons row
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               // Like button with animation
//                               _LikeButton(
//                                 profile: profile,
//                                 onLiked: (isLiked) {
//                                   // Handle like action
//                                 },
//                               ),
//                               const SizedBox(width: 15),
                              
//                               // Message icon
//                               Container(
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white.withOpacity(0.1),
//                                 ),
//                                 padding: const EdgeInsets.all(8),
//                                 child: const Icon(Iconsax.message,
//                                     color: Colors.white54, size: 20),
//                               ),
//                               const SizedBox(width: 15),
                              
//                               // Call icon
//                               Container(
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       kEliteGold.withOpacity(0.8),
//                                       kEliteGold,
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                 ),
//                                 padding: const EdgeInsets.all(8),
//                                 child: const Icon(Iconsax.call,
//                                     color: Colors.black, size: 20),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
              
//               // Elite badge corner
           
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

//   // 2. MODEL GRID CARD
//   Widget _buildModelGridCard(Profile profile, bool isDark) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         image: DecorationImage(image: CachedNetworkImageProvider(profile.imageUrl), fit: BoxFit.cover),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
//       ),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]),
//             ),
//           ),
//           Positioned(
//             bottom: 12, left: 12, right: 12,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(profile.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//                 const SizedBox(height: 4),
//                 Text("Model • ${profile.age}", style: const TextStyle(color: kEliteGold, fontSize: 12)),
//               ],
//             ),
//           ),
//           Positioned(top: 10, right: 10, child: const Icon(Iconsax.camera, color: Colors.white, size: 16)),
//         ],
//       ),
//     );
//   }

// Widget _buildMinimalistCard(Profile profile, bool isDark) {
//   return Container(
//     height: 400,
//     margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(24),
//       color: isDark ? Color(0xFF121212) : Colors.white,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           blurRadius: 15,
//           offset: const Offset(0, 5),
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         // Top Image Section
//         Expanded(
//           flex: 3,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 topRight: Radius.circular(24),
//               ),
//               image: DecorationImage(
//                 image: CachedNetworkImageProvider(profile.imageUrl),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 // Gradient Overlay
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24),
//                     ),
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.6),
//                       ],
//                     ),
//                   ),
//                 ),
                
//                 // Top Icons
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Back/Close button
//                       Container(
//                         width: 36,
//                         height: 36,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(Iconsax.arrow_left,
//                             color: Colors.white, size: 20),
//                       ),
                      
//                       // Like Button
//                       Container(
//                         width: 36,
//                         height: 36,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(Iconsax.heart,
//                             color: Colors.white, size: 20),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 // Price Tag
//                 Positioned(
//                   bottom: 15,
//                   left: 15,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: kEliteGold,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Iconsax.dollar_circle,
//                             color: Colors.white, size: 18),
//                         const SizedBox(width: 6),
//                         Text(
//                           profile.callRate,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '/hr',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
        
//         // Bottom Info Section
//         Expanded(
//           flex: 2,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           profile.name,
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white : Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Row(
//                           children: [
//                             Icon(Iconsax.location,
//                                 color: Colors.grey, size: 14),
//                             const SizedBox(width: 6),
//                             Text(
//                               profile.location,
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
                    
//                     // Availability Indicator
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: profile.isVerified
//                             ? Colors.green.withOpacity(0.1)
//                             : Colors.red.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: profile.isOnline
//                               ? Colors.green.withOpacity(0.3)
//                               : Colors.red.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: profile.isVerified
//                                   ? Colors.green
//                                   : Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             profile.isOnline
//                                 ? 'AVAILABLE'
//                                 : 'BUSY',
//                             style: TextStyle(
//                               color: profile.isVerified
//                                   ? Colors.green
//                                   : Colors.red,
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 8),
                
//                 // Bio
//                 Text(
//                   profile.bio,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
                
//                 const Spacer(),
                
//                 Container(
//                   // height: 80,
//                   decoration: BoxDecoration(
//                     color: isDark
//                         ? Color(0xFF1E1E1E)
//                         : Colors.grey[50],
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       // WhatsApp
//                       _buildMinimalistAction(
//                         icon: Iconsax.message,
//                         label: 'WhatsApp',
//                         color: Colors.green,
//                       ),
                      
//                       // Call
//                       _buildMinimalistAction(
//                         icon: Iconsax.call,
//                         label: 'Call Now',
//                         color: Colors.blue,
//                         isPrimary: true,
//                       ),
                      
//                       // Video
//                       _buildMinimalistAction(
//                         icon: Iconsax.video,
//                         label: 'Video Call',
//                         color: Colors.purple,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildMinimalistAction({
//   required IconData icon,
//   required String label,
//   required Color color,
//   bool isPrimary = false,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: isPrimary ?36 : 36,
//           height: isPrimary ? 36 : 36,
//           decoration: BoxDecoration(
//             color: isPrimary
//                 ? color
//                 : color.withOpacity(0.1),
//             shape: BoxShape.circle,
//             border: isPrimary
//                 ? null
//                 : Border.all(color: color.withOpacity(0.3)),
//             boxShadow: isPrimary
//                 ? [
//                     BoxShadow(
//                       color: color.withOpacity(0.3),
//                       blurRadius: 10,
//                       spreadRadius: 1,
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Icon(
//             icon,
//             color: isPrimary ? Colors.white : color,
//             size: isPrimary ? 18 : 18,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[700],
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildActionButton({
//   required IconData icon,
//   required String label,
//   required Color color,
//   required VoidCallback onTap,
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Column(
//       children: [
//         Container(
//           width: 44,
//           height: 44,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             shape: BoxShape.circle,
//             border: Border.all(color: color.withOpacity(0.3)),
//           ),
//           child: Icon(icon, color: color, size: 22),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[700],
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     ),
//   );
// }
//   // 4. STUDENT SMALL LIST CARD
//   Widget _buildStudentSmallCard(Profile profile, bool isDark) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(10),
//       height: 90,
//       decoration: BoxDecoration(
//         color: isDark ? kCardDark : Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: CachedNetworkImage(imageUrl: profile.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(profile.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
//                 Text("Student • ${profile.age}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Iconsax.book, size: 12, color: kEliteGold),
//                     const SizedBox(width: 4),
//                     Text(profile.interests.first, style: TextStyle(color: kEliteGold, fontSize: 11)),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           IconButton(onPressed: (){}, icon: Icon(Iconsax.message, color: isDark ? Colors.white70 : Colors.black54)),
//         ],
//       ),
//     ).animate().slideX();
//   }

//   // 5. TRAVEL LANDSCAPE CARD
//   Widget _buildTravelLandscapeCard(Profile profile, bool isDark) {
//     return Container(
//       height: 200,
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         image: DecorationImage(image: CachedNetworkImageProvider(profile.imageUrl), fit: BoxFit.cover),
//       ),
//       child: Stack(
//         children: [
//           // Gradient from bottom
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.center, colors: [Colors.black.withOpacity(0.8), Colors.transparent]),
//             ),
//           ),
//           // Location Badge Top Left
//           Positioned(
//             top: 15, left: 15,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
//               child: Row(children: [const Icon(Iconsax.airplane, color: Colors.white, size: 12), const SizedBox(width: 4), Text(profile.location, style: const TextStyle(color: Colors.white, fontSize: 11))]),
//             ),
//           ),
//           // Info Bottom
//           Positioned(
//             bottom: 15, left: 15, right: 15,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(profile.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//                     const Text("Travel Companion", style: TextStyle(color: Colors.white70, fontSize: 12)),
//                   ],
//                 ),
//                 _circleBtn(Iconsax.send_2, kEliteGold, Colors.black),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper for round buttons
//   Widget _circleBtn(IconData icon, Color bg, Color iconColor) {
//     return Container(
//       width: 45, height: 45,
//       decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
//       child: Icon(icon, color: iconColor, size: 20),
//     );
//   }
// }// Separate like button widget with animation
// class _LikeButton extends StatefulWidget {
//   final Profile profile;
//   final ValueChanged<bool> onLiked;

//   const _LikeButton({required this.profile, required this.onLiked});

//   @override
//   __LikeButtonState createState() => __LikeButtonState();
// }

// class __LikeButtonState extends State<_LikeButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   bool _isLiked = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _isLiked = widget.profile.isOnline; // Assuming Profile has isLiked property
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _toggleLike() {
//     setState(() {
//       _isLiked = !_isLiked;
//       if (_isLiked) {
//         _animationController.forward();
//         HapticFeedback.selectionClick();
//       } else {
//         _animationController.reverse();
//       }
//       widget.onLiked(_isLiked);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _toggleLike,
//       child: ScaleTransition(
//         scale: Tween(begin: 1.0, end: 1.2).animate(
//           CurvedAnimation(
//             parent: _animationController,
//             curve: Curves.elasticOut,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white.withOpacity(0.1),
//           ),
//           padding: const EdgeInsets.all(8),
//           child: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: _isLiked
//                 ? const Icon(Iconsax.heart5,
//                     color: Colors.red, size: 20, key: ValueKey('liked'))
//                 : const Icon(Iconsax.heart,
//                     color: Colors.white54, size: 20, key: ValueKey('unliked')),
//           ),
//         ),
//       ),
//     );
//   }
// }







