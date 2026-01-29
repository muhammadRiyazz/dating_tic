import 'package:dating/models/plan_model.dart';
import 'package:flutter/material.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider with ChangeNotifier {
  final SubscriptionService _service = SubscriptionService();
  
  List<SubscriptionPlanModel> _plans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SubscriptionPlanModel> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final List<String> _dummyImages = [
    "https://images.pexels.com/photos/3171204/pexels-photo-3171204.jpeg",
    "https://images.pexels.com/photos/4873585/pexels-photo-4873585.jpeg",
    "https://images.pexels.com/photos/6579000/pexels-photo-6579000.jpeg",
    "https://images.pexels.com/photos/3756679/pexels-photo-3756679.jpeg",
  ];

  Future<void> loadPlans(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _plans = await _service.fetchPlans(userId);
      // Assign dummy images locally
      for (int i = 0; i < _plans.length; i++) {
        _plans[i].dummyImage = _dummyImages[i % _dummyImages.length];
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}