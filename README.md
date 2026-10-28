# Baseball5 Community App

This is the initial Flutter app foundation for the Baseball5 Community project.

## Current project setup
- Flutter SDK: 3.47.8
- Dart SDK: 3.13.7
- App architecture: feature-first structure with app configuration, routing, theme, and screens separated by responsibility
- Navigation: `go_router`
- State management: `flutter_riverpod`
- Localization: Flutter `gen_l10n` with `de` and `en` ARB files
- Firebase: initialized with the generated `lib/firebase_options.dart` for the project `b5-community`

## Firebase setup steps

The Firebase project is already configured for this local workspace via FlutterFire and the generated Firebase config files.

Required commands on a fresh environment:

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
flutter pub get
flutterfire configure --project=b5-community --platforms=android,ios,web
flutter run
```

If the Firebase CLI is not authenticated yet:

```bash
firebase login
```

## Run locally

```bash
flutter pub get
flutter gen-l10n
flutter run
```

## Run tests

```bash
flutter test
```

## Typical validation commands

```bash
dart format lib test
flutter analyze
flutter test
```

## Notes
This step includes Firebase app initialization and default-deny Firestore/Storage rules, but does not add user data, authentication flows, or deployment actions.
