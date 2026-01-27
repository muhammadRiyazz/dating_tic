import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/providers/profile_update.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

// Method to show Interests Bottom Sheet
void showInterestsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0A0A0A),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return _InterestsBottomSheet();
    },
  );
}

class _InterestsBottomSheet extends StatefulWidget {
  @override
  State<_InterestsBottomSheet> createState() => _InterestsBottomSheetState();
}

class _InterestsBottomSheetState extends State<_InterestsBottomSheet> {
  List<Interest> _selectedInterests = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final updateProvider = context.read<UpdateProfileProvider>();
    final registrationProvider = context.read<RegistrationDataProvider>();
    
    // Load current selected interests
    final currentInterests = updateProvider.userProfile.interests;
    _selectedInterests = List.from(currentInterests);
    
    // Load interests list if not loaded
    if (registrationProvider.interests.isEmpty) {
      registrationProvider.loadInterests();
    }
    
    _initialized = true;
    if (mounted) setState(() {});
  }

  bool _isInterestSelected(String interestId) {
    return _selectedInterests.any((interest) => interest.id.toString() == interestId);
  }

  void _toggleInterest(Map<String, dynamic> interestData) {
    HapticFeedback.lightImpact();
    
    final interestId = interestData['id'].toString();
    final interestName = interestData['name'] ?? 'Unknown';
    final interestEmoji = interestData['emoji'] ?? '❤️';
    
    setState(() {
      final existingIndex = _selectedInterests.indexWhere(
        (interest) => interest.id.toString() == interestId
      );
      
      if (existingIndex != -1) {
        // Remove if already selected
        _selectedInterests.removeAt(existingIndex);
      } else {
        // Add if not selected and under limit
        if (_selectedInterests.length < 10) {
          _selectedInterests.add(Interest(
            id: int.tryParse(interestId) ?? 0,
            name: interestName,
            emoji: interestEmoji,
          ));
        }
      }
    });
    
    // Auto-update when interest is toggled
    _autoUpdateInterests();
  }

  int get _selectedCount => _selectedInterests.length;
  bool get _hasMinimumSelection => _selectedCount >= 3;
  bool get _hasMaximumSelection => _selectedCount >= 10;

  Future<void> _autoUpdateInterests() async {
    // Only auto-update if we have at least 3 interests
    if (!_hasMinimumSelection) return;

    try {
      final updateProvider = context.read<UpdateProfileProvider>();
      updateProvider.updateInterests(_selectedInterests);
      
      // Show brief success indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${
              _selectedCount == 10 
                ? 'Maximum 10 interests selected' 
                : '${_selectedCount} interests selected'
            }'),
            backgroundColor: AppColors.neonGold,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (error) {
      // Silent error - user won't notice
    }
  }

  @override
  Widget build(BuildContext context) {
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
SizedBox(height: 12,),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:  24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Interests",
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

          // Content
          Expanded(
            child: Consumer<RegistrationDataProvider>(
              builder: (context, registrationProvider, child) {
                if (!_initialized) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.neonGold,
                    ),
                  );
                }

                if (registrationProvider.interestsLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.neonGold),
                        SizedBox(height: 16),
                        Text(
                          "Loading interests...",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  );
                }

                if (registrationProvider.interests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.heart_remove,
                            color: Colors.white.withOpacity(0.3), size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          "No interests available",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  );
                }

                final interestsData = registrationProvider.interests;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: interestsData.map((category) {
                      final categoryName = category['groupTitle'] ?? 'Uncategorized';
                      final categoryEmoji = category['groupEmoji'] ?? '✨';
                      final interests = List<Map<String, dynamic>>.from(
                          category['interests'] ?? []);

                      if (interests.isEmpty) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Header
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 12),
                            child: Row(
                              children: [
                                Text(
                                  categoryEmoji,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    categoryName.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 24),
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white.withOpacity(0.05),
                                  //   borderRadius: BorderRadius.circular(8),
                                  // ),
                                  // child: Text(
                                  //   '(${interests.length})',
                                  //   style: TextStyle(
                                  //     color: Colors.white.withOpacity(0.4),
                                  //     fontSize: 11,
                                  //   ),
                                  // ),
                                ),
                              ],
                            ),
                          ),

                          // Interests Chips
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: interests.map((interest) {
                              final interestId = interest['id'].toString();
                              final interestName = interest['name'] ?? 'Unknown';
                              final interestEmoji = interest['emoji'] ?? '❤️';
                              final isSelected = _isInterestSelected(interestId);
                              
                              return _InterestChip(
                                label: interestName,
                                emoji: interestEmoji,
                                isSelected: isSelected,
                                isDisabled: !isSelected && _hasMaximumSelection,
                                onTap: () => _toggleInterest(interest),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),

      
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const _InterestChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.neonGold.withOpacity(0.09)
                : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(25),
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
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  // color:
                  //  isSelected
                  //     ? AppColors.neonGold
                  //     :
                      
                      //  Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.neonGold
                      : isDisabled
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    Iconsax.tick_circle,
                    color: AppColors.neonGold,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}