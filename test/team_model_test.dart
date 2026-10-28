import 'package:b5_community/features/teams/domain/team.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Team', () {
    test('creates a valid public active team from Firestore data', () {
      final team = Team.fromJson({
        'name': 'Berlin Sluggers',
        'description': 'Community team for weekend training and open play.',
        'city': 'Berlin',
        'countryCode': 'DE',
        'organizationType': 'team',
        'visibility': 'public',
        'recruitingEnabled': true,
        'status': 'active',
        'createdBy': 'user-123',
        'createdAt': DateTime.utc(2025, 1, 1).millisecondsSinceEpoch,
        'updatedAt': DateTime.utc(2025, 1, 2).millisecondsSinceEpoch,
      }, 'team-123');

      expect(team.id, 'team-123');
      expect(team.name, 'Berlin Sluggers');
      expect(team.isPublicAndActive, isTrue);
      expect(team.isValid, isTrue);
    });

    test('rejects invalid team values', () {
      expect(
        () => Team.fromJson({
          'name': '',
          'description': '    ',
          'city': '',
          'countryCode': 'USA',
          'organizationType': 'invalid',
          'visibility': 'private',
          'recruitingEnabled': true,
          'status': 'inactive',
          'createdBy': '',
          'createdAt': DateTime.utc(2025, 1, 1).millisecondsSinceEpoch,
          'updatedAt': DateTime.utc(2025, 1, 2).millisecondsSinceEpoch,
        }, 'team-123').validate(),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
