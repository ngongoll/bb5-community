import 'package:b5_community/features/activities/domain/activity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('training activity validates required field values', () {
    final activity = Activity(
      id: 'activity-1',
      title: 'Morning training',
      description: 'Skill work and scrimmage.',
      type: 'training',
      organizerId: 'organizer-1',
      teamId: null,
      city: 'Berlin',
      locationName: 'Mitte Field',
      startAt: DateTime.utc(2030, 1, 10, 18, 0),
      endAt: DateTime.utc(2030, 1, 10, 19, 30),
      participantLimit: 12,
      status: 'active',
      visibility: 'public',
      createdAt: DateTime.utc(2029, 1, 1),
      updatedAt: DateTime.utc(2029, 1, 1),
    );

    expect(() => activity.validate(), returnsNormally);
    expect(activity.isUpcoming, isTrue);
  });

  test('activity rejects invalid time range and empty title', () {
    final activity = Activity(
      id: 'activity-2',
      title: '',
      description: 'Nope',
      type: 'openPlay',
      organizerId: 'organizer-1',
      city: 'Hamburg',
      locationName: 'Harbor Park',
      startAt: DateTime.utc(2030, 1, 10, 19, 0),
      endAt: DateTime.utc(2030, 1, 10, 18, 0),
      status: 'active',
      visibility: 'public',
      createdAt: DateTime.utc(2029, 1, 1),
      updatedAt: DateTime.utc(2029, 1, 1),
    );

    expect(() => activity.validate(), throwsArgumentError);
  });
}
