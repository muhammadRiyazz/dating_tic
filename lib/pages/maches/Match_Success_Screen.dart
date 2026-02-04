// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:confetti/confetti.dart'; // Add this
// import 'package:flutter_animate/flutter_animate.dart'; // Add this

// class MatchSuccessScreen extends StatefulWidget {
//   final String touserImg;
//     final String fromuserImg;

//   const MatchSuccessScreen({super.key, required this.fromuserImg ,required this.touserImg});

//   @override
//   State<MatchSuccessScreen> createState() => _MatchSuccessScreenState();
// }

// class _MatchSuccessScreenState extends State<MatchSuccessScreen> {
//   late ConfettiController _confettiController;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize confetti to play immediately
//     _confettiController = ConfettiController(
      
//       duration: const Duration(seconds: 3));
//     _confettiController.play();
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D12),
//       body: Stack(
//         alignment: Alignment.topCenter,
//         children: [

//           // 1. BACKGROUND GRADIENTS
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: MediaQuery.of(context).size.height * 0.45,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [const Color(0xFFFF4D67).withOpacity(0.25), Colors.transparent],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),

//           // 2. THE CONFETTI LAYER (The "Bubbles" from the video)
      
//           SafeArea(
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: _buildCloseButton(context),
//                   ),
//                 ),
//                 const Spacer(),

//                 // 3. TILTED CARDS WITH POP ANIMATION
//                 Center(
//                   child: SizedBox(
//                     height: 300,
//                     width: double.infinity,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         // Left Card
//                         Transform.translate(
//                           offset: const Offset(-50, 20),
//                           child: Transform.rotate(
//                             angle: -0.1,
//                             child: _buildCard(widget.fromuserImg),
//                           ),
//                         ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut).moveY(begin: 100, end: 0),

//                         // Right Card
//                         Transform.translate(
//                           offset: const Offset(50, 25),
//                           child: Transform.rotate(
//                             angle: 0.1,
//                             child: _buildCard(widget.touserImg),
//                           ),
//                         ).animate().scale(delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut).moveY(begin: 100, end: 0),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 50),

//                 // 4. MATCH TEXT WITH BUBBLE POP EFFECT
//                 const Text(
//                   "MATCH!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 42,
//                     fontWeight: FontWeight.w900,
//                     letterSpacing: 6,
//                   ),
//                 )
//                     .animate()
//                     .fadeIn(duration: 400.ms)
//                     .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 800.ms)
//                     .shimmer(delay: 1000.ms, duration: 2.seconds), // Adds a nice shine over the text

//                 const SizedBox(height: 15),
//                 const Text(
//                   "You have 24 hours to take a first step\nwith new partner",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.5),
//                 ).animate().fadeIn(delay: 600.ms),

//                 const Spacer(),

//                 // 5. INPUTS
//                 _buildGlassInput().animate().slideY(begin: 1, end: 0, curve: Curves.easeOutExpo, delay: 800.ms),
//                 _buildQuickReplies().animate().fadeIn(delay: 1000.ms),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
          //     ConfettiWidget(
          //   confettiController: _confettiController,
          //   blastDirection: pi / 2, // Downwards
          //   maxBlastForce: 5,
          //   minBlastForce: 1,
          //   emissionFrequency: 0.05,
          //   numberOfParticles: 35,
          //   gravity: 0.2,
          //   shouldLoop: false,
          //   colors: const [
          //     Colors.pinkAccent,
          //     Colors.orangeAccent,
          //     Colors.yellowAccent,
          //     Colors.white,
          //                   Colors.pinkAccent,

          //   ],
          //   // Create circular "bubble" shapes like the video
          //   createParticlePath: (size) {
          //     final path = Path();
          //     path.addOval(Rect.fromCircle(center: Offset.zero, radius: 4));
          //     return path;
          //   },
          // ),
//   // ConfettiWidget(
//   //     confettiController: _confettiController,
//   //     blastDirection: pi / 2,
//   //           maxBlastForce: 5,
//   //           minBlastForce: 1,
//   //           emissionFrequency: 0.05,
//   //           numberOfParticles: 35,
//   //           gravity: 0.2,
//   //           shouldLoop: false,
//   //     colors: [Colors.red, Colors.pinkAccent],
//   //     createParticlePath: drawHeart, // Call the heart function here
//   //   ),
    
