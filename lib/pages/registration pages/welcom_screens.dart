// import 'package:dating/main.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// // Your AppColors Class
// // class AppColors {
// //   static const Color neonGold = Color(0xFFFFD700);
// //   static const Color richOrange = Color(0xFFFF8C00);
// //   static const Color valentineRed = Color(0xFFFF0055);
// //   static const Color deepBlack = Color(0xFF050505);
// //   static const Color cardBlack = Color(0xFF121212);
// //   static const Color glassBorder = Color(0x33FFFFFF);
// // }

// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   final PageController _controller = PageController();
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.deepBlack,
//       body: Stack(
//         children: [
//           // 1. Background Gradient Glow (Matches your HeightPage)
//           Positioned(
//             top: -100,
//             right: -100,
//             child: Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.neonGold.withOpacity(0.05),
//               ),
//             ),
//           ),

//           // 2. Main Page Content
//           PageView(
//             controller: _controller,
//             onPageChanged: (index) => setState(() => _currentIndex = index),
//             children: [
//               _buildPageOne(),   // Phone Mockups
//               _buildPageTwo(),   // Profile Connection Web
//               _buildPageThree(), // Chat Bubbles
//             ],
//           ),

//           // 3. Top Logo (Small C in the corner)
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 30, top: 20),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.cardBlack,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
//                 ),
//                 child: const Icon(Iconsax.heart5, color: AppColors.neonGold, size: 20),
//               ),
//             ),
//           ),

//           // 4. Bottom Controls (Dots, Skip, Get Started)
//           Positioned(
//             bottom: 50,
//             left: 30,
//             right: 30,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     // Pagination Dots
//                     Row(
//                       children: List.generate(3, (index) {
//                         return Container(
//                           margin: const EdgeInsets.only(right: 8),
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: _currentIndex == index 
//                                 ? AppColors.neonGold 
//                                 : Colors.grey.withOpacity(0.3),
//                           ),
//                         );
//                       }),
//                     ),
//                     const Spacer(),
//                     // Skip Button
//                     if (_currentIndex != 2)
//                       GestureDetector(
//                         onTap: () => _controller.jumpToPage(2),
//                         child: const Text(
//                           "Skip",
//                           style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 // Get Started Button (Only on last page)
//                 if (_currentIndex == 2)
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.neonGold,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                       ),
//                       onPressed: () {}, // Navigate to Login
//                       child: const Text(
//                         "Get Started",
//                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- SLIDE 1: PHONE MOCKUPS ---
//   Widget _buildPageOne() {
//     return _BaseLayout(
//       title: "Find Your\nSpecial Someone",
//       subtitle: "With our new exciting features connecting you with the right people.",
//       visualContent: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Dashed Circle Background
//           Container(
//             width: 250,
//             height: 250,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: AppColors.neonGold.withOpacity(0.1), width: 1),
//             ),
//           ),
//           // Main Phone Mockup
//           Positioned(
//             left: 40,
//             top: 60,
//             child: _phoneMockup(180, 100),
//           ),
//           // Secondary Phone Mockup
//           Positioned(
//             right: 30,
//             bottom: 80,
//             child: _phoneMockup(180, 100),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- SLIDE 2: CONNECTED PROFILES ---
//   Widget _buildPageTwo() {
//     return _BaseLayout(
//       title: "More Profiles,\nMore Dates",
//       subtitle: "Connecting you with more profiles across your city and beyond.",
//       visualContent: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Connecting Lines (Simulated with CustomPaint)
//           CustomPaint(
//             size: const Size(300, 300),
//             painter: LinePainter(),
//           ),
//           // Profile Circles
//           _profileCircle(80, AppColors.neonGold), // Center
//           Positioned(top: 40, left: 60, child: _profileCircle(40, Colors.grey)),
//           Positioned(top: 80, right: 50, child: _profileCircle(35, Colors.grey)),
//           Positioned(bottom: 100, left: 40, child: _profileCircle(45, Colors.grey)),
//           Positioned(bottom: 50, right: 80, child: _profileCircle(30, Colors.grey)),
//         ],
//       ),
//     );
//   }

