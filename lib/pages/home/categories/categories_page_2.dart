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
import 'package:flutter/services.dart';
import 'package:dating/main.dart'; // Ensure AppColors is defined here
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategoriesPage2 extends StatelessWidget {
  final List<Profile> profiles;
  final String goal;

  const CategoriesPage2({super.key, required this.profiles, required this.goal});

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.radar, color: Colors.white.withOpacity(0.2), size: 60),
            const SizedBox(height: 10),
            Text("No more elite profiles found", 
              style: TextStyle(color: Colors.white.withOpacity(0.4))),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 14, right: 14),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => EliteCard(
        key: ValueKey(profiles[i].userId),
        profile: profiles[i],
        goal: goal,
      ),
    );
  }
}

class EliteCard extends StatefulWidget {
  final Profile profile;
  final String goal;

  const EliteCard({super.key, required this.profile, required this.goal});

  @override
  State<EliteCard> createState() => _EliteCardState();
}

class _EliteCardState extends State<EliteCard> {
  bool _isProcessing = false;
  String? _status; // 'like' or 'pass'

  void _showPremiumUpgrade() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumUpgradeSheet(),
    );
  }

  Future<void> _handleAction(String status) async {
    if (_isProcessing) return;

    final permissionProv = Provider.of<PermissionProvider>(context, listen: false);
    
    // 1. Permission Check
    if (status == 'like' && !permissionProv.canLike) {
      _showPremiumUpgrade();
      return;
    }

    setState(() {
      _isProcessing = true;
      _status = status;
    });

    final interactionProv = Provider.of<InteractionProvider>(context, listen: false);
    final homeProv = Provider.of<HomeProvider>(context, listen: false);
    final auth = AuthService();
    
    final userId = await auth.getUserId();
    final myPhoto = await auth.getUserPhoto();

    // Haptic feedback based on action
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
            // Update matches if necessary
            context.read<MatchesProvider>().fetchMatches(userId.toString());
            // Remove from local list to trigger list animation/update
            homeProv.removeProfileLocally(widget.profile.userId);
          }
        },
      );
      
      // Refresh permissions in case likes count decreased
      permissionProv.refreshSilently(userId.toString());
    } catch (e) {
      log("Error EliteCard: $e");
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int age = calculateAge(widget.profile.dateOfBirth);
    final permissionProv = context.watch<PermissionProvider>();
    final isOnline = getStatus(widget.profile.lastSeen ?? '');

    return Opacity(
      opacity: _isProcessing ? 0.6 : 1.0,
      child: GestureDetector(
        onTap: () {
          if (_isProcessing) return;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProfileDetailsPage(
              profiledata: widget.profile,
              goalName: widget.goal,
              match: false,
            );
          }));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F0F),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.07), width: 1),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Profile Image
                _buildImageSection(isOnline),

                // 2. Info Side
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopRow(),
                        const SizedBox(height: 8),
                        Text(
                          "${widget.profile.userName}, $age",
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        _buildLocationRow(),
                        const SizedBox(height: 12),
                        _buildInterests(),
                        const Spacer(),
                        _buildActionRow(permissionProv),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(target: _isProcessing ? 1 : 0).fadeOut(duration: 400.ms);
  }

  Widget _buildImageSection(bool isOnline) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(23),
            bottomLeft: Radius.circular(23),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.profile.photo,
            width: 125,
            height: 185,
            fit: BoxFit.cover,
          ),
        ),
        if (isOnline)
          Positioned(
            top: 10, left: 10,
            child: Container(
              width: 10, height: 10,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [BoxShadow(color: Colors.greenAccent.withOpacity(0.5), blurRadius: 4)],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.neonGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text("ELITE", 
            style: TextStyle(color: AppColors.neonGold, fontSize: 8, fontWeight: FontWeight.w900)),
        ),
        // const Icon(Iconsax.verify5, color: Colors.blueAccent, size: 18),
      ],
    );
  }





  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(Iconsax.location, color: Colors.grey[500], size: 12),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            "${widget.profile.city ?? 'Nearby'} • ${widget.profile.job ?? 'Professional'}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildInterests() {
    if (widget.profile.interests.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: widget.profile.interests.take(2).map((interest) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${interest.emoji} ${interest.name}",
            style: const TextStyle(color: Colors.white70, fontSize: 9),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionRow(PermissionProvider permissionProv) {
    bool canLike = permissionProv.canLike;

    return Row(
      children: [
        // Message Button
        _iconBtn(Iconsax.message_text5, AppColors.neonGold, AppColors.neonGold.withOpacity(0.1), () {}),
        const Spacer(),
        // Pass Button
        _iconBtn(Iconsax.close_circle, Colors.white, Colors.white.withOpacity(0.1), () => _handleAction('pass')),
        const SizedBox(width: 10),
        // Like Button
        GestureDetector(
          onTap: () => _handleAction('like'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: canLike ? AppColors.neonGold : Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(canLike ? Iconsax.heart5 : Iconsax.lock, color: Colors.black, size: 16),
                const SizedBox(width: 4),
                Text(
                  canLike ? "LIKE" : "LOCKED",
                  style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon, Color color, Color bg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}