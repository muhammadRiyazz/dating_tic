// import 'dart:ui';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dating/models/profile_model.dart';
// import 'package:dating/pages/user_profile_page.dart';
// import 'package:dating/services/suppoting_data_service.dart/active_status.dart';
// import 'package:dating/services/suppoting_data_service.dart/age_calculater.dart';
// import 'package:flutter/material.dart';
// import 'package:dating/main.dart'; 
// import 'package:iconsax/iconsax.dart';

// class CategoriesPage6 extends StatelessWidget {
//   final List<Profile> profiles;
//   final String goal;
//   const CategoriesPage6({super.key, required this.profiles, required this.goal});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 110, top: 10, left: 16, right: 16),
//       itemCount: profiles.length,
//       itemBuilder: (ctx, i) => ProfessionalCard(profile: profiles[i], goal: goal),
//     );
//   }
// }

// class ProfessionalCard extends StatelessWidget {
//   final Profile profile;
//   final String goal;
//   const ProfessionalCard({super.key, required this.profile, required this.goal});

//   @override
//   Widget build(BuildContext context) {
//     final int age = calculateAge(profile.dateOfBirth);
//     final bool isAvailable = getStatus(profile.lastSeen ?? '');

//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return ProfileDetailsPage(profiledata: profile, goalName: goal, match: false);
//       })),
//       child: Container(
//         height: 500, // Fixed height for the Stack Model
//         margin: const EdgeInsets.only(bottom: 25),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(35),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             )
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(35),
//           child: Stack(
//             children: [
//               // 1. FULL BACKGROUND IMAGE
//               Positioned.fill(
//                 child: CachedNetworkImage(
//                   imageUrl: profile.photo,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Container(color: Colors.grey[900]),
//                 ),
//               ),

//               // 2. GRADIENT OVERLAY (Ensures text readability)
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.2),
//                         Colors.black.withOpacity(0.8),
//                         Colors.black,
//                       ],
//                       stops: const [0.0, 0.5, 0.8, 1.0],
//                     ),
//                   ),
//                 ),
//               ),

//               // 3. TOP BADGES (Online Status)
//               Positioned(
//                 top: 20,
//                 left: 20,
//                 child: _glassBadge(
//                   isAvailable ? "AVAILABLE" : "OFFLINE",
//                   isAvailable ? Colors.greenAccent : Colors.grey,
//                 ),
//               ),

//               // 4. FLOATING GLASS CONTENT SECTION (Stack Model)
//               Positioned(
//                 bottom: 15,
//                 left: 15,
//                 right: 15,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(30),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(30),
//                         border: Border.all(color: Colors.white.withOpacity(0.12)),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Name and Age
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "${profile.userName}, $age",
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                               ),
//                               if (profile.height != null)
//                                 Text(
//                                   "${profile.height}cm",
//                                   style: const TextStyle(
//                                     color: AppColors.neonGold,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           // Location
//                           Row(
//                             children: [
//                               const Icon(Iconsax.location, color: Colors.white54, size: 14),
//                               const SizedBox(width: 4),
//                               Text(
//                                 profile.city ?? "Nearby",
//                                 style: const TextStyle(color: Colors.white54, fontSize: 12),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                           // Bio
//                           Text(
//                             profile.bio ?? "Available for elite standard companionship.",
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.7),
//                               fontSize: 12,
//                               height: 1.4,
//                             ),
//                           ),
//                           const SizedBox(height: 20),

//                           // 5. REDESIGNED ACTION TRAY (Pass, Call, Like)
//                           Row(
//                             children: [
//                               // PASS ACTION (Circular Reddish Glass)
//                               _actionBtn(Icons.close, Colors.redAccent, () {
//                                 // Pass Logic
//                               }),
//                               const SizedBox(width: 15),
                              
//                               // VOICE CALL ACTION (Circular Glass)
//                               _actionBtn(Iconsax.call5, Colors.white, () {
//                                 // Call Logic
//                               }),
                              
//                               const Spacer(),

//                               // NEON GOLD LIKE BUTTON
//                               GestureDetector(
//                                 onTap: () {
//                                   // Like Logic
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.neonGold,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: AppColors.neonGold.withOpacity(0.3),
//                                         blurRadius: 10,
//                                         offset: const Offset(0, 4),
//                                       )
//                                     ],
//                                   ),
//                                   child: const Row(
//                                     children: [
//                                       Icon(Iconsax.heart5, color: Colors.black, size: 20),
//                                       SizedBox(width: 8),
//                                       Text(
//                                         "LIKE",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper for Circular Glass Buttons (Pass & Call)
//   Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1),
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.white.withOpacity(0.1)),
//         ),
//         child: Icon(icon, color: color, size: 22),
//       ),
//     );
//   }

