import 'dart:developer';

import 'package:dating/core/url.dart';
import 'package:dating/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeProvider with ChangeNotifier {
  List<GoalProfile> _categories = [];
  bool _isLoading = true;
  String? _error;

  List<GoalProfile> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
// Inside HomeProvider
void removeProfileLocally(int profileId) {
  for (var category in _categories) {
    category.profiles.removeWhere((p) => p.userId == profileId);
  }
  notifyListeners(); // This refreshes the UI
}
  Future<void> fetchHomeData(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
log('user id ------- $userId');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profile-grouped-by-goal'),
        body: {'userId': userId},
      );
      log('fetchHomeData-----');
log(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'SUCCESS') {

          
          _categories = (data['data'] as List)
              .map((item) => GoalProfile.fromJson(item))
              .toList();
        } else {
          _error = data['statusDesc'];
        }
      } else {
        log('Server Error');
        _error = 'Server Error: ${response.statusCode}';
      }
    } catch (e) {
      log(e.toString());
      _error = e.toString();
    } finally {
      log('finally--');
      _isLoading = false;
      notifyListeners();
    }
  }
}