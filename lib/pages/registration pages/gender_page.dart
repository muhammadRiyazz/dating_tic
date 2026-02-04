// lib/pages/registration/gender_page.dart
import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/HeightPage.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:dating/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key, required this.userdata});
  final UserRegistrationModel userdata;

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  // Premium Avatar URLs (Replace these with your actual image links)
  final String maleAvatarUrl = "assets/image/boy.png";
  final String femaleAvatarUrl = "assets/image/girl.png";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RegistrationDataProvider>();
      if (provider.gendersStatus == DataLoadStatus.initial) {
        provider.loadGenders();
      }
    });
  }

  void _continue() {
    final provider = context.read<RegistrationDataProvider>();
    if (!provider.validateGenderPage()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('Please select your gender')),
      );
      return;
    }
    final data = widget.userdata.copyWith(gender: provider.selectedGenderId);
    Navigator.push(context, MaterialPageRoute(builder: (context) => HeightPage(userdata: data)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationDataProvider>();

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
                    colors: [
                      AppColors.neonGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                Expanded(
                  child: provider.gendersLoading
                      ? _buildShimmerLoading()
                      : _buildGenderSelection(provider),
                ),
                _buildSecurityCard(),
                _buildContinueButton(provider),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection(RegistrationDataProvider provider) {
    // Separate Male/Female for the Top Boxes
    final primaryGenders = provider.genders.where((g) {
      final title = g['genderTitle']?.toString().toLowerCase() ?? '';
      return title == 'male' || title == 'female' || title == 'man' || title == 'woman';
    }).toList();

    // Sort to ensure Male is first usually
    primaryGenders.sort((a, b) => b['genderTitle'].toString().length.compareTo(a['genderTitle'].toString().length));

    final otherGenders = provider.genders.where((g) => !primaryGenders.contains(g)).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // 1. PRIMARY AVATAR BOXES (Male & Female)
          Row(
            children: primaryGenders.map((gender) {
              final title = gender['genderTitle']?.toString().toLowerCase() ?? '';
              final imageUrl = (title.contains('female') || title.contains('woman')) 
                                ? femaleAvatarUrl 
                                : maleAvatarUrl;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildAvatarBox(gender, imageUrl, provider),
                ),
              );
            }).toList(),
          ),
          
          if (otherGenders.isNotEmpty) ...[
            const SizedBox(height: 35),
            Text(
              "More Options".toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // 2. LIST VIEW (For Others)
            ...otherGenders.map((gender) => _buildSecondaryListTile(gender, provider)),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Large Boxes with Image Avatars
  Widget _buildAvatarBox(dynamic gender, String imageUrl, RegistrationDataProvider provider) {
    final isSelected = provider.selectedGenderId == gender['genderId'].toString();
    
    return GestureDetector(
      onTap: () => provider.selectGender(gender['genderId'].toString()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 200, // Slightly taller for images
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color:  AppColors.cardBlack.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30),
        
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.neonGold.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ] : [],
        ),
        child: Column(
          children: [
            const SizedBox(height: 15),
            // Selection Radio Indicator
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.yellow : Colors.white24,
                      width: 2,
                    ),
                  ),
                  child: isSelected 
                      ? const Center(child: Icon(Icons.circle, size: 12, color: Colors.yellow)) 
                      : null,
                ),
              ),
            ),
            // Avatar Image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                  // loadingBuilder: (context, child, loadingProgress) {
                  //   if (loadingProgress == null) return child;
                  //   return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  // },
                ),
              ),
            ),
            // Gender Title
            Text(
              gender['genderTitle']?.toString().toUpperCase() ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Secondary List Style
  Widget _buildSecondaryListTile(dynamic gender, RegistrationDataProvider provider) {
    final isSelected = provider.selectedGenderId == gender['genderId'].toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => provider.selectGender(gender['genderId'].toString()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neonGold.withOpacity(0.05) : Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(
            //   color: isSelected ? AppColors.neonGold : Colors.white.withOpacity(0.05),
            //   width: 1,
            // ),
          ),
          child: Row(
            children: [
              // Text(gender['genderEmoji'] ?? '✨', style: const TextStyle(fontSize: 18)),
              // const SizedBox(width: 15),
              Expanded(
                child: Text(
                  gender['genderTitle'] ?? '',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected) 
                const Icon(Iconsax.tick_circle, color: AppColors.neonGold, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.cardBlack,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: const Icon(Iconsax.arrow_left_2, color: AppColors.neonGold, size: 20),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'Which one are you?',
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your gender to see relevant people.',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Iconsax.lock, color: AppColors.neonGold.withOpacity(0.5), size: 18),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Your profile identity is kept secure and private.',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(RegistrationDataProvider provider) {
    final bool canContinue = provider.selectedGenderId != null;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: canContinue ? _continue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGold,
          disabledBackgroundColor: AppColors.neonGold.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ShimmerLoading(isLoading: true, child: GridItemShimmer(height: 80)),
      ),
    );
  }
}