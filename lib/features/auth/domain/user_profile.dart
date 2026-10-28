import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.countryCode,
    this.city,
    this.preferredLanguage = 'en',
    this.experienceLevel = 'beginner',
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uid;
  final String displayName;
  final String email;
  final String? countryCode;
  final String? city;
  final String preferredLanguage;
  final String experienceLevel;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const supportedLanguages = <String>['en', 'de'];
  static const supportedExperienceLevels = <String>[
    'beginner',
    'intermediate',
    'advanced',
    'coach',
  ];

  factory UserProfile.empty({
    required String uid,
    required String email,
    String preferredLanguage = 'en',
  }) {
    final now = DateTime.now().toUtc();

    return UserProfile(
      uid: uid,
      displayName: '',
      email: email,
      countryCode: null,
      city: null,
      preferredLanguage: preferredLanguage,
      experienceLevel: 'beginner',
      bio: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['createdAt'];
    final updatedAtValue = json['updatedAt'];

    return UserProfile(
      uid: json['uid'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      countryCode: json['countryCode'] as String?,
      city: json['city'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      experienceLevel: json['experienceLevel'] as String? ?? 'beginner',
      bio: json['bio'] as String?,
      createdAt: createdAtValue is DateTime
          ? createdAtValue
          : (createdAtValue is Timestamp
                ? createdAtValue.toDate()
                : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)),
      updatedAt: updatedAtValue is DateTime
          ? updatedAtValue
          : (updatedAtValue is Timestamp
                ? updatedAtValue.toDate()
                : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'countryCode': countryCode,
      'city': city,
      'preferredLanguage': preferredLanguage,
      'experienceLevel': experienceLevel,
      'bio': bio,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? countryCode,
    String? city,
    String? preferredLanguage,
    String? experienceLevel,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      city: city ?? this.city,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isValid {
    try {
      validate();
      return true;
    } on ArgumentError {
      return false;
    }
  }

  void validate() {
    if (uid.trim().isEmpty) {
      throw ArgumentError('User uid is required.');
    }
    if (displayName.trim().isEmpty) {
      throw ArgumentError('Display name is required.');
    }
    if (displayName.trim().length < 2) {
      throw ArgumentError('Display name must have at least 2 characters.');
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      throw ArgumentError('Valid email address is required.');
    }
    if (countryCode != null &&
        (countryCode!.trim().isEmpty || countryCode!.length != 2)) {
      throw ArgumentError('Country code must be a valid ISO code.');
    }
    if (city != null && city!.trim().isEmpty) {
      throw ArgumentError('City cannot be empty when provided.');
    }
    if (!supportedLanguages.contains(preferredLanguage)) {
      throw ArgumentError('Preferred language is not supported.');
    }
    if (!supportedExperienceLevels.contains(experienceLevel)) {
      throw ArgumentError('Experience level is not supported.');
    }
    if (bio != null && bio!.trim().length > 300) {
      throw ArgumentError('Bio must not exceed 300 characters.');
    }
  }
}
