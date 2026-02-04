import 'dart:developer';
import 'package:dating/core/url.dart';
import 'package:dating/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeProvider with ChangeNotifier {
  List<Profile> _forYouProfiles = []; // New "For You" List
  List<GoalProfile> _categories = []; // Existing Categories
  bool _isLoading = true;
  String? _error;

  List<Profile> get forYouProfiles => _forYouProfiles;
  List<GoalProfile> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void removeProfileLocally(int profileId) {
    _forYouProfiles.removeWhere((p) => p.userId == profileId);
    for (var category in _categories) {
      category.profiles.removeWhere((p) => p.userId == profileId);
    }
    notifyListeners();
  }

  Future<void> fetchHomeData(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch both APIs simultaneously for better performance
      final results = await Future.wait([
        http.post(Uri.parse('$baseUrl/get-user-matches'), body: {'userId': userId}),
        http.post(Uri.parse('$baseUrl/profile-grouped-by-goal'), body: {'userId': userId}),
      ]);

      final forYouRes = results[0];
      final categoryRes = results[1];

      // 1. Process For You Data
      if (forYouRes.statusCode == 200) {
        final data = json.decode(forYouRes.body);
        if (data['status'] == 'SUCCESS') {
          _forYouProfiles = (data['data'] as List)
              .map((item) => Profile.fromJson(item))
              .toList();
        }
      }

      // 2. Process Categories Data
      if (categoryRes.statusCode == 200) {
        final data = json.decode(categoryRes.body);
        if (data['status'] == 'SUCCESS') {
          _categories = (data['data'] as List)
              .map((item) => GoalProfile.fromJson(item))
              .toList();
        }
      }

      if (_forYouProfiles.isEmpty && _categories.isEmpty) {
        _error = "No vibes found at the moment.";
      }
    } catch (e) {
      log("Error fetching home data: $e");
      _error = "Connection error. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}