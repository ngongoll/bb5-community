---
name: baseball5-flutter-firebase
description: Build, review, and test the Baseball5 Community App in Flutter with Firebase, including Firestore data models, role-based authorization, localization, activities, teams, registrations, and security rules.
---

# Baseball5 Flutter + Firebase Development Skill

## Purpose
Use this skill when implementing, reviewing, testing, or planning features for the Baseball5 Community App. The product is an international community app with open registration and German/English localization.

## 1. Start by inspecting the repository
Before editing:
1. Read `AGENTS.md` and `.github/copilot-instructions.md`.
2. Inspect `pubspec.yaml`, the `lib/` structure, localization setup, routing, state management, Firebase initialization, existing models/repositories, rules, indexes, and tests.
3. Identify existing patterns and reuse them.
4. State the scope, assumptions, files likely to change, and any security/schema impact.

Do not assume package versions, existing files, Firebase project IDs, or deployed resources. Never include secrets in examples.

## 2. Feature architecture
Use feature-first modules. A feature normally separates:
- `data/`: Firestore DTOs/models, data sources, repository implementations.
- `domain/`: entities, repository contracts, use cases only where they add clarity.
- `presentation/`: screens, widgets, view models/controllers and UI state.

Keep the architecture proportional. Do not create boilerplate layers that only forward calls without adding value. Firebase access belongs in repositories/data sources, not directly in widgets.

## 3. Core domain model
Use these conceptual entities unless the existing project has a documented, justified alternative:

### User profile — `users/{uid}`
- `displayName`
- `photoPath` (Storage path, not a large binary)
- `countryCode` (ISO code), `city` or region
- `languages` (spoken languages), `preferredLanguage` (UI locale)
- `experienceLevel` (validated enum)
- `bio`
- `visibility`
- `status`
- `createdAt`, `updatedAt`

Keep private account details separate from public profile fields. Firebase Auth is the source of identity; never store passwords in Firestore.

### Team — `teams/{teamId}`
- `name`, optional `slug`, `logoPath`, `description`
- `city`, `countryCode`
- `createdBy`
- `organizationType` (`team` or `club`)
- `visibility`, `recruitingEnabled`, `status`
- `createdAt`

### Team membership — `teams/{teamId}/members/{uid}`
- `userId`
- team-scoped `role` (`player`, `coach`, `teamManager`)
- `status` (`active`, `invited`, or other documented lifecycle states)
- `joinedAt`

Use a stable member document ID where practical. A user can have different roles in different teams.

### Team join requests — `teams/{teamId}/joinRequests/{requestId}`
Store applicant UID, status, timestamps, and any minimal application note needed. Only the applicant and authorized team managers should be able to access relevant records.

### Activity — `activities/{activityId}`
Use a validated `type` for `training`, `openPlay`, `match`, `tournament`, `workshop`, `camp`, or `community`. Include title, description, organizer UID, optional team ID, start/end timestamps, IANA time zone, location fields, optional capacity, registration mode, visibility, status, and timestamps.

Do not store a precise user's live location as a public field. Activity venue coordinates are a separate concept and should be handled with appropriate validation.

### Registration — `activities/{activityId}/registrations/{registrationId}`
Represent either an individual user or a team registration, with `registeredBy`, status, and timestamps. Define and enforce uniqueness rules to prevent duplicate active registrations. For limited capacity, use a transaction or trusted server-side workflow so concurrent sign-ups cannot overbook.

### Supporting collections
- `content/{contentId}`: rules, beginner guides, coach training plans, materials; support localized titles/body or language-specific documents.
- `reports/{reportId}`: reporter, target type/ID, reason, status, timestamps; restrict access to the reporter and authorized moderators as appropriate.
- `notifications/{notificationId}`: recipient, type, target reference, read status, creation time.
- `devices/{deviceId}` or an equivalent private per-user structure: FCM token and platform; tokens are private and refreshable.
- `follows/{followId}`: follower/followed relationship. Add only when follow functionality is in scope.
- `posts/{postId}`: later-phase feed content. Do not implement feed, comments, or DMs as part of MVP unless explicitly requested.

Firestore is a document database, not a relational database. Denormalize small, stable display fields only when justified by query needs, and document consistency/update implications.

