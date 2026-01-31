import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/Voice_Prompt_Page.dart';
import 'package:dating/pages/registration%20pages/photos_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BioPage extends StatefulWidget {
  const BioPage({
       super.key,
    required this.userdata,
  });

  final UserRegistrationModel userdata;

  @override
  _BioPageState createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  int _charCount = 0;
  final int _maxChars = 500;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _bioController.addListener(() {
      setState(() {
        _charCount = _bioController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

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
                    'Your Bio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      // fontStyle: FontStyle.italic,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  'Tell others about yourself (optional)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    height: 1.5,
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),

                        // Bio Input Container
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.cardBlack.withOpacity(0.8),
                                AppColors.cardBlack.withOpacity(0.4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isFocused || _bioController.text.isNotEmpty
                                  ? AppColors.neonGold.withOpacity(0.3)
                                  : Colors.white.withOpacity(0.05),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with character count
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.neonGold.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Iconsax.edit_2,
                                            color: AppColors.neonGold,
                                            size: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'About You',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$_charCount/$_maxChars',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _charCount > _maxChars
                                            ? Colors.red
                                            : AppColors.neonGold.withOpacity(0.8),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Text Field
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: TextField(
                                  controller: _bioController,
                                  maxLines: 6,
                                  maxLength: _maxChars,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Write about yourself, interests, what you\'re looking for...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isFocused = true;
                                    });
                                  },
                                  onEditingComplete: () {
                                    setState(() {
                                      _isFocused = false;
                                    });
                                  },
                                ),
                              ),

                              // Suggestions
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Iconsax.lamp_1,
                                          color: AppColors.neonGold,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Writing Tips',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.neonGold,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '• Share your passions and hobbies\n• Mention what you enjoy doing\n• Describe what you\'re looking for\n• Keep it positive and authentic',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade400,
                                        height: 1.6,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Info card
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
                                  Iconsax.info_circle,
                                  color: AppColors.neonGold,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Boost Your Matches',
                                      style: TextStyle(
                                        color: AppColors.neonGold,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Profiles with bios get 40% more matches. Share something about yourself!',
                                      style: TextStyle(
                                        color: AppColors.neonGold.withOpacity(0.8),
                                        fontSize: 10,
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

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _continue,
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
                                _bioController.text.isEmpty
                                    ? 'Skip'
                                    : 'Continue',
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
 


  final UserRegistrationModel data = widget.userdata.copyWith(
    bio:_bioController.text,
  );


    // Navigate to Photos page (final step)
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => VoicePromptPage(userdata: data,),
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