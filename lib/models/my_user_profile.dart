
class MyProfile {
  final int userId;
  final String userName;
  final String? phno;
  final String? countryCode;
  final String? dateOfBirth;
  final String? height;
  final String? smokingHabit;
  final String? drinkingHabit;
  final String? job;
  final Gender gender;
  final Education education;
  final RelationshipGoal? relationshipGoal;
  final List<Interest> interests;
  final Location? location;
  final String? bio;
  final String photo;
  final List<Photo> photos;
  final List<Photo> privatePhotos;
  final String? lastSeen;
  final bool isLive;

  MyProfile({
    required this.userId,
    required this.userName,
    this.phno,
    this.countryCode,
    this.dateOfBirth,
    this.height,
    this.smokingHabit,
    this.drinkingHabit,
    this.job,
    required this.gender,
    required this.education,
    this.relationshipGoal,
    required this.interests,
    this.location,
    this.bio,
    required this.photo,
    required this.photos,
    required this.privatePhotos,
    this.lastSeen,
    required this.isLive,
  });

 factory MyProfile.fromJson(Map<String, dynamic> json) {
  return MyProfile(
    userId: json['userId'],
    userName: json['userName'],
    phno: json['phno'],
    countryCode: json['countryCode'],
    dateOfBirth: json['dateOfBirth'],
    height: json['height'],
    smokingHabit: json['smokingHabit'],
    drinkingHabit: json['drinkingHabit'],
    job: json['job'],
    gender: Gender.fromJson(json['gender']),
    education: Education.fromJson(json['education']),
    relationshipGoal: json['relationshipGoal'] != null
        ? RelationshipGoal.fromJson(json['relationshipGoal'])
        : null,
    interests: (json['interests'] as List)
        .map((e) => Interest.fromJson(e))
        .toList(),
    location: json['location'] != null 
        ? Location.fromJson(json['location']) 
        : null,
    bio: json['bio'],
    photo: json['mainPhoto'], // Changed from 'photo' to 'mainPhoto'
    photos: (json['photos'] as List) // Changed from 'photos' to 'publicPhotos'
        .map((e) => Photo.fromJson(e))
        .toList(),
    privatePhotos: (json['privatePhotos'] as List)
        .map((e) => Photo.fromJson(e))
        .toList(),
    lastSeen: json['lastSeen'],
    isLive: json['isLive'] == "1",
  );
}

  MyProfile copyWith({
    int? userId,
    String? userName,
    String? phno,
    String? countryCode,
    String? dateOfBirth,
    String? height,
    String? smokingHabit,
    String? drinkingHabit,
    String? job,
    Gender? gender,
    Education? education,
    RelationshipGoal? relationshipGoal,
    List<Interest>? interests,
    Location? location,
    String? bio,
    String? photo,
    List<Photo>? photos,
    List<Photo>? privatePhotos,
    String? lastSeen,
    bool? isLive,
  }) {
    return MyProfile(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      phno: phno ?? this.phno,
      countryCode: countryCode ?? this.countryCode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      smokingHabit: smokingHabit ?? this.smokingHabit,
      drinkingHabit: drinkingHabit ?? this.drinkingHabit,
      job: job ?? this.job,
      gender: gender ?? this.gender,
      education: education ?? this.education,
      relationshipGoal: relationshipGoal ?? this.relationshipGoal,
      interests: interests ?? this.interests,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      photo: photo ?? this.photo,
      photos: photos ?? this.photos,
      privatePhotos: privatePhotos ?? this.privatePhotos,
      lastSeen: lastSeen ?? this.lastSeen,
      isLive: isLive ?? this.isLive,
    );
  }

  factory MyProfile.empty() {
    return MyProfile(
      userId: 0,
      userName: '',
      phno: null,
      countryCode: null,
      dateOfBirth: null,
      height: null,
      smokingHabit: null,
      drinkingHabit: null,
      job: null,
      gender: Gender.empty(),
      education: Education.empty(),
      relationshipGoal: null,
      interests: [],
      location: null,
      bio: null,
      photo: '',
      photos: [],
      privatePhotos: [],
      lastSeen: null,
      isLive: false,
    );
  }
}

/// =======================
/// LOCATION
/// =======================
class Location {
  final String latitude;
  final String longitude;
  final String city;
  final String state;
  final String country;
  final String address;

  Location({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      address: json['address'],
    );
  }
}

/// =======================
/// PHOTO
/// =======================
class Photo {
  final String id;
  final String photoUrl;

  Photo({
    required this.id,
    required this.photoUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      photoUrl: json['photo_url'].replaceAll('\\', ''),
    );
  }
}

/// =======================
/// GENDER
/// =======================
class Gender {
  final int id;
  final String name;

  Gender({required this.id, required this.name});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(id: json['id'], name: json['name']);
  }

  factory Gender.empty() => Gender(id: 0, name: '');

  Gender copyWith({int? id, String? name}) {
    return Gender(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

/// =======================
/// EDUCATION
/// =======================
class Education {
  final int id;
  final String name;

  Education({required this.id, required this.name});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(id: json['id'], name: json['name']);
  }

  factory Education.empty() => Education(id: 0, name: '');

  Education copyWith({int? id, String? name}) {
    return Education(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

/// =======================
/// INTEREST
/// =======================
class Interest {
  final int id;
  final String name;
  final String emoji;

  Interest({
    required this.id,
    required this.name,
    required this.emoji,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'] ?? '',
    );
  }

  Interest copyWith({int? id, String? name, String? emoji}) {
    return Interest(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
    );
  }
}

/// =======================
/// RELATIONSHIP GOAL
/// =======================
class RelationshipGoal {
  final int id;
  final String name;
  final String emoji;

  RelationshipGoal({
    required this.id,
    required this.name,
    required this.emoji,
  });

  factory RelationshipGoal.fromJson(Map<String, dynamic> json) {
    return RelationshipGoal(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'] ?? '',
    );
  }

  RelationshipGoal copyWith({int? id, String? name, String? emoji}) {
    return RelationshipGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
    );
  }
}
