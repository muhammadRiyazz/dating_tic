import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/bio_page.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:dating/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptics
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key, required this.userdata});

  final UserRegistrationModel userdata;

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RegistrationDataProvider>();
      if (provider.interestsStatus == DataLoadStatus.initial) {
        provider.loadInterests();
      }
    });
  }

  void _continue() {
    final provider = context.read<RegistrationDataProvider>();

    if (!provider.hasMinimumInterests) {
      _showErrorSnackBar('Please select at least 3 interests');
      return;
    }

    final updatedData = widget.userdata.copyWith(
      interests: provider.selectedInterestIds,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BioPage(userdata: updatedData),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut))),
            child: child,
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationDataProvider>();

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(   decoration: BoxDecoration(  gradient: LinearGradient(
                    colors: [
                      AppColors.neonGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),),
        child: Stack(
          children: [
            // Background Gradient Glow
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.neonGold.withOpacity(0.05),
                  // blurRadius: 100,
                ),
              ),
            ),
            
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(provider),
                  
                  Expanded(
                    child: provider.interestsLoading
                        ? _buildShimmerLoading()
                        : provider.interestsHasError
                            ? _buildErrorState(provider)
                            : provider.interestsIsEmpty
                                ? _buildEmptyState()
                                : _buildInterestsList(provider),
                  ),
                  
                  _buildFooter(provider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(RegistrationDataProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.neonGold.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Iconsax.arrow_left_2,
                                color: AppColors.neonGold,
                                size: 24,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
              // Progress indicator (Step 4 of 6 - change as needed)
              const Text(
                "Step 4/6",
                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, AppColors.neonGold],
            ).createShader(bounds),
            child: const Text(
              'Interests & Vibes',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, 
              // fontStyle: FontStyle.italic
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select 3-10 interests to find your perfect match.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

 
  Widget _buildInterestsList(RegistrationDataProvider provider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: provider.interests.map((category) {
          final interests = List<Map<String, dynamic>>.from(category['interests'] ?? []);
          
          // Filter interests based on search
          final filteredInterests = interests.where((i) => 
            i['name'].toString().toLowerCase().contains(searchQuery)).toList();

          if (filteredInterests.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 12),
                child: Row(
                  children: [
                    // Text(category['groupEmoji'] ?? '', style: const TextStyle(fontSize: 18)),
                    // const SizedBox(width: 8),
                    Text(
                      (category['groupTitle'] ?? '').toString().toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 15,
                runSpacing: 16,
                children: filteredInterests.map((interest) {
                  final id = interest['id'].toString();
                  final isSelected = provider.isInterestSelected(id);
                  
                  return _InterestChip(
                    label: interest['name'],
                    emoji: interest['emoji'],
                    isSelected: isSelected,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      provider.toggleInterest(id, interest['name']);
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooter(RegistrationDataProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, AppColors.deepBlack.withOpacity(0.8)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dynamic Selected Text
       
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: provider.hasMinimumInterests ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGold,
                foregroundColor: Colors.black,
                disabledBackgroundColor: AppColors.neonGold.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(width: 8),
                  Icon(Iconsax.arrow_right_3, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Error and Loading helpers... (Shimmers, Errors etc)
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      itemBuilder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const ShimmerLoading(isLoading: true, child: CategoryShimmer(width: 100, height: 15)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(5, (_) => const ShimmerLoading(isLoading: true, child: InterestChipShimmer(width: 90, height: 40))),
          )
        ],
      ),
    );
  }

  Widget _buildErrorState(RegistrationDataProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.danger, color: Colors.redAccent, size: 40),
          const SizedBox(height: 16),
          Text(provider.interestsError ?? "An error occurred", style: const TextStyle(color: Colors.white70)),
          TextButton(onPressed: () => provider.loadInterests(), child: const Text("Retry", style: TextStyle(color: AppColors.neonGold))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("No interests found", style: TextStyle(color: Colors.grey)));
  }
}

/// A specialized Chip widget for interests
class _InterestChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neonGold : AppColors.cardBlack,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected ? AppColors.neonGold : Colors.white.withOpacity(0.1),
              width: 1,
            ),
            // boxShadow: isSelected
            //     ? [BoxShadow(color: AppColors.neonGold.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
            //     : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep your existing CategoryShimmer and InterestChipShimmer classes below...
// Shimmer Widgets for Interests Page
class CategoryShimmer extends StatelessWidget {
  final double width;
  final double height;
  
  const CategoryShimmer({
    super.key,
    required this.width,
    required this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class InterestChipShimmer extends StatelessWidget {
  final double width;
  final double height;
  
  const InterestChipShimmer({
    super.key,
    required this.width,
    required this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}