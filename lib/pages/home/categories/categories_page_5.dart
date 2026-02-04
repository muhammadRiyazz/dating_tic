import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/plans/plan_upgrade_sheet.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/providers/interaction_provider.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/permission_provider.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/suppoting_data_service.dart/active_status.dart';
import 'package:dating/services/suppoting_data_service.dart/age_calculater.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class CategoriesPage5 extends StatelessWidget {
  final List<Profile> profiles;
  final String goal;

  const CategoriesPage5({super.key, required this.profiles, required this.goal});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. ATTRACTIVE HEADER
        _buildHeader(context),

        // 2. PROFILE LIST
        profiles.isEmpty
            ? const SliverFillRemaining(
                child: Center(child: Text("No profiles found", style: TextStyle(color: Colors.white54))),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => EliteProfileCard(
                      key: ValueKey(profiles[index].userId),
                      profile: profiles[index],
                      goal: goal,
                    ),
                    childCount: profiles.length,
                  ),
                ),
              ),
        
        // Bottom Padding for Nav Bar
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal, // Dynamics Title based on Goal
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  "Discover elite matches nearby",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            _glassButton(Iconsax.setting_4, () {}),
          ],
        ),
      ),
    );
  }

  Widget _glassButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class EliteProfileCard extends StatefulWidget {
  final Profile profile;
  final String goal;

  const EliteProfileCard({super.key, required this.profile, required this.goal});

  @override
  State<EliteProfileCard> createState() => _EliteProfileCardState();
}

class _EliteProfileCardState extends State<EliteProfileCard> with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isProcessing = false;
  String? _interactionStatus;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(CurvedAnimation(parent: _overlayController, curve: Curves.elasticOut));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _overlayController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  Future<void> _handleInteraction(String status) async {
    if (_isProcessing) return;

    final permissionProvider = Provider.of<PermissionProvider>(context, listen: false);
    if (status == 'like' && !permissionProvider.canLike) {
      showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const PremiumUpgradeSheet());
      return;
    }

    setState(() {
      _isProcessing = true;
      _interactionStatus = status;
    });

    final interactionProv = Provider.of<InteractionProvider>(context, listen: false);
    final homeProv = Provider.of<HomeProvider>(context, listen: false);
    final authService = AuthService();
    final userId = await authService.getUserId();
    final myPhoto = await authService.getUserPhoto();

    _overlayController.forward();
    status == 'like' ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();

    if (status == 'like') permissionProvider.updateOptimistically('like');

    try {
      final result = await interactionProv.handleAction(
        matchedfromUserImg: myPhoto ?? '',
        context: context,
        fromUser: userId.toString(),
        toUser: widget.profile.userId.toString(),
        status: status,
        matchedUserImg: widget.profile.photo,
        onComplete: () async {
          if (mounted) {
            context.read<MatchesProvider>().fetchMatches(userId.toString());
            homeProv.removeProfileLocally(widget.profile.userId);
          }
        },
      );

      if (result['success'] != true && mounted) {
        if (status == 'like') permissionProvider.revertUpdate('like');
        _overlayController.reverse();
        setState(() { _isProcessing = false; _interactionStatus = null; });
      }
    } catch (e) {
      if (mounted) setState(() { _isProcessing = false; _interactionStatus = null; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int age = calculateAge(widget.profile.dateOfBirth);
    final bool isOnline = getStatus(widget.profile.lastSeen ?? '');

    return Container(
      height: 550,
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // 1. IMAGE
            Positioned.fill(
              child: CachedNetworkImage(imageUrl: widget.profile.photo, fit: BoxFit.cover),
            ),

            // 2. GRADIENT
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent, Colors.black.withOpacity(0.95)],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // 3. INTERACTION FEEDBACK
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _interactionStatus == null ? const SizedBox() : Icon(
                    _interactionStatus == 'like' ? Iconsax.heart5 : Iconsax.close_circle5,
                    color: _interactionStatus == 'like' ? AppColors.neonGold : Colors.red,
                    size: 100,
                  ),
                ),
              ),
            ),

            // 4. TOP BADGES
            Positioned(
              top: 20, left: 20, right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _glassBadge(isOnline ? "ONLINE" : "RECENTLY", isOnline ? Colors.greenAccent : Colors.white70),
                  _glassBadge(widget.profile.city ?? "Nearby", AppColors.neonGold, icon: Iconsax.location5),
                ],
              ),
            ),

            // 5. CONTENT
            Positioned(
              bottom: 25, left: 20, right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("${widget.profile.userName}, $age", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                      const SizedBox(width: 8),
                      // const Icon(Iconsax.verify5, color: Colors.blueAccent, size: 26),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // INTERESTS DATA
                  if (widget.profile.interests.isNotEmpty)
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: widget.profile.interests.take(3).map((interest) {
                        return _glassBadge("${interest.emoji} ${interest.name}", Colors.white, isSmall: true);
                      }).toList(),
                    ),
                  
                  const SizedBox(height: 20),

                  // ACTIONS
                  Row(
                    children: [
                      _glassActionBtn(Icons.close, Colors.white, () => _handleInteraction('pass')),
                      const SizedBox(width: 15),
                      _glassActionBtn(Iconsax.call5, Colors.white, () {}),
                      const Spacer(),
                      
                      // MEGA LIKE
                      GestureDetector(
                        onTap: () => _handleInteraction('like'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          decoration: BoxDecoration(
                            color: AppColors.neonGold,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.3), blurRadius: 10)],
                          ),
                          child: _isProcessing && _interactionStatus == 'like'
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                            : const Row(
                                children: [
                                  Icon(Iconsax.heart5, color: Colors.black, size: 22),
                                  SizedBox(width: 10),
                                  Text("LIKE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassBadge(String label, Color color, {IconData? icon, bool isSmall = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isSmall ? 8 : 12, vertical: isSmall ? 4 : 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, color: color, size: 12),
              if (icon != null) const SizedBox(width: 5),
              Text(label.toUpperCase(), style: TextStyle(color: color, fontSize: isSmall ? 10 : 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50, width: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}