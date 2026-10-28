import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/team.dart';

class TeamRepository {
  TeamRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _teamsRef =>
      _firestore.collection('teams');

  Stream<List<Team>> watchMyTeams(String ownerUid) {
    if (Firebase.apps.isEmpty || ownerUid.trim().isEmpty) {
      return const Stream<List<Team>>.empty();
    }

    return _teamsRef.where('createdBy', isEqualTo: ownerUid).snapshots().map((
      snapshot,
    ) {
      final teams = snapshot.docs
          .map((doc) => Team.fromJson({...doc.data(), 'id': doc.id}, doc.id))
          .toList();

      teams.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return teams;
    });
  }

  Future<List<Team>> fetchMyTeams(String ownerUid) async {
    if (Firebase.apps.isEmpty || ownerUid.trim().isEmpty) {
      return const <Team>[];
    }

    final snapshot = await _teamsRef
        .where('createdBy', isEqualTo: ownerUid)
        .get();

    final teams = snapshot.docs
        .map((doc) => Team.fromJson({...doc.data(), 'id': doc.id}, doc.id))
        .toList();

    teams.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return teams;
  }

  Stream<List<Team>> watchPublicTeams({
    String? city,
    String? countryCode,
    String query = '',
  }) {
    if (Firebase.apps.isEmpty) {
      return const Stream<List<Team>>.empty();
    }

    Query<Map<String, dynamic>> baseQuery = _teamsRef
        .where('visibility', isEqualTo: 'public')
        .where('status', isEqualTo: 'active');

    if (city != null && city.trim().isNotEmpty) {
      baseQuery = baseQuery.where('city', isEqualTo: city.trim());
    }

    if (countryCode != null && countryCode.trim().isNotEmpty) {
      baseQuery = baseQuery.where(
        'countryCode',
        isEqualTo: countryCode.trim().toUpperCase(),
      );
    }

    final trimmedQuery = query.trim();

    return baseQuery.snapshots().map((snapshot) {
      final teams = snapshot.docs
          .map((doc) => Team.fromJson({...doc.data(), 'id': doc.id}, doc.id))
          .where((team) => team.isPublicAndActive)
          .where((team) {
            if (trimmedQuery.isEmpty) {
              return true;
            }
            final haystack = '${team.name} ${team.city} ${team.countryCode}'
                .toLowerCase();
            return haystack.contains(trimmedQuery.toLowerCase());
          })
          .toList();

      teams.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return teams;
    });
  }

  Future<List<Team>> fetchPublicTeams({
    String? city,
    String? countryCode,
    String query = '',
  }) async {
    if (Firebase.apps.isEmpty) {
      return const <Team>[];
    }

    Query<Map<String, dynamic>> baseQuery = _teamsRef
        .where('visibility', isEqualTo: 'public')
        .where('status', isEqualTo: 'active');

    if (city != null && city.trim().isNotEmpty) {
      baseQuery = baseQuery.where('city', isEqualTo: city.trim());
    }

    if (countryCode != null && countryCode.trim().isNotEmpty) {
      baseQuery = baseQuery.where(
        'countryCode',
        isEqualTo: countryCode.trim().toUpperCase(),
      );
    }

    final snapshot = await baseQuery.get();
    final trimmedQuery = query.trim();

    final teams = snapshot.docs
        .map((doc) => Team.fromJson({...doc.data(), 'id': doc.id}, doc.id))
        .where((team) => team.isPublicAndActive)
        .where((team) {
          if (trimmedQuery.isEmpty) {
            return true;
          }
          final haystack = '${team.name} ${team.city} ${team.countryCode}'
              .toLowerCase();
          return haystack.contains(trimmedQuery.toLowerCase());
        })
        .toList();

    teams.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return teams;
  }

