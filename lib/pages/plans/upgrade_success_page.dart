// pages/plans/upgrade_success_page.dart

import 'dart:ui';
import 'package:dating/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

class UpgradeSuccessPage extends StatelessWidget {
  final String planName;
  const UpgradeSuccessPage({super.key, required this.planName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100, left: -100,
            child: Container(height: 300, width: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.neonGold.withOpacity(0.2))),
          ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1,1), end: const Offset(1.5, 1.5), duration: 3.seconds, curve: Curves.easeInOut).fadeOut(),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Icon
                  Container(
                    height: 120, width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neonGold.withOpacity(0.1),
                      border: Border.all(color: AppColors.neonGold.withOpacity(0.5), width: 2),
                    ),
                    child: const Icon(Iconsax.crown5, color: AppColors.neonGold, size: 60),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut).shimmer(duration: 2.seconds),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    "CONGRATULATIONS!",
                    style: TextStyle(color: AppColors.neonGold, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 4),
                  ).animate().fadeIn(delay: 300.ms),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    "You are now a\n$planName Member",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    "Your premium benefits are now active. Start exploring meaningful connections with your new powers!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15, height: 1.5),
                  ).animate().fadeIn(delay: 700.ms),
                  
                  const SizedBox(height: 60),
                  
                  // Back to home button
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Continue Exploring", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ).animate().fadeIn(delay: 900.ms).scale(begin: const Offset(0.9, 0.9)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}