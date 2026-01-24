// import 'dart:ui';
// import 'package:dating/pages/maches/Likers_List_Page.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class MatchesPage extends StatefulWidget {
//   const MatchesPage({super.key});

//   @override
//   State<MatchesPage> createState() => _MatchesPageState();
// }

// class _MatchesPageState extends State<MatchesPage> with TickerProviderStateMixin {
//   late AnimationController _mainController;

//   final List<Map<String, String>> mockMatches = [
//     {"name": "Elena, 22", "img": "https://images.unsplash.com/photo-1494790108377-be9c29b29330", "status": "2km away"},
//     {"name": "Marcus, 26", "img": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e", "status": "Online"},
//     {"name": "Sofia, 24", "img": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1", "status": "Recently active"},
//     {"name": "Julian, 28", "img": "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d", "status": "5km away"},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _mainController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..forward();
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A), // Deep black background
//       body: Stack(
//         children: [
//           // 1. TOP GRADIENT BACKGROUND SECTION
//           _buildTopGradient(),

//           SafeArea(
//             child: CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               slivers: [
//                 // 2. CUSTOM APP BAR
//                 _buildHeader(),

//                 // 3. LIKED YOU SECTION (PREMIUM CARD DESIGN)
//                 SliverToBoxAdapter(child: _buildPremiumLikedSection()),

