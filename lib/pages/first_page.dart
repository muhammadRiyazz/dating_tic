

// import 'package:dating/Theme/theme_provider.dart';
// import 'package:dating/main.dart';
// import 'package:dating/pages/intro_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DatingIntroScreen extends StatefulWidget {
//   const DatingIntroScreen({super.key});

//   @override
//   State<DatingIntroScreen> createState() => _DatingIntroScreenState();
// }

// class _DatingIntroScreenState extends State<DatingIntroScreen> {
//   double _rotationAngle = 0.0;
//   final List<double> _cardOffsets = [0.0, 0.0];
//   final List<Alignment> _cardAlignments = [
//     Alignment.centerLeft,
//     Alignment.centerRight
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _startAnimation();
//   }

//   void _startAnimation() {
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         _rotationAngle = 0.1;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: isDarkMode
//               ? const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xFF2A0707), // deep wine-red bottom
//                                         Color(0xFF0A0505), // dark black-red top

//                   ],
//                 )
//               : const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xFFFFF0F0), // light pink top
//                     Color(0xFFFFE6E6), // light red bottom
//                   ],
//                 ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 40),

//               /// APP NAME
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
                 
//               //     Text(
//               //       "MatchFindr",
//               //       style: TextStyle(
//               //         color: isDarkMode ? Colors.white : const Color(0xFF2A0707),
//               //         fontSize: 23,
//               //         fontWeight: FontWeight.w800,
//               //         letterSpacing: 1.5,
//               //       ),
//               //     ),
//               //   ],
//               // ),

//               const SizedBox(height: 40),

//               /// ANIMATED CARDS
            
//               /// CARDS
//               Expanded(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     /// LEFT CARD
//                     Positioned(
//                       left: 40,
//                       top: 40,
//                       child: Transform.rotate(
//                         angle: -0.15,
//                         child: ProfileCard(
//                           name: "Jason",
//                           age: "24",
//                           location: "New York",
//                           imageUrl:
//                           "https://images.unsplash.com/photo-1500648767791-00dcc994a43e"    ,
// isDarkMode: isDarkMode,
//                         ),
//                       ),
//                     ),

//                     /// RIGHT CARD
//                     Positioned(
//                       right: 40,
//                       bottom: 40,
//                       child: Transform.rotate(
//                         angle: 0.12,
//                         child: ProfileCard(
//                           isDarkMode: isDarkMode,
//                           name: "Julia",
//                           age: "27",
//                           location: "Los Angeles",
//                           imageUrl:
// "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
//                     ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),


//               const SizedBox(height: 20),

//               /// TITLE
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "Find Your\n",
//                       style: TextStyle(
//                         color: isDarkMode ? Colors.white : const Color(0xFF2A0707),
//                         fontSize: 36,
//                         height: 1.2,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "Perfect Match",
//                       style: TextStyle(
//                         color: isDarkMode
//                             ? const Color(0xFFFF3B30)
//                             : Colors.red.shade700,
//                         fontSize: 36,
//                         height: 1.2,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               /// SUBTEXT
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40),
//                 child: Text(
//                   "Swipe, Match, and Connect with Amazing People Nearby",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: isDarkMode
//                         ? const Color(0xFFD7D7D7)
//                         : Colors.grey.shade700,
//                     fontSize: 16,
//                     height: 1.4,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 32),

