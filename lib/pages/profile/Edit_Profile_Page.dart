import 'dart:ui';
import 'package:dating/main.dart'; 
import 'package:dating/models/profile_model.dart';
import 'package:dating/providers/my_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _jobController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<MyProfileProvider>().userProfile;
    _nameController = TextEditingController(text: profile?.userName ?? "");
    _bioController = TextEditingController(text: profile?.bio ?? "");
    _jobController = TextEditingController(text: profile?.job ?? "");
    _cityController = TextEditingController(text: profile?.city ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _jobController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          _buildTopGradient(),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. HEADER
                SliverToBoxAdapter(child: _buildHeader(context)),

                // 2. MEDIA GRID
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("MEDIA MANAGER"),
                        _buildPhotoEditorGrid(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // 3. MAIN FORM CONTENT (Fixed the Argument Error here)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("BASIC INFO"),
                        _buildGlassInput(label: "Full Name", controller: _nameController, icon: Iconsax.user),
                        const SizedBox(height: 12),
                        _buildGlassInput(label: "About Me", controller: _bioController, icon: Iconsax.document_text, maxLines: 4),
                        
                        const SizedBox(height: 30),
                        _buildSectionTitle("LIFESTYLE & WORK"),
                        _buildSelectorTile(icon: Iconsax.briefcase, title: "Occupation", value: _jobController.text.isEmpty ? "Add Job" : _jobController.text),
                        _buildSelectorTile(icon: Iconsax.location, title: "Current City", value: _cityController.text.isEmpty ? "Add City" : _cityController.text),
                        _buildSelectorTile(icon: Iconsax.teacher, title: "Education", value: "University Graduate"),
                        
                        const SizedBox(height: 30),
                        _buildSectionTitle("PREFERENCES"),
                        _buildSelectorTile(icon: Iconsax.heart, title: "Relationship Goal", value: "Long-term Partner"),
                        _buildSelectorTile(icon: Iconsax.ruler, title: "Height", value: "182 cm"),
                        
                        const SizedBox(height: 30),
                        _buildSectionTitle("INTERESTS"),
                        _buildInterestChips(),
                        
                        const SizedBox(height: 150), // Spacing for bottom save bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. FLOATING SAVE BUTTON
          _buildFixedSaveAction(),
        ],
      ),
    );
  }

  // --- UI WIDGETS ---

  Widget _buildTopGradient() {
    return Positioned(
      top: 0, left: 0, right: 0,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF4D67).withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Edit Studio",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
              Text("Manage your digital presence",
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
            ],
          ).animate().fadeIn().slideX(begin: -0.1),
          _glassIconButton(Iconsax.arrow_left_2, () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildPhotoEditorGrid() {
    final profile = context.watch<MyProfileProvider>().userProfile;
    final photos = profile?.photos ?? [];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        bool hasPhoto = index < photos.length;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            image: hasPhoto ? DecorationImage(image: NetworkImage(photos[index]), fit: BoxFit.cover) : null,
          ),
          child: Stack(
            children: [
              if (!hasPhoto) const Center(child: Icon(Iconsax.add, color: Colors.white24, size: 28)),
              if (index == 0 && hasPhoto)
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neonGold.withOpacity(0.9),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
                    ),
                    child: const Text("PRIMARY",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w900)),
                  ),
                ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: Icon(hasPhoto ? Iconsax.close_circle : Iconsax.add_circle, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassInput({required String label, required TextEditingController controller, required IconData icon, int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.neonGold.withOpacity(0.5), size: 20),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSelectorTile({required IconData icon, required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {}, // Navigate to selection page
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white38, size: 20),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const Spacer(),
              Text(value, style: const TextStyle(color: AppColors.neonGold, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 10),
              const Icon(Iconsax.arrow_right_3, color: Colors.white24, size: 16),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildInterestChips() {
    final interests = ["Travel", "Gym", "Sushi", "Tech", "Photography", "Art"];
    return Wrap(
      spacing: 10, runSpacing: 10,
      children: interests.map((i) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.neonPink.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.neonPink.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(i, style: const TextStyle(color: Colors.white, fontSize: 13)),
            const SizedBox(width: 8),
            const Icon(Icons.close, color: Colors.white38, size: 14),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildFixedSaveAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 100,
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.neonPink, AppColors.neonGold]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text("SAVE CHANGES", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 15, top: 10),
      child: Text(title, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)),
    );
  }

  Widget _glassIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}