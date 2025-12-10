import 'package:dating/pages/registration%20pages/name_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const OTPVerificationPage({
    Key? key,
    required this.phoneNumber,
    required this.countryCode,
  }) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;
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
    
    if (otp.length == 4) {
      _verifyOTP();
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

  void _resendOTP() {
    setState(() {
      _isResending = true;
      _showResend = false;
      _timerSeconds = 30;
    });
    
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isResending = false);
        _startTimer();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              children: [
                Icon(Iconsax.tick_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('OTP sent successfully'),
              ],
            ),
          ),
        );
      }
    });
  }

  void _verifyOTP() async {
    if (_enteredOTP.length != 4) return;
    
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      // Navigate to next page (Name/Profile)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NamePage()),
      );
    }
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 30,),
                    // Top bar with back arrow
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
                      'Enter verification code',
                      style: TextStyle(
                        fontSize: 28,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Phone number display
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: hintColor,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: 'Code sent to '),
                          TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                              color: primaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // 4-Digit OTP Input Fields - No gap, properly spaced
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: EdgeInsets.only(
                            right: index < 3 ? 12 : 0, // Add space between boxes
                          ),
                          width: 60, // Slightly wider for better touch area
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 28, // Larger font
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _otpControllers[index].text.isNotEmpty
                                      ? primaryRed
                                      : borderColor,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: primaryRed,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _otpControllers[index].text.isNotEmpty
                                      ? primaryRed.withOpacity(0.5)
                                      : borderColor,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: _otpControllers[index].text.isNotEmpty
                                  ? primaryRed.withOpacity(0.05)
                                  : isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade50,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
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
                                  color: hintColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Resend code in $_timerSeconds',
                                  style: TextStyle(
                                    color: hintColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          : TextButton(
                              onPressed: _isResending ? null : _resendOTP,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isResending)
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: primaryRed,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Iconsax.refresh,
                                      color: primaryRed,
                                      size: 16,
                                    ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _isResending ? 'Resending...' : 'Resend code',
                                    style: TextStyle(
                                      color: primaryRed,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    
                    // Privacy note
                    const SizedBox(height: 24),
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
                              'Enter the 4-digit code sent to your phone',
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
                    
                    
                    // Verify Button (auto-enables when OTP complete)
                 
                  
                  ],
                ),
              ),
                 SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _enteredOTP.length == 4 ? _verifyOTP : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
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
                          'Verify',
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
}