// import 'dart:convert';
// import 'dart:developer';

// class ApiResponse {
//   final String status;
//   final int statusCode;
//   final String statusDesc;
//   final List<GoalProfile> data;

//   ApiResponse({
//     required this.status,
//     required this.statusCode,
//     required this.statusDesc,
//     required this.data,
//   });

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       status: json['status'],
//       statusCode: json['statusCode'],
//       statusDesc: json['statusDesc'],
//       data: (json['data'] as List)
//           .map((e) => GoalProfile.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class GoalProfile {
//   final int goalId;
//   final String goalTitle;
//   final String goalEmoji;
//   final List<Profile> profiles;

//   GoalProfile({
//     required this.goalId,
//     required this.goalTitle,
//     required this.goalEmoji,
//     required this.profiles,
//   });

//   factory GoalProfile.fromJson(Map<String, dynamic> json) {
//     return GoalProfile(
//       goalId: json['goalId'],
//       goalTitle: json['goalTitle'],
//       goalEmoji: json['goalEmoji'],
//       profiles: (json['profiles'] as List)
//           .map((e) => Profile.fromJson(e))
//           .toList(),
//     );
//   }

//   GoalProfile copyWith({
//     int? goalId,
//     String? goalTitle,
//     String? goalEmoji,
//     List<Profile>? profiles,
//   }) {
//     return GoalProfile(
//       goalId: goalId ?? this.goalId,
//       goalTitle: goalTitle ?? this.goalTitle,
//       goalEmoji: goalEmoji ?? this.goalEmoji,
//       profiles: profiles ?? this.profiles,
//     );
//   }
// }

// class Profile {
//   final int userId;
//   final String userName;
//   final String? phno;
//   final String? countryCode;
//   final String? dateOfBirth;
//   final String? height;
//   final String? smokingHabit;
//   final String? drinkingHabit;
//   final String? job;
//   final Gender gender;
//   final Education education;
//   final RelationshipGoal? relationshipGoal;
//   final List<Interest> interests;
//   final String? city;
//   final String? state;
//   final String? country;
//   final String? latitude;
//   final String? longitude;
//   final String? address;
//   final String? bio;
//     final String? voiceUrl;
//         final String? interestedGender;
//         final String? interestedGenderId;


//   final String photo;
//   final List<Photo> photos;
//   final List<Photo> privatePhotos;
//   final int privatePhotoCount;
//   final bool isBoosted;
//   final String? lastSeen;
//   final bool isLive;

//   Profile({
//     this.interestedGender,
//     this.interestedGenderId,
//     this.voiceUrl,
//     required this.userId,
//     required this.userName,
//     this.phno,
//     this.countryCode,
//     this.dateOfBirth,
//     this.height,
//     this.smokingHabit,
//     this.drinkingHabit,
//     this.job,
//     required this.gender,
//     required this.education,
//     this.relationshipGoal,
//     required this.interests,
//     this.city,
//     this.state,
//     this.country,
//     this.latitude,
//     this.longitude,
//     this.address,
//     this.bio,
//     required this.photo,
//     required this.photos,
//     required this.privatePhotos,
//     required this.privatePhotoCount,
//     required this.isBoosted,
//     this.lastSeen,
//     required this.isLive,
//   });

//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       interestedGender:  json['interested_gender'],
//       interestedGenderId: json['interested_gender_id'] ,
//       voiceUrl: json['voice_url'] ,
//       userId: json['userId'],
//       userName: json['userName'],
//       phno: json['phno'],
//       countryCode: json['countryCode'],
//       dateOfBirth: json['dateOfBirth'],
//       height: json['height'],
//       smokingHabit: json['smokingHabit'],
//       drinkingHabit: json['drinkingHabit'],
//       job: json['job'],
//       gender: Gender.fromJson(json['gender']),
//       education: Education.fromJson(json['education']),
//       relationshipGoal: json['relationshipGoal'] != null
//           ? RelationshipGoal.fromJson(json['relationshipGoal'])
//           : null,
//       interests: (json['interests'] as List)
//           .map((e) => Interest.fromJson(e))
//           .toList(),
//       city: json['city'],
//       state: json['state'],
//       country: json['country'],
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       address: json['address'],
//       bio: json['bio'],
//       photo: json['mainPhoto'] ?? '',
//       photos: (json['photos'] as List)
//           .map((e) => Photo.fromJson(e))
//           .toList(),
//       privatePhotos: (json['privatePhotos'] as List)
//           .map((e) => Photo.fromJson(e))
//           .toList(),
//       privatePhotoCount: json['privatePhotoCount'] ?? 0,
//       isBoosted: json['isBoosted'] ?? false,
//       lastSeen: json['last_seen'] ?? json['lastSeen'],
//       isLive: json['is_live'] == "1" || json['is_live'] == true || json['isLive'] == "1" || json['isLive'] == true,
//     );
//   }

