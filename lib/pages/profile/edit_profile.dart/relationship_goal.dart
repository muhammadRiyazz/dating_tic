import 'package:dating/main.dart'; // For AppColors
import 'package:dating/models/profile_model.dart';
import 'package:dating/providers/profile_update.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

// Method to show Relationship Goal Bottom Sheet
void showRelationshipGoalSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0A0A0A),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return _RelationshipGoalBottomSheet();
    },
  );
}

class _RelationshipGoalBottomSheet extends StatefulWidget {
  @override
  State<_RelationshipGoalBottomSheet> createState() => _RelationshipGoalBottomSheetState();
}

class _RelationshipGoalBottomSheetState extends State<_RelationshipGoalBottomSheet> {
  late String _currentGoalId;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final updateProvider = context.read<UpdateProfileProvider>();
    _currentGoalId = updateProvider.userProfile.relationshipGoal?.id.toString() ?? '';
    
    // Load goals if not loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final registrationProvider = context.read<RegistrationDataProvider>();
      if (registrationProvider.goals.isEmpty) {
        // Load goals - you'll need to pass the gender ID
        // registrationProvider.loadRelationshipGoals(genderId);
      }
    });
  }

  Future<void> _updateGoal(String goalId, Map<String, dynamic> goal) async {
    if (_isUpdating) return;
    
    setState(() => _isUpdating = true);
    HapticFeedback.lightImpact();
    
    try {
      final updateProvider = context.read<UpdateProfileProvider>();
      updateProvider.updateRelationshipGoal(
        RelationshipGoal(
          id: int.tryParse(goalId) ?? 0,
          name: goal['goalTitle'] ?? '',
          emoji: goal['goalEmoji'] ?? '❤️',
        ),
      );
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
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

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Relationship Goal",
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

          // Content Area
          Expanded(
            child: Consumer2<RegistrationDataProvider, UpdateProfileProvider>(
              builder: (context, registrationProvider, updateProvider, child) {
                // Loading State with Shimmer Effect
                if (registrationProvider.goalsLoading) {
                  return _buildShimmerLoading();
                }

                // Empty State
                if (registrationProvider.goals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.heart_remove, 
                            color: Colors.white.withOpacity(0.3), size: 60),
                        const SizedBox(height: 16),
                        Text(
                          "No goals available",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
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
                  );
                }

                // Goals List
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: registrationProvider.goals.length,
                  itemBuilder: (context, index) {
                    final goal = registrationProvider.goals[index];
                    final goalId = goal['goalId'].toString();
                    final isSelected = _currentGoalId == goalId;
                    
                    return _buildGoalOption(
                      goal: goal,
                      isSelected: isSelected,
                      isUpdating: _isUpdating,
                      onTap: () => _updateGoal(goalId, goal),
                    );
                  },
                );
              },
            ),
          ),

          // Bottom padding
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Shimmer for emoji container
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 15),
              
              // Shimmer for text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalOption({
    required Map<String, dynamic> goal,
    required bool isSelected,
    required bool isUpdating,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUpdating ? null : onTap,
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
              //       : Colors.white.withOpacity(0.08),
              //   width: isSelected ? 1.5 : 1,
              // ),
            ),
            child: Row(
              children: [
                // Emoji Container with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // color: isSelected
                    //     ? AppColors.neonGold
                    //     : Colors.white.withOpacity(0.1),
                    border: Border.all(color:  Colors.white.withOpacity(0.1),),
                    shape: BoxShape.circle,
                  ),
                  
                  child: Text(
                    goal['goalEmoji'] ?? '❤️',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 15),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal['goalTitle'] ?? 'Unknown Goal',
                        style: TextStyle(
                          color: isSelected ? AppColors.neonGold : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal['goalSubTitle'] ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(isSelected ? 0.6 : 0.4),
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection Indicator or Loading
                if (isUpdating && isSelected)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.neonGold,
                    ),
                  )
                else if (isSelected)
                  const Icon(Iconsax.tick_circle,
                      color: AppColors.neonGold, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper method to get display text for relationship goal
String getRelationshipGoalDisplay(
  BuildContext context, {
  String? goalId,
}) {
  if (goalId == null || goalId.isEmpty) return "Add Goal";
  
  try {
    final provider = context.read<RegistrationDataProvider>();
    final goal = provider.goals.firstWhere(
      (g) => g['goalId'].toString() == goalId,
      orElse: () => {},
    );
    
    final title = goal['goalTitle'];
    final emoji = goal['goalEmoji'];
    
    return title != null ? '$emoji $title' : goalId;
  } catch (e) {
    return goalId;
  }
}

