class UserProfile {
  final String uid;
  final String username;
  final DateTime lastActive;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.uid,
    required this.username,
    DateTime? lastActive,
    Map<String, dynamic>? preferences,
  })  : lastActive = lastActive ?? DateTime.now().toUtc(),
        preferences = preferences ?? {};

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'lastActive': lastActive.toIso8601String(),
    'preferences': preferences,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    uid: json['uid'] as String,
    username: json['username'] as String,
    lastActive: DateTime.parse(json['lastActive'] as String),
    preferences: json['preferences'] as Map<String, dynamic>? ?? {},
  );

  UserProfile copyWith({
    String? username,
    DateTime? lastActive,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      uid: uid,
      username: username ?? this.username,
      lastActive: lastActive ?? this.lastActive,
      preferences: preferences ?? Map<String, dynamic>.from(this.preferences),
    );
  }
}