//                 // 4. FILTER CHIPS
// SliverToBoxAdapter(
//       // color: AppColors.deepBlack.withOpacity(0.8),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(width: 40),
//             Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                'MATCHES',
//                 style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: 1),
//               ),
//             ),
//             Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
//             const SizedBox(width: 40),
//           ],
//         ),
//       ),
//     ),
//                 // 5. MATCHES GRID
//               // 5. PREMIUM MATCHES LIST
// SliverPadding(
//   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//   sliver: SliverList(
//     delegate: SliverChildBuilderDelegate(
//       (context, index) {
//         final item = mockMatches[index % mockMatches.length];
//         return _buildSplitGlassCard(
//           item['img']!, 
//           item['name']!, 
//           item['status']!, 
//           // true, // Mocking live status
//         );
//       },
//       childCount: 8,
//     ),
//   ),
// ),
//                 const SliverToBoxAdapter(child: SizedBox(height: 100)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopGradient() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       height: MediaQuery.of(context).size.height * 0.45,
//       child: Container(
//         decoration: BoxDecoration(
//        gradient: LinearGradient(
//             colors: [
//               const Color(0xFFFF4D67).withOpacity(0.25), Colors.transparent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
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
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                Text(
//                   "Matches",
//                   style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1),
//                 ),
//                 const Text(
//                   "People who sparked with you",
//                   style: TextStyle(color: Colors.white38, fontSize: 14),
//                 ),
//               ],
//             ),
//             _glassButton(Iconsax.setting_4),
//           ],
//         ),
//       ),
//     );
//   }

//  Widget _buildPremiumLikedSection() {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//     height: 60, // Slightly slimmer for a more professional "banner" look
//     child: Stack(
//       children: [
//         // 1. MAIN BACKGROUND WITH GLASS EFFECT & GRADIENT BORDER
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             // gradient: LinearGradient(
//             //   begin: Alignment.topLeft,
//             //   end: Alignment.bottomRight,
//             //   colors: [
//             //     Colors.amber.withOpacity(0.15),
//             //     Colors.amber.withOpacity(0.03),
//             //     Colors.white.withOpacity(0.02),
//             //   ],
//             // ),
//             // border: Border.all(
//             //   color: Colors.amber.withOpacity(0.2),
//             //   width: 1,
//             // ),
//           ),
//         ),

//         // 2. INNER CONTENT
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             children: [
//               // AVATAR STACK
//               SizedBox(
//                 width: 80,
//                 height: 50,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: List.generate(3, (index) {
//                     return Positioned(
//                       left: index * 18.0,
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: .5),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 8,
//                               offset: const Offset(2, 2),
//                             )
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               Image.network(mockMatches[index]['img']!),
//                               // The "Mystery" Blur
//                               BackdropFilter(
//                                 filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
//                                 child: Container(color: Colors.black.withOpacity(0.1)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
              
//               const SizedBox(width: 3),

//               // TEXT SECTION
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Text(
//                           "12 People liked you",
//                           style: TextStyle(
//                             color: Colors.white, 
//                             fontWeight: FontWeight.w900, 
//                             fontSize: 15,
//                             letterSpacing: 0.2
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Icon(Iconsax.heart5, color: Colors.amber[400], size: 16),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       "See who wants to connect",
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.5), 
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // ACTION BUTTON (UPGRADED TO GRADIENT)
//               Container(height: 35,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // Gold to Orange-Gold
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
             
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) {
//                       return LikersListPage();
//                     },));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   ),
//                   child: const Text(
//                     "See All",
//                     style: TextStyle(
//                       color: Colors.black, 
//                       fontWeight: FontWeight.w700, 
//                       fontSize: 10
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildSplitGlassCard(String url, String name, String status) {
//   return Container(
//     height: 135, // Increased height for more content
//     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(30),
//       gradient: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           Colors.white.withOpacity(0.12), 
//           Colors.white.withOpacity(0.03)
//         ],
//       ),
//       // border: Border.all(color: Colors.white.withOpacity(0.1)),
//     ),
//     child: Row(
//       children: [
//         // --- LEFT SIDE: IMAGE + ONLINE STATUS ---
//         Stack(
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.horizontal(left: Radius.circular(30)),
//               child: Image.network(url, width: 130, height: 165, fit: BoxFit.cover),
//             ),
//             // Online Dot on Image
//             Positioned(
//               top: 12,
//               left: 12,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(10),
//                   // backdropFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                 ),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
//                     const SizedBox(width: 4),
//                     Text("ONLINE", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 8, fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),

//         // --- RIGHT SIDE: DETAILED CONTENT ---
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(12, 12, 15, 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 1. Name and Verification
//                 Row(
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(width: 5),
//                     const Icon(Icons.verified, size: 16, color: Colors.blueAccent),
//                   ],
//                 ),
                
//                 // // 2. Location/Distance
              

//                 const SizedBox(height: 10),
//  Text(
//                           "Professional Designer • 2.5km away",
//                           style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
//                         ),
//                 // 3. INTEREST TAGS (New Content)
//                 // Wrap(
//                 //   spacing: 6,
//                 //   runSpacing: 6,
//                 //   children: [
//                 //     _buildDataTag("Travel", Iconsax.cloud_sunny),
//                 //     _buildDataTag("Music", Iconsax.music),
//                 //     _buildDataTag("Gaming", Iconsax.game),
//                 //   ],
//                 // ),

//                 const Spacer(),

//                 // 4. ACTION BUTTONS
//                 Row(
//                   children: [
//                     _smallActionButton(Iconsax.message5, "Chat"),
//                     const SizedBox(width: 8),
//                     _smallActionButton(Iconsax.video5, "Call", isPrimary: true),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }

// // Helper for Interest Tags
// Widget _buildDataTag(String label, IconData icon) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     decoration: BoxDecoration(
//       color: Colors.white.withOpacity(0.05),
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(color: Colors.white.withOpacity(0.05)),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 10, color: Colors.white.withOpacity(0.6)),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.w500),
//         ),
//       ],
//     ),
//   );
// }

// // Button Helper (Updated for better sizing)
// Widget _smallActionButton(IconData icon, String label, {bool isPrimary = false}) {
//   return Expanded(
//     child: Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: isPrimary ? Colors.amber : Colors.white.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 14, color: isPrimary ? Colors.black : Colors.white),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               color: isPrimary ? Colors.black : Colors.white, 
//               fontSize: 11, 
//               fontWeight: FontWeight.bold
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// // Widget _smallActionButton(IconData icon, String label, {bool isPrimary = false}) {
// //   return Container(
// //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //     decoration: BoxDecoration(
// //       color: isPrimary ? Colors.amber : Colors.white.withOpacity(0.1),
// //       borderRadius: BorderRadius.circular(12),
// //     ),
// //     child: Row(
// //       children: [
// //         Icon(icon, size: 14, color: isPrimary ? Colors.black : Colors.white),
// //         const SizedBox(width: 4),
// //         Text(label, style: TextStyle(color: isPrimary ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
// //       ],
// //     ),
// //   );
// // }
// // Helper for the circular action buttons
// Widget _buildActionButton(IconData icon, Color color) {
//   return Container(
//     height: 45,
//     width: 45,
//     decoration: BoxDecoration(
//       color: color,
//       shape: BoxShape.circle,
//       // backdropFilter: color.opacity < 1 ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) : null,
//       border: Border.all(color: Colors.white24),
//     ),
//     child: Icon(icon, color: Colors.white, size: 20),
//   );
// }

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
import 'package:dating/pages/maches/Likers_List_Page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> with TickerProviderStateMixin {
  late AnimationController _mainController;

  final List<Map<String, String>> mockMatches = [
    {"name": "Elena, 22", "img": "https://images.unsplash.com/photo-1494790108377-be9c29b29330", "status": "2km away"},
    {"name": "Marcus, 26", "img": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e", "status": "Online"},
    {"name": "Sofia, 24", "img": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1", "status": "Recently active"},
    {"name": "Julian, 28", "img": "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d", "status": "5km away"},
  ];

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep black background
      body: Stack(
        children: [
          // 1. TOP GRADIENT BACKGROUND SECTION
          _buildTopGradient(),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 2. CUSTOM APP BAR
                _buildHeader(),

                // 3. LIKED YOU SECTION (PREMIUM CARD DESIGN)
                SliverToBoxAdapter(child: _buildPremiumLikedSection()),

                // 4. FILTER CHIPS
SliverToBoxAdapter(
      // color: AppColors.deepBlack.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
               'MATCHES',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: 1),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
            const SizedBox(width: 40),
          ],
        ),
      ),
    ),
                // 5. MATCHES GRID
              // 5. PREMIUM MATCHES LIST
SliverPadding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  sliver: SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        final item = mockMatches[index % mockMatches.length];
        return _buildPremiumMatchCard(
          item['img']!, 
          item['name']!, 
          item['status']!, 
          isLive: index % 2 == 0, // Mocking live status
        );
      },
      childCount: 8,
    ),
  ),
),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
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
            colors: [
              const Color(0xFFFF4D67).withOpacity(0.25), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(
                  "Matches",
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1),
                ),
                const Text(
                  "People who sparked with you",
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ],
            ),
            _glassButton(Iconsax.setting_4),
          ],
        ),
      ),
    );
  }

 Widget _buildPremiumLikedSection() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
    height: 60, // Slightly slimmer for a more professional "banner" look
    child: Stack(
      children: [
        // 1. MAIN BACKGROUND WITH GLASS EFFECT & GRADIENT BORDER
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     Colors.amber.withOpacity(0.15),
            //     Colors.amber.withOpacity(0.03),
            //     Colors.white.withOpacity(0.02),
            //   ],
            // ),
            // border: Border.all(
            //   color: Colors.amber.withOpacity(0.2),
            //   width: 1,
            // ),
          ),
        ),

        // 2. INNER CONTENT
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // AVATAR STACK
              SizedBox(
                width: 80,
                height: 50,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: List.generate(3, (index) {
                    return Positioned(
                      left: index * 18.0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: .5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(2, 2),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(mockMatches[index]['img']!),
                              // The "Mystery" Blur
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Container(color: Colors.black.withOpacity(0.1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(width: 3),

              // TEXT SECTION
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "12 People liked you",
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.w900, 
                            fontSize: 15,
                            letterSpacing: 0.2
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Iconsax.heart5, color: Colors.amber[400], size: 16),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "See who wants to connect",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5), 
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),

              // ACTION BUTTON (UPGRADED TO GRADIENT)
              Container(height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // Gold to Orange-Gold
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
             
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return LikersListPage();
                    },));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.w700, 
                      fontSize: 10
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget _buildPremiumMatchCard(String url, String name, String status, {bool isLive = false}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    height: 280, // Larger, more impactful height
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.network(url, fit: BoxFit.cover),

          // 2. Dark Gradient Overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // 3. Top "Live" or "Status" Badge
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isLive ? Colors.red.withOpacity(0.9) : Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  if (isLive)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: CircleAvatar(radius: 3, backgroundColor: Colors.white),
                    ),
                  Text(
                    isLive ? "LIVE" : "RECENTLY ACTIVE",
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Information Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Name and Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Iconsax.location5, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Small bio or interests snippet
                        Text(
                          "Professional Designer • 2.5km away",
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // 5. Action Buttons (Message & Call)
                  Row(
                    children: [
                      _buildActionButton(Iconsax.message_text5, Colors.white.withOpacity(0.2)),
                      const SizedBox(width: 10),
                      _buildActionButton(Iconsax.call5, Colors.amber),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper for the circular action buttons
Widget _buildActionButton(IconData icon, Color color) {
  return Container(
    height: 45,
    width: 45,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      // backdropFilter: color.opacity < 1 ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) : null,
      border: Border.all(color: Colors.white24),
    ),
    child: Icon(icon, color: Colors.white, size: 20),
  );
}

  Widget _glassButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}




























// import 'dart:ui';
// import 'package:dating/pages/maches/Likers_List_Page.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class MatchesPage extends StatefulWidget {
//   const MatchesPage({super.key});

//   @override
//   State<MatchesPage> createState() => _MatchesPageState();
// }

// class _MatchesPageState extends State<MatchesPage> with TickerProviderStateMixin {
//   late AnimationController _mainController;

//   final List<Map<String, String>> mockMatches = [
//     {"name": "Elena, 22", "img": "https://images.unsplash.com/photo-1494790108377-be9c29b29330", "status": "2km away"},
//     {"name": "Marcus, 26", "img": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e", "status": "Online"},
//     {"name": "Sofia, 24", "img": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1", "status": "Recently active"},
//     {"name": "Julian, 28", "img": "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d", "status": "5km away"},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _mainController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..forward();
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A), // Deep black background
//       body: Stack(
//         children: [
//           // 1. TOP GRADIENT BACKGROUND SECTION
//           _buildTopGradient(),

//           SafeArea(
//             child: CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               slivers: [
//                 // 2. CUSTOM APP BAR
//                 _buildHeader(),

//                 // 3. LIKED YOU SECTION (PREMIUM CARD DESIGN)
//                 SliverToBoxAdapter(child: _buildPremiumLikedSection()),

//                 // 4. FILTER CHIPS
// SliverToBoxAdapter(
//       // color: AppColors.deepBlack.withOpacity(0.8),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(width: 40),
//             Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                'MATCHES',
//                 style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: 1),
//               ),
//             ),
//             Expanded(child: Divider(color: Colors.white.withOpacity(0.3), thickness: 0.8)),
//             const SizedBox(width: 40),
//           ],
//         ),
//       ),
//     ),
//                 // 5. MATCHES GRID
//                 SliverPadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   sliver: SliverGrid(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 20,
//                       crossAxisSpacing: 20,
//                       childAspectRatio: 0.7,
//                     ),
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         final item = mockMatches[index % mockMatches.length];
//                         return _buildMatchCard(item['img']!, item['name']!, item['status']!);
//                       },
//                       childCount: 8,
//                     ),
//                   ),
//                 ),
//                 const SliverToBoxAdapter(child: SizedBox(height: 100)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopGradient() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       height: MediaQuery.of(context).size.height * 0.45,
//       child: Container(
//         decoration: BoxDecoration(
//        gradient: LinearGradient(
//             colors: [
//               const Color(0xFFFF4D67).withOpacity(0.25), Colors.transparent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
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
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                Text(
//                   "Matches",
//                   style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1),
//                 ),
//                 const Text(
//                   "People who sparked with you",
//                   style: TextStyle(color: Colors.white38, fontSize: 14),
//                 ),
//               ],
//             ),
//             _glassButton(Iconsax.setting_4),
//           ],
//         ),
//       ),
//     );
//   }

//  Widget _buildPremiumLikedSection() {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
//     height: 60, // Slightly slimmer for a more professional "banner" look
//     child: Stack(
//       children: [
//         // 1. MAIN BACKGROUND WITH GLASS EFFECT & GRADIENT BORDER
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             // gradient: LinearGradient(
//             //   begin: Alignment.topLeft,
//             //   end: Alignment.bottomRight,
//             //   colors: [
//             //     Colors.amber.withOpacity(0.15),
//             //     Colors.amber.withOpacity(0.03),
//             //     Colors.white.withOpacity(0.02),
//             //   ],
//             // ),
//             // border: Border.all(
//             //   color: Colors.amber.withOpacity(0.2),
//             //   width: 1,
//             // ),
//           ),
//         ),

//         // 2. INNER CONTENT
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             children: [
//               // AVATAR STACK
//               SizedBox(
//                 width: 80,
//                 height: 50,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: List.generate(3, (index) {
//                     return Positioned(
//                       left: index * 18.0,
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: .5),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 8,
//                               offset: const Offset(2, 2),
//                             )
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               Image.network(mockMatches[index]['img']!),
//                               // The "Mystery" Blur
//                               BackdropFilter(
//                                 filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
//                                 child: Container(color: Colors.black.withOpacity(0.1)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
              
//               const SizedBox(width: 3),

//               // TEXT SECTION
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Text(
//                           "12 People liked you",
//                           style: TextStyle(
//                             color: Colors.white, 
//                             fontWeight: FontWeight.w900, 
//                             fontSize: 15,
//                             letterSpacing: 0.2
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Icon(Iconsax.heart5, color: Colors.amber[400], size: 16),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       "See who wants to connect",
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.5), 
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // ACTION BUTTON (UPGRADED TO GRADIENT)
//               Container(height: 35,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // Gold to Orange-Gold
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
             
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) {
//                       return LikersListPage();
//                     },));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   ),
//                   child: const Text(
//                     "See All",
//                     style: TextStyle(
//                       color: Colors.black, 
//                       fontWeight: FontWeight.w700, 
//                       fontSize: 10
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }




//   Widget _buildMatchCard(String url, String name, String status) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(30),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.network(url, fit: BoxFit.cover),
//             // Bottom Info Panel
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.8),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         const Icon(Iconsax.location5, size: 10, color: Colors.amber),
//                         const SizedBox(width: 4),
//                         Text(
//                           status,
//                           style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
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










// import 'dart:convert';
// import 'dart:ui';
// import 'package:dating/main.dart';
// import 'package:dating/models/my_user_profile.dart';
// import 'package:dating/pages/first_page.dart';
// import 'package:dating/pages/home/widgets/profile_shimmer.dart';
// import 'package:dating/providers/my_profile_provider.dart';
// import 'package:dating/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import '../providers/profile_provider.dart';
// import 'my profile/my_profile.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
  
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch user profile when widget initializes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadUserProfile();
//     });
//   }
  
//   void _loadUserProfile()async {
//     // Get userId from shared preferences or auth service
//     // For example, assuming you have stored userId after login


    // final userId = await AuthService().getUserId();




    // context.read<MyProfileProvider>().fetchUserProfile(userId??'');
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = context.watch<MyProfileProvider>();
    
//     if (profileProvider.isLoading) {
//       return const ProfileShimmer();
//     }
    
//     if (profileProvider.error != null) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, color: Colors.red, size: 64),
//               const SizedBox(height: 20),
//               Text(
//                 'Failed to load profile',
//                 style: TextStyle(color: Colors.white.withOpacity(0.7)),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 profileProvider.error!,
//                 style: TextStyle(color: Colors.white.withOpacity(0.5)),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _loadUserProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                 ),
//                 child: const Text('Retry', style: TextStyle(color: Colors.black)),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
    
//     final userProfile = profileProvider.userProfile;
//     if (userProfile == null) {
//       return const ProfileShimmer();
//     }
    
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           _buildFullScreenBlurredBg(userProfile.photo),
//           SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTopNav(context),
//                   _buildMainProfileHero(context, userProfile),
//                   const SizedBox(height: 30),
//                   _buildStatsRow(),
//                   const SizedBox(height: 30),
//                   _buildPremiumMembershipCard(),
//                   const SizedBox(height: 30),
//                   _buildSectionLabel("YOUR POWER TOOLS"),
//                   _buildActionGrid(),
//                   const SizedBox(height: 30),
//                   _buildSectionLabel("ACCOUNT & PRIVACY"),
//                   _buildGlassySettingsCard(userProfile),
//                   const SizedBox(height: 20),
//                   _buildLogoutButton(context),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildFullScreenBlurredBg(String? imageUrl) {
//     return Stack(
//       children: [
//         if (imageUrl != null && imageUrl.isNotEmpty)
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(imageUrl),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         Positioned.fill(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
//             child: Container(color: Colors.black.withOpacity(0.5)),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               stops: const [0.0, 0.4, 0.9],
//               colors: [
//                 Colors.black.withOpacity(0.8),
//                 Colors.black.withOpacity(0.2),
//                 Colors.black,
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildTopNav(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("My Studio",
//                   style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
//               Text("Manage your presence",
//                   style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
//             ],
//           ).animate().fadeIn().slideX(begin: -0.1),
//           _glassContainer(
//             padding: const EdgeInsets.all(10),
//             color: AppColors.neonGold.withOpacity(0.9),
//             child: const Icon(Iconsax.flash_1, color: Colors.black, size: 22),
//           ).animate().fadeIn().scale(),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildMainProfileHero(BuildContext context, MyUserProfile userProfile) {
//     return GestureDetector(
//       onTap: () => Navigator.of(context).push(_createRoute(MyDetailedProfilePage(userProfile: userProfile))),
//       child: Center(
//         child: Column(
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   height: 170, width: 170,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: AppColors.neonPink.withOpacity(0.2), width: 2),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   child: Hero(
//                     tag: 'profile_pic',
//                     child: CircleAvatar(
//                       radius: 75,
//                       backgroundImage: NetworkImage(userProfile.photo),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Text("${userProfile.userName}, ${userProfile.age}",
//                 style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
//             if (userProfile.gender.name.isNotEmpty)
//               Text(userProfile.gender.name.toUpperCase(),
//                   style: TextStyle(color: AppColors.neonGold, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3)),
//             const SizedBox(height: 5),
//             Text("VIEW DETAILED PROFILE", 
//                 style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
//           ],
//         ),
//       ),
//     ).animate().fadeIn(duration: 600.ms);
//   }
  
//   Widget _buildStatsRow() {
//     // You can replace these with actual stats from your API
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _statItem("1.2k", "Likes"),
//         _vDivider(),
//         _statItem("48", "Matches"),
//         _vDivider(),
//         _statItem("95", "Boosts"),
//       ],
//     ).animate().fadeIn(delay: 200.ms);
//   }
  
//   Widget _statItem(String value, String label) {
//     return Column(
//       children: [
//         Text(value, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//         Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
//       ],
//     );
//   }
  
//   Widget _vDivider() {
//     return Container(
//       height: 25, width: 1,
//       color: Colors.white.withOpacity(0.1),
//       margin: EdgeInsets.symmetric(horizontal: 30),
//     );
//   }
  
//   Widget _buildPremiumMembershipCard() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 18),
//       child: Container(
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(28),
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [AppColors.neonGold.withOpacity(0.9), Color(0xFFFFA500).withOpacity(0.5)],
//                       begin: Alignment.topLeft, end: Alignment.bottomRight,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), shape: BoxShape.circle),
//                       child: Icon(Iconsax.crown_1, color: Colors.white, size: 26),
//                     ),
//                     SizedBox(width: 15),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Upgrade to Gold",
//                               style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
//                           Text("See who likes you",
//                               style: TextStyle(color: Colors.white70, fontSize: 11)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
//                       child: Text("UPGRADE",
//                           style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900)),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ).animate().slideY(begin: 0.2, curve: Curves.easeOutQuad);
//   }
  
//   Widget _buildActionGrid() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: GridView.count(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         crossAxisCount: 2,
//         mainAxisSpacing: 15,
//         crossAxisSpacing: 15,
//         childAspectRatio: 1.4,
//         children: [
//           _powerToolItem(Iconsax.edit, "Edit Profile", "Update your bio", AppColors.neonPink),
//           _powerToolItem(Iconsax.eye, "Preview", "View as others", Colors.blueAccent),
//           _powerToolItem(Iconsax.chart_21, "Statistics", "Track your growth", Colors.greenAccent),
//           _powerToolItem(Iconsax.medal_star, "Verify Me", "Get blue badge", AppColors.neonGold),
//         ],
//       ),
//     );
//   }
  
//   Widget _powerToolItem(IconData icon, String title, String sub, Color color) {
//     return _glassContainer(
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: color, size: 26),
//             SizedBox(height: 10),
//             Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//             Text(sub, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _buildGlassySettingsCard(MyUserProfile userProfile) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: _glassContainer(
//         child: Column(
//           children: [
//             _settingsTile(Iconsax.user, "Bio", userProfile.bio.isNotEmpty ? userProfile.bio : "No bio added"),
//             if (userProfile.city.isNotEmpty)
//               _settingsTile(Iconsax.location, "Location", "${userProfile.city}, ${userProfile.state}"),
//             if (userProfile.education.name.isNotEmpty)
//               _settingsTile(Iconsax.book, "Education", userProfile.education.name),
//             if (userProfile.job.isNotEmpty)
//               _settingsTile(Iconsax.briefcase, "Occupation", userProfile.job),
//             if (userProfile.interests.isNotEmpty)
//               _settingsTile(Iconsax.heart, "Interests", 
//                   userProfile.interests.map((i) => i.name).join(', ')),
//             _settingsTile(Iconsax.setting, "App Settings", "General preferences"),
//             _settingsTile(Iconsax.security_safe, "Privacy", "Control visibility", isLast: true),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _settingsTile(IconData icon, String title, String sub, {bool isLast = false}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white70, size: 20),
//       title: Text(title, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
//       subtitle: Text(sub, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
//       trailing: Icon(Iconsax.arrow_right_3, color: Colors.white24, size: 14),
//       shape: isLast ? null : Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
//       onTap: () {},
//     );
//   }
  
//   Widget _buildLogoutButton(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: InkWell(
//         onTap: () => _showLogoutBottomSheet(context),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Iconsax.logout, color: Colors.red, size: 20),
//                   ),
//                   SizedBox(width: 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Logout",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                         SizedBox(height: 2),
//                         Text(
//                           "Sign out from this device",
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.5),
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Text(
//                       "LOGOUT",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w900,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
//   }
  
//   void _showLogoutBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       barrierColor: Colors.black54,
//       isScrollControlled: true,
//       builder: (context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             padding: EdgeInsets.all(30),
//             decoration: BoxDecoration(
//               color: Color(0xFF1A1A1A).withOpacity(0.9),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 4, width: 40,
//                   decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
//                 ),
//                 SizedBox(height: 30),
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
//                   child: Icon(Iconsax.logout, color: Colors.red, size: 40),
//                 ).animate().shake(duration: 500.ms),
//                 SizedBox(height: 20),
//                 Text("Sign Out?", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
//                 SizedBox(height: 10),
//                 Text(
//                   "Are you sure you want to leave? 🥺\nWe'll miss you and your energy! ✨",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
//                 SizedBox(height: 35),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text("CANCEL", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                     SizedBox(width: 15),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           await AuthService().logout();
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(builder: (context) => DatingIntroScreen()),
//                             (route) => false,
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//                         ),
//                         child: Text("LOGOUT", style: TextStyle(fontWeight: FontWeight.w900)),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//               ],
//             ).animate().slideY(begin: 1, duration: 400.ms, curve: Curves.easeOutQuad),
//           ),
//         );
//       },
//     );
//   }
  
//   Widget _glassContainer({required Widget child, EdgeInsets? padding, Color? color}) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: Container(
//           padding: padding,
//           decoration: BoxDecoration(
//             color: color ?? Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: Colors.white.withOpacity(0.08)),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
  
//   Widget _buildSectionLabel(String label) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//       child: Text(label,
//           style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
//     );
//   }
// }

// Route _createRoute(Widget page) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => page,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(0.0, 0.1);
//       var end = Offset.zero;
//       var curve = Curves.easeOutExpo;
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      
//       return FadeTransition(
//         opacity: animation,
//         child: SlideTransition(position: animation.drive(tween), child: child),
//       );
//     },
//     transitionDuration: Duration(milliseconds: 600),
//   );
// }