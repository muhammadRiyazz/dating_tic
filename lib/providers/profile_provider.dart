import 'dart:developer';

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

  Future<void> fetchHomeData(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://tictechnologies.in/stage/weekend/profile-grouped-by-goal'),
        body: {'userId': userId},
      );
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
        _error = 'Server Error: ${response.statusCode}';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}