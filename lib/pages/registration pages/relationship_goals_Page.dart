// lib/pages/registration/relationship_goals_page.dart

import 'dart:developer';

import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/Education_Page.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:dating/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class RelationshipGoalsPage extends StatefulWidget {
  const RelationshipGoalsPage({
    super.key,
    required this.userdata,
  });

  final UserRegistrationModel userdata;

  @override
  State<RelationshipGoalsPage> createState() => _RelationshipGoalsPageState();
}

class _RelationshipGoalsPageState extends State<RelationshipGoalsPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RegistrationDataProvider>();
      if (provider.goalsStatus == DataLoadStatus.initial) {
        provider.loadRelationshipGoals(widget.userdata.gender ?? '');
      }
    });
  }

  void _continue() {
    final provider = context.read<RegistrationDataProvider>();

    if (!provider.validateGoalsPage()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a relationship goal'),
        ),
      );
      return;
    }

    final updatedData = widget.userdata.copyWith(
      relationshipGoal: provider.selectedGoalId,
    );
log(updatedData.intrestgender.toString());
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            WorkEducationPage(userdata: updatedData),
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
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
        
                const SizedBox(height: 20),
        
                /// Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.neonGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Iconsax.arrow_left_2,
                      color: AppColors.neonGold,
                    ),
                  ),
                ),
        
                const SizedBox(height: 20),
        
                /// Title
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Colors.white, AppColors.neonGold],
                      stops: [0.4, 1],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Relationship Goals',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
        
                const SizedBox(height: 6),
        
                Text(
                  'This helps us match you with people seeking the same',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
        
                /// Error State
                if (provider.goalsHasError)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.warning_2, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.goalsError ?? 'Failed to load goals',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.refresh, color: Colors.red),
                          onPressed: () {
                            provider.loadRelationshipGoals(
                              widget.userdata.gender ?? '',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
        
                const SizedBox(height: 10),
        
                /// Loading
                if (provider.goalsLoading)
                  Expanded(
                    child: ListView.separated(
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, __) => const ShimmerLoading(
                        isLoading: true,
                        child: ListItemShimmer(height: 70),
                      ),
                    ),
                  ),
        
                /// Empty
                if (provider.goalsIsEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No relationship goals available',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
        
                /// Goals List
                if (provider.goalsLoaded)
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.goals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final goal = provider.goals[index];
                        final isSelected = provider.selectedGoalId ==
                            goal['goalId'].toString();
        
                        return GestureDetector(
                          onTap: () => provider.selectGoal(
                            goal['goalId'].toString(),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              // border: Border.all(
                              //   color: isSelected
                              //       ? AppColors.neonGold
                              //       : Colors.white24,
                              // ),
                              color: isSelected
                                  ? AppColors.neonGold.withOpacity(.1)
                                  : AppColors.cardBlack,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  goal['goalEmoji'] ?? '',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        goal['goalTitle'] ?? '',
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.neonGold
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        goal['goalSubTitle'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Iconsax.tick_circle,
                                    color: AppColors.neonGold,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
        
                const SizedBox(height: 16),
        
                /// Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.selectedGoalId == null
                        ? null
                        : _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Iconsax.arrow_right_3),
                      ],
                    ),
                  ),
                ),
        
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  
 