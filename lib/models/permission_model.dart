import 'dart:math';

class UserPermissions {
  final DailyLimit dailyLikes;
  final DailyLimit viewProfilesPerDay;
  final bool unlimitedChat;
  final bool seeLikedMe;
  final bool boostProfile;
  final bool hideOnline;
  final DateTime lastUpdated;

  UserPermissions({
    required this.dailyLikes,
    required this.viewProfilesPerDay,
    required this.unlimitedChat,
    required this.seeLikedMe,
    required this.boostProfile,
    required this.hideOnline,
    required this.lastUpdated,
  });

  factory UserPermissions.fromJson(Map<String, dynamic> json) {
    return UserPermissions(
      dailyLikes: DailyLimit.fromJson(json['daily_likes'] ?? {'limit': 0, 'used': 0, 'left': 0}),
      viewProfilesPerDay: DailyLimit.fromJson(json['view_profiles_per_day'] ?? {'limit': 0, 'used': 0, 'left': 0}),
      unlimitedChat: json['unlimited_chat'] ?? false,
      seeLikedMe: json['see_liked_me'] ?? false,
      boostProfile: json['boost_profile'] ?? false,
      hideOnline: json['hide_online'] ?? false,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_likes': dailyLikes.toJson(),
      'view_profiles_per_day': viewProfilesPerDay.toJson(),
      'unlimited_chat': unlimitedChat,
      'see_liked_me': seeLikedMe,
      'boost_profile': boostProfile,
      'hide_online': hideOnline,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  // Helper methods
  bool get canLike => dailyLikes.left > 0 || dailyLikes.isUnlimited;
  bool get canViewProfiles => viewProfilesPerDay.left > 0 || viewProfilesPerDay.isUnlimited;
  bool get isPremium => unlimitedChat || seeLikedMe || boostProfile || hideOnline;

  // Optimistic update methods
  UserPermissions copyWithLikeUsed() {
    return UserPermissions(
      dailyLikes: dailyLikes.copyWithUsed(dailyLikes.used + 1),
      viewProfilesPerDay: viewProfilesPerDay,
      unlimitedChat: unlimitedChat,
      seeLikedMe: seeLikedMe,
      boostProfile: boostProfile,
      hideOnline: hideOnline,
      lastUpdated: DateTime.now(),
    );
  }

  UserPermissions copyWithViewUsed() {
    return UserPermissions(
      dailyLikes: dailyLikes,
      viewProfilesPerDay: viewProfilesPerDay.copyWithUsed(viewProfilesPerDay.used + 1),
      unlimitedChat: unlimitedChat,
      seeLikedMe: seeLikedMe,
      boostProfile: boostProfile,
      hideOnline: hideOnline,
      lastUpdated: DateTime.now(),
    );
  }
}

class DailyLimit {
  final dynamic rawLimit;
  final int used;
  final dynamic rawLeft;

  DailyLimit({
    required this.rawLimit,
    required this.used,
    required this.rawLeft,
  });

  factory DailyLimit.fromJson(Map<String, dynamic> json) {
    return DailyLimit(
      rawLimit: json['limit'] ?? 0,
      used: (json['used'] ?? 0).toInt(),
      rawLeft: json['left'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit': rawLimit,
      'used': used,
      'left': rawLeft,
    };
  }

  // Get limit as int (-1 for unlimited)
  int get limit {
    if (rawLimit == 'unlimited') return -1;
    if (rawLimit is int) return rawLimit as int;
    if (rawLimit is String) return int.tryParse(rawLimit) ?? 0;
    return 0;
  }

  // Get left as int (-1 for unlimited)
  int get left {
    if (rawLeft == 'unlimited') return -1;
    if (rawLeft is int) return rawLeft as int;
    if (rawLeft is String) return int.tryParse(rawLeft) ?? 0;
    return 0;
  }

  // Copy with new used value
  DailyLimit copyWithUsed(int newUsed) {
    int newLeft;
    if (limit == -1) {
      newLeft = -1;
    } else {
      newLeft = max(0, limit - newUsed);
    }
    
    return DailyLimit(
      rawLimit: rawLimit,
      used: newUsed,
      rawLeft: newLeft == -1 ? 'unlimited' : newLeft,
    );
  }

  String get displayText {
    if (limit == -1) return 'Unlimited';
    return '$left/$limit left today';
  }

  bool get isUnlimited => limit == -1;
}

// API Response Model
class PermissionResponse {
  final String status;
  final String? statusDesc;
  final int? statusCode;
  final UserPermissions? permissions;

  PermissionResponse({
    required this.status,
    this.statusDesc,
    this.statusCode,
    this.permissions,
  });

  factory PermissionResponse.fromJson(Map<String, dynamic> json) {
    return PermissionResponse(
      status: json['status'] ?? 'FAILED',
      statusDesc: json['statusDesc'],
      statusCode: json['statusCode'],
      permissions: json['permissions'] != null 
          ? UserPermissions.fromJson(json['permissions'])
          : null,
    );
  }

  bool get isSuccess => status == 'SUCCESS';
  bool get isFailed => status == 'FAILED';
}