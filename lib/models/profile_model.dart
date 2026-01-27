import 'dart:convert';
import 'dart:developer';

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
  final String? latitude;
  final String? longitude;
  final String? state;
  final String? country;
  final String? address;
  final String? bio;
  final List<String> photos;
  final String? city;
  final String photo;

  Profile({
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
    this.latitude,
    this.longitude,
    this.state,
    this.country,
    this.address,
    this.bio,
    required this.photos,
    required this.city,
    required this.photo,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    // Photos
    List<String> photosList = [];
    if (json['photos'] != null) {
      try {
        if (json['photos'] is String) {
          final cleaned = json['photos'].replaceAll('\\', '');
          if (cleaned.startsWith('[')) {
            photosList =
                (jsonDecode(cleaned) as List).map((e) => e.toString()).toList();
          }
        } else if (json['photos'] is List) {
          photosList =
              (json['photos'] as List).map((e) => e.toString()).toList();
        }
      } catch (e) {
        log('Photo parse error: $e');
      }
    }

    return Profile(
      userId: json['userId'],
      userName: json['userName'],
      phno: json['phno'],
      countryCode: json['countryCode'],
      dateOfBirth: json['dateOfBirth'],
      height: json['height'],
      smokingHabit: json['smokingHabit'],
      drinkingHabit: json['drinkingHabit'],
      job: json['job'],
      gender: json['gender'] != null
          ? Gender.fromJson(json['gender'])
          : Gender(id: 0, name: ''),
      education: json['education'] != null
          ? Education.fromJson(json['education'])
          : Education(id: 0, name: ''),
      relationshipGoal: json['relationshipGoal'] != null
          ? RelationshipGoal.fromJson(json['relationshipGoal'])
          : null,
      interests: json['interests'] != null
          ? (json['interests'] as List)
              .map((e) => Interest.fromJson(e))
              .toList()
          : [],
      latitude: json['latitude'],
      longitude: json['longitude'],
      state: json['state'],
      country: json['country'],
      address: json['address'],
      bio: json['bio'],
      photos: photosList,
      city: json['city'],
      photo: json['photo'],
    );
  }

  Profile copyWith({
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
    String? latitude,
    String? longitude,
    String? state,
    String? country,
    String? address,
    String? bio,
    List<String>? photos,
    String? city,
    String? photo,
  }) {
    return Profile(
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      state: state ?? this.state,
      country: country ?? this.country,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      photos: photos ?? this.photos,
      city: city ?? this.city,
      photo: photo ?? this.photo,
    );
  }
  factory Profile.empty() {
  return Profile(
    userId: 0,
    userName: '',
    phno: null,
    countryCode: null,
    dateOfBirth: null,
    height: null,
    smokingHabit: null,
    drinkingHabit: null,
    job: null,
    gender: Gender(id: 0, name: ''),
    education: Education(id: 0, name: ''),
    relationshipGoal: null,
    interests: [],
    latitude: null,
    longitude: null,
    state: null,
    country: null,
    address: null,
    bio: null,
    photos: [],
    city: null,
    photo: '',
  );
}

}

class Gender {
  final int id;
  final String name;

  Gender({required this.id, required this.name});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(id: json['id'], name: json['name']);
  }

  Gender copyWith({int? id, String? name}) {
    return Gender(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class Education {
  final int id;
  final String name;

  Education({required this.id, required this.name});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(id: json['id'], name: json['name']);
  }


  Education copyWith({int? id, String? name}) {
    return Education(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class Interest {
  final int id;
  final String name;
  final String emoji;

  Interest({required this.id, required this.name, required this.emoji});

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

class ProfileResponse {
  final String status;
  final int statusCode;
  final String statusDesc;
  final List<GoalProfile> data;

  ProfileResponse({
    required this.status,
    required this.statusCode,
    required this.statusDesc,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'],
      statusCode: json['statusCode'],
      statusDesc: json['statusDesc'],
      data: (json['data'] as List)
          .map((e) => GoalProfile.fromJson(e))
          .toList(),
    );
  }

  ProfileResponse copyWith({
    String? status,
    int? statusCode,
    String? statusDesc,
    List<GoalProfile>? data,
  }) {
    return ProfileResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      statusDesc: statusDesc ?? this.statusDesc,
      data: data ?? this.data,
    );
  }
  
}