//     // BUBBLES (Circles)
//     // ConfettiWidget(
//     //   confettiController: _confettiController,
//     //   blastDirection: pi / 2,
//     //   colors: [Colors.white, Colors.yellow],
//     //   createParticlePath: (size) {
//     //     final path = Path();
//     //     path.addOval(Rect.fromCircle(center: Offset.zero, radius: size.width / 2));
//     //     return path;
//     //   },
//     // ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(String url) {
//     return Container(
//       width: 180,
//       height: 240,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(35),
//         image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))
//         ],
//       ),
//     );
//   }
// // 1. Define the Heart Shape Path
// Path drawHeart(Size size) {
//   double width = size.width;
//   double height = size.height;
//   Path path = Path();

//   path.moveTo(0.5 * width, height * 0.35);
//   path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6, 0.5 * width, height);
//   path.moveTo(0.5 * width, height * 0.35);
//   path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6, 0.5 * width, height);

//   return path;
// }

// // 2. Define a Star Shape Path
// Path drawStar(Size size) {
//   double degToRad(double deg) => deg * (pi / 180.0);
//   const numberOfPoints = 5;
//   final halfWidth = size.width / 2;
//   final externalRadius = size.width / 2;
//   final internalRadius = externalRadius / 2.5;
//   final degreesPerStep = degToRad(360 / numberOfPoints);
//   final halfDegreesPerStep = degreesPerStep / 2;
//   final path = Path();
//   final fullAngle = degToRad(-90);

//   path.moveTo(size.width, halfWidth + externalRadius * cos(fullAngle));
//   for (double step = 0; step < 360; step += degToRad(360 / numberOfPoints)) {
//     path.lineTo(halfWidth + externalRadius * cos(step + fullAngle),
//         halfWidth + externalRadius * sin(step + fullAngle));
//     path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep + fullAngle),
//         halfWidth + internalRadius * sin(step + halfDegreesPerStep + fullAngle));
//   }
//   path.close();
//   return path;
// }
//   Widget _buildGlassInput() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(35),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(35),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: const TextField(
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: "Write a message...",
//                 hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(vertical: 20),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickReplies() {
//     final replies = ["Hey, finally us ❤️", "You caught my eye 😉", "Hi!"];
//     return SizedBox(
//       height: 80,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//         itemCount: replies.length,
//         itemBuilder: (context, index) => Container(
//           margin: const EdgeInsets.only(right: 12),
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: Text(
//             replies[index],
//             style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCloseButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.pop(context),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1),
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(Icons.close, color: Colors.white, size: 20),
//       ),
//     );
//   }
// }


import 'dart:math';
import 'dart:ui';
import 'package:dating/main.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MatchSuccessScreen extends StatefulWidget {
  final String touserImg;
  final String fromuserImg;

  const MatchSuccessScreen({super.key, required this.fromuserImg, required this.touserImg});

  @override
  State<MatchSuccessScreen> createState() => _MatchSuccessScreenState();
}

