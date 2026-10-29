import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/activity.dart';

class ActivityRepository {
  ActivityRepository({FirebaseFirestore? firestore})
    : _firestore =
          firestore ??
          (Firebase.apps.isEmpty ? null : FirebaseFirestore.instance);

  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> get _activitiesRef =>
      _firestore!.collection('activities');

  Query<Map<String, dynamic>> get _publicActiveActivitiesQuery => _activitiesRef
      .where('visibility', isEqualTo: 'public')
      .where('status', isEqualTo: 'active')
      .orderBy('startAt', descending: false);

  Future<List<Activity>> fetchPublicActivities() async {
    if (_firestore == null || Firebase.apps.isEmpty) {
      return const <Activity>[];
    }

    final snapshot = await _publicActiveActivitiesQuery.get();
    return snapshot.docs
        .map((doc) => Activity.fromJson({...doc.data(), 'id': doc.id}, doc.id))
        .where((activity) => activity.isUpcoming)
        .toList();
  }

  Stream<List<Activity>> watchPublicActivities() {
    if (_firestore == null || Firebase.apps.isEmpty) {
      return const Stream<List<Activity>>.empty();
    }

    return _publicActiveActivitiesQuery.snapshots().map((snapshot) {
      final activities = snapshot.docs
          .map(
            (doc) => Activity.fromJson({...doc.data(), 'id': doc.id}, doc.id),
          )
          .where((activity) => activity.isUpcoming)
          .toList();
      activities.sort((a, b) => a.startAt.compareTo(b.startAt));
      return activities;
    });
  }

  Stream<List<Activity>> watchMyActivities({required String userId}) {
    if (_firestore == null || Firebase.apps.isEmpty || userId.trim().isEmpty) {
      return const Stream<List<Activity>>.empty();
    }

    return _activitiesRef
        .where('organizerId', isEqualTo: userId)
        .orderBy('startAt', descending: false)
        .snapshots()
        .map((snapshot) {
          final activities = snapshot.docs
              .map(
                (doc) =>
                    Activity.fromJson({...doc.data(), 'id': doc.id}, doc.id),
              )
              .toList();
          activities.sort((a, b) => a.startAt.compareTo(b.startAt));
          return activities;
        });
  }

  Future<Activity?> fetchActivity(String activityId) async {
    if (_firestore == null || Firebase.apps.isEmpty) {
      return null;
    }

    final snapshot = await _activitiesRef.doc(activityId).get();
    if (!snapshot.exists) {
      return null;
    }

    final activity = Activity.fromJson({
      ...snapshot.data() ?? {},
      'id': snapshot.id,
    }, snapshot.id);
    return activity.isPublicAndActive ||
            activity.organizerId == FirebaseAuth.instance.currentUser?.uid
        ? activity
        : null;
  }

  Future<Activity> createActivity({
    required String organizerId,
    required Activity activity,
  }) async {
    if (_firestore == null || Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final validated = activity.copyWith(
      organizerId: organizerId.trim(),
      status: 'active',
      visibility: activity.visibility.trim().toLowerCase(),
      type: activity.type.trim().toLowerCase(),
      city: activity.city.trim(),
      locationName: activity.locationName.trim(),
      title: activity.title.trim(),
      description: activity.description.trim(),
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    validated.validate();

    final docRef = _activitiesRef.doc();
    final payload = validated.toJson();
    payload['createdAt'] = FieldValue.serverTimestamp();
    payload['updatedAt'] = FieldValue.serverTimestamp();

    debugPrint(
      'Creating activity: organizer=$organizerId type=${validated.type}',
    );

    try {
      await docRef.set(payload);
    } on FirebaseException catch (error) {
      debugPrint('Activity create failed: ${error.code} ${error.message}');
      rethrow;
    }

    return validated.copyWith(
      id: docRef.id,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  Future<Activity> updateActivity({
    required String organizerId,
    required String activityId,
    required Activity activity,
  }) async {
    if (_firestore == null || Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final current = await _activitiesRef.doc(activityId).get();
    if (!current.exists || current.data()?['organizerId'] != organizerId) {
      throw StateError('You can only edit your own activities.');
    }

    final validated = activity.copyWith(
      organizerId: organizerId,
      updatedAt: DateTime.now().toUtc(),
    );
    validated.validate();

    final payload = validated.toJson();
    payload['createdAt'] =
        current.data()?['createdAt'] ?? FieldValue.serverTimestamp();
    payload['updatedAt'] = FieldValue.serverTimestamp();

    await _activitiesRef.doc(activityId).update(payload);
    return validated.copyWith(id: activityId);
  }

  Future<void> deleteActivity({
    required String organizerId,
    required String activityId,
  }) async {
    if (_firestore == null || Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final current = await _activitiesRef.doc(activityId).get();
    if (!current.exists || current.data()?['organizerId'] != organizerId) {
      throw StateError('You can only delete your own activities.');
    }

    await _activitiesRef.doc(activityId).delete();
  }

  Future<bool> isUserRegistered({
    required String activityId,
    required String userId,
  }) async {
    if (_firestore == null || Firebase.apps.isEmpty || userId.trim().isEmpty) {
      return false;
    }

    final snapshot = await _activitiesRef
        .doc(activityId)
        .collection('registrations')
        .doc(userId)
        .get();
    return snapshot.exists;
  }

  Future<void> registerForActivity({
    required String activityId,
    required String userId,
  }) async {
    if (_firestore == null || Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final activityDoc = await _activitiesRef.doc(activityId).get();
    if (!activityDoc.exists) {
      throw StateError('Activity not found.');
    }

    final activity = Activity.fromJson({
      ...activityDoc.data() ?? {},
      'id': activityDoc.id,
    }, activityDoc.id);
    if (activity.status != 'active') {
      throw StateError('This activity is no longer available.');
    }
    if (activity.startAt.isBefore(DateTime.now().toUtc())) {
      throw StateError('Registration is closed for this activity.');
    }

    final registrations = await _activitiesRef
        .doc(activityId)
        .collection('registrations')
        .get();
    if (activity.participantLimit != null &&
        registrations.docs.length >= activity.participantLimit!) {
      throw StateError('This activity has reached its participant limit.');
    }

    await _activitiesRef
        .doc(activityId)
        .collection('registrations')
        .doc(userId)
        .set({
          'userId': userId,
          'status': 'registered',
          'registeredAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> cancelRegistration({
    required String activityId,
    required String userId,
  }) async {
    if (_firestore == null || Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final registrationRef = _activitiesRef
        .doc(activityId)
        .collection('registrations')
        .doc(userId);
    await registrationRef.delete();
  }
}

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository();
});
