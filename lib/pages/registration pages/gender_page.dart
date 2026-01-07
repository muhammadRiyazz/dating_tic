import 'package:dating/main.dart';
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
  {'value': 'man', 'label': 'Man', 'icon': Iconsax.man, 'emoji': '👨'},
  {'value': 'woman', 'label': 'Woman', 'icon': Iconsax.woman, 'emoji': '👩'},
  {'value': 'non_binary', 'label': 'Non-binary', 'icon': Iconsax.profile_2user, 'emoji': '⚧️'},
  {'value': 'trans_man', 'label': 'Trans Man', 'icon': Iconsax.profile_circle, 'emoji': '🏳️‍⚧️👨'},
  {'value': 'trans_woman', 'label': 'Trans Woman', 'icon': Iconsax.profile_circle, 'emoji': '🏳️‍⚧️👩'},
  {'value': 'prefer_not_to_say', 'label': 'Prefer not to say', 'icon': Iconsax.eye_slash, 'emoji': '🙊'},
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: 
      Container(
        decoration: BoxDecoration(  gradient: LinearGradient(
                    colors: [
                      AppColors.neonGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
                  
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button with glow effect
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.cardBlack,
                            borderRadius: BorderRadius.circular(14),
                            // border: Border.all(
                            //   color: AppColors.neonGold.withOpacity(0.3),
                            //   width: 1,
                            // ),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: AppColors.neonGold.withOpacity(0.1),
                            //     blurRadius: 8,
                            //     spreadRadius: 1,
                            //   ),
                            // ],
                          ),
                          child: Icon(
                            Iconsax.arrow_left_2,
                            color: AppColors.neonGold,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
        
                      // Title with gradient text
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
                            fontStyle: FontStyle.italic,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
        
                      // Description with animated dots
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Tell us how you identify to help us show you relevant matches',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade300,
                                height: 1.4,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        
                // Search and gender options
                Expanded(
                  child: Column(
                    children: [
                      // Search bar
              
                      // Gender options grid
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
                          itemCount: _genderOptions.length,
                          itemBuilder: (context, index) {
                            final option = _genderOptions[index];
                            final isSelected = _selectedGender == option['value'];
                            
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedGender = option['value'];
                                });
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
                                        ? AppColors.neonGold.withOpacity(0.0)
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
                                        option['emoji'] ?? '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        option['label'],
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
                    ],
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
                    onPressed: _selectedGender != null ? _continue : null,
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
    if (_selectedGender == null) return;
    
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() => _isLoading = false);
    
    // Navigate to Height page
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HeightPage(),
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