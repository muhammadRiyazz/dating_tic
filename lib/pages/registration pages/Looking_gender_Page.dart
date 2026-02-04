// lib/pages/registration/looking_for_page.dart
import 'dart:developer';

import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/HeightPage.dart';
import 'package:dating/pages/registration%20pages/relationship_goals_Page.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:dating/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LookingForPage extends StatefulWidget {
  const LookingForPage({super.key, required this.userdata});
  final UserRegistrationModel userdata;

  @override
  _LookingForPageState createState() => _LookingForPageState();
}

class _LookingForPageState extends State<LookingForPage> {
  // Premium Avatar URLs (Matching your gender_page design)
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
    
    // Use the looking for validation from your provider
    if (provider.selectedLookingForId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red, 
          content: Text('Please select who you are looking for')
        ),
      );
      return;
    }
    
    final updatedData = widget.userdata.copyWith(
      intrestgender: provider.selectedLookingForId, // Fixed: use selectedLookingForId instead of selectedGenderId
    );
    
    log('Looking for selection:');
    log('Selected lookingForId: ${provider.selectedLookingForId.toString()}');
    log('Updated userdata intrestgender: ${updatedData.intrestgender.toString()}');

    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => RelationshipGoalsPage(userdata: updatedData))
    );
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
                      : _buildPreferenceSelection(provider),
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

  Widget _buildPreferenceSelection(RegistrationDataProvider provider) {
    final primaryGenders = provider.genders.where((g) {
      final title = g['genderTitle']?.toString().toLowerCase() ?? '';
      return title == 'male' || title == 'female' || title == 'man' || title == 'woman';
    }).toList();

    primaryGenders.sort((a, b) => b['genderTitle'].toString().length.compareTo(a['genderTitle'].toString().length));

    final otherGenders = provider.genders.where((g) => !primaryGenders.contains(g)).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
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
              "Other Preferences".toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ...otherGenders.map((gender) => _buildSecondaryListTile(gender, provider)),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAvatarBox(dynamic gender, String imageUrl, RegistrationDataProvider provider) {
    // Use selectedLookingForId for selection logic
    final isSelected = provider.selectedLookingForId == gender['genderId'].toString();
    
    return GestureDetector(
      onTap: () => provider.selectLookingFor(gender['genderId'].toString()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 200,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.cardBlack.withOpacity(0.6),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
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

  Widget _buildSecondaryListTile(dynamic gender, RegistrationDataProvider provider) {
    // Use selectedLookingForId for selection logic
    final isSelected = provider.selectedLookingForId == gender['genderId'].toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => provider.selectLookingFor(gender['genderId'].toString()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neonGold.withOpacity(0.05) : Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
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
          'Who do you want to meet?',
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose who you\'d like to see on your feed.',
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
          Icon(Iconsax.heart_tick, color: AppColors.neonGold.withOpacity(0.5), size: 18),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'We will use this preference to show you the best matches.',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(RegistrationDataProvider provider) {
    final bool canContinue = provider.selectedLookingForId != null;
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