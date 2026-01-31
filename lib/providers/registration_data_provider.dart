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

  // --- NEW: Looking For (Preference) ---
  String? _selectedLookingForId;
  
  // Education levels
  DataLoadStatus _educationStatus = DataLoadStatus.initial;
  List<Map<String, dynamic>> _educationLevels = [];
  String? _educationError;
  String? _selectedEducationId;
  
  // Job title
  String? _jobTitle;

  // Interests
  DataLoadStatus _interestsStatus = DataLoadStatus.initial;
  List<Map<String, dynamic>> _interests = [];
  String? _interestsError;
  List<String> _selectedInterestIds = [];
  List<String> _selectedInterestNames = [];

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

  // --- NEW: Getters for Looking For ---
  String? get selectedLookingForId => _selectedLookingForId;
  bool get isLookingForSelected => _selectedLookingForId != null;
  
  // Getters for education
  DataLoadStatus get educationStatus => _educationStatus;
  List<Map<String, dynamic>> get educationLevels => _educationLevels;
  String? get educationError => _educationError;
  String? get selectedEducationId => _selectedEducationId;
  bool get educationLoading => _educationStatus == DataLoadStatus.loading;
  bool get educationLoaded => _educationStatus == DataLoadStatus.success;
  bool get educationHasError => _educationStatus == DataLoadStatus.error;
  bool get educationIsEmpty => _educationStatus == DataLoadStatus.empty;
  
  // Getters for interests
  DataLoadStatus get interestsStatus => _interestsStatus;
  List<Map<String, dynamic>> get interests => _interests;
  String? get interestsError => _interestsError;
  List<String> get selectedInterestIds => _selectedInterestIds;
  List<String> get selectedInterestNames => _selectedInterestNames;
  bool get interestsLoading => _interestsStatus == DataLoadStatus.loading;
  bool get interestsLoaded => _interestsStatus == DataLoadStatus.success;
  bool get interestsHasError => _interestsStatus == DataLoadStatus.error;
  bool get interestsIsEmpty => _interestsStatus == DataLoadStatus.empty;
  int get selectedInterestsCount => _selectedInterestIds.length;
  bool get hasMinimumInterests => _selectedInterestIds.length >= 3;
  bool get hasMaximumInterests => _selectedInterestIds.length >= 10;
  
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
    _selectedLookingForId = null; // Reset preference
    
    _educationStatus = DataLoadStatus.initial;
    _educationLevels = [];
    _educationError = null;
    _selectedEducationId = null;
    
    _interestsStatus = DataLoadStatus.initial;
    _interests = [];
    _interestsError = null;
    _selectedInterestIds = [];
    _selectedInterestNames = [];
    
    _jobTitle = null;
    
    notifyListeners();
  }

  // Reset only selection
  void resetSelections() {
    _selectedGoalId = null;
    _selectedGenderId = null;
    _selectedLookingForId = null; // Reset preference
    _selectedEducationId = null;
    _selectedInterestIds = [];
    _selectedInterestNames = [];
    _jobTitle = null;
    notifyListeners();
  }

  // Load relationship goals
  Future<void> loadRelationshipGoals(String genderId) async {
    if (_goalsStatus == DataLoadStatus.loading) return;
    
    _goalsStatus = DataLoadStatus.loading;
    _goalsError = null;
    notifyListeners();
    
    try {
      final response = await _service.getRelationshipGoals(genderId);
      
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

  // Load interests
  Future<void> loadInterests() async {
    if (_interestsStatus == DataLoadStatus.loading) return;
    
    _interestsStatus = DataLoadStatus.loading;
    _interestsError = null;
    notifyListeners();
    
    try {
      final response = await _service.getInterests();
      
      if (response.success && response.data != null) {
        _interests = response.data!;
        _interestsStatus = _interests.isEmpty ? DataLoadStatus.empty : DataLoadStatus.success;
      } else {
        _interestsStatus = DataLoadStatus.error;
        _interestsError = response.error;
      }
    } catch (e) {
      _interestsStatus = DataLoadStatus.error;
      _interestsError = 'Failed to load: $e';
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

  // --- NEW: Set looking for preference ---
  void selectLookingFor(String genderId) {
    _selectedLookingForId = genderId;
    notifyListeners();
  }

  // Set selected education
  void selectEducation(String educationId) {
    _selectedEducationId = educationId;
    notifyListeners();
  }

  // Toggle interest selection
  void toggleInterest(String interestId, String interestName) {
    if (_selectedInterestIds.contains(interestId)) {
      _selectedInterestIds.remove(interestId);
      _selectedInterestNames.remove(interestName);
    } else {
      if (_selectedInterestIds.length < 10) {
        _selectedInterestIds.add(interestId);
        _selectedInterestNames.add(interestName);
      }
    }
    notifyListeners();
  }

  // Clear all selected interests
  void clearSelectedInterests() {
    _selectedInterestIds.clear();
    _selectedInterestNames.clear();
    notifyListeners();
  }

  // Check if interest is selected
  bool isInterestSelected(String interestId) {
    return _selectedInterestIds.contains(interestId);
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

  // --- NEW: Get selected looking for details ---
  Map<String, dynamic>? getSelectedLookingFor() {
    if (_selectedLookingForId == null) return null;
    return _genders.firstWhere(
      (gender) => gender['genderId'].toString() == _selectedLookingForId,
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
  bool validateLookingForPage() => isLookingForSelected; // NEW
  bool validateGoalsPage() => isGoalSelected;
  bool validateInterestsPage() => _selectedInterestIds.length >= 3;
  
  // Get summary data for API submission
  // Map<String, dynamic> getRegistrationData() {
  //   return {
  //     'genderId': _selectedGenderId,
  //     'lookingForId': _selectedLookingForId, // UPDATED
  //     'goalId': _selectedGoalId,
  //     'educationId': _selectedEducationId,
  //     'jobTitle': _jobTitle,
  //     'interestIds': _selectedInterestIds,
  //   };
  // }
}