// providers/likers_provider.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/services/liked_service.dart';

class LikersProvider with ChangeNotifier {
  final LikedService _service = LikedService();
  List<Profile> _likers = [];
  bool _isLoading = false;

  List<Profile> get likers => _likers;
  bool get isLoading => _isLoading;

  Future<void> fetchLikers(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _likers = await _service.getLikedProfiles(userId);
    } catch (e) {

      log("Error fetching likers: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeLikerLocally(int userId) {
    _likers.removeWhere((p) => p.userId == userId);
    notifyListeners();
  }
}