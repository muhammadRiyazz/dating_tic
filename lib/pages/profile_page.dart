import 'dart:ui';
import 'package:dating/pages/first_page.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep black background
      body: Stack(
        children: [
          // 1. TOP GRADIENT (Consistency with Matches Page)
          _buildTopGradient(),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 2. HEADER SECTION (Title & Subtitle)
                _buildHeader(),

                // 3. MAIN GLASS PROFILE CARD
                SliverToBoxAdapter(child: _buildMainGlassCard()),

                // 4. MANAGE ACCOUNT SECTION
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
                    child: _buildSectionDivider("MANAGE ACCOUNT"),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildGlassTile(Iconsax.user_edit, "Personal Information", "Photos, Bio, Gender"),
                      _buildGlassTile(Iconsax.notification_bing, "Notifications", "Match, Message, Likes alerts"),
                      _buildGlassTile(Iconsax.security_safe, "Privacy & Safety", "Blocked users, Incognito mode"),
                      _buildGlassTile(Iconsax.global_edit, "Language", "English (United States)"),
                    ]),
                  ),
                ),

                // 5. PREMIUM SECTION
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
                    child: _buildSectionDivider("UPGRADES"),
                  ),
                ),

                SliverToBoxAdapter(child: _buildGoldPremiumCard()),

                // 6. SUPPORT & LOGOUT
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildGlassTile(Iconsax.info_circle, "Help & Support", "FAQs, Contact us"),
                      GestureDetector(
                        
                      onTap: () async {
  await AuthService().logout();


Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DatingIntroScreen()),
          (route) => false,
        );
},

                        
                        child: _buildGlassTile(Iconsax.logout, "Logout", "Sign out of your account", isDestructive: true)),
                    ]),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFF4D67).withOpacity(0.25), 
              Colors.transparent
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 32, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: -1
                  ),
                ),
                Text(
                  "Design your identity",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4), 
                    fontSize: 14
                  ),
                ),
              ],
            ),
            _glassCircleButton(Iconsax.setting_4),
          ],
        ),
      ),
    );
  }

  Widget _buildMainGlassCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          // Profile Avatar with Gradient Border
          Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              
color: Color.fromARGB(255, 206, 206, 206)            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://images.unsplash.com/photo-1506794778202-cad84cf45f1d"),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Julian, 28",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Product Designer • New York",
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 20),
          // Profile Completion
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Profile Strength", style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text("80%", style: TextStyle(color: Colors.pinkAccent[100], fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.8,
              minHeight: 6,
              backgroundColor: Colors.white10,
              color: const Color(0xFFFF4D67),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5), 
            fontWeight: FontWeight.bold, 
            fontSize: 10, 
            letterSpacing: 1.5
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1), thickness: 1)),
      ],
    );
  }

  Widget _buildGlassTile(IconData icon, String title, String subtitle, {bool isDestructive = false, bool isPremium = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: isDestructive ? Colors.redAccent : (isPremium ? Colors.amber : Colors.white), size: 20),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
        trailing: const Icon(Iconsax.arrow_right_3, color: Colors.white24, size: 16),
      ),
    );
  }

  Widget _buildGoldPremiumCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withOpacity(0.2), 
            const Color(0xFFFFA500).withOpacity(0.1)
          ],
        ),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.crown_15, color: Colors.amber, size: 32),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Get Gold", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text("See who liked you", style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text("Upgrade", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _glassCircleButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

}