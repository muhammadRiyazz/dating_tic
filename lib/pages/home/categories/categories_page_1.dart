import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class CategoriesPage1 extends StatelessWidget {
    final List<Profile> profiles; // Add this line

  const CategoriesPage1({super.key ,required this.profiles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 12, right: 12),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => ImmersiveProfileCard(profile: profiles[i]),
    );
  }
}



class ImmersiveProfileCard extends StatefulWidget {
  final Profile profile;
  const ImmersiveProfileCard({super.key, required this.profile});

  @override
  State<ImmersiveProfileCard> createState() => _ImmersiveProfileCardState();
}

class _ImmersiveProfileCardState extends State<ImmersiveProfileCard> {
  final List<Widget> _particles = [];

  // Helper function to calculate age
  int _calculateAge(String? dobString) {
    if (dobString == null || dobString.isEmpty) return 0;
    try {
      // Handles formats like "YYYY-MM-DD"
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

  void _triggerHeartExplosion() {
    for (int i = 0; i < 15; i++) {
      _addParticle();
    }
  }

  void _addParticle() {
    final random = Random();
    final double angle = -pi / 2 + (random.nextDouble() - 0.5);
    final double speed = 100 + random.nextDouble() * 200;
    final key = UniqueKey();

    // Note: Ensure HeartParticle widget exists in your project
    /* 
    final widget = HeartParticle(
      key: key,
      angle: angle,
      speed: speed,
      onComplete: () {
        if (mounted) setState(() => _particles.removeWhere((element) => element.key == key));
      },
    );
    setState(() => _particles.add(widget));
    */
  }

  @override
  Widget build(BuildContext context) {
    final int age = _calculateAge(widget.profile.dateOfBirth);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsPage(profiledata:widget.profile ,);
        },));
      },
      child: Container(
        height: 500, // Increased height for a more premium look
        margin: const EdgeInsets.only(bottom: 25, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 1. Profile Main Image
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                imageUrl: widget.profile.photo,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[900]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
      
            // 2. Sophisticated Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.2, 0.6, 1.0],
                ),
              ),
            ),
      
            // 3. Location Badge (Top Left)
            Positioned(
              top: 20,
              left: 20,
              child: _glassContainer(
                child: Row(
                  children: [
                    const Icon(Iconsax.location5, color: AppColors.neonGold, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      widget.profile.city ?? "Nearby",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            // 4. Content Area (Bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name and Age
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.profile.userName}, $age",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Icon(Icons.verified, color: Colors.blueAccent, size: 22),
                        ),
                      ],
                    ),
      
                    // Job / Education
                    // if (widget.profile.job != null)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 4),
                    //     child: Text(
                    //       "${widget.profile.job} • ${widget.profile.education.name}",
                    //       style: TextStyle(
                    //         color: Colors.white.withOpacity(0.8),
                    //         fontSize: 14,
                    //       ),
                    //     ),
                    //   ),
      
                    const SizedBox(height: 5),
      
                    // Interests (Dynamic from Model)
                    if (widget.profile.interests.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.profile.interests.take(3).map((interest) {
                          return _glassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text(
                              "${interest.emoji} ${interest.name}",
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          );
                        }).toList(),
                      ),
      
                    // const SizedBox(height: 15),
      
                    // // Bio
                    // if (widget.profile.bio != null)
                    //   Text(
                    //     widget.profile.bio!,
                    //     maxLines: 2,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: TextStyle(
                    //       color: Colors.white.withOpacity(0.7),
                    //       fontSize: 13,
                    //       height: 1.4,
                    //     ),
                    //   ),
      
                    const SizedBox(height: 10),
      
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _circularActionBtn(Iconsax.close_circle, Colors.white, Colors.white10),
                        _circularActionBtn(Iconsax.message_text5, Colors.white, Colors.white10),
                        _circularActionBtn(Iconsax.video5, Colors.white, Colors.white10),
                        
                        // Heart Button
                        GestureDetector(
                          onTap: () {
                            _triggerHeartExplosion();
                            HapticFeedback.heavyImpact();
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.neonGold, Color(0xFFFFB74D)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonGold.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(Iconsax.heart5, color: Colors.black, size: 30),
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
    );
  }

  // Helper widget for Glass buttons/badges
  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  // Helper widget for circular buttons
  Widget _circularActionBtn(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}