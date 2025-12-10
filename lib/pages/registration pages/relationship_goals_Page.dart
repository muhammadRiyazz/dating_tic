import 'package:dating/pages/registration%20pages/Education_Page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RelationshipGoalsPage extends StatefulWidget {
  @override
  _RelationshipGoalsPageState createState() => _RelationshipGoalsPageState();
}

class _RelationshipGoalsPageState extends State<RelationshipGoalsPage> {
  String? _selectedGoal;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _goalOptions = [
    {
      'value': 'long_term',
      'label': 'Long-term relationship',
      'subtitle': 'Looking for something serious',
      'icon': Iconsax.heart,
    },
    {
      'value': 'short_term',
      'label': 'Short-term fun',
      'subtitle': 'Casual dating and fun',
      'icon': Iconsax.flash,
    },
    {
      'value': 'friendship',
      'label': 'New friends',
      'subtitle': 'Expand your social circle',
      'icon': Iconsax.people,
    },
    {
      'value': 'figuring_out',
      'label': 'Figuring it out',
      'subtitle': 'Not sure yet',
      'icon': Iconsax.search_normal,
    },
    {
      'value': 'marriage',
      'label': 'Marriage-minded',
      'subtitle': 'Looking for life partner',
      'icon': Iconsax.profile_2user,
    },
    {
      'value': 'casual',
      'label': 'Casual dating',
      'subtitle': 'See where things go',
      'icon': Iconsax.calendar,
    },
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
          padding: const EdgeInsets.all( 32),
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
                'What are you looking for?',
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
                'This helps us match you with people seeking the same',
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Goal Options
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _goalOptions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final option = _goalOptions[index];
                    final isSelected = _selectedGoal == option['value'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGoal = option['value'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? primaryRed.withOpacity(0.2)
                                    : primaryRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                option['icon'],
                                color: isSelected ? primaryRed : primaryRed.withOpacity(0.7),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option['label'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? primaryRed : textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option['subtitle'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Iconsax.tick_circle,
                                color: primaryRed,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedGoal != null ? _continue : null,
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
                              'Continue',
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
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _continue() async {
    if (_selectedGoal == null) return;
    
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkEducationPage(),
      ),
    );
  }
}