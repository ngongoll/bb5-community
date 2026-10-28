import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  const Team({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.countryCode,
    required this.organizationType,
    required this.visibility,
    required this.recruitingEnabled,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String city;
  final String countryCode;
  final String organizationType;
  final String visibility;
  final bool recruitingEnabled;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const maxNameLength = 80;
  static const maxDescriptionLength = 1000;
  static const maxCityLength = 80;
  static const supportedOrganizationTypes = <String>['team', 'club'];
  static const supportedVisibilities = <String>['public', 'private'];
  static const supportedStatuses = <String>['active', 'inactive', 'archived'];

  bool get isPublicAndActive =>
      visibility == 'public' && status == 'active' && organizationType != '';

  factory Team.empty({required String id}) {
    final now = DateTime.now().toUtc();

    return Team(
      id: id,
      name: '',
      description: '',
      city: '',
      countryCode: '',
      organizationType: 'team',
      visibility: 'public',
      recruitingEnabled: false,
      status: 'active',
      createdBy: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Team.fromJson(Map<String, dynamic> json, String id) {
    final createdAtValue = json['createdAt'];
    final updatedAtValue = json['updatedAt'];

    return Team(
      id: id,
      name: (json['name'] as String?)?.trim() ?? '',
      description: (json['description'] as String?)?.trim() ?? '',
      city: (json['city'] as String?)?.trim() ?? '',
      countryCode: (json['countryCode'] as String?)?.trim().toUpperCase() ?? '',
      organizationType:
          (json['organizationType'] as String?)?.trim().toLowerCase() ?? 'team',
      visibility:
          (json['visibility'] as String?)?.trim().toLowerCase() ?? 'private',
      recruitingEnabled: json['recruitingEnabled'] as bool? ?? false,
      status: (json['status'] as String?)?.trim().toLowerCase() ?? 'inactive',
      createdBy: (json['createdBy'] as String?)?.trim() ?? '',
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
      'name': name,
      'description': description,
      'city': city,
      'countryCode': countryCode,
      'organizationType': organizationType,
      'visibility': visibility,
      'recruitingEnabled': recruitingEnabled,
      'status': status,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Team copyWith({
    String? id,
    String? name,
    String? description,
    String? city,
    String? countryCode,
    String? organizationType,
    String? visibility,
    bool? recruitingEnabled,
    String? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      city: city ?? this.city,
      countryCode: countryCode ?? this.countryCode,
      organizationType: organizationType ?? this.organizationType,
      visibility: visibility ?? this.visibility,
      recruitingEnabled: recruitingEnabled ?? this.recruitingEnabled,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
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
    final trimmedName = name.trim();
    final trimmedDescription = description.trim();
    final trimmedCity = city.trim();
    final trimmedCountryCode = countryCode.trim();

    if (trimmedName.isEmpty || trimmedName.length < 2) {
      throw ArgumentError(
        'Team name is required and must be at least 2 characters.',
      );
    }
    if (trimmedName.length > maxNameLength) {
      throw ArgumentError('Team name is too long.');
    }
    if (trimmedDescription.length > maxDescriptionLength) {
      throw ArgumentError('Team description is too long.');
    }
    if (trimmedCity.isNotEmpty && trimmedCity.length > maxCityLength) {
      throw ArgumentError('City is too long.');
    }
    if (trimmedCountryCode.isEmpty) {
      throw ArgumentError('Country code is required.');
    }
    if (trimmedCountryCode.length != 2) {
      throw ArgumentError('Country code must be a valid ISO code.');
    }
    if (!supportedOrganizationTypes.contains(organizationType)) {
      throw ArgumentError('Organization type is not supported.');
    }
    if (!supportedVisibilities.contains(visibility)) {
      throw ArgumentError('Visibility is not supported.');
    }
    if (!supportedStatuses.contains(status)) {
      throw ArgumentError('Status is not supported.');
    }
    if (createdBy.trim().isEmpty) {
      throw ArgumentError('Created by is required.');
    }
  }
}
