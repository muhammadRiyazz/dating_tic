import 'package:geolocator/geolocator.dart'; // Location first
import 'dart:developer';
import 'package:dating/Theme/theme_provider.dart';
import 'package:dating/main.dart';
import 'package:dating/pages/registration%20pages/phone_number_input.dart';
import 'package:dating/services/location_service.dart';
import 'package:flutter/material.dart';
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
  bool _isLoadingLocation = false;

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

      setState(() => _contentReady = true);
    } catch (e) {
      log("Video init error: $e");
      setState(() => _hasError = true);
    }
  }

  // --- NEW LOCATION MANAGEMENT LOGIC ---
  Future<bool> _handleLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog(
        "Location Services Disabled",
        "Please enable location services (GPS) to find matches nearby.",
        onPressed: () async => await Geolocator.openLocationSettings(),
      );
      return false;
    }

    // 2. Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // User denied again
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission is required to continue.")),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog(
        "Permission Permanently Denied",
        "We need location access to show you people nearby. Please enable it in App Settings.",
        onPressed: () async => await Geolocator.openAppSettings(),
      );
      return false;
    }

    return true;
  }

  void _showLocationDialog(String title, String message, {required VoidCallback onPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: AppColors.neonGold)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGold),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
            child: const Text("Settings", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGetStarted() async {
    if (_isLoadingLocation) return;

    setState(() => _isLoadingLocation = true);

    // Check Permissions first
    bool hasPermission = await _handleLocationPermissions();
    
    if (hasPermission) {
      try {
        // Fetch location and wait briefly so the next page has data
        await LocationManager().fetchAndCacheLocation();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  PhoneNumberPage()),
        );
      } catch (e) {
        log("Location fetch failed: $e");
        // Still navigate, LocationPage will handle the fallback
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  PhoneNumberPage()),
        );
      }
    }

    setState(() => _isLoadingLocation = false);
  }
  // --- END OF LOCATION LOGIC ---

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
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
          SafeArea(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (_hasError) return _fallbackGradient();
    if (!_contentReady || !_videoController.value.isInitialized) {
      return _fallbackGradient();
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

  Widget _fallbackGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF120202), Color(0xFF000000)],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(text: "Find Your\n", style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
                TextSpan(text: "Perfect Match", style: TextStyle(color: AppColors.neonGold, fontSize: 36, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Swipe, Match, and Connect with Amazing People Nearby",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, height: 1.4),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGold,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
              ),
              onPressed: _handleGetStarted,
              child: _isLoadingLocation
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
                  : const Text("Get Started", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
          ),
        ),
        const SizedBox(height: 30),
        AnimatedOpacity(
          opacity: _isLoadingLocation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text("📍 Verifying location permissions...", textAlign: TextAlign.center, style: TextStyle(color: AppColors.neonGold.withOpacity(0.8), fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  width: 100, height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.neonGold.withOpacity(0.5), AppColors.neonGold, AppColors.neonGold.withOpacity(0.5)]),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text("By continuing, you agree to our Terms of Service and Privacy Policy", textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}