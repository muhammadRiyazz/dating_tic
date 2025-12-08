// main.dart (or your main app file)
import 'package:dating/Theme/theme_provider.dart';
import 'package:dating/pages/chat_page.dart';
import 'package:dating/pages/first_page.dart';
import 'package:dating/pages/intro_page.dart';
import 'package:dating/pages/match_page.dart';
import 'package:dating/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MatchFindr',
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFFFF3B30),
        scaffoldBackgroundColor: const Color(0xFFFFF5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF5F5),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFFF3B30),
        scaffoldBackgroundColor: const Color(0xFF0A0505),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0505),
          elevation: 0,
        ),
      ),
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode 
          ? ThemeMode.dark 
          : ThemeMode.light,
      home: const DatingIntroScreen(),
    );
  }
}

class DatingHomePage extends StatefulWidget {
  const DatingHomePage({super.key});

  @override
  State<DatingHomePage> createState() => _DatingHomePageState();
}

class _DatingHomePageState extends State<DatingHomePage> {
  int _selectedIndex = 0;

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    const DiscoverPage(), // Rename DatingHomePage to DiscoverPage
    const MatchesPage(),
    const ChatPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryRed = const Color(0xFFFF3B30);
    final secondaryTextColor = theme.brightness == Brightness.dark 
        ? Colors.grey.shade400 
        : Colors.grey.shade600;

    return Scaffold(
      body: _pages[_selectedIndex],
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: secondaryTextColor.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomNavItem(
                  icon: Iconsax.home5,
                  label: 'Discover',
                  index: 0,
                  primaryRed: primaryRed,
                  secondaryTextColor: secondaryTextColor,
                ),
                _buildBottomNavItem(
                  icon: Iconsax.flash_1,
                  label: 'Matches',
                  index: 1,
                  primaryRed: primaryRed,
                  secondaryTextColor: secondaryTextColor,
                ),
                _buildBottomNavItem(
                  icon: Iconsax.message_text5,
                  label: 'Chat',
                  index: 2,
                  primaryRed: primaryRed,
                  secondaryTextColor: secondaryTextColor,
                ),
                _buildBottomNavItem(
                  icon: Iconsax.user_octagon,
                  label: 'Profile',
                  index: 3,
                  primaryRed: primaryRed,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color primaryRed,
    required Color secondaryTextColor,
  }) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryRed : secondaryTextColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryRed : secondaryTextColor,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}