//   Profile copyWith({

    
//     String?  interestedGender,
//         String?  interestedGenderId,
//     String?  voiceUrl,

//     int? userId,
//     String? userName,
//     String? phno,
//     String? countryCode,
//     String? dateOfBirth,
//     String? height,
//     String? smokingHabit,
//     String? drinkingHabit,
//     String? job,
//     Gender? gender,
//     Education? education,
//     RelationshipGoal? relationshipGoal,
//     List<Interest>? interests,
//     String? city,
//     String? state,
//     String? country,
//     String? latitude,
//     String? longitude,
//     String? address,
//     String? bio,
//     String? photo,
//     List<Photo>? photos,
//     List<Photo>? privatePhotos,
//     int? privatePhotoCount,
//     bool? isBoosted,
//     String? lastSeen,
//     bool? isLive,
//   }) {
//     return Profile(
//       interestedGender:interestedGender??this.interestedGender ,
//       interestedGenderId:interestedGenderId??this. interestedGenderId ,
//       voiceUrl: voiceUrl?? this.voiceUrl,
//       userId: userId ?? this.userId,
//       userName: userName ?? this.userName,
//       phno: phno ?? this.phno,
//       countryCode: countryCode ?? this.countryCode,
//       dateOfBirth: dateOfBirth ?? this.dateOfBirth,
//       height: height ?? this.height,
//       smokingHabit: smokingHabit ?? this.smokingHabit,
//       drinkingHabit: drinkingHabit ?? this.drinkingHabit,
//       job: job ?? this.job,
//       gender: gender ?? this.gender,
//       education: education ?? this.education,
//       relationshipGoal: relationshipGoal ?? this.relationshipGoal,
//       interests: interests ?? this.interests,
//       city: city ?? this.city,
//       state: state ?? this.state,
//       country: country ?? this.country,
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       address: address ?? this.address,
//       bio: bio ?? this.bio,
//       photo: photo ?? this.photo,
//       photos: photos ?? this.photos,
//       privatePhotos: privatePhotos ?? this.privatePhotos,
//       privatePhotoCount: privatePhotoCount ?? this.privatePhotoCount,
//       isBoosted: isBoosted ?? this.isBoosted,
//       lastSeen: lastSeen ?? this.lastSeen,
//       isLive: isLive ?? this.isLive,
//     );
//   }

//   factory Profile.empty() {
//     return Profile(
//       interestedGender: null,
//       interestedGenderId: null,
//       voiceUrl: null,
//       userId: 0,
//       userName: '',
//       phno: null,
//       countryCode: null,
//       dateOfBirth: null,
//       height: null,
//       smokingHabit: null,
//       drinkingHabit: null,
//       job: null,
//       gender: Gender.empty(),
//       education: Education.empty(),
//       relationshipGoal: null,
//       interests: [],
//       city: null,
//       state: null,
//       country: null,
//       latitude: null,
//       longitude: null,
//       address: null,
//       bio: null,
//       photo: '',
//       photos: [],
//       privatePhotos: [],
//       privatePhotoCount: 0,
//       isBoosted: false,
//       lastSeen: null,
//       isLive: false,
//     );
//   }
// }

// /// =======================
// /// LOCATION (Kept for backward compatibility)
// /// =======================
// class Location {
//   final String latitude;
//   final String longitude;
//   final String city;
//   final String state;
//   final String country;
//   final String address;

//   Location({
//     required this.latitude,
//     required this.longitude,
//     required this.city,
//     required this.state,
//     required this.country,
//     required this.address,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       city: json['city'],
//       state: json['state'],
//       country: json['country'],
//       address: json['address'],
//     );
//   }
// }

// /// =======================
// /// PHOTO
// /// =======================
// class Photo {
//   final String id;
//   final String photoUrl;

