import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/home/widgets/animations/pulse_animation_small.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:iconsax/iconsax.dart';

class CategoriesPage5 extends StatelessWidget {
      final List<Profile> profiles; // Add this line

  const CategoriesPage5({super.key , required this.profiles});

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nearby Matches",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${profiles.length} people nearby",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.filter, color: AppColors.neonGold, size: 14),
                    const SizedBox(width: 4),
                    Text("Filter", style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Nearby Cards Grid
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 110),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: profiles.length,
            itemBuilder: (context, index) => NearbyCard(profile: profiles[index]),
          ),
        ),
      ],
    );
  }
}



class NearbyCard extends StatelessWidget {
  final Profile profile;
  
  const NearbyCard({super.key, required this.profile});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBlack,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image with Pulse Animation
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: profile.photo,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Pulse Animation Overlay
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: PulseAnimationSmall(),
                ),
                // Distance Badge
                // Positioned(
                //   top: 10,
                //   left: 10,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.6),
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(Iconsax.location, color: AppColors.neonGold, size: 10),
                //         const SizedBox(width: 4),
                //         Text(profile.location.latitude??'', style: const TextStyle(color: Colors.white, fontSize: 10)),
                //       ],
                //     ),
                //   ),
                // ),
                // Online Indicator
                // if (profile.isOnline)
                //   Positioned(
                //     top: 10,
                //     right: 10,
                //     child: Container(
                //       width: 10,
                //       height: 10,
                //       decoration: BoxDecoration(
                //         color: Colors.green,
                //         shape: BoxShape.circle,
                //         boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 8)],
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
          
          // Profile Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      profile.userName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    // if (profile.isVerified)
                    //   Icon(Iconsax.verify5, color: AppColors.neonGold, size: 14),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${profile.dateOfBirth} • ${profile.bio}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 8),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Message Button
                    Expanded(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.message, color: AppColors.blueAccent, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              "Message",
                              style: TextStyle(color: AppColors.blueAccent, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Call Button
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.greenAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Iconsax.call, color: AppColors.greenAccent, size: 14),
                    ),
                    const SizedBox(width: 8),
                    // Heart Button
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.pinkAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Iconsax.heart, color: AppColors.pinkAccent, size: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}