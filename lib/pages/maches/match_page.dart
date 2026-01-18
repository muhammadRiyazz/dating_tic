



































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
      // backgroundColor: const Color(0xFF0A0A0A), // Deep black background
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
                width: 90,
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
























