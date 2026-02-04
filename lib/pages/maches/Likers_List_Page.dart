

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class LikersListPage extends StatefulWidget {
//   const LikersListPage({super.key});

//   @override
//   State<LikersListPage> createState() => _LikersListPageState();
// }

// class _LikersListPageState extends State<LikersListPage> {
//    final List<Map<String, dynamic>> likers = [
//     {
//       "name": "Elena Rodriguez",
//       "age": "22",
//       "img": "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
//       "match": "98%",
//       "bio": "Art curator & coffee enthusiast ☕",
//       "distance": "2.5 km",
//       "interests": ["Painting", "Coffee", "Museums", "Photography"],
//       "verified": true,
//       "online": true,
//       "time": "Just now"
//     },
//     {
//       "name": "Marcus Chen",
//       "age": "26",
//       "img": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
//       "match": "92%",
//       "bio": "Mountain guide & adventure seeker 🏔️",
//       "distance": "5.1 km",
//       "interests": ["Hiking", "Rock Climbing", "Camping", "Travel"],
//       "verified": true,
//       "online": false,
//       "time": "2 hours ago"
//     },
//     {
//       "name": "Sofia Patel",
//       "age": "24",
//       "img": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1",
//       "match": "85%",
//       "bio": "Professional chef & food blogger 👩‍🍳",
//       "distance": "3.7 km",
//       "interests": ["Cooking", "Travel", "Wine Tasting", "Yoga"],
//       "verified": true,
//       "online": true,
//       "time": "1 hour ago"
//     },
//     {
//       "name": "Julian Wright",
//       "age": "28",
//       "img": "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d",
//       "match": "88%",
//       "bio": "UI/UX Designer & digital nomad 💻",
//       "distance": "1.8 km",
//       "interests": ["Design", "Tech", "Minimalism", "Cafes"],
//       "verified": false,
//       "online": true,
//       "time": "Just now"
//     },
//     {
//       "name": "Sarah Miller",
//       "age": "23",
//       "img": "https://images.unsplash.com/photo-1517841905240-472988babdf9",
//       "match": "95%",
//       "bio": "Yoga instructor & meditation guide 🧘‍♀️",
//       "distance": "4.2 km",
//       "interests": ["Yoga", "Meditation", "Wellness", "Reading"],
//       "verified": true,
//       "online": false,
//       "time": "5 hours ago"
//     },
//     {
//       "name": "Alex Rivera",
//       "age": "27",
//       "img": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d",
//       "match": "90%",
//       "bio": "Music producer & vinyl collector 🎵",
//       "distance": "6.3 km",
//       "interests": ["Music", "Concerts", "Vinyl", "Production"],
//       "verified": true,
//       "online": true,
//       "time": "30 min ago"
//     },
//     {
//       "name": "Zara Khan",
//       "age": "25",
//       "img": "https://images.unsplash.com/photo-1534528741775-53994a69daeb",
//       "match": "87%",
//       "bio": "Architect & sustainable design advocate 🏛️",
//       "distance": "3.1 km",
//       "interests": ["Architecture", "Sustainability", "Art", "Design"],
//       "verified": false,
//       "online": true,
//       "time": "Just now"
//     },
//   ];


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: Stack(
//         children: [
//           // 1. TOP GRADIENT (Matching the Matches Page)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: MediaQuery.of(context).size.height * 0.45,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFFFF4D67).withOpacity(0.2), 
//                     Colors.transparent
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),

//           SafeArea(
//             child: CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               slivers: [
//                 // 2. CUSTOM APP BAR
//                 _buildHeader(context),

//                 // 3. TITLE SECTION
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Liked You",
//                           style: TextStyle(
//                             color: Colors.white, 
//                             fontSize: 32, 
//                             fontWeight: FontWeight.w900, 
//                             letterSpacing: -1
//                           ),
//                         ),
//                         Text(
//                           "They've already swiped right. Your move!",
//                           style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),





//                 // Filter Section
//                 SliverToBoxAdapter(
//                   child: _buildFilterSection(),
//                 ),

//                 // List Title
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Recent Likes",
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         Text(
//                           "See all",
//                           style: TextStyle(
//                             color: Colors.amber.withOpacity(0.8),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Likers List
//                 SliverPadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         final person = likers[index];
//                         return _buildLikerCard(person);
//                       },
//                       childCount: likers.length,
//                     ),
//                   ),

//                 ),



               
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildStatItem(String title, String value, IconData icon) {
//   //   return Column(
//   //     children: [
//   //       Container(
//   //         width: 40,
//   //         height: 40,
//   //         decoration: BoxDecoration(
//   //           color: Colors.white.withOpacity(0.05),
//   //           shape: BoxShape.circle,
//   //         ),
//   //         child: Icon(icon, color: Colors.amber, size: 20),
//   //       ),
//   //       const SizedBox(height: 8),
//   //       Text(
//   //         value,
//   //         style: const TextStyle(
//   //           color: Colors.white,
//   //           fontSize: 16,
//   //           fontWeight: FontWeight.w700,
//   //         ),
//   //       ),
//   //       Text(
//   //         title,
//   //         style: TextStyle(
//   //           color: Colors.white.withOpacity(0.5),
//   //           fontSize: 11,
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }



//   Widget _buildFilterSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             _buildFilterChip("All", true),
//             const SizedBox(width: 8),
//             _buildFilterChip("Online Now", false),
//             const SizedBox(width: 8),
//             _buildFilterChip("Nearby", false),
//             const SizedBox(width: 8),
//             _buildFilterChip("Verified", false),
//             const SizedBox(width: 8),
//             _buildFilterChip("High Match", false),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterChip(String text, bool active) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: active ? Colors.amber : Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: active ? Colors.amber : Colors.white.withOpacity(0.1),
//         ),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: active ? Colors.black : Colors.white.withOpacity(0.8),
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//  Widget _buildLikerCard(Map<String, dynamic> person) {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(24),
//       // border: Border.all(color: Colors.white.withOpacity(0.1)),
//       gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFFFF4D67).withOpacity(0.2), 
//                     Colors.transparent
//                                         , Color(0xFFFF4D67).withOpacity(0.03), 

//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomCenter,
//                 ),
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: GestureDetector(
//           onTap: () {},
//           child: Padding(
//             padding: const EdgeInsets.all(14.0),
//             child: Row(
//               children: [
//                 // Profile Image with Status Indicator
//                 Stack(
//                   children: [
//                     Container(
//                       width: 75,
//                       height: 85,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         image: DecorationImage(
//                           image: NetworkImage(person['img'] as String),
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           )
//                         ],
//                       ),
//                     ),
//                     if (person['online'] as bool)
//                       Positioned(
//                         bottom: 4,
//                         right: 4,
//                         child: Container(
//                           width: 14,
//                           height: 14,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF00FF85), // Neon Green
//                             shape: BoxShape.circle,
//                             border: Border.all(color: const Color(0xFF1A1A1A), width: 2.5),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),

//                 const SizedBox(width: 14),

//                 // Content Section
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         children: [
//                           Flexible(
//                             child: Text(
//                               person['name'] as String,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 0.5,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           if (person['verified'] as bool)
//                             const Icon(Iconsax.verify5, color: Colors.blue, size: 14),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Iconsax.location5, color: Colors.white.withOpacity(0.5), size: 10),
//                           const SizedBox(width: 4),
//                           Text(
//                             "${person['age']} • ${person['distance']} away",
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.5),
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         person['bio'] as String,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 12,
//                           height: 1.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Action Buttons (Vertical Layout for better thumb reach)
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8),
//                   child: Column(
//                     children: [
//                       _buildActionButton(
//                         icon: Iconsax.heart5,
//                         color: Colors.orangeAccent,
//                         onTap: () {},
//                         isPrimary: true,
//                       ),
//                       const SizedBox(height: 12),
//                       _buildActionButton(
//                         icon: Iconsax.close_circle,
//                         color: Colors.white.withOpacity(0.2),
//                         onTap: () {},
//                         isPrimary: false,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildActionButton({
//   required IconData icon,
//   required Color color,
//   required VoidCallback onTap,
//   required bool isPrimary,
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isPrimary ? null : color,
//         gradient: isPrimary
//             ? const LinearGradient(
//                 colors: [Color(0xFFFFB700), Color(0xFFFF8A00)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               )
//             : null,
//         boxShadow: isPrimary
//             ? [
//                 BoxShadow(
//                   color: Colors.orange.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 )
//               ]
//             : [],
//       ),
//       child: Icon(icon, color: Colors.white, size: 20),
//     ),
//   );
// }
//   Widget _buildHeader(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: _glassButton(Iconsax.arrow_left_2),
//             ),
//             _glassButton(Iconsax.setting_4),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLikerListTile(Map<String, dynamic> person) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.03),
//         borderRadius: BorderRadius.circular(28),
//         border: Border.all(color: Colors.white.withOpacity(0.05)),
//       ),
//       child: Row(
//         children: [
//           // LEFT SIDE: IMAGE
//           Stack(
//             children: [
//               Container(
//                 width: 90,
//                 height: 110,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   image: DecorationImage(
//                     image: NetworkImage(person['img']!),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               // Match Badge on Image
//               Positioned(
//                 bottom: 5,
//                 right: 5,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     person['match']!,
//                     style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(width: 16),

//           // MIDDLE: CONTENT
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${person['name']}, ${person['age']}",
//                   style: const TextStyle(
//                     color: Colors.white, 
//                     fontSize: 18, 
//                     fontWeight: FontWeight.bold
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   person['bio']!,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Icon(Iconsax.location5, color: Colors.amber.withOpacity(0.7), size: 14),
//                     const SizedBox(width: 4),
//                     Text(
//                       "2.5 km away",
//                       style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // RIGHT SIDE: ACTIONS
//           Column(
//             children: [
//               _actionButton(Iconsax.close_circle, Colors.white10, Colors.white54),
//               const SizedBox(height: 12),
//               _actionButton(Iconsax.heart5, Colors.amber.withOpacity(0.2), Colors.amber),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _actionButton(IconData icon, Color bgColor, Color iconColor) {
//     return Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         color: bgColor,
//         shape: BoxShape.circle,
//       ),
//       child: Icon(icon, color: iconColor, size: 20),
//     );
//   }

//   Widget _glassButton(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Icon(icon, color: Colors.white, size: 22),
//     );
//   }
// }



import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/maches/widgets/likers_shimmer.dart';
import 'package:dating/pages/maches/widgets/video_style_card.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/providers/likers_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LikersListPage extends StatefulWidget {
  const LikersListPage({super.key});

  @override
  State<LikersListPage> createState() => _LikersListPageState();
}

