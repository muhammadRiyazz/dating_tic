import 'package:dating/main.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use PostFrameCallback to prevent the "setState during build" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initApp();
    });
  }

  Future<void> _initApp() async {
    // 1. Get the real userId from AuthService
final authService = AuthService();
    final userId = await authService.getUserId();

    // 2. If we have a userId, trigger the Home API call immediately
    if (userId != null ) {
      // ignore: use_build_context_synchronously
      Provider.of<HomeProvider>(context, listen: false).fetchHomeData(userId);
    }
    // 3. Keep splash visible for branding
    await Future.delayed(const Duration(milliseconds: 2500));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weekend',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                // fontStyle: FontStyle.italic,
                letterSpacing: 2,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [AppColors.neonGold, AppColors.richOrange],
                  ).createShader(const Rect.fromLTWH(0, 0, 200, 100)),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.neonGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
