import 'package:dating/pages/registration%20pages/relationship_goals_Page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LifestylePage extends StatefulWidget {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    final backgroundColor = isDark ? const Color(0xFF0A0505) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:  32),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 30,),
                    // Back button,
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Iconsax.arrow_left_2,
                              color: primaryRed,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 20),
                
                    // Title
                    Text(
                      'Lifestyle',
                      style: TextStyle(
                        fontSize: 28,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                
                    // Description
                    Text(
                      'Tell us about your habits',
                      style: TextStyle(
                        fontSize: 16,
                        color: hintColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                
                    // Smoking Section
                    Text(
                      'Smoking',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                
                    // Smoking Options Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
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
                              color: isSelected 
                                  ? primaryRed.withOpacity(0.1)
                                  : isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected 
                                    ? primaryRed.withOpacity(0.3)
                                    : borderColor,
                                width: isSelected ? 2 : 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  option['icon'],
                                  color: isSelected ? primaryRed : hintColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  option['label'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? primaryRed : textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                
                    const SizedBox(height: 32),
                
                    // Drinking Section
                    Text(
                      'Drinking',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                
                    // Drinking Options Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
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
                              color: isSelected 
                                  ? primaryRed.withOpacity(0.1)
                                  : isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected 
                                    ? primaryRed.withOpacity(0.3)
                                    : borderColor,
                                width: isSelected ? 2 : 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  option['icon'],
                                  color: isSelected ? primaryRed : hintColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  option['label'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? primaryRed : textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                
                    const SizedBox(height: 24),
                
                    // Optional Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryRed.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: primaryRed.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.info_circle,
                            color: primaryRed,
                            size: 14,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This helps show you compatible matches. You can skip if preferred.',
                              style: TextStyle(
                                color: hintColor,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                
                
                    // Continue Button (can skip)
                
                  ],
                ),
              ),
                  SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _selectedSmoking == null && _selectedDrinking == null
                                        ? 'Skip'
                                        : 'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Iconsax.arrow_right_3, size: 20),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _continue() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    // Navigate to next page (Bio or Location)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RelationshipGoalsPage(), // Or LocationPage
      ),
    );
  }
}