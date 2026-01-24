class GlobalUserData {
  final String userId;
  final String userName;
  final String photoUrl;
  final String? phone;
  final String? email;
  final bool isLoggedIn;

  GlobalUserData({
    required this.userId,
    required this.userName,
    required this.photoUrl,
    this.phone,
    this.email,
    required this.isLoggedIn,
  });

  factory GlobalUserData.empty() {
    return GlobalUserData(
      userId: '',
      userName: '',
      photoUrl: '',
      isLoggedIn: false,
    );
  }

  factory GlobalUserData.fromJson(Map<String, dynamic> json) {
    return GlobalUserData(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      phone: json['phone'],
      email: json['email'],
    
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'photoUrl': photoUrl,
      'phone': phone,
      'email': email,
      'isLoggedIn': isLoggedIn,
    };
  }

  GlobalUserData copyWith({
    String? userId,
    String? userName,
    String? photoUrl,
    String? phone,
    String? email,
    DateTime? loginTime,
    bool? isLoggedIn,
  }) {
    return GlobalUserData(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  String toString() {
    return 'GlobalUserData(userId: $userId, userName: $userName, photoUrl: $photoUrl, isLoggedIn: $isLoggedIn)';
  }
}