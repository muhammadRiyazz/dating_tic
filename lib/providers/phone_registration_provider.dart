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
  successLogin, // For already registered users
  successRegister, // For new users
  error,
}

enum UserType {
  login,
  register,
  unknown,
}

class RegistrationProvider extends ChangeNotifier {
  final RegistrationService _service = RegistrationService();
  
  // Phone registration states
  RegistrationStatus _status = RegistrationStatus.initial;
  String? _error;
  String? _statusDesc;
  int? _statusCode;
  String? _userRegTempId;
  UserType _userType = UserType.unknown;
  bool _hasError = false;
  
  // OTP verification states
  OTPVerificationStatus _otpStatus = OTPVerificationStatus.initial;
  String? _otpError;
  String? _otpStatusDesc;
  int? _otpStatusCode;
  String? _userId;
  UserType _verifiedUserType = UserType.unknown;
  bool _otpHasError = false;

  // Getters for phone registration
  RegistrationStatus get status => _status;
  String? get error => _error;
  String? get statusDesc => _statusDesc;
  int? get statusCode => _statusCode;
  String? get userRegTempId => _userRegTempId;
  UserType get userType => _userType;
  bool get hasError => _hasError;
  bool get isLoading => _status == RegistrationStatus.loading;
  bool get isSuccess => _status == RegistrationStatus.success;
  
  // Helper getters for UI
  bool get isExistingUser => _userType == UserType.login;
  bool get isNewUser => _userType == UserType.register;

  // Getters for OTP verification
  OTPVerificationStatus get otpStatus => _otpStatus;
  String? get otpError => _otpError;
  String? get otpStatusDesc => _otpStatusDesc;
  int? get otpStatusCode => _otpStatusCode;
  String? get userId => _userId;
  UserType get verifiedUserType => _verifiedUserType;
  bool get otpHasError => _otpHasError;
  bool get otpIsLoading => _otpStatus == OTPVerificationStatus.loading;
  bool get otpIsSuccess => _otpStatus == OTPVerificationStatus.successLogin || 
                          _otpStatus == OTPVerificationStatus.successRegister;
  
  // Helper getters for post-OTP
  bool get isLoginSuccessful => _otpStatus == OTPVerificationStatus.successLogin;
  bool get isRegisterSuccessful => _otpStatus == OTPVerificationStatus.successRegister;

  // Reset all states
  void reset() {
    _status = RegistrationStatus.initial;
    _error = null;
    _statusDesc = null;
    _statusCode = null;
    _userRegTempId = null;
    _userType = UserType.unknown;
    _hasError = false;
    
    _otpStatus = OTPVerificationStatus.initial;
    _otpError = null;
    _otpStatusDesc = null;
    _otpStatusCode = null;
    _userId = null;
    _verifiedUserType = UserType.unknown;
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
    _userType = UserType.unknown;
    _hasError = false;
    notifyListeners();
  }

  // Reset only OTP verification state
  void resetOTPState() {
    _otpStatus = OTPVerificationStatus.initial;
    _otpError = null;
    _otpStatusDesc = null;
    _otpStatusCode = null;
    _userId = null;
    _verifiedUserType = UserType.unknown;
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
        phone: phoneDigits,
        countryCode: countryCode,
      );

      if (response.success) {
        // Success - determine if user is existing or new
        _status = RegistrationStatus.success;
        _userRegTempId = response.userRegTempId;
        _statusDesc = response.statusDesc;
        _statusCode = response.statusCode;
        _hasError = false;
        
        // Determine user type
        if (response.userType == 'LOGIN') {
          _userType = UserType.login;
          log('Existing user detected: $_userRegTempId');
        } else if (response.userType == 'REGISTER') {
          _userType = UserType.register;
          log('New user detected: $_userRegTempId');
        }
        
      } else {
        // Error
        _setError(response.error ?? 'Registration failed');
        _statusDesc = response.statusDesc;
        _statusCode = response.statusCode;
        
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
        // Success - determine if it's login or registration
        _userId = response.userId;
        _otpStatusDesc = response.statusDesc;
        _otpStatusCode = response.statusCode;
        _otpHasError = false;
        
        // Determine user type and set appropriate status
        if (response.userType == 'LOGIN') {
          _otpStatus = OTPVerificationStatus.successLogin;
          _verifiedUserType = UserType.login;
          log('Login successful. User ID: $_userId');
        } else if (response.userType == 'REGISTER') {
          _otpStatus = OTPVerificationStatus.successRegister;
          _verifiedUserType = UserType.register;
          log('Registration successful. User ID: $_userId');
        }
        
      } else {
        // Error
        _setOTPError(response.error ?? 'OTP verification failed');
        _otpStatusDesc = response.statusDesc;
        _otpStatusCode = response.statusCode;
        
        log('OTP verification failed: ${response.error}');
      }
    } catch (e) {
      _setOTPError('An unexpected error occurred: $e');
      log('OTP verification exception: $e');
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

  // Get formatted message based on user type
  String getUserTypeMessage() {
    if (_userType == UserType.login) {
      return 'Welcome back! Please enter OTP to login.';
    } else if (_userType == UserType.register) {
      return 'Please enter OTP to continue registration.';
    }
    return 'Please enter OTP.';
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
}