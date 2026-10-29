import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.organizerId,
    required this.city,
    required this.locationName,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
    this.teamId,
    this.participantLimit,
  });

  final String id;
  final String title;
  final String description;
  final String type;
  final String organizerId;
  final String? teamId;
  final String city;
  final String locationName;
  final DateTime startAt;
  final DateTime endAt;
  final int? participantLimit;
  final String status;
  final String visibility;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const supportedTypes = <String>['training', 'openPlay'];
  static const supportedStatuses = <String>['active', 'cancelled'];
  static const supportedVisibilities = <String>['public', 'private'];

  bool get isPublicAndActive =>
      visibility == 'public' &&
      status == 'active' &&
      supportedTypes.contains(type);

  bool get isUpcoming =>
      status == 'active' && startAt.isAfter(DateTime.now().toUtc());

  bool get hasParticipantLimit =>
      participantLimit != null && participantLimit! > 0;

  factory Activity.empty({required String id}) {
    final now = DateTime.now().toUtc();
    return Activity(
      id: id,
      title: '',
      description: '',
      type: 'training',
      organizerId: '',
      city: '',
      locationName: '',
      startAt: now.add(const Duration(hours: 1)),
      endAt: now.add(const Duration(hours: 2)),
      status: 'active',
      visibility: 'public',
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json, String id) {
    return Activity(
      id: id,
      title: (json['title'] as String?)?.trim() ?? '',
      description: (json['description'] as String?)?.trim() ?? '',
      type: (json['type'] as String?)?.trim().toLowerCase() ?? 'training',
      organizerId: (json['organizerId'] as String?)?.trim() ?? '',
      teamId: json['teamId'] as String?,
      city: (json['city'] as String?)?.trim() ?? '',
      locationName: (json['locationName'] as String?)?.trim() ?? '',
      startAt: _dateTimeFromValue(json['startAt']),
      endAt: _dateTimeFromValue(json['endAt']),
      participantLimit: json['participantLimit'] is int
          ? json['participantLimit'] as int
          : null,
      status: (json['status'] as String?)?.trim().toLowerCase() ?? 'active',
      visibility:
          (json['visibility'] as String?)?.trim().toLowerCase() ?? 'public',
      createdAt: _dateTimeFromValue(json['createdAt']),
      updatedAt: _dateTimeFromValue(json['updatedAt']),
    );
  }

  static DateTime _dateTimeFromValue(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toUtc();
    }
    if (value is DateTime) {
      return value.toUtc();
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'organizerId': organizerId,
      'teamId': teamId,
      'city': city,
      'locationName': locationName,
      'startAt': Timestamp.fromDate(startAt.toUtc()),
      'endAt': Timestamp.fromDate(endAt.toUtc()),
      'participantLimit': participantLimit,
      'status': status,
      'visibility': visibility,
      'createdAt': Timestamp.fromDate(createdAt.toUtc()),
      'updatedAt': Timestamp.fromDate(updatedAt.toUtc()),
    };
  }

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? organizerId,
    String? teamId,
    String? city,
    String? locationName,
    DateTime? startAt,
    DateTime? endAt,
    int? participantLimit,
    String? status,
    String? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      organizerId: organizerId ?? this.organizerId,
      teamId: teamId ?? this.teamId,
      city: city ?? this.city,
      locationName: locationName ?? this.locationName,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      participantLimit: participantLimit ?? this.participantLimit,
      status: status ?? this.status,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  void validate() {
    final trimmedTitle = title.trim();
    final trimmedDescription = description.trim();
    final trimmedCity = city.trim();
    final trimmedLocation = locationName.trim();
    final trimmedOrganizerId = organizerId.trim();

    if (trimmedTitle.isEmpty || trimmedTitle.length < 2) {
      throw ArgumentError('Activity title is required.');
    }
    if (trimmedTitle.length > 120) {
      throw ArgumentError('Activity title is too long.');
    }
    if (trimmedDescription.length > 2000) {
      throw ArgumentError('Description is too long.');
    }
    if (!supportedTypes.contains(type)) {
      throw ArgumentError('Unsupported activity type.');
    }
    if (trimmedOrganizerId.isEmpty) {
      throw ArgumentError('Organizer is required.');
    }
    if (trimmedCity.isEmpty || trimmedCity.length > 80) {
      throw ArgumentError('A valid city is required.');
    }
    if (trimmedLocation.isEmpty || trimmedLocation.length > 120) {
      throw ArgumentError('A valid meeting location is required.');
    }
    if (!supportedStatuses.contains(status)) {
      throw ArgumentError('Unsupported activity status.');
    }
    if (!supportedVisibilities.contains(visibility)) {
      throw ArgumentError('Unsupported activity visibility.');
    }
    if (participantLimit != null && participantLimit! <= 0) {
      throw ArgumentError('Participant limit must be greater than zero.');
    }
    if (startAt.isAtSameMomentAs(endAt) || endAt.isBefore(startAt)) {
      throw ArgumentError('End time must be after the start time.');
    }
  }
}

class ActivityRegistration {
  const ActivityRegistration({
    required this.activityId,
    required this.userId,
    required this.status,
    required this.registeredAt,
  });

  final String activityId;
  final String userId;
  final String status;
  final DateTime registeredAt;

  factory ActivityRegistration.fromJson(
    Map<String, dynamic> json,
    String activityId,
    String userId,
  ) {
    return ActivityRegistration(
      activityId: activityId,
      userId: userId,
      status: (json['status'] as String?)?.trim().toLowerCase() ?? 'registered',
      registeredAt: Activity._dateTimeFromValue(json['registeredAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'activityId': activityId,
      'status': status,
      'registeredAt': Timestamp.fromDate(registeredAt.toUtc()),
    };
  }
}
