import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/Looking_gender_Page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LifestylePage extends StatefulWidget {
  const LifestylePage({
    super.key,
    required this.userdata,
  });

  final UserRegistrationModel userdata;

  @override
  _LifestylePageState createState() => _LifestylePageState();
}

class _LifestylePageState extends State<LifestylePage> {
  String? _selectedSmoking;
  String? _selectedDrinking;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _smokingOptions = [
    {'value': 'never', 'label': 'Never', 'icon': Iconsax.activity},
    {'value': 'socially', 'label': 'Socially', 'icon': Iconsax.people},
    {'value': 'occasionally', 'label': 'Occasionally', 'icon': Iconsax.calendar},
    {'value': 'regularly', 'label': 'Regularly', 'icon': Iconsax.flash_circle},
  ];

  final List<Map<String, dynamic>> _drinkingOptions = [
    {'value': 'never', 'label': 'Never', 'icon': Iconsax.activity},
    {'value': 'socially', 'label': 'Socially', 'icon': Iconsax.activity},
    {'value': 'occasionally', 'label': 'Occasionally', 'icon': Iconsax.calendar},
    {'value': 'regularly', 'label': 'Regularly', 'icon': Iconsax.flash_circle},
    {'value': 'sober', 'label': 'Sober', 'icon': Iconsax.health},
  ];

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Row(
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
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        Colors.white,
                        AppColors.neonGold,
                      ],
                      stops: const [0.4, 1.0],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Lifestyle',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about your habits',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    height: 1.5,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Smoking',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 13),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _smokingOptions.length,
                        itemBuilder: (context, index) {
                          final option = _smokingOptions[index];
                          final isSelected = _selectedSmoking == option['value'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSmoking = option['value'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.neonGold.withOpacity(0.15),
                                          AppColors.neonGold.withOpacity(0.05),
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
                                borderRadius: BorderRadius.circular(12),
                                // border: Border.all(
                                //   color: isSelected
                                //       ? AppColors.neonGold.withOpacity(0.5)
                                //       : Colors.grey.shade50.withOpacity(0.3),
                                //   width: .5,
                                // ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    option['icon'],
                                    color: isSelected ? AppColors.neonGold : Colors.grey.shade400,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    option['label'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? AppColors.neonGold : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Drinking',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 13),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _drinkingOptions.length,
                        itemBuilder: (context, index) {
                          final option = _drinkingOptions[index];
                          final isSelected = _selectedDrinking == option['value'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDrinking = option['value'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.neonGold.withOpacity(0.15),
                                          AppColors.neonGold.withOpacity(0.05),
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
                                borderRadius: BorderRadius.circular(12),
                                // border: Border.all(
                                //   color: isSelected
                                //       ? AppColors.neonGold.withOpacity(0.5)
                                //       : Colors.grey.shade50.withOpacity(0.3),
                                //   width: .5,
                                // ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    option['icon'],
                                    color: isSelected ? AppColors.neonGold : Colors.grey.shade400,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    option['label'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? AppColors.neonGold : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.neonGold.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.neonGold.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.info_circle,
                            color: AppColors.neonGold,
                            size: 14,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Please select your habits to find the most compatible matches.',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonGold,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Iconsax.arrow_right_3,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _continue() {
    // Validation: Check if both selections are made
    if (_selectedSmoking == null || _selectedDrinking == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please select both smoking and drinking habits.',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.neonGold,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final UserRegistrationModel data = widget.userdata.copyWith(
      drinkingHabit: _selectedDrinking,
      smokingHabit: _selectedSmoking,
    );

    // Navigate to next page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LookingForPage(
          userdata: data,
        ),
      ),
    );
  }
}