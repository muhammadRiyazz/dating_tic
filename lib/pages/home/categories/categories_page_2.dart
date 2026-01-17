import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:dating/main.dart';
import 'package:iconsax/iconsax.dart';

class CategoriesPage2 extends StatelessWidget {
  final List<Profile> profiles;

  const CategoriesPage2({super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Bouncing effect for a premium feel
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 110, top: 10, left: 14, right: 14),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => EliteCard(profile: profiles[i]),
    );
  }
}

class EliteCard extends StatelessWidget {
  final Profile profile;

  const EliteCard({super.key, required this.profile});

  // Helper to calculate age from DOB string (YYYY-MM-DD)
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

  @override
  Widget build(BuildContext context) {
    final int age = _calculateAge(profile.dateOfBirth);

    return GestureDetector(
        onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsPage(profiledata:profile ,);
        },));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.black,
          // Premium Dark Gradient
          // gradient: const LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [ Color(0xFF0F0F0F)],
          // ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black.withOpacity(0.3),
            //   blurRadius: 12,
            //   offset: const Offset(0, 6),
            // ),
          ],
        ),
        child: IntrinsicHeight( // Ensures the row components match height
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Profile Image with Overlay Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(23),
                      bottomLeft: Radius.circular(23),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: profile.photo,
                      width: 125,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Tiny "Online" indicator on image
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: [BoxShadow(color: Colors.greenAccent.withOpacity(0.5), blurRadius: 4)],
                      ),
                    ),
                  ),
                ],
              ),
      
              // 2. Info Side
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Label & Verify
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.neonGold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.neonGold.withOpacity(0.5)),
                            ),
                            child: const Text(
                              "ELITE MEMBER",
                              style: TextStyle(
                                color: AppColors.neonGold,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Icon(Iconsax.verify5, color: Colors.blueAccent, size: 18),
                        ],
                      ),
                      const SizedBox(height: 10),
      
                      // Name and Age
                      Text(
                        "${profile.userName}, $age",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
      
                      // Location Info
                      Row(
                        children: [
                          Icon(Iconsax.location, color: Colors.grey[500], size: 12),
                          const SizedBox(width: 4),
                          Text(
                            "${profile.city ?? 'Nearby'} • ${profile.job ?? 'Professional'}",
                            style: TextStyle(color: Colors.grey[500], fontSize: 11),
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 12),
      
                      // Dynamic Interests Tags
                      if (profile.interests.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: profile.interests.take(2).map((interest) {
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
                        ),
      
                      const Spacer(),
      
                      // Action Buttons Row
                      Row(
                        children: [
                          _smallActionBtn(Iconsax.message_text5, AppColors.neonGold),
                          const SizedBox(width: 10),
                          _smallActionBtn(Iconsax.call5, Colors.white),
                          const Spacer(),
                          
                          // New Like Button
                          GestureDetector(
                            onTap: () {
                              // Add Like logic here
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.neonGold, Color(0xFFFFB74D)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Iconsax.heart5, color: Colors.black, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "LIKE",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallActionBtn(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}