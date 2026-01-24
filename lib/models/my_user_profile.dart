// import 'dart:convert';

// import 'package:dating/models/profile_model.dart';

// class MyUserProfile {
//   final int userId;
//   final String userName;
//   final String phno;
//   final String dateOfBirth;
//   final String height;
//   final String smokingHabit;
//   final String drinkingHabit;
//   final String job;
//   final Gender gender;
//   final Education education;
//   final List<Interest> interests;
//   final String city;
//   final String state;
//   final String country;
//   final String bio;
//   final List<String> photos;
//   final String photo;
//   final int age;

//   MyUserProfile({
//     required this.userId,
//     required this.userName,
//     required this.phno,
//     required this.dateOfBirth,
//     required this.height,
//     required this.smokingHabit,
//     required this.drinkingHabit,
//     required this.job,
//     required this.gender,
//     required this.education,
//     required this.interests,
//     required this.city,
//     required this.state,
//     required this.country,
//     required this.bio,
//     required this.photos,
//     required this.photo,
//     required this.age,
//   });

//   factory MyUserProfile.fromJson(Map<String, dynamic> json) {
//     // Calculate age from dateOfBirth
//     final dob = DateTime.parse(json['dateOfBirth']);
//     final now = DateTime.now();
//     final age = now.year - dob.year;
    
//     // Parse photos array
//     final photosList = json['photos'] is String 
//         ? List<String>.from(jsonDecode(json['photos']))
//         : List<String>.from(json['photos'] ?? []);
    
//     return MyUserProfile(
//       userId: json['userId'],
//       userName: json['userName'],
//       phno: json['phno'],
//       dateOfBirth: json['dateOfBirth'],
//       height: json['height'],
//       smokingHabit: json['smokingHabit'],
//       drinkingHabit: json['drinkingHabit'],
//       job: json['job'],
//       gender: Gender.fromJson(json['gender']),
//       education: Education.fromJson(json['education']),
//       interests: List<Interest>.from(
//         json['interests'].map((x) => Interest.fromJson(x))
//       ),
//       city: json['city'],
//       state: json['state'],
//       country: json['country'],
//       bio: json['bio'],
//       photos: photosList,
//       photo: json['photo'],
//       age: age,
//     );
//   }
// }