//   // --- SLIDE 3: CHAT BUBBLES ---
//   Widget _buildPageThree() {
//     return _BaseLayout(
//       title: "Interact Around\nThe World",
//       subtitle: "Send direct messages to your matches and start the conversation.",
//       visualContent: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Background concentric circles
//           Container(
//             width: 280, height: 280,
//             decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.neonGold.withOpacity(0.05))),
//           ),
//           // Chat Bubbles
//           Positioned(
//             top: 70, left: 50,
//             child: _chatBubble(width: 150, height: 80, isLeft: true),
//           ),
//           Positioned(
//             bottom: 100, right: 40,
//             child: _chatBubble(width: 140, height: 80, isLeft: false),
//           ),
//           // Small avatars floating
//           Positioned(top: 50, right: 40, child: _profileCircle(30, AppColors.neonGold)),
//           Positioned(bottom: 60, left: 50, child: _profileCircle(30, AppColors.neonGold)),
//         ],
//       ),
//     );
//   }

//   // REUSABLE COMPONENTS

//   Widget _phoneMockup(double h, double w) {
//     return Container(
//       height: h, width: w,
//       decoration: BoxDecoration(
//         color: AppColors.cardBlack,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.white10, width: 2),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 10),
//           Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
//           const Spacer(),
//           Container(height: 40, width: double.infinity, color: AppColors.neonGold.withOpacity(0.1)),
//         ],
//       ),
//     );
//   }

//   Widget _profileCircle(double size, Color color) {
//     return Container(
//       width: size, height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColors.cardBlack,
//         border: Border.all(color: color.withOpacity(0.5), width: 1.5),
//         image: const DecorationImage(
//           image: NetworkImage('https://via.placeholder.com/150'), // Replace with your assets
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   Widget _chatBubble({required double width, required double height, required bool isLeft}) {
//     return Container(
//       width: width, height: height,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.cardBlack,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.neonGold.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//         children: [
//           Container(width: width * 0.7, height: 8, decoration: BoxDecoration(color: AppColors.neonGold.withOpacity(0.4), borderRadius: BorderRadius.circular(4))),
//           const SizedBox(height: 8),
//           Container(width: width * 0.4, height: 8, decoration: BoxDecoration(color: AppColors.neonGold.withOpacity(0.2), borderRadius: BorderRadius.circular(4))),
//         ],
//       ),
//     );
//   }
// }

// // Base Layout for titles and spacing
// class _BaseLayout extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final Widget visualContent;

//   const _BaseLayout({required this.title, required this.subtitle, required this.visualContent});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 120),
//           Expanded(child: visualContent),
//           ShaderMask(
//             shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, AppColors.neonGold]).createShader(bounds),
//             child: Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, height: 1.1)),
//           ),
//           const SizedBox(height: 15),
//           Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.grey.shade400, height: 1.4)),
//           const SizedBox(height: 150),
//         ],
//       ),
//     );
//   }
// }

// // Custom Painter for the web of lines in Slide 2
// class LinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppColors.neonGold.withOpacity(0.15)
//       ..strokeWidth = 1.0;
    
//     Offset center = Offset(size.width / 2, size.height / 2);
//     canvas.drawLine(center, const Offset(60, 40), paint);
//     canvas.drawLine(center, const Offset(250, 80), paint);
//     canvas.drawLine(center, const Offset(40, 220), paint);
//     canvas.drawLine(center, const Offset(220, 250), paint);
//   }
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
































// import 'package:dating/main.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// // Assuming your AppColors are defined globally as provided
// // class AppColors {
// //   static const Color neonGold = Color(0xFFFFD700);
// //   static const Color richOrange = Color(0xFFFF8C00);
// //   static const Color valentineRed = Color(0xFFFF0055);
// //   static const Color deepBlack = Color(0xFF050505);
// //   static const Color cardBlack = Color(0xFF121212);
// // }

// class PostRegistrationTour extends StatefulWidget {
//   const PostRegistrationTour({super.key});

//   @override
//   State<PostRegistrationTour> createState() => _PostRegistrationTourState();
// }

// class _PostRegistrationTourState extends State<PostRegistrationTour> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.deepBlack,
//       body: Stack(
//         children: [
//           // Background subtle glow
//           Positioned(
//             top: -100,
//             left: -50,
//             child: Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.neonGold.withOpacity(0.03),
//               ),
//             ),
//           ),

//           // Main Content
//           Column(
//             children: [
//               Expanded(
//                 child: PageView(
//                   controller: _pageController,
//                   onPageChanged: (index) => setState(() => _currentPage = index),
//                   children: [
//                     _buildDiscoveryPage(),
//                     _buildMatchingPage(),
//                     _buildInteractionPage(),
//                   ],
//                 ),
//               ),
              
//               // Bottom Footer Area
//               _buildFooter(),
//             ],
//           ),

//           // Top Branding
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 30, top: 20),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.cardBlack,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
//                 ),
//                 child: const Icon(Iconsax.flash_15, color: AppColors.neonGold, size: 20),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- PAGE 1: DISCOVERY (Phone Mockups) ---
//   Widget _buildDiscoveryPage() {
//     return _BaseTourPage(
//       title: "Find Your\nSpecial Someone",
//       description: "Our algorithm connects you with people who share your vibe and interests.",
//       visual: Stack(
//         alignment: Alignment.center,
//         children: [
          
