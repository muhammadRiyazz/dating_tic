// lib/pages/registration/gender_page.dart
import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/HeightPage.dart';
import 'package:dating/pages/registration%20pages/relationship_goals_page.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:dating/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({
     super.key,
    required this.userdata,
  });

  final UserRegistrationModel userdata;

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load genders when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RegistrationDataProvider>();
      if (provider.gendersStatus == DataLoadStatus.initial) {
        provider.loadGenders();
      }
    });
  }

void _continue() async {
  final provider = context.read<RegistrationDataProvider>();
  
  if (!provider.validateGenderPage()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please select your gender'),
      ),
    );
    return;
  }
  
  final UserRegistrationModel data = widget.userdata.copyWith(
    gender: provider.selectedGenderId,
  );

 Navigator.push(context, MaterialPageRoute(builder:(context) {
   return HeightPage( userdata: data,) ;
 }, ));

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
                // Header
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.neonGold.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Iconsax.arrow_left_2,
                                  color: AppColors.neonGold,
                                  size: 24,
                                ),
                              ),
                      ),
                      const SizedBox(height: 30),

                      // Title with gradient
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              Colors.white,
                              AppColors.neonGold,
                            ],
                            stops: const [0.7, 1.0],
                          ).createShader(bounds);
                        },
                        child: Text(
                          'Select Your Gender',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            // fontStyle: FontStyle.italic,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Description
                      Text(
                        'Tell us how you identify to help us show you relevant matches',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade300,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Error message
                if (provider.gendersHasError)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.warning_2, color: Colors.red, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            provider.gendersError ?? 'Failed to load genders',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Iconsax.refresh, color: Colors.red, size: 16),
                          onPressed: provider.loadGenders,
                        ),
                      ],
                    ),
                  ),

                // Empty state
                if (provider.gendersIsEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.user_remove,
                            color: Colors.grey.shade400,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No genders available',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: provider.loadGenders,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Loading state
                if (provider.gendersLoading)
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.8,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return ShimmerLoading(
                          isLoading: true,
                          child: GridItemShimmer(height: 60),
                        );
                      },
                    ),
                  ),

                // Gender options grid
                if (provider.gendersLoaded)
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.8,
                      ),
                      itemCount: provider.genders.length,
                      itemBuilder: (context, index) {
                        final gender = provider.genders[index];
                        final isSelected = provider.selectedGenderId == gender['genderId'].toString();
                        
                        return GestureDetector(
                          onTap: () {
                            provider.selectGender(gender['genderId'].toString());
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.neonGold.withOpacity(0.2),
                                        AppColors.neonGold.withOpacity(0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        AppColors.cardBlack.withOpacity(0.8),
                                        AppColors.cardBlack.withOpacity(0.4),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.neonGold.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.05),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.neonGold.withOpacity(0.2)
                                        : Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    gender['genderEmoji'] ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    gender['genderTitle'] ?? 'Unknown',
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.neonGold
                                          : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Icon(
                                      Iconsax.tick_circle,
                                      color: AppColors.neonGold,
                                      size: 20,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Security information card
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonGold.withOpacity(0.08),
                        AppColors.neonGold.withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.neonGold.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.neonGold.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.lock_1,
                          color: AppColors.neonGold,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Private & Secure',
                              style: TextStyle(
                                color: AppColors.neonGold,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your gender identity is private and will only be used to improve your match recommendations',
                              style: TextStyle(
                                color: AppColors.neonGold.withOpacity(0.8),
                                fontSize: 8,
                                height: 1.4,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.selectedGenderId != null && !_isLoading ? _continue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return AppColors.neonGold.withOpacity(0.5);
                          }
                          return AppColors.neonGold;
                        },
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Iconsax.arrow_right_3,
                                size: 20,
                                color: Colors.black,
                              ),
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