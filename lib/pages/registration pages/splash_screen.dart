import 'dart:async';
import 'package:dating/providers/my_profile_provider.dart';
import 'package:dating/providers/profile_provider.dart' show HomeProvider;
import 'package:dating/services/auth_service.dart';
import 'package:dating/main.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Path matches your pubspec.yaml (assets/image/)
  final String splashAsset = "assets/image/splash_bg.jpeg";
  bool _imageReady = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  @override
  void didChangeDependencies() {
    // PRE-CACHE ensures the image is in RAM before the first frame
    precacheImage(AssetImage(splashAsset), context).then((_) {
      if (mounted) {
        setState(() => _imageReady = true);
      }
    });
    super.didChangeDependencies();
  }

  Future<void> _initApp() async {
    final authService = AuthService();
    final userId = await authService.getUserId();

    if (userId != null) {
      if (mounted) {
        context.read<MyProfileProvider>().fetchUserProfile(userId);
        Provider.of<HomeProvider>(context, listen: false).fetchHomeData(userId);
      }
    }
    
    // Total branding time
    await Future.delayed(const Duration(milliseconds: 4500));
    
    // Navigate logic here...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. CINEMATIC BACKGROUND IMAGE
          if (_imageReady)
            Image.asset(
              splashAsset,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )
            .animate()
            .fadeIn(duration: 800.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(1.0, 1.0), 
              end: const Offset(1.07, 1.07), // Subtle high-end zoom
              duration: 10.seconds,
              curve: Curves.linear,
            ),
          
          // 2. PREMIUM MULTI-STOP GRADIENT (Cinematic Overlay)
          // This makes the text pop and looks better than a simple gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.7, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.85), // Dark top
                    Colors.transparent,             // Clear middle
                    Colors.black.withOpacity(0.4),  // Subtle shadow
                    Colors.black.withOpacity(0.65), // Deep dark bottom
                  ],
                ),
              ),
            ),
          ),
          
          // 3. MAIN CONTENT (Logo & Tagline)
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                
                // MAIN LOGO
                const Text(
                  'Weekend',
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'PlayfairDisplay', 
                    fontWeight: FontWeight.w900,
                    letterSpacing: -2,
                    color: Color(0xFFFFD700), // Gold
                    shadows: [
                      Shadow(color: Colors.black45, blurRadius: 15, offset: Offset(0, 8))
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 1000.ms, delay: 500.ms)
                .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),

                const SizedBox(height: 0),

                // TAGLINE with Letter Spacing Expansion
                Text(
                  'FIND YOUR PERFECT MATCH',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                  ),
                )  
      .animate()
                .fadeIn(duration: 1000.ms, delay: 500.ms)
                .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
                // .animate()
                // .fadeIn(delay: 1000.ms)
                // .custom(
                //   duration: 2.seconds,
                //   builder: (context, value, child) => Text(
                //     'FIND YOUR PERFECT MATCH',
                //     style: TextStyle(
                //       fontSize: 10,
                //       color: Colors.white.withOpacity(0.7),
                //       fontWeight: FontWeight.w500,
                //       letterSpacing: 2.0 + (value * 3.0), // Spreading effect
                //     ),
                //   ),
                // ),
                const SizedBox(height: 40),

                const Spacer(flex: 2),

                // 4. BOTTOM LOADING INDICATOR (Standard Slim Bar)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white10,
                      color: const Color(0xFFFFD700).withOpacity(0.8),
                      minHeight: 1.5,
                    ),
                  ),
                ).animate().fadeIn(delay: 1500.ms),
                
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}