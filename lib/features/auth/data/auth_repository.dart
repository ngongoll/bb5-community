import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../domain/user_profile.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Stream<User?> authStateChanges() {
    if (Firebase.apps.isEmpty) {
      return const Stream<User?>.empty();
    }

    return _firebaseAuth.authStateChanges();
  }

  User? get currentUser =>
      Firebase.apps.isEmpty ? null : _firebaseAuth.currentUser;

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    await _firebaseAuth.signOut();
  }

  Future<UserProfile?> createProfileFromAuth(
    User user,
    String preferredLanguage,
  ) async {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final profile = UserProfile(
      uid: user.uid,
      displayName: user.displayName ?? user.email?.split('@').first ?? 'Player',
      email: user.email ?? '',
      countryCode: null,
      city: null,
      preferredLanguage: preferredLanguage,
      experienceLevel: 'beginner',
      bio: null,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    final firestore = FirebaseFirestore.instance;
    final profileData = profile.toJson();
    await firestore.collection('users').doc(user.uid).set(profileData);

    return profile;
  }
}
