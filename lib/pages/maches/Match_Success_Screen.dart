import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; // Add this
import 'package:flutter_animate/flutter_animate.dart'; // Add this

class MatchSuccessScreen extends StatefulWidget {
  final String touserImg;
    final String fromuserImg;

  const MatchSuccessScreen({super.key, required this.fromuserImg ,required this.touserImg});

  @override
  State<MatchSuccessScreen> createState() => _MatchSuccessScreenState();
}

class _MatchSuccessScreenState extends State<MatchSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Initialize confetti to play immediately
    _confettiController = ConfettiController(
      
      duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [

          // 1. BACKGROUND GRADIENTS
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFF4D67).withOpacity(0.25), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 2. THE CONFETTI LAYER (The "Bubbles" from the video)
      
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildCloseButton(context),
                  ),
                ),
                const Spacer(),

                // 3. TILTED CARDS WITH POP ANIMATION
                Center(
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Left Card
                        Transform.translate(
                          offset: const Offset(-50, 20),
                          child: Transform.rotate(
                            angle: -0.1,
                            child: _buildCard(widget.fromuserImg),
                          ),
                        ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut).moveY(begin: 100, end: 0),

                        // Right Card
                        Transform.translate(
                          offset: const Offset(50, 25),
                          child: Transform.rotate(
                            angle: 0.1,
                            child: _buildCard(widget.touserImg),
                          ),
                        ).animate().scale(delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut).moveY(begin: 100, end: 0),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // 4. MATCH TEXT WITH BUBBLE POP EFFECT
                const Text(
                  "MATCH!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 800.ms)
                    .shimmer(delay: 1000.ms, duration: 2.seconds), // Adds a nice shine over the text

                const SizedBox(height: 15),
                const Text(
                  "You have 24 hours to take a first step\nwith new partner",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.5),
                ).animate().fadeIn(delay: 600.ms),

                const Spacer(),

                // 5. INPUTS
                _buildGlassInput().animate().slideY(begin: 1, end: 0, curve: Curves.easeOutExpo, delay: 800.ms),
                _buildQuickReplies().animate().fadeIn(delay: 1000.ms),

                const SizedBox(height: 20),
              ],
            ),
          ),
              ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // Downwards
            maxBlastForce: 5,
            minBlastForce: 1,
            emissionFrequency: 0.05,
            numberOfParticles: 35,
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
  // ConfettiWidget(
  //     confettiController: _confettiController,
  //     blastDirection: pi / 2,
  //           maxBlastForce: 5,
  //           minBlastForce: 1,
  //           emissionFrequency: 0.05,
  //           numberOfParticles: 35,
  //           gravity: 0.2,
  //           shouldLoop: false,
  //     colors: [Colors.red, Colors.pinkAccent],
  //     createParticlePath: drawHeart, // Call the heart function here
  //   ),
    
    // BUBBLES (Circles)
    // ConfettiWidget(
    //   confettiController: _confettiController,
    //   blastDirection: pi / 2,
    //   colors: [Colors.white, Colors.yellow],
    //   createParticlePath: (size) {
    //     final path = Path();
    //     path.addOval(Rect.fromCircle(center: Offset.zero, radius: size.width / 2));
    //     return path;
    //   },
    // ),
        ],
      ),
    );
  }

  Widget _buildCard(String url) {
    return Container(
      width: 180,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
    );
  }
// 1. Define the Heart Shape Path
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

// 2. Define a Star Shape Path
Path drawStar(Size size) {
  double degToRad(double deg) => deg * (pi / 180.0);
  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = size.width / 2;
  final internalRadius = externalRadius / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(-90);

  path.moveTo(size.width, halfWidth + externalRadius * cos(fullAngle));
  for (double step = 0; step < 360; step += degToRad(360 / numberOfPoints)) {
    path.lineTo(halfWidth + externalRadius * cos(step + fullAngle),
        halfWidth + externalRadius * sin(step + fullAngle));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep + fullAngle),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep + fullAngle));
  }
  path.close();
  return path;
}
  Widget _buildGlassInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write a message...",
                hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    final replies = ["Hey, finally us ❤️", "You caught my eye 😉", "Hi!"];
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        itemCount: replies.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            replies[index],
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }
}