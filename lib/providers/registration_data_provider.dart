// lib/providers/registration_data_provider.dart
import 'package:flutter/material.dart';
import '../services/registration_service.dart';

enum DataLoadStatus {
  initial,
  loading,
  success,
  error,
  empty,
}

class RegistrationDataProvider extends ChangeNotifier {
  final RegistrationDataService _service = RegistrationDataService();
  
  // Relationship goals
  DataLoadStatus _goalsStatus = DataLoadStatus.initial;
  List<Map<String, dynamic>> _goals = [];
  String? _goalsError;
  String? _selectedGoalId;
  
  // Genders
  DataLoadStatus _gendersStatus = DataLoadStatus.initial;
  List<Map<String, dynamic>> _genders = [];
  String? _gendersError;
  String? _selectedGenderId;
  
  // Education levels
  DataLoadStatus _educationStatus = DataLoadStatus.initial;
  List<Map<String, dynamic>> _educationLevels = [];
  String? _educationError;
  String? _selectedEducationId;
  
  // Job title
  String? _jobTitle;

  // Getters for relationship goals
  DataLoadStatus get goalsStatus => _goalsStatus;
  List<Map<String, dynamic>> get goals => _goals;
  String? get goalsError => _goalsError;
  String? get selectedGoalId => _selectedGoalId;
  bool get goalsLoading => _goalsStatus == DataLoadStatus.loading;
  bool get goalsLoaded => _goalsStatus == DataLoadStatus.success;
  bool get goalsHasError => _goalsStatus == DataLoadStatus.error;
  bool get goalsIsEmpty => _goalsStatus == DataLoadStatus.empty;
  
  // Getters for genders
  DataLoadStatus get gendersStatus => _gendersStatus;
  List<Map<String, dynamic>> get genders => _genders;
  String? get gendersError => _gendersError;
  String? get selectedGenderId => _selectedGenderId;
  bool get gendersLoading => _gendersStatus == DataLoadStatus.loading;
  bool get gendersLoaded => _gendersStatus == DataLoadStatus.success;
  bool get gendersHasError => _gendersStatus == DataLoadStatus.error;
  bool get gendersIsEmpty => _gendersStatus == DataLoadStatus.empty;
  
  // Getters for education
  DataLoadStatus get educationStatus => _educationStatus;
  List<Map<String, dynamic>> get educationLevels => _educationLevels;
  String? get educationError => _educationError;
  String? get selectedEducationId => _selectedEducationId;
  bool get educationLoading => _educationStatus == DataLoadStatus.loading;
  bool get educationLoaded => _educationStatus == DataLoadStatus.success;
  bool get educationHasError => _educationStatus == DataLoadStatus.error;
  bool get educationIsEmpty => _educationStatus == DataLoadStatus.empty;
  
  // Job title getter/setter
  String? get jobTitle => _jobTitle;
  set jobTitle(String? value) {
    _jobTitle = value;
    notifyListeners();
  }

  // Reset all data
  void resetAll() {
    _goalsStatus = DataLoadStatus.initial;
    _goals = [];
    _goalsError = null;
    _selectedGoalId = null;
    
    _gendersStatus = DataLoadStatus.initial;
    _genders = [];
    _gendersError = null;
    _selectedGenderId = null;
    
    _educationStatus = DataLoadStatus.initial;
    _educationLevels = [];
    _educationError = null;
    _selectedEducationId = null;
    
    _jobTitle = null;
    
    notifyListeners();
  }

  // Reset only selection
  void resetSelections() {
    _selectedGoalId = null;
    _selectedGenderId = null;
    _selectedEducationId = null;
    _jobTitle = null;
    notifyListeners();
  }

  // Load relationship goals
  Future<void> loadRelationshipGoals() async {
    if (_goalsStatus == DataLoadStatus.loading) return;
    
    _goalsStatus = DataLoadStatus.loading;
    _goalsError = null;
    notifyListeners();
    
    try {
      final response = await _service.getRelationshipGoals();
      
      if (response.success && response.data != null) {
        _goals = response.data!;
        _goalsStatus = _goals.isEmpty ? DataLoadStatus.empty : DataLoadStatus.success;
      } else {
        _goalsStatus = DataLoadStatus.error;
        _goalsError = response.error;
      }
    } catch (e) {
      _goalsStatus = DataLoadStatus.error;
      _goalsError = 'Failed to load: $e';
    }
    
    notifyListeners();
  }

  // Load genders
  Future<void> loadGenders() async {
    if (_gendersStatus == DataLoadStatus.loading) return;
    
    _gendersStatus = DataLoadStatus.loading;
    _gendersError = null;
    notifyListeners();
    
    try {
      final response = await _service.getGenders();
      
      if (response.success && response.data != null) {
        _genders = response.data!;
        _gendersStatus = _genders.isEmpty ? DataLoadStatus.empty : DataLoadStatus.success;
      } else {
        _gendersStatus = DataLoadStatus.error;
        _gendersError = response.error;
      }
    } catch (e) {
      _gendersStatus = DataLoadStatus.error;
      _gendersError = 'Failed to load: $e';
    }
    
    notifyListeners();
  }

  // Load education levels
  Future<void> loadEducationLevels() async {
    if (_educationStatus == DataLoadStatus.loading) return;
    
    _educationStatus = DataLoadStatus.loading;
    _educationError = null;
    notifyListeners();
    
    try {
      final response = await _service.getEducationLevels();
      
      if (response.success && response.data != null) {
        _educationLevels = response.data!;
        _educationStatus = _educationLevels.isEmpty ? DataLoadStatus.empty : DataLoadStatus.success;
      } else {
        _educationStatus = DataLoadStatus.error;
        _educationError = response.error;
      }
    } catch (e) {
      _educationStatus = DataLoadStatus.error;
      _educationError = 'Failed to load: $e';
    }
    
    notifyListeners();
  }

  // Set selected goal
  void selectGoal(String goalId) {
    _selectedGoalId = goalId;
    notifyListeners();
  }

  // Set selected gender
  void selectGender(String genderId) {
    _selectedGenderId = genderId;
    notifyListeners();
  }

  // Set selected education
  void selectEducation(String educationId) {
    _selectedEducationId = educationId;
    notifyListeners();
  }

  // Get selected goal details
  Map<String, dynamic>? getSelectedGoal() {
    if (_selectedGoalId == null) return null;
    return _goals.firstWhere(
      (goal) => goal['goalId'].toString() == _selectedGoalId,
      orElse: () => {},
    );
  }

  // Get selected gender details
  Map<String, dynamic>? getSelectedGender() {
    if (_selectedGenderId == null) return null;
    return _genders.firstWhere(
      (gender) => gender['genderId'].toString() == _selectedGenderId,
      orElse: () => {},
    );
  }

  // Get selected education details
  Map<String, dynamic>? getSelectedEducation() {
    if (_selectedEducationId == null) return null;
    return _educationLevels.firstWhere(
      (edu) => edu['eduId'].toString() == _selectedEducationId,
      orElse: () => {},
    );
  }

  // Check if all required fields are filled
  bool get isGenderSelected => _selectedGenderId != null;
  bool get isGoalSelected => _selectedGoalId != null;
  
  // Validate form
  bool validateGenderPage() => isGenderSelected;
  bool validateGoalsPage() => isGoalSelected;
  
  // Get summary data for API submission
  Map<String, dynamic> getRegistrationData() {
    return {
      'genderId': _selectedGenderId,
      'goalId': _selectedGoalId,
      'educationId': _selectedEducationId,
      'jobTitle': _jobTitle,
    };
  }
}