//   // Helper for Glass Status Badge
//   Widget _glassBadge(String text, Color color) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.4),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: color.withOpacity(0.4)),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//               const SizedBox(width: 8),
//               Text(
//                 text,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
import 'package:dating/main.dart'; 
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class CategoriesPage6 extends StatelessWidget {
  final List<Profile> profiles;
  final String goal;
  const CategoriesPage6({super.key, required this.profiles, required this.goal});

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.radar, color: Colors.white.withOpacity(0.2), size: 80),
            const SizedBox(height: 16),
            Text("No elite vibes found here yet...",
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 16, right: 16),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => PinterestEliteCard(
        key: ValueKey(profiles[i].userId),
        profile: profiles[i], 
        goal: goal
      ),
    );
  }
}

class PinterestEliteCard extends StatefulWidget {
  final Profile profile;
  final String goal;
  const PinterestEliteCard({super.key, required this.profile, required this.goal});

  @override
  State<PinterestEliteCard> createState() => _PinterestEliteCardState();
}

class _PinterestEliteCardState extends State<PinterestEliteCard> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _overlayController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  String? _interactionStatus;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _overlayController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(CurvedAnimation(parent: _overlayController, curve: Curves.elasticOut));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _overlayController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _slideController.dispose();
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

  void _onInteraction(String status) async {
    if (_isProcessing) return;
    final permissionProvider = Provider.of<PermissionProvider>(context, listen: false);
    
    if (status == 'like' && !permissionProvider.canLike) {
      _showPremiumUpgrade();
      return;
    }
    
    _isProcessing = true;
    setState(() => _interactionStatus = status);
    
    final interactionProv = Provider.of<InteractionProvider>(context, listen: false);
    final homeProv = Provider.of<HomeProvider>(context, listen: false);
    final authService = AuthService();
    final userId = await authService.getUserId();
    final myPhoto = await authService.getUserPhoto();

    _overlayController.forward();
    if (status == 'like') permissionProvider.updateOptimistically('like');

    Offset endOffset = status == 'like' ? const Offset(1.5, 0.2) : const Offset(-1.5, 0.2);
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: endOffset).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOutCubic),
    );

    status == 'like' ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();

    _slideController.forward().then((_) async {
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

        if (result['success'] != true) {
          if (status == 'like') permissionProvider.revertUpdate('like');
          _slideController.reset();
          setState(() => _interactionStatus = null);
        }
      } catch (e) {
        if (status == 'like') permissionProvider.revertUpdate('like');
        _slideController.reset();
        setState(() => _interactionStatus = null);
      } finally {
        _isProcessing = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int age = calculateAge(widget.profile.dateOfBirth);
    final bool isAvailable = getStatus(widget.profile.lastSeen ?? '');
    final permissionProvider = context.watch<PermissionProvider>();

    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsPage(profiledata: widget.profile, goalName: widget.goal, match: false);
        })),
        child: Container(
          height: 520,
          margin: const EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Stack(
              children: [
                // 1. FULL IMAGE with Hero
                Positioned.fill(
                  child: Hero(
                    tag: 'profile_image_${widget.profile.userId}',
                    child: CachedNetworkImage(
                      imageUrl: widget.profile.photo,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.black),
                    ),
                  ),
                ),

                // 2. GRADIENTS
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.black.withOpacity(0.9)],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                // 3. TOP SECTION: ACTIVE STATUS & LOCATION
                Positioned(
                  top: 25,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _topGlassBadge(
                        isAvailable ? "AVAILABLE" : "OFFLINE",
                        isAvailable ? Colors.greenAccent : Colors.white38,
                        isAvailable ? Icons.circle : Iconsax.timer_1,
                      ),
                      _topGlassBadge(
                        widget.profile.city ?? "Nearby",
                        Colors.white,
                        Iconsax.location5,
                        colorAccent: AppColors.neonGold,
                      ),
                    ],
                  ),
                ),

                // 4. INTERACTION OVERLAY (Heart/Pass)
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

                // 5. BOTTOM GLASS CONTENT PANEL
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.white.withOpacity(0.12)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "${widget.profile.userName}, $age",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // const Icon(Iconsax.verify5, color: Colors.blueAccent, size: 22),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (widget.profile.interests.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 6,
                                  children: widget.profile.interests.take(2).map((i) => _traitChip("${i.emoji} ${i.name}")).toList(),
                                ),
                              ),
                            
                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _iconBtn(Iconsax.close_circle, Colors.white, () => _onInteraction('pass')),
                                _buildLikeButton(permissionProvider),
                                _iconBtn(Iconsax.message_text5, Colors.white, () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLikeButton(PermissionProvider permissionProvider) {
    bool canLike = permissionProvider.canLike;
    return GestureDetector(
      onTap: () => _onInteraction('like'),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: canLike
              ? const LinearGradient(colors: [AppColors.neonGold, Color(0xFFFFB74D)])
              : LinearGradient(colors: [Colors.grey.shade700, Colors.grey.shade900]),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: canLike ? AppColors.neonGold.withOpacity(0.4) : Colors.transparent,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(canLike ? Iconsax.heart5 : Iconsax.lock, color: canLike ? Colors.black : Colors.white54, size: 32),
      ),
    );
  }

  Widget _topGlassBadge(String text, Color textColor, IconData icon, {Color? colorAccent}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: colorAccent ?? textColor, size: 12),
              const SizedBox(width: 6),
              Text(text.toUpperCase(), style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _traitChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}