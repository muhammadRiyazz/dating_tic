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
  final int? userRegTempId;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusDesc,
    this.statusCode,
    this.userRegTempId,
  });
}

class RegistrationService {
  static const String _baseUrl = 'https://tictechnologies.in/stage/weekend';
  

  // lib/services/registration_service.dart - Add this method
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

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status'] == 'SUCCESS') {
        return ApiResponse(
          success: true,
          data: jsonResponse,
          statusDesc: jsonResponse['statusDesc'],
          statusCode: jsonResponse['statusCode'],
          userRegTempId: jsonResponse['data']['userRegId'],
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
    log(e.toString());
    return ApiResponse(
      success: false,
      error: 'Network error: $e',
    );
  }
}
  Future<ApiResponse<Map<String, dynamic>>> sendPhoneNumber({
    required String phone,
    required String countryCode,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/registration");
      
      final response = await http.post(
        url,
        // headers: {
        //   'Content-Type': 'application/json',
        // },
        body: {
          'phone': phone,
          'countryCode': countryCode,
        },
      );
log(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['status'] == 'SUCCESS') {
          return ApiResponse(
            success: true,
            data: jsonResponse,
            statusDesc: jsonResponse['statusDesc'],
            statusCode: jsonResponse['statusCode'],
            userRegTempId: jsonResponse['data']['userRegTempId'],
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
      return ApiResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }
}