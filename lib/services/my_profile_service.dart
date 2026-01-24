import 'dart:convert';
import 'dart:developer';
import 'package:dating/models/profile_model.dart';
import 'package:http/http.dart' as http;
import '../models/my_user_profile.dart';

class ProfileService {
  static const String _baseUrl = 'https://tictechnologies.in/stage/weekend';
  
  Future<Profile> fetchProfileById(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/profile-by-id'),
        body:{'userId': userId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'SUCCESS') {
          return Profile.fromJson(data['data']);
        } else {
          throw Exception(data['statusDesc'] ?? 'Failed to fetch profile');
        }
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      log('ProfileService Error: $e');
      rethrow;
    }
  }
}