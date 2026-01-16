import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/home/widgets/animations/heart_particle.dart';
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
    
    final widget = HeartParticle(
      key: key,
      angle: angle,
      speed: speed,
      onComplete: () {
        if (mounted) setState(() => _particles.removeWhere((element) => element.key == key));
      },
    );
    setState(() => _particles.add(widget));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:   380,
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.cardBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CachedNetworkImage(
              imageUrl: widget.profile.photo,
              height: 580,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.95),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Location Badge
          Positioned(
            top: 25,
            left: 25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.location, color: AppColors.neonGold, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        widget.profile.latitude??'',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Online Status Indicator
          // if (widget.profile.isOnline)
          //   Positioned(
          //     top: 25,
          //     right: 25,
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(20),
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          //           decoration: BoxDecoration(
          //             color: Colors.green.withOpacity(0.3),
          //             borderRadius: BorderRadius.circular(20),
          //             border: Border.all(color: Colors.green.withOpacity(0.5)),
          //           ),
          //           child: Row(
          //             children: [
          //               Container(
          //                 width: 8,
          //                 height: 8,
          //                 decoration: BoxDecoration(
          //                   color: Colors.green,
          //                   borderRadius: BorderRadius.circular(4),
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.green.withOpacity(0.5),
          //                       blurRadius: 8,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               const SizedBox(width: 6),
          //               Text(
          //                 "Online",
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          
          // Bottom Info Card
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E).withOpacity(0.2),
                    // border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Verification
                      Row(
                        children: [
                          Text(
                            "${widget.profile.userName}, ${widget.profile.dateOfBirth}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 10,),
                          // if (widget.profile.isVerified)
                          //   const Icon(Icons.verified, color: AppColors.neonGold, size: 18),
                        ],
                      ),
                      
                      const SizedBox(height: 2),
                      
                      // Bio
                      Text(
                        widget.profile.bio??'',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 10,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Interests Tags
                      // if (widget.profile.tags.isNotEmpty)
                      //   Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Wrap(
                      //         spacing: 8,
                      //         runSpacing: 6,
                      //         children: widget.profile.tags.map((tag) {
                      //           return Container(
                      //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //             decoration: BoxDecoration(
                      //               color: AppColors.neonGold.withOpacity(0.2),
                      //               borderRadius: BorderRadius.circular(15),
                      //               border: Border.all(
                      //                 color: AppColors.neonGold.withOpacity(0.3),
                      //                 width: 1,
                      //               ),
                      //             ),
                      //             child: Text(
                      //               "#$tag",
                      //               style: TextStyle(
                      //                 color: AppColors.neonGold,
                      //                 fontSize: 8,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             ),
                      //           );
                      //         }).toList(),
                      //       ),
                      //       const SizedBox(height: 10),
                      //     ],
                      //   ),
                      
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _glassActionBtn(Iconsax.close_circle, Colors.white70, "Pass"),
                          _glassActionBtn(Iconsax.message, Colors.white70, "Message"),
                          _glassActionBtn(Iconsax.call, Colors.white70, "Call"),
                          GestureDetector(
                            onTap: () {
                              _triggerHeartExplosion();
                              HapticFeedback.mediumImpact();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.neonGold, AppColors.richOrange],
                                ),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.neonGold.withOpacity(0.5),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  const Icon(Iconsax.heart5, color: Colors.black, size: 26),
                                  ..._particles,
                                ],
                              ),
                            ),
                          ),
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
    );
  }
  
  Widget _glassActionBtn(IconData icon, Color color, String label) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
      ],
    );
  }
}