import 'dart:developer';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

Widget buildForYouCarousel(List<Profile> profiles) {
  if (profiles.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Section Header
      Row(
        children: [
          const SizedBox(width: 30),
          Expanded(child: Divider(color: const Color(0xFFFFD700).withOpacity(0.2))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('FOR YOU', 
              style: TextStyle(
                color: const Color(0xFFFFD700).withOpacity(0.5), 
                fontWeight: FontWeight.w900, 
                fontSize: 8, 
                letterSpacing: 2
              )),
          ),
          Expanded(child: Divider(color: const Color(0xFFFFD700).withOpacity(0.2))),
          const SizedBox(width: 30),
        ],
      ),
      const SizedBox(height: 15),

      CarouselSlider.builder(
        itemCount: profiles.length,
        options: CarouselOptions(
          height: 420,
          aspectRatio: 0.8,
          viewportFraction: 0.75,
          enlargeCenterPage: true,
          enlargeFactor: 0.2,
          enableInfiniteScroll: profiles.length > 1,
          autoPlay: profiles.length > 1,
          autoPlayInterval: const Duration(seconds: 4),
        ),
        itemBuilder: (context, index, realIndex) {
          return ForYouProfileCard(
            profile: profiles[index],
          );
        },
      ),
    ],
  );
}

class ForYouProfileCard extends StatefulWidget {
  final Profile profile;
  const ForYouProfileCard({super.key, required this.profile});

  @override
  State<ForYouProfileCard> createState() => _ForYouProfileCardState();
}

class _ForYouProfileCardState extends State<ForYouProfileCard> with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _overlayController;
  late Animation<double> _scaleAnimation;
  String? _interactionStatus;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.elasticOut),
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
    
    // Check Permissions for "Like"
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

    // Visual Feedback
    _overlayController.forward();
    status == 'like' ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();

    try {
      await interactionProv.handleAction(
        matchedfromUserImg: myPhoto ?? '',
        context: context,
        fromUser: userId.toString(),
        toUser: widget.profile.userId.toString(),
        status: status,
        matchedUserImg: widget.profile.photo,
        onComplete: () async {
          if (mounted) {
            context.read<MatchesProvider>().fetchMatches(userId.toString());
            // Remove from local list to show the next card in carousel
            homeProv.removeProfileLocally(widget.profile.userId);
          }
        },
      );
      
      // Refresh permissions
      permissionProvider.refreshSilently(userId.toString());

    } catch (e) {
      log("Error during interaction: $e");
    } finally {
      if (mounted) {
        _overlayController.reverse().then((_) {
          setState(() {
            _isProcessing = false;
            _interactionStatus = null;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.profile;
    final permissionProvider = context.watch<PermissionProvider>();
    int matchPercentage = ((user.interestMatch ?? 0) * 20).clamp(0, 100);
    bool isActive = getStatus(user.lastSeen ?? '');
    String distanceLabel = (user.distance != null && user.distance! < 50) 
        ? "Near you" 
        : "${user.distance?.toStringAsFixed(1) ?? '0'} km away";

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsPage(
            goalName: user.relationshipGoal?.name ?? '',
            match: false,
            profiledata: user,
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))
          ],
          image: DecorationImage(image: NetworkImage(user.photo), fit: BoxFit.cover),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Stack(
            children: [
              // Premium Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.95)],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),

              // Interaction Overlay (The Heart or Cross when swiping)
              if (_interactionStatus != null)
                Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Icon(
                      _interactionStatus == 'like' ? Iconsax.heart5 : Iconsax.close_circle5,
                      color: _interactionStatus == 'like' ? Colors.amber : Colors.red,
                      size: 100,
                    ),
                  ),
                ),

              // ACTIVE STATUS TAG
              if (isActive)
                Positioned(
                  top: 20, left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        CircleAvatar(radius: 3, backgroundColor: Colors.white),
                        SizedBox(width: 5),
                        Text("Active", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),

              // SIDE ACTIONS
              Positioned(
                right: 15, top: 0, bottom: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSideAction(Iconsax.message_notif, "Chat", () {}),
                    const SizedBox(height: 15),
                    _buildSideAction(Iconsax.call, "Call", () {}),
                    const SizedBox(height: 15),
                    _buildSideAction(Iconsax.close_circle, "Skip", () => _onInteraction('pass')),
                  ],
                ),
              ),

              // LIKE BUTTON
              Positioned(
                bottom: 20, right: 15,
                child: GestureDetector(
                  onTap: () => _onInteraction('like'),
                  child: Container(
                    height: 60, width: 60,
                    decoration: BoxDecoration(
                      gradient: permissionProvider.canLike 
                          ? const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFB8860B)])
                          : LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade800]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                      ],
                    ),
                    child: Icon(
                      permissionProvider.canLike ? Iconsax.heart5 : Iconsax.lock, 
                      color: permissionProvider.canLike ? Colors.black : Colors.white, 
                      size: 30
                    ),
                  ),
                ),
              ),

              // PROFILE DETAILS
              Positioned(
                bottom: 20, left: 20, right: 85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("${user.userName}, ${calculateAge(user.dateOfBirth)}",
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1.1),
                          ),
                        ),
                        if (user.isBoosted)
                          const Padding(padding: EdgeInsets.only(left: 5, top: 4), child: Icon(Iconsax.flash_15, color: Color(0xFFFFD700), size: 18)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Iconsax.location, color: Colors.white60, size: 12),
                        const SizedBox(width: 5),
                        Text(distanceLabel, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Match Badge
                    _buildMatchBadge(matchPercentage),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchBadge(int percentage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.heart5, color: Color(0xFFFFD700), size: 12),
              const SizedBox(width: 5),
              Text("$percentage% MATCH",
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}