class _MatchSuccessScreenState extends State<MatchSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    // Delay confetti slightly for the "impact" moment
    Future.delayed(600.ms, () => _confettiController.play());
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: Stack(
        children: [
          // 1. AMBIENT BACKGROUND
          _buildPremiumBackground(size),

          // 2. MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const Spacer(),

                // 3. THE MATCH VISUAL
                _buildMatchVisual(),

                const SizedBox(height: 50),

                // 4. TEXT CONTENT
                _buildMainText(),

                const Spacer(),

                // 5. ACTION AREA
                _buildInteractionArea(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // // 6. BURST CONFETTI (Centered on the cards)
       

                        Center(
                          heightFactor: 300,
                          child: ConfettiWidget(
                                      confettiController: _confettiController,
                                      blastDirection: pi / 2, // Downwards
                                      maxBlastForce: 5,
                                      minBlastForce: 1,
                                      emissionFrequency: 0.0,
                                      numberOfParticles: 40,
                                      gravity: 0.2,
                                      shouldLoop: false,
                                      colors: const [
                                        Colors.pinkAccent,
                                        Colors.orangeAccent,
                                        Colors.yellowAccent,
                                        Colors.white,
                              Colors.pinkAccent,
                          
                                      ],
                                      // Create circular "bubble" shapes like the video
                                      createParticlePath: (size) {
                                        final path = Path();
                                        path.addOval(Rect.fromCircle(center: Offset.zero, radius: 4));
                                        return path;
                                      },
                                    ),
                        ),
        ],
      ),
    );
  }

  Widget _buildPremiumBackground(Size size) {
    return Stack(
      children: [
        // Moving glow 1
        Positioned(
          top: size.height * 0.1,
          left: -50,
          child: _blurCircle(350, const Color(0xFFFF4D67).withOpacity(0.1)),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(end: 100, duration: 5.seconds),

        // Moving glow 2
        Positioned(
          bottom: size.height * 0.2,
          right: -50,
          child: _blurCircle(300, AppColors.pinkAccent.withOpacity(0.1)),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).moveX(end: -100, duration: 7.seconds),
     
      ],
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    ).animate().blur(begin: const Offset(40, 40), end: const Offset(80, 80));
  }

  Widget _buildMatchVisual() {
    return Center(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left Card
            _buildAnimatedCard(widget.fromuserImg, -1, -55),
            
            // Right Card
            _buildAnimatedCard(widget.touserImg, 1, 55),

            // Pulsing Heart in the middle
            // _buildCentralHeart(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(String url, double angle, double xOffset) {
    return Transform.rotate(
      angle: angle * 0.12,
      child: _buildCard(url),
    )
    .animate()
    .fadeIn(duration: 400.ms)
    .moveX(begin: xOffset * 4, end: xOffset, curve: Curves.elasticOut, duration: 1.2.seconds)
    .then()
    .animate(onPlay: (c) => c.repeat(reverse: true))
    .moveY(begin: 0, end: angle * 10, duration: 2.seconds, curve: Curves.easeInOut);
  }

  // Widget _buildCentralHeart() {
  //   return Container(
  //     padding: const EdgeInsets.all(15),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFFF4D67),
  //       shape: BoxShape.circle,
  //       boxShadow: [
  //         BoxShadow(color: const Color(0xFFFF4D67).withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
  //       ],
  //     ),
  //     child: const Icon(Icons.favorite, color: Colors.white, size: 35),
  //   )
  //   .animate()
  //   .scale(begin: Offset.zero, end: const Offset(1, 1), delay: 600.ms, curve: Curves.elasticOut)
  //   .shimmer(delay: 2.seconds, duration: 1.5.seconds);
  // }

  Widget _buildMainText() {
    return Column(
      children: [
        const Text(
          "MATCHED!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.bounceIn),
        
        const SizedBox(height: 5),
        
           Text(
              "Connection is rare, don't let it fade.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 8),
            
            // THE SUB-TEXT / INSTRUCTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "You and ${widget.touserImg.split('/').last.split('.').first.characters.take(1).toUpperCase()}${widget.touserImg.contains('http') ? 'them' : ''} have 24 hours to start a conversation before this match expires.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 500.ms),
            ),
      ],
    );
  }

  Widget _buildInteractionArea() {
    return Column(
      children: [
      

        // Glass Input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                  // border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Say something interesting...",
                          hintStyle: TextStyle(color: Colors.white30),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFFFF4D67)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 700.ms).scaleY(begin: 0, curve: Curves.easeOutExpo),



        const SizedBox(height: 15),



  // Quick Replies
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: ["Hi! 😊", "You look great!", "Coffee sometime?", "Hey there!"]
                .map((text) => _buildQuickChip(text))
                .toList(),
          ),
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),


        const SizedBox(height: 14),


      ],
    );
  }

  Widget _buildQuickChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        // border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildCard(String url) {
    return Container(
      width: 150,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 8))
        ],
        // border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.white60),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Path drawHeart(Size size) {
    double width = size.width;
    double height = size.height;
    Path path = Path();
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6, 0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6, 0.5 * width, height);
    return path;
  }
}