class _LikersListPageState extends State<LikersListPage> {
  final PageController _pageController = PageController(viewportFraction: 0.78);
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (mounted) setState(() => _currentPage = _pageController.page!);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = await AuthService().getUserId();
      
      if (mounted) {
        context.read<LikersProvider>().fetchLikers(userId.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Consumer<LikersProvider>(
              builder: (context, provider, child) {
                bool hasLikers = !provider.isLoading && provider.likers.isNotEmpty;

                return Column(
                  children: [
                    _buildHeader(context),
                    
                    // Show PASS hint only if list is NOT empty
                    if (hasLikers) 
                      _buildActionHint(Icons.keyboard_arrow_up, "DRAG UP TO PASS", isTop: true),
                    
                    const Spacer(),

                    // if (provider.isLoading)
                    //   const LikersShimmer()
                    // else 
                    if (hasLikers)
                      _buildLikersCarousel(provider)
                    else
                      _buildEnhancedEmptyState(provider), // Premium Empty State

                    const Spacer(),

                    // Show MATCH hint only if list is NOT empty
                    if (hasLikers)
                      _buildActionHint(Icons.keyboard_arrow_down, "DRAG DOWN TO MATCH", isTop: false),
                    
                    const SizedBox(height: 30),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikersCarousel(LikersProvider provider) {
    return SizedBox(
      height: 480,
      child: PageView.builder(
        controller: _pageController,
        itemCount: provider.likers.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          double relativePosition = index - _currentPage;
          double scale = (1 - (relativePosition.abs() * .15)).clamp(0.8, 1.0);
          double opacity = (1 - (relativePosition.abs() * 0.4)).clamp(0.5, 1.0);

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: InkWell(
                onTap: () {
                   HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProfileDetailsPage(profiledata: provider.likers[index],goalName:provider.likers[index].relationshipGoal!.name,match: true,);
          },));
                },
                
                child: VideoStyleCard(profile: provider.likers[index])),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedEmptyState(LikersProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing Background Circles
              ...List.generate(3, (index) => Container(
                height: 120 + (index * 40.0),
                width: 120 + (index * 40.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF4D67).withOpacity(0.1 - (index * 0.03))),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: (1000 + (index * 200)).ms,
                curve: Curves.easeInOut,
              )),
              
              const Icon(Iconsax.heart_search, color: AppColors.neonGold, size: 50),
            ],
          ),
      
                provider.isLoading?SizedBox():

      
      
          Column(children: [  const SizedBox(height: 40),
          const Text(
            "Nothing here yet",
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 12),
          Text(
            "It looks like no one has liked you yet. Don't worry, the perfect match is just a swipe away!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14, height: 1.5),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          const SizedBox(height: 35),
          ],)
        
          // Action Button
          
        ],
      ),
    );
  }

  Widget _buildActionHint(IconData icon, String label, {required bool isTop}) {
    return Column(
      children: [
        if (isTop) Icon(icon, color: Colors.white.withOpacity(0.2), size: 28)
            .animate(onPlay: (c) => c.repeat()).moveY(begin: 5, end: -5, duration: 1.5.seconds),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
              color: isTop ? Colors.white.withOpacity(0.2) : AppColors.neonGold.withOpacity(0.8), 
              fontSize: 10, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 2.5
            )),
        if (!isTop) const SizedBox(height: 6),
        if (!isTop) Icon(icon, color: AppColors.neonGold.withOpacity(0.8), size: 32)
            .animate(onPlay: (c) => c.repeat()).moveY(begin: -8, end: 8, duration: 1.2.seconds),
      ],
    );
  }

  Widget _buildBackgroundGradient() {
    return Positioned(
      top: 0, left: 0, right: 0,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFF4D67).withOpacity(0.2), Colors.transparent],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _glassButton(Iconsax.arrow_left_2, () => Navigator.pop(context)),
          Column(
            children: [
              SizedBox(height: 10,),
              const Text("Liked You",
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -1)),
              Text("Now Your move!",
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
          _glassButton(Iconsax.setting_4, () {}),
        ],
      ),
    );
  }

  Widget _glassButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}