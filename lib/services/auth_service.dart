// // lib/services/auth_service.dart
import 'dart:developer';

import 'package:dating/pages/first_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// lib/services/auth_service.dart

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userTokenKey = 'user_token';
  static const String _userPhoneKey = 'user_phone';
  static const String _userNameKey = 'user_name';
  static const String _userPhotoKey = 'user_photo';

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Login user and store all data
  Future<void> login({
    required String userId,
    String? token,
    String? phone,
    String? name,
    required String photo, // Now strictly required
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userPhotoKey, photo); // Save photo URL
    
    if (token != null) await prefs.setString(_userTokenKey, token);
    if (phone != null) await prefs.setString(_userPhoneKey, phone);
    if (name != null) await prefs.setString(_userNameKey, name);
    
    log("User $userId logged in with photo: $photo");
  }

  // Get user photo URL
  Future<String?> getUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhotoKey);
  }

  // Get user ID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }
  Future<void> updateProfile({String? name, String? photo}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString(_userNameKey, name);
    if (photo != null) await prefs.setString(_userPhotoKey, photo);
  }
  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all keys
  }

   Future<void> updateUserPhoto(String? photo) async {
    final prefs = await SharedPreferences.getInstance();
    if (photo != null) await prefs.setString(_userPhotoKey, photo);
  }
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  // Existing getUserData method...
  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
      'userId': prefs.getString(_userIdKey) ?? '',
      'photo': prefs.getString(_userPhotoKey) ?? '',
      'name': prefs.getString(_userNameKey) ?? '',
    };
  }
}