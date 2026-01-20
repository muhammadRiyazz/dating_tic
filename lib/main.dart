import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/pages/first_page.dart';
import 'package:dating/pages/home/home_screen.dart';
import 'package:dating/pages/registration%20pages/splash_screen.dart';
import 'package:dating/pages/registration%20pages/welcom_screens.dart';
import 'package:dating/providers/interaction_provider.dart';
import 'package:dating/providers/likers_provider.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/phone_registration_provider.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/providers/registration_data_provider.dart' ;
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  
  runApp(
    MultiProvider(
      providers: [
    ChangeNotifierProvider(create: (_) => RegistrationProvider()),
    ChangeNotifierProvider(create: (_) => RegistrationDataProvider()),       
        ChangeNotifierProvider(create: (_) => HomeProvider()),       
     ChangeNotifierProvider(create: (_) => LikersProvider()), 
          ChangeNotifierProvider(create: (_) => MatchesProvider()), // Add this
// Add this

     ChangeNotifierProvider(create: (_) => InteractionProvider()), // Add this

        // Add other providers here
      ],
      child: MyApp(),
    ),
  );
}

// ----------------------------------------
// 1. THEME & COLORS
// ----------------------------------------

class AppColors {
    static const Color deepBlack = Color(0xFF000000);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color mutedGold = Color(0xFF8B7322);
  static const Color cardBlack = Color(0xFF1A1A1A);
  static const Color neonGold = Color(0xFFFFD700);
  static const Color richOrange = Color(0xFFFF8C00);
  static const Color valentineRed = Color(0xFFFF4D6D);
  static const Color blueAccent = Color(0xFF2196F3);
  static const Color greenAccent = Color(0xFF4CAF50);
  static const Color purpleAccent = Color(0xFF9C27B0);
  static const Color pinkAccent = Color(0xFFE91E63);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.deepBlack,
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: AuthChecker(),
      // const SplashScreen(),
      // WeekendHome(),
      // DatingIntroScreen(),
    );
  }
}

// New widget to check authentication state
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();
    
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }
    
    return _isLoggedIn ? const WeekendHome() : const DatingIntroScreen();
  }
}