//   Photo({
//     required this.id,
//     required this.photoUrl,
//   });

//   factory Photo.fromJson(Map<String, dynamic> json) {
//     return Photo(
//       id: json['id']?.toString() ?? '',
//       photoUrl: (json['photo_url'] ?? json['photoUrl'] ??  json['path'])
         
//     );
//   }
// }

// /// =======================
// /// GENDER
// /// =======================
// class Gender {
//   final int id;
//   final String name;

//   Gender({required this.id, required this.name});

//   factory Gender.fromJson(Map<String, dynamic> json) {
//     return Gender(
//       id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       name: json['name']?.toString() ?? '',
//     );
//   }

//   factory Gender.empty() => Gender(id: 0, name: '');

//   Gender copyWith({int? id, String? name}) {
//     return Gender(
//       id: id ?? this.id,
//       name: name ?? this.name,
//     );
//   }
// }

// /// =======================
// /// EDUCATION
// /// =======================
// class Education {
//   final int id;
//   final String name;

//   Education({required this.id, required this.name});

//   factory Education.fromJson(Map<String, dynamic> json) {
//     return Education(
//       id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       name: json['name']?.toString() ?? '',
//     );
//   }

//   factory Education.empty() => Education(id: 0, name: '');

//   Education copyWith({int? id, String? name}) {
//     return Education(
//       id: id ?? this.id,
//       name: name ?? this.name,
//     );
//   }
// }

// /// =======================
// /// INTEREST
// /// =======================
// class Interest {
//   final int id;
//   final String name;
//   final String emoji;

//   Interest({
//     required this.id,
//     required this.name,
//     required this.emoji,
//   });

//   factory Interest.fromJson(Map<String, dynamic> json) {
//     return Interest(
//       id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       name: json['name']?.toString() ?? '',
//       emoji: json['emoji']?.toString() ?? '',
//     );
//   }

//   Interest copyWith({int? id, String? name, String? emoji}) {
//     return Interest(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       emoji: emoji ?? this.emoji,
//     );
//   }
// }

// /// =======================
// /// RELATIONSHIP GOAL
// /// =======================
// class RelationshipGoal {
//   final int id;
//   final String name;
//   final String emoji;

//   RelationshipGoal({
//     required this.id,
//     required this.name,
//     required this.emoji,
//   });

//   factory RelationshipGoal.fromJson(Map<String, dynamic> json) {
//     return RelationshipGoal(
//       id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       name: json['name']?.toString() ?? '',
//       emoji: json['emoji']?.toString() ?? '',
//     );
//   }

//   RelationshipGoal copyWith({int? id, String? name, String? emoji}) {
//     return RelationshipGoal(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       emoji: emoji ?? this.emoji,
//     );
//   }
// }

class ApiResponse {
  final String status;
  final int statusCode;
  final String statusDesc;
  final List<GoalProfile> data;

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.statusDesc,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      statusCode: json['statusCode'],
      statusDesc: json['statusDesc'],
      data: (json['data'] as List)
          .map((e) => GoalProfile.fromJson(e))
          .toList(),
    );
  }
}

class GoalProfile {
  final int goalId;
  final String goalTitle;
  final String goalEmoji;
  final List<Profile> profiles;

  GoalProfile({
    required this.goalId,
    required this.goalTitle,
    required this.goalEmoji,
    required this.profiles,
  });

  factory GoalProfile.fromJson(Map<String, dynamic> json) {
    return GoalProfile(
      goalId: json['goalId'],
      goalTitle: json['goalTitle'],
      goalEmoji: json['goalEmoji'],
      profiles: (json['profiles'] as List)
          .map((e) => Profile.fromJson(e))
          .toList(),
    );
  }

  GoalProfile copyWith({
    int? goalId,
    String? goalTitle,
    String? goalEmoji,
    List<Profile>? profiles,
  }) {
    return GoalProfile(
      goalId: goalId ?? this.goalId,
      goalTitle: goalTitle ?? this.goalTitle,
      goalEmoji: goalEmoji ?? this.goalEmoji,
      profiles: profiles ?? this.profiles,
    );
  }
}

