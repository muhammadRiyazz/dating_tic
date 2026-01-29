import 'dart:async';
import 'dart:developer';
import 'package:dating/pages/first_page.dart';
import 'package:dating/pages/home/home_screen.dart';
import 'package:dating/pages/registration%20pages/splash_screen.dart';
import 'package:dating/providers/interaction_provider.dart';
import 'package:dating/providers/likers_provider.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/my_profile_provider.dart';
import 'package:dating/providers/phone_registration_provider.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/providers/profile_update.dart';
import 'package:dating/providers/registration_data_provider.dart' ;
import 'package:dating/providers/subscription_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/notification_service.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  

  // Initialize notifications (non-blocking)
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   FirebaseNotificationService.init();
  // });



  // Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => GlobalUserProvider()),
        ChangeNotifierProvider(create: (_) => MyProfileProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationDataProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => LikersProvider()),
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => InteractionProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProfileProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),

        
      ],
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("🌙 Background notification: ${message.messageId}");
}
// ----------------------------------------
// 1. THEME & COLORS
// ----------------------------------------

class AppColors {
    static const Color bg = Color(0xFF0A0A0A);
  static const Color neonPink = Color(0xFFFF4D67);
  static const Color glassWhite = Colors.white10;
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
      home:
      //  NotificationDebugScreen(),
      AuthChecker(),
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
    await Future.delayed(const Duration(milliseconds: 5000));
    
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