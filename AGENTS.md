# AGENTS.md — Baseball5 Community App

## Mission
Build and maintain an international Baseball5 community app using Flutter and Firebase. The app starts with German and English and supports open registration. Core MVP areas are profiles, player discovery, teams/clubs, training/Open Play, activities/events, registrations, learning content, notifications, moderation, privacy, and role-based access control.

## Source of truth
- Follow the architecture and conventions already established in the repository.
- Read this file and `.github/copilot-instructions.md` before making changes.
- For task-specific workflows, read `.github/skills/baseball5-flutter-firebase/SKILL.md`.
- Do not invent existing files, package versions, Firebase configuration, schema fields, or deployment state. Inspect the repository first.
- If project code conflicts with these instructions, explain the conflict and propose the smallest safe migration rather than silently rewriting large areas.

## Architecture
- Use feature-first structure. Keep UI, application/business logic, and data access separate.
- Prefer small, testable widgets and services. Avoid giant screens, giant repositories, and unrelated refactors.
- Keep Firebase SDK calls inside data sources/repositories; UI widgets should not directly implement Firestore queries or authorization logic.
- Use typed Dart models with explicit serialization/deserialization and validation.
- Use the state-management and routing packages already present. If none exist, propose a choice before adding dependencies.
- Keep dependency injection explicit and testable.
- Do not add a new package for a trivial utility without explaining why.

## Firebase and data
- Firebase Authentication owns identity. Use the authenticated Firebase UID as the user document ID.
- Cloud Firestore stores structured application data; Cloud Storage stores files; Firebase Cloud Messaging delivers push notifications; Cloud Functions handle trusted server-side workflows when needed.
- Never store passwords or authentication secrets in Firestore.
- Treat client input as untrusted. Validate input in the client for usability and enforce authorization and invariants in Security Rules and/or trusted backend code.
- Never trust a role, owner ID, participant count, or status supplied by the client without checking it against trusted data.
- Use server timestamps for authoritative creation/update times where appropriate.
- Design queries intentionally and add required composite indexes to `firestore.indexes.json`.
- Avoid unbounded collection reads. Use pagination, limits, and appropriate query indexes.
- Use transactions/batched writes or trusted server logic where consistency matters. Capacity-limited registrations must not overbook under concurrent requests.
- Keep Firestore document sizes and fan-out in mind. Store large media in Storage, not in Firestore documents.
- Use stable document IDs for unique relationships where appropriate (for example team membership by UID). Prevent duplicate active registrations for the same participant/activity.
- Prefer additive schema changes. Document migration or backfill needs for breaking schema changes.

## Security and privacy — non-negotiable
- Never weaken or open Firestore/Storage Security Rules just to make a feature work.
- Default-deny access unless a rule explicitly grants it.
- Users may edit only their own profile fields; sensitive fields and global roles must not be client-editable.
- Team managers may manage only teams where they have a valid manager membership.
- Event organizers may manage only events they are authorized to manage.
- Users may not change another user's membership, registration, report, or notification state unless explicitly authorized.
- Admin privileges must be granted through a trusted administrative process, never through public client writes.
- Validate file paths, file sizes, content types, and ownership in Storage Rules.
- Include tests for allowed and denied access, including cross-user and cross-team attempts.
- Avoid exposing precise user location. Use city/region or coarse location unless a user explicitly opts into more precision.
- Support block/report and moderation workflows before launching user-generated content or messaging.
- Do not log access tokens, passwords, private messages, email addresses, precise location, or other sensitive data.
- Consider deletion, retention, consent, minors' safety, and applicable privacy law before production release. Do not claim legal compliance without a proper review.

## Internationalization
- All user-facing UI strings must be localized; do not hardcode English or German text in widgets.
- German (`de`) and English (`en`) are the initial supported locales.
- Store timestamps consistently and display them in the user's locale/time zone.
- Store an IANA time-zone identifier for scheduled activities where relevant.
- Use ISO country codes for country identifiers.
- For user-generated or editorial content, define an explicit fallback policy when a translation is missing.

## Product and data conventions
- Keep the initial product scope focused on profiles, teams, activities/events, registrations, learning content, safety, and basic reminders.
- Represent training, Open Play, matches, tournaments, workshops, camps, and community meetups as typed activities where a shared schema is appropriate.
- Keep activity registrations separate from activity documents.
- Model team membership as a separate relationship with a team-scoped role.
- Distinguish global roles (for example platform admin/moderator) from team-scoped roles (player, coach, team manager) and event-specific permissions.
- Treat feed, likes/comments, direct messages, and advanced tournament brackets as later-phase features unless the task explicitly requests them.

## Code quality
- Follow Dart/Flutter style and `dart format`.
- Use meaningful names and null safety. Avoid `dynamic` unless there is a clear reason.
- Handle loading, empty, error, permission-denied, and offline states in user-facing flows.
- Keep business logic out of widgets.
- Add or update unit, widget, and rules tests for changed behavior.
- Do not delete or skip tests to make a change pass.
- Do not report tests, builds, emulator checks, or deployments as successful unless you actually ran them and observed success.
- Never deploy Firebase rules, indexes, functions, or hosting without explicit user authorization.
- Do not place real Firebase secrets or service-account keys in source control.

## Working protocol
For every non-trivial task:
1. Inspect relevant files, package configuration, current architecture, and tests.
2. Summarize the intended change and identify security/schema implications.
3. Implement the smallest coherent change.
4. Add/update tests and localization resources.
5. Run formatting, static analysis, and relevant tests when tooling is available.
6. Report files changed, commands actually run, results, unresolved risks, and any required Firebase console or deployment steps.

If a requirement is ambiguous and affects security, data model, billing, or a breaking migration, ask a concise clarifying question before implementing. Otherwise make a conservative choice and state the assumption.
