import 'package:dating/services/subscription_service.dart';
import 'package:flutter/material.dart';
import '../models/plan_model.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<SubscriptionPlanModel> _plans = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPlanIndex = 1; // Default to most popular

  List<SubscriptionPlanModel> get plans => _plans;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get currentPlanIndex => _currentPlanIndex;
  bool get hasError => _error.isNotEmpty;

  void setCurrentPlanIndex(int index) {
    _currentPlanIndex = index;
    notifyListeners();
  }

  Future<void> fetchPlans(String userId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _plans = await SubscriptionService.fetchPlans(userId: userId);
      
      // Find the most popular plan (with badge)
      for (int i = 0; i < _plans.length; i++) {
        if (_plans[i].badge?.toLowerCase().contains('popular') == true) {
          _currentPlanIndex = i;
          break;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryFetch(String userId) {
    _error = '';
    fetchPlans(userId);
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}