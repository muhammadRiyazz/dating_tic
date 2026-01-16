import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';

class CategoriesPage3 extends StatelessWidget {
      final List<Profile> profiles; // Add this line

  const CategoriesPage3({super.key , required this.profiles});

  @override
  Widget build(BuildContext context) {
    
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 16, right: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => ModelGridCard(profile: profiles[i]),
    );
  }
}


class ModelGridCard extends StatelessWidget {
  final Profile profile;
  
  const ModelGridCard({super.key, required this.profile});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: CachedNetworkImageProvider(profile.photo),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Available",
                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.userName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                // Wrap(
                //   spacing: 4,
                //   children: profile.tags.take(2).map((t) {
                //     return Text(
                //       "#$t",
                //       style: TextStyle(color: AppColors.neonGold, fontSize: 10),
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
}