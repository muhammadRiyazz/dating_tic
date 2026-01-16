import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:iconsax/iconsax.dart';

class CategoriesPage2 extends StatelessWidget {
      final List<Profile> profiles; // Add this line

  const CategoriesPage2({super.key , required this.profiles});

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 12, right: 12),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => EliteCard(profile: profiles[i]),
    );
  }
}

class EliteCard extends StatelessWidget {
  final Profile profile;
  
  const EliteCard({super.key, required this.profile});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGold.withOpacity(0.05),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(23),
              bottomLeft: Radius.circular(23),
            ),
            child: CachedNetworkImage(
              imageUrl: profile.photo,
              width: 110,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.neonGold,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "BLACK CARD",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Iconsax.verify5, color: AppColors.neonGold, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${profile.latitude} • Active",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  // Tags
                  // Wrap(
                  //   spacing: 8,
                  //   children: profile.tags.take(2).map((tag) {
                  //     return Container(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white.withOpacity(0.1),
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       child: Text(
                  //         "#$tag",
                  //         style: const TextStyle(color: Colors.white70, fontSize: 10),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _smallActionBtn(Iconsax.message, AppColors.blueAccent),
                      const SizedBox(width: 10),
                      _smallActionBtn(Iconsax.call, AppColors.greenAccent),
                      const SizedBox(width: 10),
                      _smallActionBtn(Iconsax.video, AppColors.purpleAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _smallActionBtn(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}