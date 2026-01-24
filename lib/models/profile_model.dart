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
          .map((profile) => Profile.fromJson(profile))
          .toList(),
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
        this.relationshipGoal,

    this.countryCode,
    this.dateOfBirth,
    this.height,
    this.smokingHabit,
    this.drinkingHabit,
    this.job,
    required this.gender,
    required this.education,
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
    // Parse photos from JSON string
    List<String> photosList = [];
    if (json['photos'] != null) {
      try {
        if (json['photos'] is String) {
          // Remove backslashes and parse JSON array
          String photosString = json['photos'].replaceAll('\\', '');
          List<dynamic> parsed = (photosString.startsWith('[') && photosString.endsWith(']'))
              ? jsonDecode(photosString) as List<dynamic>
              : [];
          photosList = parsed.map((e) => e.toString()).toList();
        } else if (json['photos'] is List) {
          photosList = (json['photos'] as List).map((e) => e.toString()).toList();
        }
      } catch (e) {
        log('Error parsing photos: $e');
      }
    }

    // Parse gender
    Gender gender = Gender(id: 0, name: '');
    if (json['gender'] != null && json['gender'] is Map) {
      gender = Gender.fromJson(json['gender']);
    }

    // Parse education
    Education education = Education(id: 0, name: '');
    if (json['education'] != null && json['education'] is Map) {
      education = Education.fromJson(json['education']);
    }

    // Parse interests
    List<Interest> interestsList = [];
    if (json['interests'] != null && json['interests'] is List) {
      interestsList = (json['interests'] as List)
          .map((interest) => Interest.fromJson(interest))
          .toList();
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
      gender: gender,
      education: education,
      interests: interestsList,
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
}

class Gender {
  final int id;
  final String name;

  Gender({
    required this.id,
    required this.name,
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Education {
  final int id;
  final String name;

  Education({
    required this.id,
    required this.name,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      name: json['name'],
    );
  }
}

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
          .map((goal) => GoalProfile.fromJson(goal))
          .toList(),
    );
  }
}