//               /// BUTTONS
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Column(
//                   children: [
//                     /// GET STARTED BUTTON
//                     SizedBox(
//                       height: 55,
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFFF3B30),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           elevation: 5,
//                           shadowColor: Colors.red.withOpacity(0.5),
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => 
//                               // DatingHomePage
//                                DatingHomePage(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//   "Get Started",                          style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // / THEME TOGGLE
//                     // Container(
//                     //   width: 200,
//                     //   height: 50,
//                     //   decoration: BoxDecoration(
//                     //     color: isDarkMode
//                     //         ? Colors.black.withOpacity(0.3)
//                     //         : Colors.white.withOpacity(0.5),
//                     //     borderRadius: BorderRadius.circular(15),
//                     //     border: Border.all(
//                     //       color: isDarkMode
//                     //           ? Colors.white24
//                     //           : Colors.red.shade100,
//                     //     ),
//                     //   ),
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     //     children: [
//                     //       Icon(
//                     //         Icons.light_mode,
//                     //         color: !isDarkMode
//                     //             ? Colors.orange.shade700
//                     //             : Colors.grey.shade400,
//                     //       ),
//                     //       Switch(
//                     //         value: isDarkMode,
//                     //         onChanged: (value) {
//                     //           themeProvider.toggleTheme();
//                     //         },
//                     //         activeColor: Colors.red,
//                     //         inactiveTrackColor: Colors.grey.shade300,
//                     //       ),
//                     //       Icon(
//                     //         Icons.dark_mode,
//                     //         color: isDarkMode
//                     //             ? Colors.indigo.shade300
//                     //             : Colors.grey.shade400,
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// PROFILE CARD --------------------------------------------
// class ProfileCard extends StatelessWidget {
//   final String name;
//   final String age;
//   final String location;
//   final String imageUrl;
//   final bool isDarkMode;

//   const ProfileCard({
//     required this.name,
//     required this.age,
//     required this.location,
//     required this.imageUrl,
//     required this.isDarkMode,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         width: 180,
//         height: 250,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           color: isDarkMode
//               ? const Color(0xFF4A1A1A)
//               : Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: isDarkMode
//                   ? Colors.black.withOpacity(0.6)
//                   : Colors.red.shade100,
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//               spreadRadius: -5,
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25),
//           child: Stack(
//             children: [
//               /// IMAGE
//               Positioned.fill(
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Container(
//                       // color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
//                       // child: Center(
//                       //   child: CircularProgressIndicator(
//                       //     color: Colors.red,
//                       //   ),
//                       // ),
//                     );
//                   },
//                 ),
//               ),

//               /// GRADIENT OVERLAY
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.transparent,
//                         isDarkMode
//                             ? Colors.black.withOpacity(0.8)
//                             : Colors.black.withOpacity(0.6),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               /// MATCH PERCENTAGE BADGE
//               Positioned(
//                 top: 15,
//                 left: 15,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.favorite, color: Colors.white, size: 14),
//                       const SizedBox(width: 4),
//                       const Text(
//                         "86%",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               /// PROFILE INFO
//               Positioned(
//                 left: 15,
//                 bottom: 15,
//                 right: 15,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "$name, $age",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           color: Colors.white.withOpacity(0.8),
//                           size: 14,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           location,
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               /// LIKE BUTTON
//               Positioned(
//                 bottom: 15,
//                 right: 15,
//                 child: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.red.withOpacity(0.5),
//                         blurRadius: 8,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.favorite,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

















































// import 'dart:developer';

// import 'package:dating/Theme/theme_provider.dart';
// import 'package:dating/main.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

// class DatingIntroScreen extends StatefulWidget {
//   const DatingIntroScreen({super.key});

//   @override
//   State<DatingIntroScreen> createState() => _DatingIntroScreenState();
// }

// class _DatingIntroScreenState extends State<DatingIntroScreen> {
// late VideoPlayerController _videoController;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     _initVideo();
//   }

//   Future<void> _initVideo() async {
//     try {
    
//         _videoController = VideoPlayerController.asset('');
      

//       await _videoController.initialize();

//       _chewieController = ChewieController(
//         videoPlayerController: _videoController,
//         autoPlay: true,
//         looping: true,
//         showControls: false,
//         allowFullScreen: false,
//         aspectRatio: _videoController.value.aspectRatio,
//         errorBuilder: (context, errorMessage) {
//           return Center(
//             child: Text(
//               "Video Error\n$errorMessage",
//               style: const TextStyle(color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//           );
//         },
//       );

//       if (mounted) setState(() {});
//     } catch (e) {
//       log("Video init error: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Video
//          _chewieController != null &&
//                   _videoController.value.isInitialized
//               ? SizedBox.expand(
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _videoController.value.size.width,
//                       height: _videoController.value.size.height,
//                       child: Chewie(controller: _chewieController!),
//                     ),
//                   ),
//                 )
//               : const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 ),
//           // Dark Gradient Overlay for better text readability
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.8),
//                     Colors.black.withOpacity(0.9),
//                   ],
//                   stops: const [0.0, 0.3, 0.7, 1.0],
//                 ),
//               ),
//             ),
//           ),

