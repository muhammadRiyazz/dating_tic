import 'dart:async';
import 'dart:developer';
import 'package:dating/pages/first_page.dart';
import 'package:dating/pages/home/home_screen.dart';
import 'package:dating/pages/registration%20pages/splash_screen.dart';
import 'package:dating/providers/interaction_provider.dart';
import 'package:dating/providers/likers_provider.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/my_profile_provider.dart';
import 'package:dating/providers/permission_provider.dart';
import 'package:dating/providers/phone_registration_provider.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/providers/profile_update.dart';
import 'package:dating/providers/registration_data_provider.dart';
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
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProfileProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationDataProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => LikersProvider()),
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => InteractionProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProfileProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => PermissionProvider()),
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
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const AppInitializer(),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;
  bool _isLoggedIn = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final authService = AuthService();
      final isLoggedIn = await authService.isLoggedIn();
      
      if (isLoggedIn) {
        // Get user ID
        _userId = await authService.getUserId();
        
        if (_userId != null) {
          // Initialize permission provider
          final permissionProvider = Provider.of<PermissionProvider>(context, listen: false);
          await permissionProvider.loadPermissions(_userId!);
          
          // Initialize other providers
          context.read<MyProfileProvider>().fetchUserProfile(_userId!);
          Provider.of<HomeProvider>(context, listen: false).fetchHomeData(_userId!);
        }
      }
      
      _isLoggedIn = isLoggedIn;
    } catch (e) {
      log('App initialization error: $e');
    } finally {
      // Add a minimum splash time for branding
      await Future.delayed(const Duration(milliseconds: 3000));
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SplashScreen();
    }
    
    return _isLoggedIn ? const WeekendHome() : const DatingIntroScreen();
  }
}