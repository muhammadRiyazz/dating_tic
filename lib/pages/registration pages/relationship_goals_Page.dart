import 'package:dating/main.dart';
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
    'value': 'marriage',
    'label': 'Marriage-minded',
    'subtitle': 'Looking for a life partner',
    'icon': Iconsax.profile_2user,
    'emoji': '💍'
  },
  {
    'value': 'long_term',
    'label': 'Long-term relationship',
    'subtitle': 'Something serious',
    'icon': Iconsax.heart,
    'emoji': '💖'
  },
  {
    'value': 'short_term',
    'label': 'Short-term dating',
    'subtitle': 'Enjoy the moment',
    'icon': Iconsax.flash,
    'emoji': '⚡'
  },
  {
    'value': 'casual',
    'label': 'Casual dating',
    'subtitle': 'No pressure, see where it goes',
    'icon': Iconsax.calendar,
    'emoji': '📅'
  },

  {
    'value': 'hookups',
    'label': 'Hookups',
    'subtitle': 'Physical connection',
    'icon': Iconsax.emoji_happy,
    'emoji': '🔥'
  },
  {
    'value': 'friends_with_benefits',
    'label': 'Friends with benefits',
    'subtitle': 'Fun with boundaries',
    'icon': Iconsax.heart_circle,
    'emoji': '😉'
  },
  {
    'value': 'open_relationship',
    'label': 'Open relationship',
    'subtitle': 'Consensual & open-minded',
    'icon': Iconsax.refresh,
    'emoji': '🔓'
  },

  // Social
  {
    'value': 'friendship',
    'label': 'New friends',
    'subtitle': 'Meet and connect',
    'icon': Iconsax.people,
    'emoji': '👥'
  },
  {
    'value': 'figuring_out',
    'label': 'Figuring it out',
    'subtitle': 'Not sure yet',
    'icon': Iconsax.search_normal,
    'emoji': '🤔'
  },
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                // Back button
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

                // Title with gradient
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
                  child: Text(
                    'Relationship Goals',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  'This helps us match you with people seeking the same',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(13),
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
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.neonGold.withOpacity(0.0)
                                  : Colors.white.withOpacity(0.05),
                              width: 1.5,
                            ),
                            // boxShadow: isSelected
                            //     ? [
                            //         BoxShadow(
                            //           color: AppColors.neonGold.withOpacity(0.1),
                            //           blurRadius: 10,
                            //           spreadRadius: 2,
                            //         ),
                            //       ]
                            //     : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.neonGold.withOpacity(0.2)
                                      : Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  option['icon'] ?? '',
                                  // style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['label'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? AppColors.neonGold : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option['subtitle'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isSelected 
                                            ? AppColors.neonGold.withOpacity(0.8) 
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Iconsax.tick_circle,
                                  color: AppColors.neonGold,
                                  size: 15,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
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
                          'Your goal will help us show you people looking for the same type of connection',
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

                const SizedBox(height: 20),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedGoal != null ? _continue : null,
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

  void _continue() async {
    if (_selectedGoal == null) return;
    
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => WorkEducationPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}