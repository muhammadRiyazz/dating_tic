import 'dart:ui';
import 'package:dating/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';

class UpgradeSuccessPage extends StatefulWidget {
  final String planName;
  final String duration;
  final String price;
  final String bgImage;

  const UpgradeSuccessPage({
    super.key,
    required this.planName,
    required this.duration,
    required this.price,
    required this.bgImage,
  });

  @override
  State<UpgradeSuccessPage> createState() => _UpgradeSuccessPageState();
}

class _UpgradeSuccessPageState extends State<UpgradeSuccessPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    Future.delayed(const Duration(milliseconds: 500), () {
      _confettiController.play();
      HapticFeedback.lightImpact(); // Changed to light for a more "standard" feel
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.bgImage, 
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.9),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),
          ),

          ...List.generate(2, (index) => Positioned(
            top: index == 0 ? 100 : null,
            bottom: index == 1 ? 200 : null,
            left: index == 0 ? -100 : null,
            right: index == 1 ? -100 : null,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonGold.withOpacity(0.08),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .moveY(begin: 0, end: 30, duration: 4.seconds, curve: Curves.easeInOut),
          )),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUnlockHeader(),
                  const SizedBox(height: 20),
                  _buildPremiumCard(),
                  const SizedBox(height: 30),
                  
                  // Status Text
                  Column(
                    children: [
                      const Text(
                        "MEMBERSHIP ACTIVE",
                        style: TextStyle(
                          color: AppColors.neonGold,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ).animate().fadeIn(delay: 800.ms).shimmer(duration: 3.seconds, color: Colors.white24),
                      const SizedBox(height: 12),
                      Text(
                        "You now have full access to all exclusive\npremium features.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 15,
                          height: 1.2,
                        ),
                      ).animate().fadeIn(delay: 1000.ms),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _buildContinueButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 6. Confetti Cannon (Unchanged per request)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [AppColors.neonGold, Colors.white, Color(0xFFFFD700)],
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 100, width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                border: Border.all(color: AppColors.neonGold.withOpacity(0.2), width: 1),
              ),
            ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1,1), end: const Offset(1.2, 1.2), duration: 2.seconds).fadeOut(),
            
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGold.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Icon(Iconsax.crown, color: Colors.yellow.withOpacity(0.6), size: 54),
            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutCubic),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          "SUCCESSFULLY ACTIVATED",
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
        Text(
          widget.planName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
      ],
    );
  }

  Widget _buildPremiumCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            children: [
              _buildRow("PLAN TYPE", widget.planName, AppColors.neonGold),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white.withOpacity(0.08), thickness: 1),
              ),
              _buildRow("BILLING CYCLE", widget.duration, Colors.white),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white.withOpacity(0.08), thickness: 1),
              ),
              _buildRow("TOTAL PAID", "₹${widget.price}", Colors.white),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.05, end: 0, curve: Curves.easeOut);
  }

  Widget _buildRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          value.toUpperCase(),
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.neonGold,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: const Text(
        "GET STARTED",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 1,
        ),
      ),
    ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }
}