class Profile {
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
  final String? city;
  final String? state;
  final String? country;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? bio;
  final String? voiceUrl;
  final String? interestedGender;
  final String? interestedGenderId;
  final String photo;
  final List<Photo> photos;
  final List<Photo> privatePhotos;
  final int privatePhotoCount;
  final bool isBoosted;
  final String? lastSeen;
  final bool isLive;
  final double? distance; // Added field
  final int? interestMatch; // Added field
  final String? uID;





  Profile({
    this.uID,
    this.interestedGender,
    this.interestedGenderId,
    this.voiceUrl,
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
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.address,
    this.bio,
    required this.photo,
    required this.photos,
    required this.privatePhotos,
    required this.privatePhotoCount,
    required this.isBoosted,
    this.lastSeen,
    required this.isLive,
     this.distance, // Added in constructor
     this.interestMatch, // Added in constructor
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      uID: json['uid'],
      interestedGender: json['interested_gender'],
      interestedGenderId: json['interested_gender_id'],
      voiceUrl: json['voice_url'],
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
      city: json['city'],
      state: json['state'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      bio: json['bio'],
      photo: json['mainPhoto'] ?? '',
      photos: (json['photos'] as List)
          .map((e) => Photo.fromJson(e))
          .toList(),
      privatePhotos: (json['privatePhotos'] as List)
          .map((e) => Photo.fromJson(e))
          .toList(),
      privatePhotoCount: json['privatePhotoCount'] ?? 0,
      isBoosted: json['isBoosted'] ?? false,
      lastSeen: json['last_seen'] ?? json['lastSeen'],
      isLive: json['is_live'] == "1" || json['is_live'] == true || json['isLive'] == "1" || json['isLive'] == true,
      distance: json['distance'] != null
          ? (json['distance'] is double
              ? json['distance']
              : json['distance'] is int
                  ? json['distance'].toDouble()
                  : double.tryParse(json['distance'].toString()) ?? 0.0)
          : 0.0, // Parse distance with type safety
      interestMatch: json['interestMatch'] != null
          ? (json['interestMatch'] is int
              ? json['interestMatch']
              : int.tryParse(json['interestMatch'].toString()) ?? 0)
          : 0, // Parse interestMatch with type safety
    );
  }

  Profile copyWith({
    String ? uID,
    String? interestedGender,
    String? interestedGenderId,
    String? voiceUrl,
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
    String? city,
    String? state,
    String? country,
    String? latitude,
    String? longitude,
    String? address,
    String? bio,
    String? photo,
    List<Photo>? photos,
    List<Photo>? privatePhotos,
    int? privatePhotoCount,
    bool? isBoosted,
    String? lastSeen,
    bool? isLive,
    double? distance, // Added to copyWith
    int? interestMatch, // Added to copyWith
  }) {
    return Profile(
      uID: uID??this.uID,
      interestedGender: interestedGender ?? this.interestedGender,
      interestedGenderId: interestedGenderId ?? this.interestedGenderId,
      voiceUrl: voiceUrl ?? this.voiceUrl,
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
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      photo: photo ?? this.photo,
      photos: photos ?? this.photos,
      privatePhotos: privatePhotos ?? this.privatePhotos,
      privatePhotoCount: privatePhotoCount ?? this.privatePhotoCount,
      isBoosted: isBoosted ?? this.isBoosted,
      lastSeen: lastSeen ?? this.lastSeen,
      isLive: isLive ?? this.isLive,
      distance: distance ?? this.distance, // Added
      interestMatch: interestMatch ?? this.interestMatch, // Added
    );
  }

  factory Profile.empty() {
    return Profile(
      uID: null,
      interestedGender: null,
      interestedGenderId: null,
      voiceUrl: null,
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
      city: null,
      state: null,
      country: null,
      latitude: null,
      longitude: null,
      address: null,
      bio: null,
      photo: '',
      photos: [],
      privatePhotos: [],
      privatePhotoCount: 0,
      isBoosted: false,
      lastSeen: null,
      isLive: false,
      distance: 0.0, // Added with default value
      interestMatch: 0, // Added with default value
    );
  }
}

/// =======================
/// LOCATION (Kept for backward compatibility)
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
      id: json['id']?.toString() ?? '',
      photoUrl: (json['photo_url'] ?? json['photoUrl'] ?? json['path']),
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
    return Gender(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
    );
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
    return Education(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
    );
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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      emoji: json['emoji']?.toString() ?? '',
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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      emoji: json['emoji']?.toString() ?? '',
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