//           // Dashed Orbital Lines
//           CustomPaint(
//             size: const Size(300, 500),
//             painter: CircleDashedPainter(),
//           ),
//           // Back Phone
//           Positioned(
//             right: 70,
//             top: 110,
//             child: _phoneMockup(height: 190, width: 110, color: AppColors.neonGold.withOpacity(0.1)),
//           ),
//           // Front Phone
//           Positioned(
//             left: 50,
//             bottom: 50,
//             child: _phoneMockup(height: 190, width: 110, color: AppColors.neonGold.withOpacity(0.2)),
//           ),
//         ],
//       ),
//     );
//   }

  

//   // --- PAGE 2: MATCHING (Profile Web) ---
//   Widget _buildMatchingPage() {
//     return _BaseTourPage(
//       title: "More Profiles,\nMore Dates",
//       description: "Access a wider network of verified profiles tailored just for you.",
//       visual: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Connection Lines
//           CustomPaint(
//             size: const Size(300, 300),
//             painter: WebLinePainter(),
//           ),
//           // Avatars scattered like the screenshot
//           _avatar(65, AppColors.neonGold), // Main
//           Positioned(top: 40, right: 70, child: _avatar(35, Colors.white24)),
//           Positioned(top: 100, left: 40, child: _avatar(45, Colors.white24)),
//           Positioned(bottom: 80, right: 40, child: _avatar(40, Colors.white24)),
//           Positioned(bottom: 40, left: 80, child: _avatar(30, Colors.white24)),
//           // Floating small heart
//           Positioned(top: 60, left: 100, child: Icon(Iconsax.heart5, color: AppColors.valentineRed.withOpacity(0.5), size: 14)),
//         ],
//       ),
//     );
//   }



 
//   // --- PAGE 3: INTERACTION (Chat Bubbles) ---
  // Widget _buildInteractionPage() {
  //   return _BaseTourPage(
  //     title: "Interact Around\nThe World",
  //     description: "Break the ice with instant messaging and video call features.",
  //     visual: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         // Background rings
  //         Container(
  //           width: 250, height: 260,
  //           decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.05))),
  //         ),
  //         // Top Chat Bubble
  //         Positioned(
  //           top: 100, left: 40,
  //           child: _chatBubble(isLeft: true),
  //         ),
  //         // Bottom Chat Bubble
  //         Positioned(
  //           bottom: 100, right: 40,
  //           child: _chatBubble(isLeft: false),
  //         ),
  //         // Floating Profile Avatars
  //         Positioned(top: 65, left: 30, child: _avatar(30, AppColors.neonGold)),
  //         Positioned(bottom: 80, right: 30, child: _avatar(30, AppColors.neonGold)),
  //       ],
  //     ),
  //   );
  // }

//   // --- REUSABLE COMPONENTS ---

