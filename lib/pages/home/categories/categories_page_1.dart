import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/home/widgets/icons.dart';
import 'package:dating/pages/plans/plan_upgrade_sheet.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:dating/providers/matches_provider.dart';
import 'package:dating/providers/permission_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/providers/interaction_provider.dart';

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
            Icon(Iconsax.radar,
                color: Colors.white.withOpacity(0.2), size: 80),
            const SizedBox(height: 16),
            Text("Searching for more vibes...",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 16)),
          ],
        ),
      );
    }
    
    // Wrap with Permission Status Bar
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 110, top: 10, left: 12, right: 12),
        itemCount: profiles.length,
        itemBuilder: (ctx, i) => ImmersiveProfileCard(
          key: ValueKey(profiles[i].userId),
          profile: profiles[i],
          goal: goal,
        ),
      ),
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
void _showPremiumUpgrade({String? featureName, String? description}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PremiumUpgradeSheet(
  
    ),
  );
}
  void _onInteraction(String status) async {
    if (_isProcessing) return;
    
    final permissionProvider = Provider.of<PermissionProvider>(context, listen: false);
    
    // Check if user can like
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

    // Show animation
    _overlayController.forward();

    // Optimistically update permissions
    if (status == 'like') {
      permissionProvider.updateOptimistically('like');
    }

    // Slide animation
    Offset endOffset = status == 'like' 
        ? const Offset(1.5, 0.2) 
        : const Offset(-1.5, 0.2);
    
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: endOffset).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOutCubic),
    );

    // Haptic feedback
    status == 'like' 
        ? HapticFeedback.heavyImpact() 
        : HapticFeedback.mediumImpact();

    Future.delayed(const Duration(milliseconds: 300), () {
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
              final currentUserId = await AuthService().getUserId();
              if (mounted) {
                context.read<MatchesProvider>().fetchMatches(currentUserId.toString());
              }
              homeProv.removeProfileLocally(widget.profile.userId);
            },
          );

          if (!mounted) return;

          // Handle result
          if (result['success'] == true) {
            // Success - refresh permissions silently
            WidgetsBinding.instance.addPostFrameCallback((_) {
              permissionProvider.refreshSilently(userId.toString());
            });
          } else {
            // Failed - revert optimistic update
            if (status == 'like') {
              permissionProvider.revertUpdate('like');
            }
            
            // Show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Action failed'),
                backgroundColor: Colors.red,
              ),
            );
            
            // Reset animation
            _slideController.reset();
            setState(() => _interactionStatus = null);
          }
        } catch (e) {
          if (!mounted) return;
          
          // Revert on error
          if (status == 'like') {
            permissionProvider.revertUpdate('like');
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Network error'),
              backgroundColor: Colors.red,
            ),
          );
          
          _slideController.reset();
          setState(() => _interactionStatus = null);
        } finally {
          _isProcessing = false;
        }
      });
    });
  }



  int _calculateAge(String? dobString) {
    if (dobString == null || dobString.isEmpty) return 0;
    try {
      DateTime birthDate = DateTime.parse(dobString);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildLikeButton(BuildContext context, PermissionProvider permissionProvider) {
    bool canLike = permissionProvider.canLike;
    
    return GestureDetector(
      onTap: () {
        if (canLike) {
          _onInteraction('like');
        } else {
          _showPremiumUpgrade();
        }
      },
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          gradient: canLike
              ? const LinearGradient(
                  colors: [AppColors.neonGold, Color(0xFFFFB74D)],
                )
              : LinearGradient(
                  colors: [Colors.grey.shade600, Colors.grey.shade800],
                ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: canLike
                  ? AppColors.neonGold.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.3),
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
      child: circularActionBtnhome(
        Iconsax.close_circle,
        Colors.white,
        Colors.white10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int age = _calculateAge(widget.profile.dateOfBirth);
    final permissionProvider = context.watch<PermissionProvider>();

    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProfileDetailsPage(
                  profiledata: widget.profile,
                  goalName: widget.goal,
                  match: false,
                );
              },
            ),
          );
        },
        child: Container(
          height: 520,
          margin: const EdgeInsets.only(bottom: 25, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.5),
            //     blurRadius: 20,
            //     offset: const Offset(0, 10),
            //   ),
            // ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Profile Image with HERO Tag
              Hero(
                tag: 'profile_image_${widget.profile.userId}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: CachedNetworkImage(
                    imageUrl: widget.profile.photo,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 2. Premium Gradient
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.66),
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),

              // 3. Central Pop Animation (Icon feedback)
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
                            _interactionStatus == 'like'
                                ? Iconsax.heart5
                                : Iconsax.close_circle5,
                            color: _interactionStatus == 'like'
                                ? AppColors.neonGold
                                : Colors.red,
                            size: 100,
                          ),
                        ),
                ),
              ),

              // 4. Like Counter Badge (Only show for free users)
              // if (!permissionProvider.canChat) // Basic plan
              //   Positioned(
              //     top: 20,
              //     right: 20,
              //     child: _glassContainer(
              //       child: Row(
              //         children: [
              //           const Icon(
              //             Iconsax.heart5,
              //             color: Colors.pink,
              //             size: 12,
              //           ),
              //           const SizedBox(width: 4),
              //           Text(
              //             permissionProvider.likesStatus,
              //             style: const TextStyle(
              //               color: Colors.white,
              //               fontSize: 10,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),

              // 5. Location Badge
              Positioned(
                top: 20,
                left: 20,
                child: _glassContainer(
                  child: Row(
                    children: [
                      const Icon(Iconsax.location5,
                          color: AppColors.neonGold, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        widget.profile.city ?? "Nearby",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Bottom Info Content
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.verified,
                              color: Colors.blueAccent, size: 22),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (widget.profile.interests.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          children: widget.profile.interests.take(3).map((interest) {
                            return _glassContainer(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "${interest.emoji} ${interest.name}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPassButton(context),
                          circularActionBtnhome(
                              Iconsax.message_text5, Colors.white, Colors.white10),
                          circularActionBtnhome(
                              Iconsax.video5, Colors.white, Colors.white10),
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

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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