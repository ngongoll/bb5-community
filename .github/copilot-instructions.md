# GitHub Copilot Instructions — Baseball5 Community App

This repository contains an international Baseball5 community app built with Flutter and Firebase. German (`de`) and English (`en`) are the initial locales. Registration is open to interested users.

## Always
- Read `AGENTS.md` and relevant feature documentation before making architectural changes.
- Keep code feature-first, typed, testable, and null-safe.
- Keep UI, business logic, and Firebase data access separated.
- Use the repository's existing state-management, routing, and package conventions. Do not introduce alternatives without explaining the trade-off.
- Localize all user-visible strings in German and English.
- Handle loading, empty, error, offline, and permission-denied states.
- Add tests for changed logic and access-control behavior.
- Update Firestore indexes and schema documentation when queries or data models change.
- Explain assumptions and list the files changed.

## Firebase safety
- Never trust client-provided role, owner, status, or capacity values.
- Never grant global admin roles from client-side code.
- Never loosen Firestore or Storage Security Rules as a workaround.
- Enforce authorization in Security Rules and trusted server code, not only in the UI.
- Use transactions or trusted server logic for capacity-limited registrations and other concurrency-sensitive updates.
- Do not store passwords, tokens, service-account keys, or secrets in source control.
- Never deploy Firebase resources without explicit authorization.

## Data model defaults
- Firebase Auth UID is the user profile document ID.
- Use separate documents for users, teams, team memberships, activities, registrations, reports, notifications, and device tokens where appropriate.
- Store media in Cloud Storage and metadata/path references in Firestore.
- Use server timestamps for authoritative timestamps.
- Keep team roles scoped to a team; distinguish them from global roles.
- Use pagination and bounded queries for growing collections.

## Before finishing
- Format changed Dart files.
- Run `flutter analyze` and relevant tests if available.
- Test Firestore/Storage Rules with the Firebase Emulator Suite when rules or protected data access change.
- Never claim a command passed unless it was run and its result was observed.
- Summarize what changed, tests run, outcomes, and remaining manual steps.

For task workflows and detailed conventions, see `.github/skills/baseball5-flutter-firebase/SKILL.md`.