  Future<Team> createTeam({
    required String ownerUid,
    required Team team,
  }) async {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final normalizedOwnerUid = ownerUid.trim();
    final projectId = Firebase.app().options.projectId;

    final validatedTeam = team.copyWith(
      createdBy: normalizedOwnerUid,
      status: 'active',
      visibility: team.visibility.trim().toLowerCase(),
      organizationType: team.organizationType.trim().toLowerCase(),
      countryCode: team.countryCode.trim().toUpperCase(),
      city: team.city.trim(),
      description: team.description.trim(),
      name: team.name.trim(),
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    validatedTeam.validate();

    final docRef = _teamsRef.doc();
    final payload = <String, dynamic>{
      'name': validatedTeam.name,
      'description': validatedTeam.description,
      'city': validatedTeam.city,
      'countryCode': validatedTeam.countryCode,
      'organizationType': validatedTeam.organizationType,
      'visibility': validatedTeam.visibility,
      'recruitingEnabled': validatedTeam.recruitingEnabled,
      'status': validatedTeam.status,
      'createdBy': normalizedOwnerUid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    debugPrint(
      'Attempting team creation: project=$projectId userUid=$normalizedOwnerUid payloadKeys=${payload.keys.toList()}',
    );

    try {
      await docRef.set(payload);
    } on FirebaseException catch (error) {
      debugPrint(
        'Team creation failed: code=${error.code}; message=${error.message}; '
        'project=$projectId; userUid=$normalizedOwnerUid',
      );
      rethrow;
    } catch (error, stackTrace) {
      debugPrint(
        'Team creation failed unexpectedly: $error; '
        'project=$projectId; userUid=$normalizedOwnerUid',
      );
      Error.throwWithStackTrace(error, stackTrace);
    }

    return validatedTeam.copyWith(
      id: docRef.id,
      createdBy: normalizedOwnerUid,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  Future<Team?> fetchOwnedTeam({
    required String teamId,
    required String ownerUid,
  }) async {
    if (Firebase.apps.isEmpty || ownerUid.trim().isEmpty) {
      return null;
    }

    final snapshot = await _teamsRef.doc(teamId).get();
    if (!snapshot.exists) {
      return null;
    }

    final team = Team.fromJson({
      ...snapshot.data() ?? {},
      'id': snapshot.id,
    }, snapshot.id);

    if (team.createdBy != ownerUid.trim()) {
      return null;
    }

    return team;
  }

  Future<Team> updateTeam({
    required String ownerUid,
    required String teamId,
    required Team team,
  }) async {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final currentTeam = await fetchOwnedTeam(
      teamId: teamId,
      ownerUid: ownerUid,
    );
    if (currentTeam == null) {
      throw StateError('You can only edit your own teams.');
    }

    final validatedTeam = team.copyWith(
      createdBy: currentTeam.createdBy,
      createdAt: currentTeam.createdAt,
      updatedAt: DateTime.now().toUtc(),
      visibility: team.visibility.trim().toLowerCase(),
      organizationType: team.organizationType.trim().toLowerCase(),
      countryCode: team.countryCode.trim().toUpperCase(),
      city: team.city.trim(),
      description: team.description.trim(),
      name: team.name.trim(),
    );
    validatedTeam.validate();

    final payload = <String, dynamic>{
      'name': validatedTeam.name,
      'description': validatedTeam.description,
      'city': validatedTeam.city,
      'countryCode': validatedTeam.countryCode,
      'organizationType': validatedTeam.organizationType,
      'visibility': validatedTeam.visibility,
      'recruitingEnabled': validatedTeam.recruitingEnabled,
      'status': validatedTeam.status,
      'createdBy': currentTeam.createdBy,
      'createdAt': Timestamp.fromDate(currentTeam.createdAt.toUtc()),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _teamsRef.doc(teamId).update(payload);

    return validatedTeam.copyWith(
      id: teamId,
      createdBy: currentTeam.createdBy,
      createdAt: currentTeam.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  Future<void> deleteTeam({
    required String ownerUid,
    required String teamId,
  }) async {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final team = await fetchOwnedTeam(teamId: teamId, ownerUid: ownerUid);
    if (team == null) {
      throw StateError('You can only delete your own teams.');
    }

    await _teamsRef.doc(teamId).delete();
  }

  Future<Team?> fetchTeam(String teamId) async {
    if (Firebase.apps.isEmpty) {
      return null;
    }

    final snapshot = await _teamsRef.doc(teamId).get();
    if (!snapshot.exists) {
      return null;
    }

    final team = Team.fromJson({
      ...snapshot.data() ?? {},
      'id': snapshot.id,
    }, snapshot.id);
    return team.isPublicAndActive ? team : null;
  }
}

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository();
});
