import 'package:b5_community/features/auth/domain/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile', () {
    test('creates a valid profile from required fields', () {
      final profile = UserProfile(
        uid: 'abc123',
        displayName: 'Alex',
        email: 'alex@example.com',
        countryCode: 'DE',
        city: 'Berlin',
        preferredLanguage: 'de',
        experienceLevel: 'beginner',
        bio: 'Loves training nights.',
        createdAt: DateTime.utc(2025, 1, 1),
        updatedAt: DateTime.utc(2025, 1, 2),
      );

      expect(profile.uid, 'abc123');
      expect(profile.isValid, isTrue);
    });

    test('rejects invalid profile values', () {
      expect(
        () => UserProfile(
          uid: 'abc123',
          displayName: '',
          email: 'alex@example.com',
          countryCode: 'USA',
          city: 'Berlin',
          preferredLanguage: 'fr',
          experienceLevel: 'unknown',
          bio: 'Loves training nights.',
          createdAt: DateTime.utc(2025, 1, 1),
          updatedAt: DateTime.utc(2025, 1, 2),
        ).validate(),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