//   Widget _buildFooter() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               // Indicators
//               Row(
//                 children: List.generate(3, (index) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.only(right: 6),
//                   width: _currentPage == index ? 20 : 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: _currentPage == index ? AppColors.neonGold : Colors.white24,
//                   ),
//                 )),
//               ),
//               const Spacer(),
//               if (_currentPage != 2)
//                 TextButton(
//                   onPressed: () => _pageController.jumpToPage(2),
//                   child: const Text("Skip", style: TextStyle(color: Colors.grey)),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 30),
//           SizedBox(
//             width: double.infinity,
//             height: 58,
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_currentPage < 2) {
//                   _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.ease);
//                 } else {
//                   // Final logic: go to Home
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.neonGold,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//               ),
//               child: Text(
//                 _currentPage == 2 ? "Get Started" : "Next",
//                 style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _phoneMockup({required double height, required double width, required Color color}) {
//     return Container(
//       height: height, width: width,
//       decoration: BoxDecoration(
//         color: AppColors.cardBlack,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.white12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15)],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: Column(
//           children: [
//             const SizedBox(height: 8),
//             Container(width: 30, height: 3, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
//             const Spacer(),
//             Container(height: 50, width: double.infinity, color: color),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _avatar(double size, Color borderColor) {
//     return Container(
//       width: size, height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColors.cardBlack,
//         border: Border.all(color: borderColor.withOpacity(0.5), width: 2),
//       ),
//       child: const Center(child: Icon(Iconsax.user, color: Colors.white24, size: 16)),
//     );
//   }

//   Widget _chatBubble({required bool isLeft}) {
//     return Container(
//       width: 160,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.cardBlack,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.neonGold.withOpacity(0.1)),
//       ),
//       child: Column(
//         crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//         children: [
//           Container(width: 100, height: 6, decoration: BoxDecoration(color: AppColors.neonGold.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
//           const SizedBox(height: 8),
//           Container(width: 60, height: 6, decoration: BoxDecoration(color: AppColors.neonGold.withOpacity(0.1), borderRadius: BorderRadius.circular(10))),
//         ],
//       ),
//     );
//   }
// }

// // --- SUPPORTING UI CLASSES ---

// class _BaseTourPage extends StatelessWidget {
//   final String title;
//   final String description;
//   final Widget visual;

//   const _BaseTourPage({required this.title, required this.description, required this.visual});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 100),
//           Expanded(child: visual),
//           ShaderMask(
//             shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, AppColors.neonGold]).createShader(bounds),
//             child: Text(title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, height: 1.1)),
//           ),
//           const SizedBox(height: 15),
//           Text(description, style: TextStyle(fontSize: 16, color: Colors.grey.shade400, height: 1.5)),
//           const SizedBox(height: 60),
//         ],
//       ),
//     );
//   }
// }

// class CircleDashedPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.white.withOpacity(0.05)..style = PaintingStyle.stroke..strokeWidth = 1;
//     canvas.drawCircle(Offset(size.width/2, size.height/2), 120, paint);
//     canvas.drawCircle(Offset(size.width/2, size.height/2), 160, paint);
//   }
//   @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class WebLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = AppColors.neonGold.withOpacity(0.1)..strokeWidth = 1;
//     Offset center = Offset(size.width/2, size.height/2);
//     canvas.drawLine(center, const Offset(60, 40), paint);
//     canvas.drawLine(center, const Offset(240, 60), paint);
//     canvas.drawLine(center, const Offset(40, 200), paint);
//     canvas.drawLine(center, const Offset(240, 220), paint);
//   }
//   @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }


























import 'package:dating/main.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math' as math;


class PremiumWelcomeTour extends StatefulWidget {
  const PremiumWelcomeTour({super.key});

  @override
  State<PremiumWelcomeTour> createState() => _PremiumWelcomeTourState();
}

class _PremiumWelcomeTourState extends State<PremiumWelcomeTour> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalTabs = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Stack(
        children: [
          // 1. Dynamic Background Glow (Changes position based on page)
          _buildBackgroundGlow(),

          // 2. Main Instruction Content
          Column(
            children: [
              const SizedBox(height: 60),
              // Top Progress Header
              _buildTopProgress(),
              
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    _pageDiscovery(),     // Discovery
                    _pageMatching(),      // Connections
                    // _buildInteractionPag;"(),   // Chat
                    _pageVerification(),  // Security
                    _pageInterests(),     // Hobbies
                    _pageTravel(),        // Global
                    _pageMoods(),         // Real-time Vibe
                    _pageFinal(),         // Ready to go
                  ],
                ),
              ),

              // 3. Bottom Action Area
              _buildBottomControls(),
            ],
















          ),
        ],
      ),
    );
  }
  Widget _buildInteractionPage() {
    return _BasePage(
      title: "Interact Around\nThe World",
      subtitle: "Break the ice with instant messaging and video call features.",
      visual: Stack(
        alignment: Alignment.center,
        children: [
          // Background rings
          Container(
            width: 250, height: 260,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.05))),
          ),
          // Top Chat Bubble
          Positioned(
            top: 100, left: 40,
            child: _chatBubble(isLeft: true ,width:120),
          ),
          // Bottom Chat Bubble
          Positioned(
            bottom: 100, right: 40,
            child: _chatBubble(isLeft: false,width: 130),
          ),
          // Floating Profile Avatars
          Positioned(top: 65, left: 30, child: _avatar(30, AppColors.neonGold)),
          Positioned(bottom: 80, right: 30, child: _avatar(30, AppColors.neonGold)),
        ],
      ),
    );
  }
  // --- INDIVIDUAL PAGE DESIGNS ---

  Widget _pageDiscovery() {
    return _BasePage(
      title: "Find Your\nSpecial Someone",
      subtitle: "Experience a curated feed of profiles designed to match your unique personality and lifestyle.",
      visual: Stack(
        alignment: Alignment.center,
        children: [
          _dashedCircle(280), _dashedCircle(200),
          Positioned(left: 30, child: _mockupPhone(180, 100, 15)),
          Positioned(right: 30, top: 40, child: _mockupPhone(180, 100, -10)),
        ],
      ),
    );
  }

  Widget _pageMatching() {
    return _BasePage(
      title: "More Profiles,\nMore Dates",
      subtitle: "Our deep-matching algorithm connects you with a global network of verified singles.",
      visual: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(300, 300), painter: ConnectionWebPainter()),
          _avatar(70, AppColors.neonGold, isMain: true),
          Positioned(top: 20, left: 40, child: _avatar(40, Colors.white10)),
          Positioned(top: 80, right: 30, child: _avatar(45, Colors.white10)),
          Positioned(bottom: 50, left: 60, child: _avatar(35, Colors.white10)),
          Positioned(bottom: 90, right: 70, child: _avatar(30, Colors.white10)),
        ],
      ),
    );
  }



  Widget _pageVerification() {
    return _BasePage(
      title: "Verified & \nAuthentic",
      subtitle: "No more catfishing. Our AI-powered verification ensures you only meet real people.",
      visual: Stack(
        alignment: Alignment.center,
        children: [
          _pulseCircle(220), _pulseCircle(160),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(color: AppColors.cardBlack, shape: BoxShape.circle, border: Border.all(color: AppColors.neonGold, width: 2)),
            child: const Icon(Iconsax.verify5, color: AppColors.neonGold, size: 60),
          ),
        ],
      ),
    );
  }

  Widget _pageInterests() {
    return _BasePage(
      title: "Shared Vibes,\nShared Lives",
      subtitle: "Select your passions and find someone who loves the same music, food, and adventures as you.",
      visual: Stack(
        alignment: Alignment.center,
        children: [
          _avatar(80, AppColors.neonGold),
          _floatingTag("🎵 Techno", -100, -80),
          _floatingTag("🍣 Sushi", 90, -40),
          _floatingTag("✈️ Travel", -80, 70),
          _floatingTag("🧗 Hiking", 70, 90),
        ],
      ),
    );
  }

  Widget _pageTravel() {
    return _BasePage(
      title: "Passport to\nNew Places",
      subtitle: "Traveling soon? Change your location in advance and build connections before you land.",
      visual: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Iconsax.global5, size: 180, color: Colors.white10),
          _avatar(50, AppColors.neonGold),
          Positioned(top: 40, left: 100, child: Icon(Iconsax.location5, color: AppColors.neonGold, size: 30)),
        ],
      ),
    );
  }

  Widget _pageMoods() {
    return _BasePage(
      title: "Instant\nConnections",
      subtitle: "Show your real-time mood and let others know if you're up for coffee, a drink, or a walk.",
      visual: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _moodIcon("☕", "Coffee"),
          const SizedBox(width: 20),
          _moodIcon("🍸", "Drinks"),
          const SizedBox(width: 20),
          _moodIcon("🎬", "Movies"),
        ],
      ),
    );
  }

  Widget _pageFinal() {
    return _BasePage(
      title: "Everything\nis Ready",
      subtitle: "Your profile is set up. Step into a world of exciting possibilities and find your match.",
      visual: Container(
        height: 200, width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [AppColors.neonGold.withOpacity(0.2), Colors.transparent]),
        ),
        child: const Icon(Iconsax.heart5, color: AppColors.neonGold, size: 100),
      ),
    );
  }

  // --- REUSABLE UI COMPONENTS ---

  Widget _buildTopProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: List.generate(_totalTabs, (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 3,
            decoration: BoxDecoration(
              color: index <= _currentPage ? AppColors.neonGold : Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildBottomControls() {
    bool isLast = _currentPage == _totalTabs - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
      child: Column(
        children: [
          if (!isLast)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${_currentPage + 1} / $_totalTabs", style: const TextStyle(color: Colors.grey)),
                TextButton(onPressed: () => _pageController.jumpToPage(_totalTabs - 1), child: const Text("Skip", style: TextStyle(color: Colors.white60))),
              ],
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 60,
            child: ElevatedButton(
              onPressed: () {
                if (!isLast) {
                  _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                } else {
                  // Navigate to Dashboard
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGold,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10, shadowColor: AppColors.neonGold.withOpacity(0.3),
              ),
              child: Text(isLast ? "GET STARTED" : "CONTINUE", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mockupPhone(double h, double w, double rot) {
    return Transform.rotate(
      angle: rot * math.pi / 180,
      child: Container(
        height: h, width: w,
        decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10), boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20)]),
        child: Column(children: [const SizedBox(height: 10), Container(width: 30, height: 3, color: Colors.white12), const Spacer(), Container(height: 40, width: double.infinity, color: AppColors.neonGold.withOpacity(0.1))]),
      ),
    );
  }

  Widget _avatar(double s, Color bc, {bool isMain = false}) {
    return Container(
      width: s, height: s,
      decoration: BoxDecoration(
        shape: BoxShape.circle, color: AppColors.cardBlack,
        border: Border.all(color: bc.withOpacity(0.5), width: isMain ? 3 : 1),
        boxShadow: isMain ? [BoxShadow(color: bc.withOpacity(0.2), blurRadius: 20)] : null,
      ),
      child: const Icon(Iconsax.user, color: Colors.white24, size: 20),
    );
  }

  Widget _chatBubble({required bool isLeft, required double width}) {
    return Container(
      width: width, padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(20), border: Border.all()),
      child: Column(crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end, children: [
        Container(width: width * 0.6, height: 8, decoration: BoxDecoration(color: AppColors.neonGold.withOpacity(0.3), borderRadius: BorderRadius.circular(5))),
        const SizedBox(height: 10),
        Container(width: width * 0.4, height: 8, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5))),
      ]),
    );
  }

  Widget _floatingTag(String label, double x, double y) {
    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.neonGold.withOpacity(0.3))),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _moodIcon(String emoji, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70, height: 70,
          decoration: BoxDecoration(color: AppColors.cardBlack, borderRadius: BorderRadius.circular(20), border: Border.all()),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 30))),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _dashedCircle(double s) => Container(width: s, height: s, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.05), width: 1)));
  Widget _pulseCircle(double s) => Container(width: s, height: s, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.neonGold.withOpacity(0.1), width: 2)));

  Widget _buildBackgroundGlow() {
    return AnimatedPositioned(
      duration: const Duration(seconds: 1),
      top: _currentPage % 2 == 0 ? -100 : 200,
      right: _currentPage % 2 == 0 ? -100 : 300,
      child: Container(width: 400, height: 400, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.neonGold.withOpacity(0.03))),
    );
  }
}

// Custom Painter for Page 2
class ConnectionWebPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.neonGold.withOpacity(0.15)..strokeWidth = 1.2;
    Offset c = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(c, const Offset(60, 40), paint);
    canvas.drawLine(c, const Offset(260, 100), paint);
    canvas.drawLine(c, const Offset(80, 240), paint);
    canvas.drawLine(c, const Offset(220, 200), paint);
  }
  @override bool shouldRepaint(CustomPainter old) => false;
}

class _BasePage extends StatelessWidget {
  final String title, subtitle;
  final Widget visual;
  const _BasePage({required this.title, required this.subtitle, required this.visual});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Expanded(child: Center(child: visual)),
          const SizedBox(height: 40),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, AppColors.neonGold]).createShader(bounds),
            child: Text(title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, height: 1.1)),
          ),
          const SizedBox(height: 15),
          Text(subtitle, style: const TextStyle(fontSize: 16,  height: 1.5)),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}