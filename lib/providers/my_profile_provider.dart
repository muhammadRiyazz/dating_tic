import 'package:dating/models/my_user_profile.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/services/my_profile_service.dart';
import 'package:flutter/material.dart';

class MyProfileProvider with ChangeNotifier {
  Profile? _userProfile;
  bool _isLoading = false;
  String? _error;
  final ProfileService _profileService = ProfileService();

  Profile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserProfile(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await _profileService.fetchProfileById(userId);
      _userProfile = profile;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProfile() {
    _userProfile = null;
    _error = null;
    notifyListeners();
  }
}