//           // Content
//           SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),

//                 const Spacer(),

//                 // Main Content with Animation
//                 AnimatedOpacity(
//                   opacity: _isLoading ? 0 : 1,
//                   duration: const Duration(milliseconds: 1500),
//                   child: AnimatedSlide(
//                     offset: _isLoading ? const Offset(0, 0.5) : Offset.zero,
//                     duration: const Duration(milliseconds: 1000),
//                     curve: Curves.easeOutBack,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         children: [
//                           // Title
//                           RichText(
//                             textAlign: TextAlign.center,
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "Find Your\n",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 42,
//                                     height: 1.1,
//                                     fontWeight: FontWeight.w900,
//                                     shadows: [
//                                       Shadow(
//                                         color: Colors.black.withOpacity(0.5),
//                                         blurRadius: 10,
//                                         offset: const Offset(2, 2),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "Perfect Match",
//                                   style: TextStyle(
//                                     color: const Color(0xFFFF3B30),
//                                     fontSize: 36,
//                                     height: 1.1,
//                                     fontWeight: FontWeight.w900,
//                                     shadows: [
//                                       Shadow(
//                                         color: Colors.black.withOpacity(0.5),
//                                         blurRadius: 10,
//                                         offset: const Offset(2, 2),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 15),

//                           // Subtext
//                           Text(
//                             "Swipe, Match, and Connect with Amazing People Nearby",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.9),
//                               fontSize: 15,
//                               height: 1.4,
//                               fontWeight: FontWeight.w600,
//                               shadows: [
//                                 Shadow(
//                                   color: Colors.black.withOpacity(0.5),
//                                   blurRadius: 5,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

               
//                 const SizedBox(height: 30),

//                 // Get Started Button
//                 AnimatedOpacity(
//                   opacity: _isLoading ? 0 : 1,
//                   duration: const Duration(milliseconds: 2500),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: SizedBox(
//                       height: 60,
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFFF3B30),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           elevation: 10,
//                           // shadowColor: Colors.red.withOpacity(0.7),
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DatingHomePage(),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Get Started",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
                        
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // Terms Text
//                 AnimatedOpacity(
//                   opacity: _isLoading ? 0 : 1,
//                   duration: const Duration(milliseconds: 3000),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Text(
//                       "By continuing, you agree to our Terms of Service and Privacy Policy",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.7),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),

