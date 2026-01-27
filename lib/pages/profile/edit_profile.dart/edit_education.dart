import 'package:dating/main.dart'; // For AppColors
import 'package:dating/models/profile_model.dart';
import 'package:dating/providers/profile_update.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

// Method to show Education Bottom Sheet
void showEducationBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0A0A0A),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return _EducationBottomSheet();
    },
  );
}

class _EducationBottomSheet extends StatefulWidget {
  @override
  State<_EducationBottomSheet> createState() => _EducationBottomSheetState();
}

class _EducationBottomSheetState extends State<_EducationBottomSheet> {
  Education? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1A1A1A),
            const Color(0xFF0A0A0A),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Consumer2<RegistrationDataProvider, UpdateProfileProvider>(
        builder: (context, registrationProvider, updateProvider, child) {
          final educationList = registrationProvider.educationLevels;
          final currentEducation = updateProvider.userProfile.education;
          
          // Check if education is selected
          bool isEducationSelected(Map<String, dynamic> education) {
            if (currentEducation == null) return false;
            
            // Get eduId from the map (could be int or String)
            final eduId = education['eduId'];
            if (eduId != null) {
              // Convert both to strings for comparison
              return currentEducation.id?.toString() == eduId.toString();
            }
            
            // Or compare based on name
            return currentEducation.name == education['eduTitle'];
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Education Level",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Iconsax.close_circle,
                          color: Colors.white38, size: 24),
                    ),
                  ],
                ),
              ),

              // Loading State
              if (registrationProvider.educationLoading)
                Expanded(
                  child: _buildShimmerLoading(),
                ),

              // Empty State
              if (!registrationProvider.educationLoading && educationList.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.book, 
                            color: Colors.white.withOpacity(0.3), size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          "No education levels available",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Check your connection",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Options Grid using Wrap
              if (!registrationProvider.educationLoading && educationList.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: educationList.map((education) {
                        final isSelected = isEducationSelected(education);
                        
                        return _buildEducationChip(
                          education: education,
                          isSelected: isSelected,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            
                            // Create Education object
                            final eduId = education['eduId'];
                            final eduTitle = education['eduTitle'] ?? '';
                            
                            // Convert eduId to int
                            int? id;
                            if (eduId != null) {
                              if (eduId is int) {
                                id = eduId;
                              } else if (eduId is String) {
                                id = int.tryParse(eduId);
                              }
                            }
                            
                            final newEducation = Education(
                              id: id ?? 0,
                              name: eduTitle,
                            );
                            
                            updateProvider.updateEducation(newEducation);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),

              // Bottom padding
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(8, (index) {
          return Container(
            width: 150,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEducationChip({
    required Map<String, dynamic> education,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.neonGold.withOpacity(0.15)
                : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(
            //   color: isSelected
            //       ? AppColors.neonGold.withOpacity(0.5)
            //       : Colors.white.withOpacity(0.08),
            //   width: isSelected ? 1.5 : 1,
            // ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text
              Text(
                education['eduTitle'] ?? 'Unknown',
                style: TextStyle(
                  color: isSelected ? AppColors.neonGold : Colors.white,
                  fontSize: isSelected? 14:12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              // Selection Indicator
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Iconsax.tick_circle,
                      color: AppColors.neonGold, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper method to get display text for education
String getEducationDisplay(BuildContext context) {
  final updateProvider = context.read<UpdateProfileProvider>();
  final education = updateProvider.userProfile.education;
  
  if (education == null || education.name == null || education.name!.isEmpty) {
    return "Add Education";
  }
  
  return education.name!;
}