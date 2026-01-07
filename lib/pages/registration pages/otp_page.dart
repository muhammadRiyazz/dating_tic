import 'package:dating/main.dart';
import 'package:dating/pages/registration%20pages/name_page.dart';
import 'package:dating/providers/phone_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final String userRegTempId;

  const OTPVerificationPage({
    Key? key,
    required this.phoneNumber,
    required this.countryCode,
    required this.userRegTempId,
  }) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isResending = false;
  int _timerSeconds = 30;
  bool _showResend = false;
  String _enteredOTP = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNodes[0].requestFocus();
    });
    
    for (int i = 0; i < _otpControllers.length; i++) {
      _otpControllers[i].addListener(() => _onOTPChanged(i));
    }

    // Reset OTP state when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationProvider>().resetOTPState();
    });
  }

  @override
  void dispose() {
    for (var node in _focusNodes) node.dispose();
    for (var controller in _otpControllers) controller.dispose();
    super.dispose();
  }

  void _onOTPChanged(int index) {
    String otp = '';
    for (var controller in _otpControllers) {
      otp += controller.text;
    }
    _enteredOTP = otp;
    
    if (_otpControllers[index].text.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_timerSeconds > 0 && mounted) {
        setState(() => _timerSeconds--);
        _startTimer();
      } else if (mounted) {
        setState(() => _showResend = true);
      }
    });
  }

  void _resendOTP() async {
    setState(() {
      _isResending = true;
      _showResend = false;
      _timerSeconds = 30;
    });
    
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    
    // Call API to resend OTP
    final provider = context.read<RegistrationProvider>();
    // Here you would need to call an API endpoint to resend OTP
    // For now, we'll simulate it
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isResending = false);
      _startTimer();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.neonGold,
          content: Row(
            children: [
              Icon(Iconsax.tick_circle5, color: Colors.black, size: 18),
              const SizedBox(width: 8),
              Text(
                'OTP sent successfully',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _verifyOTP() async {
    if (_enteredOTP.length != 4) return;
    
    final provider = context.read<RegistrationProvider>();
    
    await provider.verifyOTP(
      userRegTempId: widget.userRegTempId,
      otp: _enteredOTP,
    );

    if (provider.otpIsSuccess && provider.userRegId != null) {
      // Navigate to next page (Name/Profile) on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NamePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container( decoration: BoxDecoration(  gradient: LinearGradient(
                    colors: [
                      AppColors.neonGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 30),
                      
                      // Top bar with back arrow
                      Row(
                        children: [
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
                            stops: const [0.7, 1.0],
                          ).createShader(bounds);
                        },
                        child: Text(
                        'Enter verification code',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      // Title
                     
                      const SizedBox(height: 8),
                      
                      // Phone number display
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(text: 'Code sent to '),
                            TextSpan(
                              text: widget.phoneNumber,
                              style: TextStyle(
                                color: AppColors.neonGold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Error message if any
                      if (provider.otpHasError && provider.otpError != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.warning_2,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  provider.otpError!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // 4-Digit OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            margin: EdgeInsets.only(
                              right: index < 3 ? 12 : 0,
                            ),
                            width: 60,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: _otpControllers[index].text.isNotEmpty
                                        ? AppColors.neonGold
                                        : Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.neonGold,
                                    width: 2.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: _otpControllers[index].text.isNotEmpty
                                        ? AppColors.neonGold.withOpacity(0.6)
                                        : Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                filled: true,
                                fillColor: _otpControllers[index].text.isNotEmpty
                                    ? AppColors.neonGold.withOpacity(0.1)
                                    : AppColors.cardBlack,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                                }
                                
                                // Clear error when user types
                                if (provider.otpHasError) {
                                  provider.resetOTPState();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      
                      // Timer/Resend Section
                      Center(
                        child: !_showResend
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.timer_1,
                                    color: Colors.grey.shade400,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Resend code in $_timerSeconds',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : TextButton(
                                onPressed: _isResending ? null : _resendOTP,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.neonGold,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_isResending)
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.neonGold,
                                        ),
                                      )
                                    else
                                      Icon(
                                        Iconsax.refresh5,
                                        color: AppColors.neonGold,
                                        size: 16,
                                      ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _isResending ? 'Resending...' : 'Resend code',
                                      style: TextStyle(
                                        color: AppColors.neonGold,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      
                      // Info note
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.neonGold.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.neonGold.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Iconsax.info_circle5,
                              color: AppColors.neonGold,
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Enter the 4-digit code sent to your phone',
                                style: TextStyle(
                                  color: AppColors.neonGold.withOpacity(0.9),
                                  fontSize: 12,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _enteredOTP.length == 4 && !provider.otpIsLoading ? _verifyOTP : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.neonGold.withOpacity(0.3),
                    ),
                    child: provider.otpIsLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
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