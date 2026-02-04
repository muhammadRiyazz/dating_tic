import 'package:dating/main.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/registration%20pages/Voice_Prompt_Page.dart';
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
  final FocusNode _bioFocusNode = FocusNode();
  bool _isLoading = false;
  int _charCount = 0;
  final int _maxChars = 300; // Updated to 300

  @override
  void initState() {
    super.initState();
    _bioFocusNode.addListener(() => setState(() {}));
    _bioController.addListener(() {
      setState(() {
        _charCount = _bioController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _bioFocusNode.dispose();
    super.dispose();
  }

  void _continue() async {
    // Validation: Bio is now required
    if (_bioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please write a short bio to continue.',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.neonGold,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
        ),
      );
      return;
    }

    // Validation: Minimum length check for better quality
    if (_bioController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Your bio is a bit too short. Tell us a little more!',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.neonGold,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);

    final UserRegistrationModel data = widget.userdata.copyWith(
      bio: _bioController.text.trim(),
    );

    if (!mounted) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => VoicePromptPage(userdata: data),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut))),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.neonGold.withOpacity(0.1), Colors.transparent],
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
                // Header (Unchanged as requested)
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
                        icon: Icon(Iconsax.arrow_left_2, color: AppColors.neonGold, size: 24),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, AppColors.neonGold],
                    stops: const [0.4, 1.0],
                  ).createShader(bounds),
                  child: const Text(
                    'Your Bio',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Express yourself in your own words',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade400, height: 1.5),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        // Bio Input Container
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: AppColors.cardBlack.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _bioFocusNode.hasFocus 
                                  ? AppColors.neonGold .withOpacity(0.2)
                                  : Colors.white.withOpacity(0.1),
                              width: .5,
                            ),
                            boxShadow: _bioFocusNode.hasFocus 
                                ? [BoxShadow(color: AppColors.neonGold.withOpacity(0.01), blurRadius: 15)] 
                                : [],
                          ),
                          child: Column(
                            children: [
                              // Character Count Header
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                // border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'About You *',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    Text(
                                      '$_charCount/$_maxChars',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _charCount >= _maxChars ? Colors.red : AppColors.neonGold,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Input Field
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: TextField(
                                  controller: _bioController,
                                  focusNode: _bioFocusNode,
                                  maxLines: 6,
                                  maxLength: _maxChars,
                                  style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.5),
                                  decoration: InputDecoration(
                                    hintText: 'What makes you unique? Share your hobbies, favorite music, or travel stories...',
                                    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Premium Tips Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBlack.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Iconsax.magicpen, color: AppColors.neonGold, size: 18),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Pro Tips',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildTip('Mention 3 things you love.'),
                              _buildTip('Keep it honest and conversational.'),
                              _buildTip('Adding a bio increases matches by 40%.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Continue', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                              SizedBox(width: 10),
                              Icon(Iconsax.arrow_right_3, size: 20),
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

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Iconsax.verify, color: AppColors.neonGold.withOpacity(0.5), size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for the divider inside the container
extension ContainerBorder on Widget {
  Widget border({required Border border}) => Container(decoration: BoxDecoration(border: border), child: this);
}