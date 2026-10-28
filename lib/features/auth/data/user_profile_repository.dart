import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../domain/user_profile.dart';

class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  Stream<UserProfile?> watchProfile(String uid) {
    if (Firebase.apps.isEmpty) {
      return const Stream<UserProfile?>.empty();
    }

    return _usersRef.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return UserProfile.fromJson({
        ...snapshot.data() ?? {},
        'uid': snapshot.id,
      });
    });
  }

  Future<UserProfile?> fetchProfile(String uid) async {
    if (Firebase.apps.isEmpty) {
      return null;
    }

    final snapshot = await _usersRef.doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }

    return UserProfile.fromJson({...snapshot.data() ?? {}, 'uid': snapshot.id});
  }

  Future<void> saveProfile(UserProfile profile) async {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    profile.validate();

    await _usersRef
        .doc(profile.uid)
        .set(profile.toJson(), SetOptions(merge: true));
  }

  Future<void> updateProfile(UserProfile profile) async {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final nextProfile = profile.copyWith(updatedAt: DateTime.now().toUtc());
    nextProfile.validate();

    await _usersRef
        .doc(nextProfile.uid)
        .set(nextProfile.toJson(), SetOptions(merge: true));
  }
}
