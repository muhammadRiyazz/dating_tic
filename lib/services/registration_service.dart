// lib/services/registration_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

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
  Future<ApiResponse<List<Map<String, dynamic>>>> getRelationshipGoals() async {
    try {
      final url = Uri.parse('$_baseUrl/relationship-goal');
      final response = await http.post(url);

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
}
class RegistrationService {
  static const String _baseUrl = 'https://tictechnologies.in/stage/weekend';

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