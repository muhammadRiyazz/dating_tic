import 'package:dating/pages/registration%20pages/HeightPage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GenderPage extends StatefulWidget {
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String? _selectedGender;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _genderOptions = [
    {'value': 'man', 'label': 'Man', 'icon': Iconsax.man},
    {'value': 'woman', 'label': 'Woman', 'icon': Iconsax.woman},
    {'value': 'non_binary', 'label': 'Non-binary', 'icon': Iconsax.profile_2user},
    {'value': 'prefer_not_to_say', 'label': 'Prefer not to say', 'icon': Iconsax.eye_slash},
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
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
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
                'What\'s your gender?',
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
                'Select the option that best describes you',
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Gender Options
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _genderOptions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final option = _genderOptions[index];
                    final isSelected = _selectedGender == option['value'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = option['value'];
                        });
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? primaryRed.withOpacity(0.1)
                              : isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? primaryRed.withOpacity(0.3)
                                : borderColor,
                            width:  .5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(
                              option['icon'],
                              color: isSelected ? primaryRed : hintColor,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              option['label'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? primaryRed : textColor,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Iconsax.tick_circle,
                                  color: primaryRed,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Privacy Note
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
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Iconsax.lock,
                        color: primaryRed,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This information helps us show you relevant matches',
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

              const SizedBox(height: 20),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedGender != null ? _continue : null,
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
                      : Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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
    if (_selectedGender == null) return;
    
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    // Navigate to Looking For page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeightPage(),
      ),
    );
  }
}