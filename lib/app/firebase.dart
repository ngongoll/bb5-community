import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

Future<FirebaseApp?> initializeFirebase() async {
  final platform = defaultTargetPlatform;
  final useEmulator = const bool.fromEnvironment(
    'USE_FIREBASE_EMULATOR',
    defaultValue: false,
  );

  try {
    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kDebugMode && !kIsWeb && useEmulator) {
      try {
        FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8088);
        debugPrint(
          'Using Firestore emulator at 127.0.0.1:8088 for project=${app.options.projectId}',
        );
      } on FirebaseException catch (error) {
        debugPrint(
          'Firestore emulator connection not available: '
          '${error.code} ${error.message ?? ""}',
        );
      }
    } else if (kDebugMode && !kIsWeb) {
      debugPrint(
        'Using production Firestore project=${app.options.projectId}; '
        'set USE_FIREBASE_EMULATOR=true to target the local emulator.',
      );
    }

    debugPrint(
      'Firebase initialized for platform=$platform project=${app.options.projectId}',
    );
    return app;
  } on UnsupportedError catch (error) {
    if (platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux) {
      debugPrint(
        'Desktop Firebase fallback using generated desktop options: $error',
      );
      return Firebase.initializeApp(options: DefaultFirebaseOptions.macos);
    }

    debugPrint('Firebase initialization failed: $error');
    rethrow;
  } on FirebaseException catch (error) {
    debugPrint('Firebase initialization failed: $error');
    rethrow;
  }
}