## 4. Roles and authorization
Distinguish:
- Global roles: regular user, moderator, platform administrator.
- Team-scoped roles: player, coach, team manager.
- Event-scoped authorization: organizer/authorized event manager.

Never let a client assign itself a privileged role. Enforce authorization in Firestore/Storage Rules and trusted server code. UI visibility is not security.

For each new operation, document:
1. Who can read the record?
2. Who can create it?
3. Who can update or delete it?
4. Which fields may change?
5. How are cross-user/cross-team attacks denied?
6. What happens if the operation is retried or runs concurrently?

Default to least privilege. Do not write broad `allow read, write: if request.auth != null` rules as a shortcut.

## 5. Localization and time
- Use Flutter localization resources (for example ARB files) for all UI strings.
- Support `de` and `en` from the start.
- Keep UI locale separate from spoken-language profile preferences.
- Store authoritative times as Firestore timestamps; store the IANA timezone for the venue/event when useful.
- Display dates/times in a clearly defined local time zone.
- Use ISO country codes and validated enums.
- Define fallback behavior for untranslated editorial content.

## 6. Firebase implementation rules
- Use official FlutterFire packages compatible with the project's Flutter/Dart SDK.
- Keep configuration generated by FlutterFire tooling; do not hand-edit generated files unless there is a documented reason.
- Use `Firebase Emulator Suite` for local Auth/Firestore/Storage/Functions testing when available.
- Keep rules and indexes in version control.
- Add required composite indexes when introducing queries.
- Bound and paginate collection queries.
- Handle permission-denied and network failures explicitly.
- Use server timestamps for authoritative audit fields.
- Use App Check as a defense-in-depth measure; it does not replace authorization.
- Use Cloud Functions or another trusted backend for privileged workflows, scheduled reminders, moderation side effects, and consistency-sensitive operations.
- Design server-triggered functions to be idempotent because events may be retried.
- Never deploy rules, indexes, functions, or other Firebase resources without explicit user authorization.

## 7. Security and safety checklist
Before finishing any feature touching user data:
- [ ] Authorization is enforced outside the UI.
- [ ] Firestore and Storage rules follow least privilege.
- [ ] No user can write global roles or another user's private data.
- [ ] Cross-team and cross-event access is denied.
- [ ] Inputs, enums, file sizes, and content types are validated.
- [ ] Sensitive data is not logged.
- [ ] Report/block/moderation requirements are considered for user-generated content.
- [ ] Account deletion and related data/file cleanup are considered.
- [ ] Tests include both permitted and denied cases.

## 8. Testing and quality gates
For each task:
1. Add unit tests for model parsing, validation, and business logic.
2. Add widget tests for meaningful UI behavior and loading/error/empty states.
3. Add Firestore/Storage Rules tests for protected reads/writes.
4. Run `dart format` on changed Dart files.
5. Run `flutter analyze`.
6. Run relevant `flutter test` suites.
7. If configured, run Firebase Emulator Suite tests.
8. Report exactly which commands ran and their outcomes. If tooling is unavailable, say so; do not imply tests passed.

## 9. Definition of done
A change is complete only when:
- It matches the requested scope and existing architecture.
- Models and validation are typed and documented.
- UI strings are localized in German and English.
- Loading, empty, error, permission-denied, and offline states are handled where relevant.
- Access rules and tests are updated for protected data.
- Required Firestore indexes are included.
- Formatting, static analysis, and relevant tests have been run when available.
- Remaining risks, assumptions, and manual Firebase Console steps are clearly stated.

## 10. Response format for implementation tasks
When reporting work, use:
- **Implemented:** concise list of behavior delivered.
- **Files changed:** paths and purpose.
- **Security/data impact:** rules, schema, indexes, migrations.
- **Validation:** exact commands run and results.
- **Remaining work:** blockers, deployment steps, or follow-up items.

## 11. Suggested MVP implementation order
1. Firebase setup, localization, navigation, linting, emulator configuration.
2. Auth and user profiles.
3. Team profiles, memberships, join requests, team roles.
4. Activities, event discovery, registrations, capacity handling.
5. Learning content.
6. Basic notifications and event reminders.
7. Reports, moderation tools, account deletion workflow, security review.
8. Pilot release and monitoring.

Do not add social feed, likes/comments, direct messaging, or advanced tournament brackets to MVP unless the user explicitly changes scope.
