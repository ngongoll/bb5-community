import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user_profile.dart';
import 'auth_repository.dart';
import 'user_profile_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

final userProfileStreamProvider = StreamProvider.autoDispose<UserProfile?>((
  ref,
) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream<UserProfile?>.empty();
  }

  return ref.watch(userProfileRepositoryProvider).watchProfile(user.uid);
});
