import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/plans/plan_upgrade_sheet.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/providers/interaction_provider.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/permission_provider.dart';
import 'package:dating/providers/profile_provider.dart'; // Assuming HomeProvider is here
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/suppoting_data_service.dart/active_status.dart';
import 'package:dating/services/suppoting_data_service.dart/age_calculater.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class CategoriesPage3 extends StatelessWidget {
  final List<Profile> profiles;
  final String goal;
  const CategoriesPage3({super.key, required this.profiles, required this.goal});

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const Center(child: Text("No profiles found", style: TextStyle(color: Colors.white54)));
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 16, right: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => ModelGridCard(
        key: ValueKey(profiles[i].userId),
        profile: profiles[i], 
        goal: goal
      ),
    );
  }
}

class ModelGridCard extends StatefulWidget {
  final Profile profile;
  final String goal;
  const ModelGridCard({super.key, required this.profile, required this.goal});

  @override
  State<ModelGridCard> createState() => _ModelGridCardState();
}

class _ModelGridCardState extends State<ModelGridCard> with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  String? _interactionStatus;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.2).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  void _showPremiumUpgrade() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumUpgradeSheet(),
    );
  }

  Future<void> _onInteraction(String status) async {
    if (_isProcessing) return;

    final permissionProvider = Provider.of<PermissionProvider>(context, listen: false);
    
    // Permission Check
    if (status == 'like' && !permissionProvider.canLike) {
      _showPremiumUpgrade();
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

    // Haptic Feedback
    status == 'like' ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();

    // Show Overlay Animation
    _overlayController.forward();

    // Optimistic Update
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
            // Remove from local grid list
            homeProv.removeProfileLocally(widget.profile.userId);
          }
        },
      );

      if (result['success'] != true && mounted) {
        if (status == 'like') permissionProvider.revertUpdate('like');
        _overlayController.reverse();
        setState(() {
          _isProcessing = false;
          _interactionStatus = null;
        });
      }
    } catch (e) {
      log("Error during interaction: $e");
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _interactionStatus = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int age = calculateAge(widget.profile.dateOfBirth);
    
    return GestureDetector(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => ProfileDetailsPage(
          profiledata: widget.profile, 
          goalName: widget.goal, 
          match: false
        ))
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: CachedNetworkImageProvider(widget.profile.photo), 
            fit: BoxFit.cover
          ),
        ),
        child: Stack(
          children: [
            // Bottom Gradient
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, 
                    end: Alignment.bottomCenter, 
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)]
                  ),
                ),
              ),
            ),

            // Online Badge
            Positioned(
              top: 10, 
              left: 10, 
              child: getStatus(widget.profile.lastSeen ?? '') ? _onlineDot() : const SizedBox()
            ),

            // Interaction Overlay (The Heart/Cross that pops up)
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _interactionStatus == null 
                      ? const SizedBox.shrink()
                      : Icon(
                          _interactionStatus == 'like' ? Iconsax.heart5 : Iconsax.close_circle5,
                          color: _interactionStatus == 'like' ? AppColors.neonGold : Colors.red,
                          size: 60,
                        ),
                ),
              ),
            ),

            // Action Buttons
            Positioned(
              bottom: 45, 
              right: 8,
              child: Column(
                children: [
                  _gridAction(
                    Icons.close, 
                    Colors.red, 
                    () => _onInteraction('pass')
                  ),
                  const SizedBox(height: 8),
                  _gridAction(
                    Iconsax.heart5, 
                    AppColors.neonGold, 
                    () => _onInteraction('like')
                  ),
                ],
              ),
            ),

            // Name Info
            Positioned(
              bottom: 12, left: 12, right: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.profile.userName}, $age", 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis, 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                  ),
                  Text(
                    widget.profile.city ?? "Nearby", 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis, 
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _onlineDot() => Container(
    width: 8, height: 8, 
    decoration: const BoxDecoration(
      color: Colors.greenAccent, 
      shape: BoxShape.circle, 
      boxShadow: [BoxShadow(color: Colors.greenAccent, blurRadius: 4)]
    )
  );

  Widget _gridAction(IconData icon, Color color, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4), 
        shape: BoxShape.circle, 
        border: Border.all(color: color.withOpacity(0.5))
      ),
      child: _isProcessing && _interactionStatus != null 
          ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: color))
          : Icon(icon, color: color, size: 16),
    ),
  );
}