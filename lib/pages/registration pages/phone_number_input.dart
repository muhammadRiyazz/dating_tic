import 'package:dating/pages/registration%20pages/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:iconsax/iconsax.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+91';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    final backgroundColor = isDark ? const Color(0xFF0A0505) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    // Top bar with mobile-themed stack icon
                    Row(
                      children: [
                        // Mobile/Phone themed icon (like smartphone stack)
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Handle menu tap or navigate back
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Iconsax.mobile_programming5, // Simple mobile icon
                              color: primaryRed,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const Spacer(),

                        // Optional: You can add other icons on the right side
                        // For example, a help icon or skip button
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(Icons.help_outline, color: primaryRed),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Simple title
                    Text(
                      'What\'s your phone number?',
                      style: TextStyle(
                        fontSize: 28,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Simple description
                    Text(
                      'We\'ll send you a text with a verification code.',
                      style: TextStyle(
                        fontSize: 15,
                        color: hintColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Clean input field
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Country code
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                CountryCodePicker(
                                  onChanged: (c) => _countryCode = c.dialCode!,
                                  initialSelection: 'IN',
                                  textStyle: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  padding: EdgeInsets.zero,
                                  showFlag: true,
                                  flagWidth: 20,
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey.shade500,
                                ),
                              ],
                            ),
                          ),

                          // Phone input
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Phone number',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Info text

                    // Privacy note (like Aisle)
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryRed.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primaryRed.withOpacity(0.1)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.shield_tick,
                            color: primaryRed,
                            size: 14,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your phone number is private and won\'t appear on your profile',
                              style: TextStyle(
                                color: hintColor,
                                fontSize: 10,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Simple button
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                  //  _phoneController.text.length >= 10
                  //     ? 
                      _sendOTP,
                      // : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: 
                  // _isLoading
                  //     ? SizedBox(
                  //         width: 24,
                  //         height: 24,
                  //         child: CircularProgressIndicator(
                  //           strokeWidth: 3,
                  //           color: Colors.white,
                  //         ),
                  //       )
                  //     : 
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // Terms text
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _sendOTP() async {
    if (_phoneController.text.length < 10) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationPage(
          phoneNumber: '$_countryCode ${_phoneController.text}',
          countryCode: _countryCode,
        ),
      ),
    );
  }
}
