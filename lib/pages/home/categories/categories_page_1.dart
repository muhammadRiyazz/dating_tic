// import 'dart:developer';
// import 'dart:ui';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dating/models/profile_model.dart';
// import 'package:dating/pages/home/widgets/icons.dart';
// import 'package:dating/pages/maches/Match_Success_Screen.dart';
// import 'package:dating/pages/plans/plan_upgrade_sheet.dart';
// import 'package:dating/pages/user_profile_page.dart';
// import 'package:dating/providers/matches_provider.dart';
// import 'package:dating/providers/permission_provider.dart';
// import 'package:dating/services/suppoting_data_service.dart/age_calculater.dart';
// import 'package:dating/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:dating/main.dart';
// import 'package:flutter/services.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:dating/providers/profile_provider.dart';
// import 'package:dating/providers/interaction_provider.dart';

// class CategoriesPage1 extends StatelessWidget {
//   final List<Profile> profiles;
//   final String goal;

//   const CategoriesPage1({
//     super.key,
//     required this.profiles,
//     required this.goal,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (profiles.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Iconsax.radar,
//                 color: Colors.white.withOpacity(0.2), size: 80),
//             const SizedBox(height: 16),
//             Text("Searching for more vibes...",
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.5), fontSize: 16)),
//           ],
//         ),
//       );
//     }
    
//     // REMOVED Expanded from here. 
//     // If the parent needs this to fill space, wrap 'CategoriesPage1' in an Expanded there.
//     return ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 110, top: 10, left: 12, right: 12),
//       itemCount: profiles.length,
//       itemBuilder: (ctx, i) {
//         return ImmersiveProfileCard(
//           key: ValueKey(profiles[i].userId),
//           profile: profiles[i],
//           goal: goal,
//         );
//       },
//     );
//   }
// }

// class ImmersiveProfileCard extends StatefulWidget {
//   final Profile profile;
//   final String goal;

//   const ImmersiveProfileCard({
//     super.key,
//     required this.profile,
//     required this.goal,
//   });

//   @override
//   State<ImmersiveProfileCard> createState() => _ImmersiveProfileCardState();
// }

// class _ImmersiveProfileCardState extends State<ImmersiveProfileCard>
//     with TickerProviderStateMixin {
//   late AnimationController _slideController;
//   late Animation<Offset> _slideAnimation;
  
//   late AnimationController _overlayController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;

//   String? _interactionStatus;
//   bool _isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
    
//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
//     );

//     _overlayController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
//       CurvedAnimation(parent: _overlayController, curve: Curves.elasticOut),
//     );
//     _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _overlayController, curve: Curves.easeIn),
//     );
//   }

//   @override
//   void dispose() {
//     _slideController.dispose();
//     _overlayController.dispose();
//     super.dispose();
//   }

//   void _showPremiumUpgrade() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => const PremiumUpgradeSheet(),
//     );
//   }

//   void _onInteraction(String status) async {
//     if (_isProcessing) return;
    
//     final permissionProvider = Provider.of<PermissionProvider>(context, listen: false);
    
//     if (status == 'like' && !permissionProvider.canLike) {
//       _showPremiumUpgrade();
//       return;
//     }
    
//     _isProcessing = true;
//     if (mounted) setState(() => _interactionStatus = status);
    
//     final interactionProv = Provider.of<InteractionProvider>(context, listen: false);
//     final homeProv = Provider.of<HomeProvider>(context, listen: false);
//     final authService = AuthService();
    
//     final userId = await authService.getUserId();
//     final myPhoto = await authService.getUserPhoto();

//     _overlayController.forward();

//     if (status == 'like') {
//       permissionProvider.updateOptimistically('like');
//     }

//     Offset endOffset = status == 'like' 
//         ? const Offset(1.5, 0.2) 
//         : const Offset(-1.5, 0.2);
    
//     _slideAnimation = Tween<Offset>(begin: Offset.zero, end: endOffset).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeInOutCubic),
//     );

//     status == 'like' 
//         ? HapticFeedback.heavyImpact() 
//         : HapticFeedback.mediumImpact();

//     _slideController.forward().then((_) async {
//       try {
//         await interactionProv.handleAction(
//           matchedfromUserImg: myPhoto ?? '',
//           context: context,
//           fromUser: userId.toString(),
//           toUser: widget.profile.userId.toString(),
//           status: status,
//           matchedUserImg: widget.profile.photo,
//           onComplete: () async {
//             final currentUserId = await AuthService().getUserId();
//             if (mounted) {
//               context.read<MatchesProvider>().fetchMatches(currentUserId.toString());
//               homeProv.removeProfileLocally(widget.profile.userId);
//             }
//           },
//         );

//         if (!mounted) return;

//         // Success - refresh permissions
//         permissionProvider.refreshSilently(userId.toString());
        
//       } catch (e) {
//         if (!mounted) return;
        
//         if (status == 'like') {
//           permissionProvider.revertUpdate('like');
//         }
        
