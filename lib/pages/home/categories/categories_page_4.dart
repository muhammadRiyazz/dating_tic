import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:iconsax/iconsax.dart';

class CategoriesPage4 extends StatelessWidget {
      final List<Profile> profiles; // Add this line

  const CategoriesPage4({super.key , required this.profiles});

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 20, right: 20),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => CallGirlCard(profile: profiles[i]),
    );
  }
}


class CallGirlCard extends StatelessWidget {
  final Profile profile;
  
  const CallGirlCard({super.key, required this.profile});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(
          image: CachedNetworkImageProvider(profile.photo),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.purple.withOpacity(0.1), Colors.black],
                stops: const [0.0, 0.9],
              ),
            ),
          ),
          // Live Indicator
          // if (profile.isOnline)
          //   Positioned(
          //     top: 20,
          //     left: 20,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //       decoration: BoxDecoration(
          //         color: Colors.red,
          //         borderRadius: BorderRadius.circular(20),
          //         boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 10)],
          //       ),
          //       child: const Row(
          //         children: [
          //           Icon(Icons.circle, color: Colors.white, size: 8),
          //           SizedBox(width: 4),
          //           Text(
          //             "LIVE NOW",
          //             style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                profile.userName,
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              // if (profile.isVerified) const SizedBox(width: 8),
                              // if (profile.isVerified)
                              //   const Icon(Iconsax.verify, color: AppColors.neonGold, size: 18),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   profile.latitude??'',
                          //   style: const TextStyle(color: AppColors.neonGold, fontSize: 14, fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ),
                    // Action Buttons
                    Row(
                      children: [
                        _callGirlActionBtn(Iconsax.close_circle, Colors.red.withOpacity(0.3), "Pass"),
                        const SizedBox(width: 10),
                        _callGirlActionBtn(Iconsax.message, Colors.blue.withOpacity(0.3), "Msg"),
                        const SizedBox(width: 10),
                        _callGirlActionBtn(Iconsax.call, Colors.green.withOpacity(0.3), "Call"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Tags
                // Wrap(
                //   spacing: 8,
                //   children: profile.tags.map((tag) {
                //     return Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                //       decoration: BoxDecoration(
                //         color: Colors.white.withOpacity(0.1),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: Text(
                //         "#$tag",
                //         style: const TextStyle(color: Colors.white70, fontSize: 11),
                //       ),
                //     );
                //   }).toList(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _callGirlActionBtn(IconData icon, Color bgColor, String label) {
    return Column(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: bgColor.withOpacity(0.4), blurRadius: 8)],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}