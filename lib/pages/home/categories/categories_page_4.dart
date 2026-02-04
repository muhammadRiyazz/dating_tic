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

class CategoriesPage4 extends StatelessWidget {
  final List<Profile> profiles;
  final String goal;

  const CategoriesPage4({super.key, required this.profiles, required this.goal});

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const Center(child: Text("No more profiles available", style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 16, right: 16),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => CallGirlCard(
        key: ValueKey(profiles[i].userId),
        profile: profiles[i], 
        goal: goal
      ),
    );
  }
}

class CallGirlCard extends StatefulWidget {
  final Profile profile;
  final String goal;

  const CallGirlCard({super.key, required this.profile, required this.goal});

  @override
  State<CallGirlCard> createState() => _CallGirlCardState();
}

class _CallGirlCardState extends State<CallGirlCard> with TickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
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

    // 1. Permission Check
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

    // 2. Feedback
    status == 'like' ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();
    _overlayController.forward();

    // 3. Optimistic Update
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
        setState(() {
          _isProcessing = false;
          _interactionStatus = null;
        });
      }
    } catch (e) {
      log("Error interaction: $e");
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
    final bool isOnline = getStatus(widget.profile.lastSeen ?? '');

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsPage(profiledata: widget.profile, goalName: widget.goal, match: false);
        }));
      },
      child: Container(
        height: 420,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Stack(
            children: [
              // 1. Background Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: widget.profile.photo,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[900]),
                ),
              ),

              // 2. Premium Pink Overlay Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.purple.withOpacity(0.2),
                        Colors.transparent,
                        const Color(0xFFE91E63).withOpacity(0.3),
                        Colors.black.withOpacity(0.95),
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // 3. Interaction Overlay Animation (The Pop-up icon)
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
                            size: 100,
                          ),
                  ),
                ),
              ),

              // 4. Online Badge
              if (isOnline)
                Positioned(
                  top: 20,
                  left: 20,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
                            SizedBox(width: 6),
                            Text("ONLINE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // 5. Content Section
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.profile.userName}, $age",
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // const Icon(Iconsax.verify5, color: Colors.blueAccent, size: 28),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _premiumTrait(Iconsax.location5, widget.profile.city ?? "Nearby"),
                            _premiumTrait(Iconsax.ruler, "${widget.profile.height ?? '165'} cm"),
                            _premiumTrait(Iconsax.heart5, widget.profile.relationshipGoal?.name ?? "Dating"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ACTION BUTTONS
                      Row(
                        children: [
                          // Pass Button
                          _circleBtn(
                            Icons.close, 
                            Colors.white.withOpacity(0.1), 
                            Colors.white, 
                            onTap: () => _onInteraction('pass')
                          ),
                          const SizedBox(width: 12),
                          // Message Button
                          _circleBtn(Iconsax.message_text5, Colors.white.withOpacity(0.1), Colors.white, onTap: () {}),
                          const SizedBox(width: 12),
                          // Call Button
                          _circleBtn(Iconsax.call5, Colors.white.withOpacity(0.1), Colors.white, onTap: () {}),
                          
                          const Spacer(),

                          // THE MEGA LIKE BUTTON
                          GestureDetector(
                            onTap: () => _onInteraction('like'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.neonGold,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.neonGold.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: _isProcessing && _interactionStatus == 'like'
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                                : const Icon(Iconsax.heart5, color: Colors.black, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _premiumTrait(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 12),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, Color bg, Color iconColor, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}