//         _slideController.reset();
//         if (mounted) setState(() => _interactionStatus = null);
//       } finally {
//         _isProcessing = false;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final int age = calculateAge(widget.profile.dateOfBirth);
//     final permissionProvider = context.watch<PermissionProvider>();

//     return SlideTransition(
//       position: _slideAnimation,
//       child: GestureDetector(
//         onTap: () {
//           HapticFeedback.lightImpact();
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProfileDetailsPage(
//                 profiledata: widget.profile,
//                 goalName: widget.goal,
//                 match: false,
//               ),
//             ),
//           );
//         },
//         child: Container(
//           height: 510,
//           margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.5),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Hero(
//                 tag: 'profile_image_${widget.profile.userId}',
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(30),
//                   child: CachedNetworkImage(
//                     imageUrl: widget.profile.photo,
//                     height: double.infinity,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.black.withOpacity(0.1),
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.3),
//                       Colors.black.withOpacity(0.9),
//                     ],
//                     stops: const [0.0, 0.3, 0.6, 1.0],
//                   ),
//                 ),
//               ),
//               FadeTransition(
//                 opacity: _opacityAnimation,
//                 child: ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: _interactionStatus == null
//                       ? const SizedBox.shrink()
//                       : Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: _interactionStatus == 'like'
//                                 ? AppColors.neonGold.withOpacity(0.2)
//                                 : Colors.red.withOpacity(0.2),
//                           ),
//                           child: Icon(
//                             _interactionStatus == 'like'
//                                 ? Iconsax.heart5
//                                 : Iconsax.close_circle5,
//                             color: _interactionStatus == 'like'
//                                 ? AppColors.neonGold
//                                 : Colors.red,
//                             size: 100,
//                           ),
//                         ),
//                 ),
//               ),
//               Positioned(
//                 top: 20,
//                 left: 20,
//                 child: _glassContainer(
//                   child: Row(
//                     children: [
//                       const Icon(Iconsax.location5,
//                           color: AppColors.neonGold, size: 14),
//                       const SizedBox(width: 5),
//                       Text(
//                         widget.profile.city ?? '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Flexible(
//                             child: Text(
//                               "${widget.profile.userName}, $age",
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       if (widget.profile.interests.isNotEmpty)
//                         Wrap(
//                           spacing: 8,
//                           children: widget.profile.interests.take(3).map((interest) {
//                             return _glassContainer(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child: Text(
//                                 "${interest.emoji} ${interest.name}",
//                                 style: const TextStyle(
//                                     color: Colors.white, fontSize: 10),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildPassButton(context),
//                           circularActionBtnhome(
//                               Iconsax.message_text5, Colors.white, Colors.white10),
//                           circularActionBtnhome(
//                               Iconsax.video5, Colors.white, Colors.white10),
//                           _buildLikeButton(context, permissionProvider),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLikeButton(BuildContext context, PermissionProvider permissionProvider) {
//     bool canLike = permissionProvider.canLike;
//     return GestureDetector(
//       onTap: () => canLike ? _onInteraction('like') : _showPremiumUpgrade(),
//       child: Container(
//         height: 65,
//         width: 65,
//         decoration: BoxDecoration(
//           gradient: canLike
//               ? const LinearGradient(colors: [AppColors.neonGold, Color(0xFFFFB74D)])
//               : LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade800]),
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: canLike ? AppColors.neonGold.withOpacity(0.4) : Colors.grey.withOpacity(0.3),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Icon(
//           canLike ? Iconsax.heart5 : Iconsax.lock,
//           color: canLike ? Colors.black : Colors.white70,
//           size: 32,
//         ),
//       ),
//     );
//   }

//   Widget _buildPassButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _onInteraction('pass'),
//       child: circularActionBtnhome(Iconsax.close_circle, Colors.white, Colors.white10),
//     );
//   }

//   Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/call/CallPage.dart';
import 'package:dating/pages/home/widgets/icons.dart';
import 'package:dating/pages/maches/Match_Success_Screen.dart';
import 'package:dating/pages/plans/plan_upgrade_sheet.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/permission_provider.dart';
import 'package:dating/services/suppoting_data_service.dart/age_calculater.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/providers/interaction_provider.dart';
// --- AGORA IMPORTS ---
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

// --- AGORA SERVICE CLASS ---


class CategoriesPage1 extends StatelessWidget {
  final List<Profile> profiles;
  final String goal;

  const CategoriesPage1({
    super.key,
    required this.profiles,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.radar, color: Colors.white.withOpacity(0.2), size: 80),
            const SizedBox(height: 16),
            Text("Searching for more vibes...",
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 12, right: 12),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) {
        return ImmersiveProfileCard(
          key: ValueKey(profiles[i].userId),
          profile: profiles[i],
          goal: goal,
        );
      },
    );
  }
}

class ImmersiveProfileCard extends StatefulWidget {
  final Profile profile;
  final String goal;

