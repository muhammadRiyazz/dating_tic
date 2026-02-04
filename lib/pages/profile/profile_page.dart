import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/pages/first_page.dart';
import 'package:dating/pages/plans/plans_list_page.dart';
import 'package:dating/pages/profile/edit_profile.dart/Edit_Profile_Page.dart';
import 'package:dating/pages/profile/my_profile.dart';
import 'package:dating/pages/profile/profile_image_shimmer.dart';
import 'package:dating/providers/my_profile_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    
  }



  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<MyProfileProvider>();

    return 
    // Scaffold(body: Container(color: Colors.amberAccent,));
    Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          buildFullScreenBlurredBg(profileProvider),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopNav(context),
                  profileProvider.isLoading||profileProvider.userProfile==null?Center(child: ProfileImageShimmer()):
                  _buildMainProfileHero(context, profileProvider ),
                  const SizedBox(height: 30),
                  // _buildStatsRow(),
                  // const SizedBox(height: 30),
                  _buildPremiumMembershipCard(),
                  const SizedBox(height: 30),
                  _buildSectionLabel("YOUR POWER TOOLS"),
                  _buildActionGrid(),
                  const SizedBox(height: 30),
                  _buildSectionLabel("ACCOUNT & PRIVACY"),
                  _buildGlassySettingsCard(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Background with user's profile photo
  Widget buildFullScreenBlurredBg(MyProfileProvider profileProvider ) {
  final String profileImageUrl =
    profileProvider.isLoading ||
            profileProvider.userProfile?.photo == null ||
            profileProvider.userProfile!.photo.isEmpty
        ? 'https://i.pravatar.cc/1000?img=65'
        : profileProvider.userProfile!.photo;

    return Stack(
      children: [
   
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(profileImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.4, 0.9],
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.2),
                Colors.black,
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Top Navigation
  Widget _buildTopNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
   
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Studio",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              Text(
                "Manage your presence",
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
              ),
            ],
          ).animate().fadeIn().slideX(begin: -0.1),
          _glassContainer(
            padding: const EdgeInsets.all(10),
            color: AppColors.neonGold.withOpacity(0.9),
            child: const Icon(Iconsax.flash_1, color: Colors.black, size: 22),
          ).animate().fadeIn().scale(),
        ],
      ),
    );
  }

  // Main Profile Hero with shimmer
  Widget _buildMainProfileHero(
    BuildContext context,

    MyProfileProvider profileProvider
  ) {

    // Get age from detailed profile if available
 

    return GestureDetector(
      onTap: () {
          Navigator.of(context).push(_createRoute(const MyDetailedProfilePage()));
        
      },
      child: Center(
        child: Column(
          children: [
            // Profile Image with shimmer
          
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.neonPink.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Hero(
                      tag: 'profile_pic',
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: NetworkImage(
                         profileProvider.userProfile!.photo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 20),
            
           Column(
                children: [
                  Text(
                   profileProvider.userProfile!.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  profileProvider.userProfile!.relationshipGoal==null?SizedBox(): 
                   Text(
                     profileProvider.userProfile!.relationshipGoal!.name,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              )
            
          
          ],
        ),
      ).animate().fadeIn(duration: 600.ms),
    );
  }

  // Rest of your existing methods remain the same...
  // Widget _buildStatsRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       _statItem("1.2k", "Likes"),
  //       _vDivider(),
  //       _statItem("48", "Matches"),
  //       _vDivider(),
  //       _statItem("95", "Boosts"),
  //     ],
  //   ).animate().fadeIn(delay: 200.ms);
  // }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
        ),
      ],
    );
  }

  Widget _vDivider() {
    return Container(
      height: 25,
      width: 1,
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 30),
    );
  }

  Widget _buildPremiumMembershipCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonGold.withOpacity(0.9),
                        const Color(0xFFFFA500).withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Iconsax.crown_1, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upgrade to Gold",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            "See who likes you",
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    InkWell(onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SubscriptionCardPage();
                      },));
                    },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          "UPGRADE",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 0.2, curve: Curves.easeOutQuad);
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildActionGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 1.4,
        children: [
          InkWell(
            onTap: () {
              
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditProfilePage();
              },));
            },
            
            child: _powerToolItem(Iconsax.edit, "Edit Profile", "Update your bio", AppColors.neonPink)),
          // _powerToolItem(Iconsax.eye, "Preview", "View as others", Colors.blueAccent),
          // _powerToolItem(Iconsax.chart_21, "Statistics", "Track your growth", Colors.greenAccent),
          _powerToolItem(Iconsax.medal_star, "Verify Me", "Get blue badge", AppColors.neonGold),
        ],
      ),
    );
  }

  Widget _powerToolItem(IconData icon, String title, String sub, Color color) {
    return _glassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              sub,
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassySettingsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _glassContainer(
        child: Column(
          children: [
            _settingsTile(Iconsax.setting, "App Settings", "General preferences"),
            _settingsTile(Iconsax.notification, "Notifications", "Manage your alerts"),
            _settingsTile(Iconsax.security_safe, "Privacy", "Control visibility"),
            _settingsTile(Iconsax.wallet_3, "Billing", "Manage gold plan"),
            _settingsTile(
              Iconsax.message_question,
              "Help Center",
              "FAQ & Support",
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, String sub, {bool isLast = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        sub,
        style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
      ),
      trailing: const Icon(Iconsax.arrow_right_3, color: Colors.white24, size: 14),
      shape: isLast
          ? null
          : Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: InkWell(
        onTap: () => _showLogoutBottomSheet(context),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.logout, color: Colors.red, size: 20),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Sign out from this device",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "LOGOUT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.logout, color: Colors.red, size: 40),
                ).animate().shake(duration: 500.ms),
                const SizedBox(height: 20),
                const Text(
                  "Sign Out?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to leave? 🥺\nWe'll miss you and your energy! ✨",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                ),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(
                            color: Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await AuthService().logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => DatingIntroScreen()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          "LOGOUT",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ).animate().slideY(begin: 1, duration: 400.ms, curve: Curves.easeOutQuad),
          ),
        );
      },
    );
  }

  Widget _glassContainer({required Widget child, EdgeInsets? padding, Color? color}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 0.1);
      var end = Offset.zero;
      var curve = Curves.easeOutExpo;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: animation.drive(tween), child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 600),
  );
}




