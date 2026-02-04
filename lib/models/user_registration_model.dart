class UserRegistrationModel {
  final String? userRegId;
  final String? userName;
    final String? phoneNo;

  final String? dateOfBirth;
  final String? gender;
    final String? intrestgender;


  final String? voiceEncryptionExtension;
  final String? voiceEncryption;

  final double? height;
  final String? smokingHabit;
  final String? drinkingHabit;
  final String? relationshipGoal;
  final String? job;
  final String? education;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? state;
  final String? country;
  final String? address;
  final String? bio;
  final List<String>? photos;
    final List<String>? privatePhotos;

  final List<String>? interests;
  final String? mainPhotoUrl;

  const UserRegistrationModel({
    this.voiceEncryption,
    this.voiceEncryptionExtension,
    this.intrestgender,
    this.userName,
    this.privatePhotos,
    this.interests,
    this.phoneNo,
    this.userRegId,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.smokingHabit,
    this.drinkingHabit,
    this.relationshipGoal,
    this.job,
    this.education,
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.country,
    this.address,
    this.bio,
    this.photos,
    this.mainPhotoUrl,
  });
UserRegistrationModel copyWith({
  String? voiceEncryptionExtension,
  String? voiceEncryption,
  List<String>? interests,
  String? userName,
  String? userRegId,
  String? dateOfBirth,
  String? intrestgender,
  List<String>? privatePhotos,
  String? gender,
  double? height,
  String? smokingHabit,
  String? drinkingHabit,
  String? relationshipGoal,
  String? job,
  String? education,
  double? latitude,
  double? longitude,
  String? city,
  String? state,
  String? country,
  String? phoneNo,
  String? address,
  String? bio,
  List<String>? photos,
  String? mainPhotoUrl,
}) {
  return UserRegistrationModel(
    voiceEncryption: voiceEncryption ?? this.voiceEncryption,
    voiceEncryptionExtension:
        voiceEncryptionExtension ?? this.voiceEncryptionExtension,

    intrestgender: intrestgender ?? this.intrestgender,
    phoneNo: phoneNo ?? this.phoneNo,
    privatePhotos: privatePhotos ?? this.privatePhotos,
    interests: interests ?? this.interests,

    userName: userName ?? this.userName,
    userRegId: userRegId ?? this.userRegId,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    height: height ?? this.height,
    smokingHabit: smokingHabit ?? this.smokingHabit,
    drinkingHabit: drinkingHabit ?? this.drinkingHabit,
    relationshipGoal: relationshipGoal ?? this.relationshipGoal,
    job: job ?? this.job,
    education: education ?? this.education,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    city: city ?? this.city,
    state: state ?? this.state,
    country: country ?? this.country,
    address: address ?? this.address,
    bio: bio ?? this.bio,
    photos: photos ?? this.photos,
    mainPhotoUrl: mainPhotoUrl ?? this.mainPhotoUrl,
  );
}

  // Convert to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     if (userRegId != null) 'userRegId': userRegId,
  //     if (userName != null) 'userName': userName,
  //     if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
  //     if (gender != null) 'gender': gender,
  //     if (height != null) 'height': height,
  //     if (smokingHabit != null) 'smokingHabit': smokingHabit,
  //     if (drinkingHabit != null) 'drinkingHabit': drinkingHabit,
  //     if (relationshipGoal != null) 'relationshipGoal': relationshipGoal,
  //     if (job != null) 'job': job,
  //     if (education != null) 'education': education,
  //     if (latitude != null) 'latitude': latitude,
  //     if (longitude != null) 'longitude': longitude,
  //     if (city != null) 'city': city,
  //     if (state != null) 'state': state,
  //     if (country != null) 'country': country,
  //     if (address != null) 'address': address,
  //     if (bio != null) 'bio': bio,
  //     if (photos != null) 'photos': photos,
  //     if (mainPhotoUrl != null) 'mainPhotoUrl': mainPhotoUrl,
  //   };
  // }

  // Alternative: Include null values in JSON (uncomment if needed)
  Map<String, dynamic> toJson() {
    return {

      'interests':interests,
      'userRegId': userRegId,
      'user_name': userName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'height': height,
      'smoking_habit': smokingHabit,
      'drinking_habit': drinkingHabit,
      'relationship_goal': relationshipGoal,
      'job': job,
      'education': education,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'country': country,
      'address': address,
      'bio': bio,
      'photos': photos,
      'mainphotourl': mainPhotoUrl,
    };
  }
}