  const ImmersiveProfileCard({
    super.key,
    required this.profile,
    required this.goal,
  });

  @override
  State<ImmersiveProfileCard> createState() => _ImmersiveProfileCardState();
}

class _ImmersiveProfileCardState extends State<ImmersiveProfileCard>
    with TickerProviderStateMixin {
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

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

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
    _slideController.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  // --- NEW CALL HANDLER ---
  void _handleCall(bool isVideo) async {
    final auth = AuthService();
    final myId = await auth.getUserId();
    
    // Request Permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      if (isVideo) Permission.camera,
    ].request();

    if (statuses.values.every((status) => status.isGranted)) {
      // Create a unique channel name (e.g. "callerID_receiverID")
      String channelName = "call_${myId}_${widget.profile.userId}";
      
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelName: channelName,
            isVideo: isVideo,
            remoteUserName: widget.profile.userName,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissions required for calling")),
      );
    }
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
    if (mounted) setState(() => _interactionStatus = status);

    final interactionProv = Provider.of<InteractionProvider>(context, listen: false);
    final homeProv = Provider.of<HomeProvider>(context, listen: false);
    final authService = AuthService();

    final userId = await authService.getUserId();
    final myPhoto = await authService.getUserPhoto();

    _overlayController.forward();

    if (status == 'like') {
      permissionProvider.updateOptimistically('like');
    }

    Offset endOffset = status == 'like' ? const Offset(1.5, 0.2) : const Offset(-1.5, 0.2);

    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: endOffset).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOutCubic),
    );

    status == 'like' ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();

    _slideController.forward().then((_) async {
      try {
        await interactionProv.handleAction(
          matchedfromUserImg: myPhoto ?? '',
          context: context,
          fromUser: userId.toString(),
          toUser: widget.profile.userId.toString(),
          status: status,
          matchedUserImg: widget.profile.photo,
          onComplete: () async {
            final currentUserId = await AuthService().getUserId();
            if (mounted) {
              context.read<MatchesProvider>().fetchMatches(currentUserId.toString());
              homeProv.removeProfileLocally(widget.profile.userId);
            }
          },
        );
        if (!mounted) return;
        permissionProvider.refreshSilently(userId.toString());
      } catch (e) {
        if (!mounted) return;
        if (status == 'like') permissionProvider.revertUpdate('like');
        _slideController.reset();
        if (mounted) setState(() => _interactionStatus = null);
      } finally {
        _isProcessing = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int age = calculateAge(widget.profile.dateOfBirth);
    final permissionProvider = context.watch<PermissionProvider>();

    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileDetailsPage(
                profiledata: widget.profile,
                goalName: widget.goal,
                match: false,
              ),
            ),
          );
        },
        child: Container(
          height: 510,
          margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: 'profile_image_${widget.profile.userId}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: widget.profile.photo,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
              FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _interactionStatus == null
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _interactionStatus == 'like'
                                ? AppColors.neonGold.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                          ),
                          child: Icon(
                            _interactionStatus == 'like' ? Iconsax.heart5 : Iconsax.close_circle5,
                            color: _interactionStatus == 'like' ? AppColors.neonGold : Colors.red,
                            size: 100,
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: _glassContainer(
                  child: Row(
                    children: [
                      const Icon(Iconsax.location5, color: AppColors.neonGold, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        widget.profile.city ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "${widget.profile.userName}, $age",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (widget.profile.interests.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          children: widget.profile.interests.take(3).map((interest) {
                            return _glassContainer(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text("${interest.emoji} ${interest.name}", style: const TextStyle(color: Colors.white, fontSize: 10)),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPassButton(context),
                          // --- UPDATED VOICE CALL BUTTON ---
                          GestureDetector(
                            onTap: () => _handleCall(false),
                            child: circularActionBtnhome(Iconsax.call5, Colors.white, Colors.white10),
                          ),
                          // --- UPDATED VIDEO CALL BUTTON ---
                          GestureDetector(
                            onTap: () => _handleCall(true),
                            child: circularActionBtnhome(Iconsax.video5, Colors.white, Colors.white10),
                          ),
                          _buildLikeButton(context, permissionProvider),
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

  Widget _buildLikeButton(BuildContext context, PermissionProvider permissionProvider) {
    bool canLike = permissionProvider.canLike;
    return GestureDetector(
      onTap: () => canLike ? _onInteraction('like') : _showPremiumUpgrade(),
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          gradient: canLike
              ? const LinearGradient(colors: [AppColors.neonGold, Color(0xFFFFB74D)])
              : LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade800]),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: canLike ? AppColors.neonGold.withOpacity(0.4) : Colors.grey.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          canLike ? Iconsax.heart5 : Iconsax.lock,
          color: canLike ? Colors.black : Colors.white70,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildPassButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _onInteraction('pass'),
      child: circularActionBtnhome(Iconsax.close_circle, Colors.white, Colors.white10),
    );
  }

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}
