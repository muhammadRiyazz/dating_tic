// lib/providers/registration_provider.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import '../services/registration_service.dart';

enum RegistrationStatus {
  initial,
  loading,
  success,
  error,
}

enum OTPVerificationStatus {
  initial,
  loading,
  success,
  error,
}

class RegistrationProvider extends ChangeNotifier {
  final RegistrationService _service = RegistrationService();
  
  // Phone registration states
  RegistrationStatus _status = RegistrationStatus.initial;
  String? _error;
  String? _statusDesc;
  int? _statusCode;
  String? _userRegTempId;
  bool _hasError = false;
  
  // OTP verification states
  OTPVerificationStatus _otpStatus = OTPVerificationStatus.initial;
  String? _otpError;
  String? _otpStatusDesc;
  int? _otpStatusCode;
  int? _userRegId;
  bool _otpHasError = false;

  // Getters for phone registration
  RegistrationStatus get status => _status;
  String? get error => _error;
  String? get statusDesc => _statusDesc;
  int? get statusCode => _statusCode;
  String? get userRegTempId => _userRegTempId;
  bool get hasError => _hasError;
  bool get isLoading => _status == RegistrationStatus.loading;
  bool get isSuccess => _status == RegistrationStatus.success;

  // Getters for OTP verification
  OTPVerificationStatus get otpStatus => _otpStatus;
  String? get otpError => _otpError;
  String? get otpStatusDesc => _otpStatusDesc;
  int? get otpStatusCode => _otpStatusCode;
  int? get userRegId => _userRegId;
  bool get otpHasError => _otpHasError;
  bool get otpIsLoading => _otpStatus == OTPVerificationStatus.loading;
  bool get otpIsSuccess => _otpStatus == OTPVerificationStatus.success;

  // Reset all states
  void reset() {
    _status = RegistrationStatus.initial;
    _error = null;
    _statusDesc = null;
    _statusCode = null;
    _userRegTempId = null;
    _hasError = false;
    
    _otpStatus = OTPVerificationStatus.initial;
    _otpError = null;
    _otpStatusDesc = null;
    _otpStatusCode = null;
    _userRegId = null;
    _otpHasError = false;
    
    notifyListeners();
  }

  // Reset only phone registration state
  void resetPhoneRegistration() {
    _status = RegistrationStatus.initial;
    _error = null;
    _statusDesc = null;
    _statusCode = null;
    _userRegTempId = null;
    _hasError = false;
    notifyListeners();
  }

  // Reset only OTP verification state
  void resetOTPState() {
    _otpStatus = OTPVerificationStatus.initial;
    _otpError = null;
    _otpStatusDesc = null;
    _otpStatusCode = null;
    _userRegId = null;
    _otpHasError = false;
    notifyListeners();
  }

  // Send phone number for registration
  Future<void> sendPhoneNumber({
    required String phone,
    required String countryCode,
  }) async {
    // Validate input
    if (phone.isEmpty) {
      _setError('Please enter phone number');
      return;
    }
    
    // Remove any non-digit characters
    final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
    
    if (phoneDigits.length < 10) {
      _setError('Please enter a valid 10-digit phone number');
      return;
    }

    if (countryCode.isEmpty) {
      _setError('Please select country code');
      return;
    }

    // Set loading state
    _status = RegistrationStatus.loading;
    _hasError = false;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.sendPhoneNumber(
        phone: phoneDigits, // Send cleaned phone number
        countryCode: countryCode,
      );

      if (response.success) {
        // Success
        _status = RegistrationStatus.success;
        _userRegTempId = response.userRegTempId.toString();
        _statusDesc = response.statusDesc;
        _statusCode = response.statusCode;
        _hasError = false;
        
        // Log success for debugging
        log('Phone registration successful: $_userRegTempId');
      } else {
        // Error
        _setError(response.error ?? 'Registration failed');
        _statusDesc = response.statusDesc;
        _statusCode = response.statusCode;
        
        // Log error for debugging
        log('Phone registration failed: ${response.error}');
      }
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      log('Phone registration exception: $e');
    }
    
    notifyListeners();
  }

  // Verify OTP
  Future<void> verifyOTP({
    required String userRegTempId,
    required String otp,
  }) async {
    // Validate OTP
    if (otp.isEmpty) {
      _setOTPError('Please enter OTP');
      return;
    }
    
    // Clean OTP - remove any non-digit characters
    final cleanedOtp = otp.replaceAll(RegExp(r'\D'), '');
    
    if (cleanedOtp.length != 4) {
      _setOTPError('Please enter 4-digit OTP');
      return;
    }

    // Set loading state
    _otpStatus = OTPVerificationStatus.loading;
    _otpHasError = false;
    _otpError = null;
    notifyListeners();

    try {
      final response = await _service.verifyOTP(
        userRegTempId: userRegTempId,
        otp: cleanedOtp,
      );

      if (response.success) {
        // Success
        _otpStatus = OTPVerificationStatus.success;
        _userRegId = response.userRegTempId; // This is actually userRegId from API
        _otpStatusDesc = response.statusDesc;
        _otpStatusCode = response.statusCode;
        _otpHasError = false;
        
        // Log success for debugging
        print('OTP verification successful: $_userRegId');
      } else {
        // Error
        _setOTPError(response.error ?? 'OTP verification failed');
        _otpStatusDesc = response.statusDesc;
        _otpStatusCode = response.statusCode;
        
        // Log error for debugging
        print('OTP verification failed: ${response.error}');
      }
    } catch (e) {
      _setOTPError('An unexpected error occurred: $e');
      print('OTP verification exception: $e');
    }
    
    notifyListeners();
  }

  // Helper method to set phone registration error
  void _setError(String error) {
    _status = RegistrationStatus.error;
    _error = error;
    _hasError = true;
  }

  // Helper method to set OTP error
  void _setOTPError(String error) {
    _otpStatus = OTPVerificationStatus.error;
    _otpError = error;
    _otpHasError = true;
  }

  // Check if phone number is valid
  bool isValidPhoneNumber(String phone) {
    final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
    return phoneDigits.length >= 10;
  }

  // Check if OTP is valid
  bool isValidOTP(String otp) {
    final cleanedOtp = otp.replaceAll(RegExp(r'\D'), '');
    return cleanedOtp.length == 4;
  }

  // Clear all errors
  void clearErrors() {
    if (_hasError) {
      _hasError = false;
      _error = null;
    }
    
    if (_otpHasError) {
      _otpHasError = false;
      _otpError = null;
    }
    
    notifyListeners();
  }

  // Get formatted phone number
  String formatPhoneNumber(String phone, String countryCode) {
    final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
    return '$countryCode $phoneDigits';
  }

  // Resend OTP (you would call the sendPhoneNumber API again)
  Future<void> resendOTP({
    required String phone,
    required String countryCode,
  }) async {
    // Reset OTP state first
    resetOTPState();
    
    // Call the phone registration API again
    await sendPhoneNumber(
      phone: phone,
      countryCode: countryCode,
    );
  }
}