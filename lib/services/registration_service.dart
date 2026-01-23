// lib/services/registration_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:dating/providers/profile_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? statusDesc;
  final int? statusCode;
  final String? userRegTempId;
  final String? userType;
  final String? userId;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusDesc,
    this.statusCode,
    this.userRegTempId,
    this.userType,
    this.userId,
  });
}

class RegistrationDataService {
  static const String _baseUrl = 'https://tictechnologies.in/stage/weekend';

  // Get Relationship Goals
  Future<ApiResponse<List<Map<String, dynamic>>>> getRelationshipGoals(String genderId) async {
    try {
      final url = Uri.parse('$_baseUrl/relationship-goal');
      log(genderId);
      final response = await http.post(
        url,
        body: {
          'genderId': genderId,
        },
      );
      log('Relationship goals response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['status'] == 'SUCCESS') {
          final List<dynamic> data = jsonResponse['data'];
          return ApiResponse(
            success: true,
            data: data.map((item) => Map<String, dynamic>.from(item)).toList(),
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        } else {
          return ApiResponse(
            success: false,
            error: jsonResponse['statusDesc'] ?? 'Failed to fetch relationship goals',
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        }
      } else {
        return ApiResponse(
          success: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Relationship goals error: $e');
      return ApiResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }

  // Get Genders
  Future<ApiResponse<List<Map<String, dynamic>>>> getGenders() async {
    try {
      final url = Uri.parse('$_baseUrl/gender');
      final response = await http.post(url);

      log('Genders response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['status'] == 'SUCCESS') {
          final List<dynamic> data = jsonResponse['data'];
          return ApiResponse(
            success: true,
            data: data.map((item) => Map<String, dynamic>.from(item)).toList(),
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        } else {
          return ApiResponse(
            success: false,
            error: jsonResponse['statusDesc'] ?? 'Failed to fetch genders',
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        }
      } else {
        return ApiResponse(
          success: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Genders error: $e');
      return ApiResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }

  // Get Education Levels
  Future<ApiResponse<List<Map<String, dynamic>>>> getEducationLevels() async {
    try {
      final url = Uri.parse('$_baseUrl/education');
      final response = await http.post(url);

      log('Education response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['status'] == 'SUCCESS') {
          final List<dynamic> data = jsonResponse['data'];
          return ApiResponse(
            success: true,
            data: data.map((item) => Map<String, dynamic>.from(item)).toList(),
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        } else {
          return ApiResponse(
            success: false,
            error: jsonResponse['statusDesc'] ?? 'Failed to fetch education levels',
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        }
      } else {
        return ApiResponse(
          success: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Education error: $e');
      return ApiResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }

  // Get Interests
  Future<ApiResponse<List<Map<String, dynamic>>>> getInterests() async {
    try {
      final url = Uri.parse('$_baseUrl/interests');
      final response = await http.post(url);

      log('Interests response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['status'] == 'SUCCESS') {
          final List<dynamic> data = jsonResponse['data'];
          return ApiResponse(
            success: true,
            data: data.map((item) => Map<String, dynamic>.from(item)).toList(),
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        } else {
          return ApiResponse(
            success: false,
            error: jsonResponse['statusDesc'] ?? 'Failed to fetch interests',
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        }
      } else {
        return ApiResponse(
          success: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Interests error: $e');
      return ApiResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }
}

class RegistrationService {
  static const String _baseUrl = 'https://tictechnologies.in/stage/weekend';



  
Future<ApiResponse<String>> getUserMainPhoto(String userId) async {
    try {
      final url = Uri.parse('$_baseUrl/main-photo-by-id');
      final response = await http.post(
        url,
        body: {'userId': userId},
      );

      log('Main photo response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'SUCCESS') {
          // Return the photo URL string from the nested data object
          return ApiResponse(
            success: true,
            data: jsonResponse['data']['photo'].toString(),
            statusDesc: jsonResponse['statusDesc'],
          );
        } else {
          return ApiResponse(
            success: false,
            error: jsonResponse['statusDesc'] ?? 'Failed to fetch photo',
          );
        }
      }
      return ApiResponse(success: false, error: 'Server error: ${response.statusCode}');
    } catch (e) {
      return ApiResponse(success: false, error: 'Network error: $e');
    }
  }

  // Send phone number - returns whether user is already registered or new
  Future<ApiResponse<Map<String, dynamic>>> sendPhoneNumber({
    required String phone,
    required String countryCode,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/registration');
      
      final response = await http.post(
        url,
        body: {
          'phone': phone,
          'countryCode': countryCode,
        },
      );

      log('Phone registration response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['status'] == 'SUCCESS') {
          return ApiResponse(
            success: true,
            data: jsonResponse,
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
            userRegTempId: jsonResponse['data']['userRegTempId'].toString(),
            userType: jsonResponse['data']['userType'], // 'LOGIN' or 'REGISTER'
          );
        } else {
          return ApiResponse(
            success: false,
            error: jsonResponse['statusDesc'] ?? 'Registration failed',
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        }
      } else {
        return ApiResponse(
          success: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Phone registration error: $e');
      return ApiResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }

  // Verify OTP - returns user ID and whether it's login or registration
  Future<ApiResponse<Map<String, dynamic>>> verifyOTP({
    required String userRegTempId,
    required String otp,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/registration-otp-verification');
      
      final response = await http.post(
        url,
        body: {
          'userRegTempId': userRegTempId,
          'otp': otp,
        },
      );

      log('OTP verification response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['status'] == 'SUCCESS') {
          return ApiResponse(
            success: true,
            data: jsonResponse,
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
            userId: jsonResponse['data']['userId'].toString(),
            userType: jsonResponse['data']['userType'], // 'LOGIN' or 'REGISTER'
          );
        } else {
          return ApiResponse(
            success: false,
            error: jsonResponse['statusDesc'] ?? 'OTP verification failed',
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
          );
        }
      } else {
        return ApiResponse(
          success: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('OTP verification error: $e');
      return ApiResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }
}





Future<void> fetchprofiles(BuildContext context)async{
final authService = AuthService();
    final userId = await authService.getUserId();

    // 2. If we have a userId, trigger the Home API call immediately
    if (userId != null ) {
      // ignore: use_build_context_synchronously
      Provider.of<HomeProvider>(context, listen: false).fetchHomeData(userId);
    }
}