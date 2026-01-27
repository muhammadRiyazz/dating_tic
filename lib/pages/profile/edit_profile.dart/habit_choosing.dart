 // Method to show Smoking Habit Bottom Sheet
  import 'package:dating/main.dart';
import 'package:dating/providers/profile_update.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
  final List<Map<String, dynamic>> _smokingOptions = [
    {'value': 'never', 'label': 'Never', 'icon': Iconsax.activity},
    {'value': 'socially', 'label': 'Socially', 'icon': Iconsax.people},
    {'value': 'occasionally', 'label': 'Occasionally', 'icon': Iconsax.calendar},
    {'value': 'regularly', 'label': 'Regularly', 'icon': Iconsax.flash_circle},
  ];

  final List<Map<String, dynamic>> _drinkingOptions = [
    {'value': 'never', 'label': 'Never', 'icon': Iconsax.activity},
    {'value': 'socially', 'label': 'Socially', 'icon': Iconsax.people},
    {'value': 'occasionally', 'label': 'Occasionally', 'icon': Iconsax.calendar},
    {'value': 'regularly', 'label': 'Regularly', 'icon': Iconsax.flash_circle},
    {'value': 'sober', 'label': 'Sober', 'icon': Iconsax.health},
  ];
void showSmokingHabitSheet(BuildContext context) {
    final updateProvider = context.read<UpdateProfileProvider>();
    final currentHabit = updateProvider.userProfile.smokingHabit;

    showModalBottomSheet(
      
      context: context,
      backgroundColor: const Color(0xFF0A0A0A),
      isScrollControlled: true,
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(

            constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
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
          child: Column(
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
                    Text(
                      "Smoking Habit",
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

              // Options
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _smokingOptions.length,
                  itemBuilder: (context, index) {
                    final option = _smokingOptions[index];
                    final isSelected = currentHabit == option['value'];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            updateProvider.updateLifestyle(
                              smokingHabit: option['value'] as String,
                            );
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.neonGold.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(
                              //   color: isSelected
                              //       ? AppColors.neonGold.withOpacity(0.5)
                              //       : Colors.white.withOpacity(0.1),
                              // ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.neonGold
                                        : Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    option['icon'] as IconData,
                                    color: isSelected ? Colors.black : Colors.white70,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option['label'] as String,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.neonGold
                                              : Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getSmokingDescription(option['value'] as String),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Iconsax.tick_circle,
                                      color: AppColors.neonGold, size: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom padding
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  // Method to show Drinking Habit Bottom Sheet
  void showDrinkingHabitSheet(BuildContext context) {
    final updateProvider = context.read<UpdateProfileProvider>();
    final currentHabit = updateProvider.userProfile.drinkingHabit;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0A0A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(  constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
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
          child: Column(
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
                    Text(
                      "Drinking Habit",
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

              // Options
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _drinkingOptions.length,
                  itemBuilder: (context, index) {
                    final option = _drinkingOptions[index];
                    final isSelected = currentHabit == option['value'];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            updateProvider.updateLifestyle(
                              drinkingHabit: option['value'] as String,
                            );
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.neonGold.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(
                              //   color: isSelected
                              //       ? AppColors.neonGold.withOpacity(0.5)
                              //       : Colors.white.withOpacity(0.1),
                              // ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.neonGold
                                        : Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    option['icon'] as IconData,
                                    color: isSelected ? Colors.black : Colors.white70,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option['label'] as String,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.neonGold
                                              : Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getDrinkingDescription(option['value'] as String),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Iconsax.tick_circle,
                                      color: AppColors.neonGold, size: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom padding
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  // Helper methods for descriptions
  String _getSmokingDescription(String value) {
    switch (value) {
      case 'never':
        return 'I don\'t smoke';
      case 'socially':
        return 'Only at parties or social events';
      case 'occasionally':
        return 'Sometimes, but not often';
      case 'regularly':
        return 'Smoke regularly';
      default:
        return '';
    }
  }

  String _getDrinkingDescription(String value) {
    switch (value) {
      case 'never':
        return 'I don\'t drink alcohol';
      case 'socially':
        return 'Only at social gatherings';
      case 'occasionally':
        return 'Once in a while';
      case 'regularly':
        return 'Drink regularly';
      case 'sober':
        return 'Sober lifestyle';
      default:
        return '';
    }
  }

  // Convert habit value to display text
  String getDisplayHabit(String? value) {
    if (value == null) return "Add Habit";
    
    final allOptions = [..._smokingOptions, ..._drinkingOptions];
    final option = allOptions.firstWhere(
      (opt) => opt['value'] == value,
      orElse: () => {'label': value},
    );
    
    return option['label'] as String;
  }