//           // Loading Indicator
//           if (_isLoading)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const CircularProgressIndicator(
//                         color: Color(0xFFFF3B30),
//                         strokeWidth: 3,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "Loading amazing experience...",
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoBackground(bool isDarkMode) {
//     if (_hasError) {
//       // Fallback gradient background if video fails to load
//       return Container(
//         decoration: BoxDecoration(
//           gradient: isDarkMode
//               ? const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xFF2A0707),
//                     Color(0xFF0A0505),
//                   ],
//                 )
//               : const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xFFFFF0F0),
//                     Color(0xFFFFE6E6),
//                   ],
//                 ),
//         ),
//       );
//     }

//     if (!_videoController.value.isInitialized) {
//       return Container(
//         color: Colors.black,
//         child: const Center(
//           child: CircularProgressIndicator(
//             color: Color(0xFFFF3B30),
//           ),
//         ),
//       );
//     }

//     return Chewie(controller: _chewieController);
//   }

//   Widget _buildStatItem(String value, String label) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             shadows: [
//               Shadow(
//                 color: Colors.black.withOpacity(0.5),
//                 blurRadius: 5,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }




























// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

// class FullscreenIntroVideo extends StatefulWidget {
//   final String videoUrl; // Asset file or network

//   const FullscreenIntroVideo({super.key, required this.videoUrl});

//   @override
//   State<FullscreenIntroVideo> createState() => _FullscreenIntroVideoState();
// }

// class _FullscreenIntroVideoState extends State<FullscreenIntroVideo> {
//   late VideoPlayerController _videoController;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     _initVideo();
//   }

//   Future<void> _initVideo() async {
//     try {
//       // Use asset or network
//       if (widget.videoUrl.startsWith("http")) {
//         _videoController = VideoPlayerController.networkUrl(
//           Uri.parse(widget.videoUrl),
//         );
//       } else {
//         _videoController = VideoPlayerController.asset(widget.videoUrl);
//       }

//       await _videoController.initialize();

//       _chewieController = ChewieController(
//         videoPlayerController: _videoController,
//         autoPlay: true,
//         looping: true,
//         showControls: false,
//         allowFullScreen: false,
//         aspectRatio: _videoController.value.aspectRatio,
//         errorBuilder: (context, errorMessage) {
//           return Center(
//             child: Text(
//               "Video Error\n$errorMessage",
//               style: const TextStyle(color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//           );
//         },
//       );

//       if (mounted) setState(() {});
//     } catch (e) {
//       print("Video init error: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           _chewieController != null &&
//                   _videoController.value.isInitialized
//               ? SizedBox.expand(
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _videoController.value.size.width,
//                       height: _videoController.value.size.height,
//                       child: Chewie(controller: _chewieController!),
//                     ),
//                   ),
//                 )
//               : const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 ),





//         ],
//       ),
//     );
//   }
// }




import 'dart:developer';
import 'package:dating/Theme/theme_provider.dart';
import 'package:dating/main.dart';
import 'package:dating/pages/registration%20pages/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class DatingIntroScreen extends StatefulWidget {
  const DatingIntroScreen({super.key});

  @override
  State<DatingIntroScreen> createState() => _DatingIntroScreenState();
}

class _DatingIntroScreenState extends State<DatingIntroScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  bool _hasError = false;
  bool _contentReady = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      const String videoPath = "assets/videos/intro_video.mp4";

      _videoController = VideoPlayerController.asset(videoPath);

      await _videoController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: true,
        showControls: false,
        allowFullScreen: false,
        aspectRatio: _videoController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          _hasError = true;
          return const SizedBox();
        },
      );

      setState(() {
        _contentReady = true;
      });
    } catch (e) {
      log("Video init error: $e");
      setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = theme.isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(isDarkMode),

          // Gradient Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // CONTENT
          SafeArea(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  // Background Video OR Fallback
  Widget _buildBackground(bool isDarkMode) {
    if (_hasError) {
      return _fallbackGradient(isDarkMode);
    }

    if (!_contentReady || !_videoController.value.isInitialized) {
      return _fallbackGradient(isDarkMode);
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoController.value.size.width,
          height: _videoController.value.size.height,
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }

  // Fallback background (no loading circle)
  Widget _fallbackGradient(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF120202),
                  Color(0xFF000000),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFE6E6),
                  Color(0xFFFFC2C2),
                ],
              ),
      ),
    );
  }

  // Main UI content
  Widget _buildMainContent() {
    return Column(
      children: [
        const Spacer(),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Find Your\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: "Perfect Match",
                  style: TextStyle(
                    color: Color(0xFFFF3B30),
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Swipe, Match, and Connect with Amazing People Nearby",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Get Started Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PhoneNumberPage()),
                );
              },
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Terms
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "By continuing, you agree to our Terms of Service and Privacy Policy",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
