// user_profile_provider.dart
import 'package:dating/models/profile_model.dart';
import 'package:flutter/material.dart';

class UpdateProfileProvider with ChangeNotifier {
   Profile _userProfile  =Profile.empty();

  Profile get userProfile => _userProfile;

  // Initialize with existing data
  void initializeProfile(Profile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  // Update entire profile
  void updateProfile(Profile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }

  // Update specific fields

  // Basic Info
  void updateBasicInfo({
    String? userName,
    String? dateOfBirth,
    Gender? gender,
  }) {
    _userProfile = _userProfile.copyWith(
      userName: userName,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );
    notifyListeners();
  }

  // Education
  void updateEducation(Education education) {
    _userProfile = _userProfile.copyWith(education: education);
    notifyListeners();
  }

  // Relationship Goal
  void updateRelationshipGoal(RelationshipGoal goal) {
    _userProfile = _userProfile.copyWith(relationshipGoal: goal);
    notifyListeners();
  }

  // Height
  void updateHeight(String height) {
    _userProfile = _userProfile.copyWith(height: height);
    notifyListeners();
  }

  // Job
  void updateJob(String job) {
    _userProfile = _userProfile.copyWith(job: job);
    notifyListeners();
  }

  // Lifestyle
  void updateLifestyle({
    String? smokingHabit,
    String? drinkingHabit,
  }) {
    _userProfile = _userProfile.copyWith(
      smokingHabit: smokingHabit,
      drinkingHabit: drinkingHabit,
    );
    notifyListeners();
  }

  // Location
  void updateLocation({
    String? latitude,
    String? longitude,
    String? city,
    String? state,
    String? country,
    String? address,
  }) {
    _userProfile = _userProfile.copyWith(

     latitude: latitude??'', longitude: longitude??'', city: city??'', state: state??'', country: country??'', address: address??'',
     
    );
    notifyListeners();
  }

  // Bio
  void updateBio(String bio) {
    _userProfile = _userProfile.copyWith(bio: bio);
    notifyListeners();
  }

  // Photos
  void updatePhotos(List<Photo> photos) {
    _userProfile = _userProfile.copyWith(photos:photos );
    notifyListeners();
  }

  void updateMainPhoto(String mainPhotoUrl) {
    _userProfile = _userProfile.copyWith(photo: mainPhotoUrl);
    notifyListeners();
  }

  void addPhoto(Photo photoUrl) {
    List<Photo> currentPhotos = List.from(_userProfile.photos);
    currentPhotos.add(photoUrl);
    _userProfile = _userProfile.copyWith(photos: currentPhotos);
    notifyListeners();
  }

  // Interests
  void updateInterests(List<Interest> interests) {
    _userProfile = _userProfile.copyWith(interests: interests);
    notifyListeners();
  }

  void addInterest(Interest interest) {
    List<Interest> currentInterests = List.from(_userProfile.interests );
    if (!currentInterests.contains(interest)) {
      currentInterests.add(interest);
      _userProfile = _userProfile.copyWith(interests: currentInterests);
      notifyListeners();
    }
  }

  void removeInterest(Interest interest) {
    List<Interest> currentInterests = List.from(_userProfile.interests );
    currentInterests.remove(interest);
    _userProfile = _userProfile.copyWith(interests: currentInterests);
    notifyListeners();
  }

  // Clear all data
  void clearProfile() {
    _userProfile = Profile.empty();
    notifyListeners();
  }

  // Check if profile is complete
bool isProfileComplete() {
  return _userProfile.userName.trim().isNotEmpty &&
      _userProfile.gender.name.trim().isNotEmpty &&
      _userProfile.education.name.trim().isNotEmpty &&
      (_userProfile.relationshipGoal?.name.trim().isNotEmpty ?? false) &&
      _userProfile.photos.isNotEmpty;
}

}