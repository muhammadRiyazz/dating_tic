// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userTokenKey = 'user_token';
  static const String _userPhoneKey = 'user_phone';
  static const String _userNameKey = 'user_name';
  static const String _userPhotoKey = 'user_photo';

  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Login user
  Future<void> login({
    required String userId,
    String? token,
    String? phone,
    String? name,
    String? photo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
    
    if (token != null) await prefs.setString(_userTokenKey, token);
    if (phone != null) await prefs.setString(_userPhoneKey, phone);
    if (name != null) await prefs.setString(_userNameKey, name);
    if (photo != null) await prefs.setString(_userPhotoKey, photo);
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userTokenKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userPhotoKey);
  }

  // Get user data
  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
      'userId': prefs.getString(_userIdKey) ?? '',
      'token': prefs.getString(_userTokenKey) ?? '',
      'phone': prefs.getString(_userPhoneKey) ?? '',
      'name': prefs.getString(_userNameKey) ?? '',
      'photo': prefs.getString(_userPhotoKey) ?? '',
    };
  }

  // Get user ID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Update user profile
  Future<void> updateProfile({String? name, String? photo}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString(_userNameKey, name);
    if (photo != null) await prefs.setString(_userPhotoKey, photo);
  }
}