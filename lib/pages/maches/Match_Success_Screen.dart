import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MatchSuccessScreen extends StatelessWidget {
  final String userImg;
  const MatchSuccessScreen({super.key, required this.userImg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Glass Blur Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _glassCloseButton(context),
                  ),
                ),
                const Spacer(),

                // TILTED CARDS SECTION
                SizedBox(
                  height: 320,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // My Profile Card
                      Transform.rotate(
                        angle: -0.15,
                        child: _buildMatchCard("https://images.unsplash.com/photo-1539571696357-5a69c17a67c6"),
                      ),
                      // Liked Person Card
                      Transform.translate(
                        offset: const Offset(40, 20),
                        child: Transform.rotate(
                          angle: 0.15,
                          child: _buildMatchCard(userImg),
                        ),
                      ),
                      // Floating Heart Center
                      _buildFloatingHeart(),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const Text("MATCH!", style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 5)),
                const SizedBox(height: 12),
                const Text(
                  "You have 24 hours to take a first step\nwith new partner",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
                ),

                const Spacer(),

                // GLASS MESSAGE INPUT
                _buildGlassMessageInput(),

                // QUICK CHIPS
                _buildQuickReplies(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(String url) {
    return Container(
      width: 180,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildFloatingHeart() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Color(0xFF6366F1), // Modern Purple-Blue
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0xFF6366F1), blurRadius: 20, spreadRadius: 2)],
      ),
      child: const Icon(Iconsax.heart5, color: Colors.white, size: 30),
    );
  }

  Widget _buildGlassMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write a message...",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    final replies = ["Hey, finally us ❤️", "You caught my eye 😉", "Hi!"];
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        itemCount: replies.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(replies[index], style: const TextStyle(color: Colors.white, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _glassCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }
}