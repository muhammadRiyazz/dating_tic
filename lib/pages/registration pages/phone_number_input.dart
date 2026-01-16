// lib/pages/registration/phone_number_input.dart
import 'package:dating/main.dart';
import 'package:dating/pages/registration%20pages/otp_page.dart';
import 'package:dating/providers/phone_registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _countryCode = '+91';

  @override
  void initState() {
    super.initState();
    // Reset provider state when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationProvider>().reset();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

// In the _sendOTP method of PhoneNumberPage
void _sendOTP() async {
  if (_formKey.currentState?.validate() ?? false) {
    final provider = context.read<RegistrationProvider>();
    
    await provider.sendPhoneNumber(
      phone: _phoneController.text.trim(),
      countryCode: _countryCode,
    );

    if (provider.isSuccess && provider.userRegTempId != null) {
      // Navigate to OTP page with user type info
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationPage(
            phoneNumber: '$_countryCode ${_phoneController.text.trim()}',
            countryCode: _countryCode,
            userRegTempId: provider.userRegTempId!,
            isExistingUser: provider.isExistingUser, // Pass this info
          ),
        ),
      );
    }
  }
}

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    
    // Remove any non-digit characters
    final phoneDigits = value.replaceAll(RegExp(r'\D'), '');
    
    if (phoneDigits.length < 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 30),
                        
                        // Back button
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
                        const SizedBox(height: 18),
          ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.white,
                                AppColors.neonGold,
                              ],
stops: const [0.3, 1.0],
                            ).createShader(bounds);
                          },
                          child: Text(
                          'What\'s your phone number?',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              // fontStyle: FontStyle.italic,
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        // Title
                       
                        const SizedBox(height: 15),
        
                        // Description
                        Text(
                          'We\'ll send you a text with a verification code.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade400,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 25),
                        
                        // Error message if any
                        if (provider.hasError && provider.error != null)
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
                                    provider.error!,
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
                        
                        // Phone input field
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: AppColors.cardBlack,
                            border: Border.all(
                              color: provider.hasError 
                                ? Colors.red.withOpacity(0.5) 
                                : Colors.white.withOpacity(0.1)
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Country code
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    CountryCodePicker(
                                      onChanged: (c) {
                                        setState(() {
                                          _countryCode = c.dialCode!;
                                        });
                                        // Reset error when user changes country code
                                        if (provider.hasError) {
                                          provider.reset();
                                        }
                                      },
                                      initialSelection: 'IN',
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.zero,
                                      showFlag: true,
                                      flagWidth: 20,
                                      backgroundColor: Colors.black,
                                      boxDecoration: BoxDecoration(
                                        color: AppColors.cardBlack,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                                child: VerticalDivider(
                                  color: Colors.white24,
                                  thickness: 1,
                                ),
                              ),
                              const SizedBox(width: 12),
        
                              // Phone input
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Phone number',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    errorStyle: const TextStyle(
                                      fontSize: 0,
                                      height: 0,
                                    ),
                                  ),
                                  validator: _validatePhone,
                                  onChanged: (value) {
                                    // Reset error when user types
                                    if (provider.hasError) {
                                      provider.reset();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
        
                        // Privacy note
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.neonGold.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            // border: Border.all(color: AppColors.neonGold.withOpacity(0.2)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Iconsax.shield_tick5,
                                color: AppColors.neonGold,
                                size: 16,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your phone number is private and won\'t appear on your profile',
                                  style: TextStyle(
                                    color: AppColors.neonGold.withOpacity(0.9),
                                    fontSize: 11,
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
                ),
                
                // Get OTP Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.neonGold.withOpacity(0.3),
                    ),
                    child: provider.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'Get OTP',
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