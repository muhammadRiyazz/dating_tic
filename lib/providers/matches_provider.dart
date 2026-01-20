import 'package:flutter/material.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/services/matches_service.dart';

class MatchesProvider with ChangeNotifier {
  final MatchesService _service = MatchesService();
  
  List<Profile> _matches = [];
  bool _isLoading = false;

  List<Profile> get matches => _matches;
  bool get isLoading => _isLoading;

  Future<void> fetchMatches(String userId) async {
    _isLoading = true;
    notifyListeners();

    _matches = await _service.getMatches(userId);
    
    _isLoading = false;
    notifyListeners();
  }
}