import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../app/app_locale_provider.dart';
import '../data/auth_providers.dart';
import '../domain/user_profile.dart';

final userProfileStreamProvider = StreamProvider.autoDispose<UserProfile?>((
  ref,
) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream<UserProfile?>.empty();
  }

  return ref.read(userProfileRepositoryProvider).watchProfile(user.uid);
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final localeController = ref.watch(appLocaleProvider);
    final currentUser = FirebaseAuth.instance.currentUser;
    final profileAsync = ref.watch(userProfileStreamProvider);

    return SafeArea(
      child: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.profileEmptyState),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              profile.displayName,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.push('/profile/edit'),
                            icon: const Icon(Icons.edit_rounded),
                            tooltip: l10n.editProfileTitle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(profile.email),
                      const SizedBox(height: 16),
                      _InfoRow(
                        label: l10n.countryCodeLabel,
                        value: profile.countryCode ?? '—',
                      ),
                      _InfoRow(
                        label: l10n.cityLabel,
                        value: profile.city ?? '—',
                      ),
                      _InfoRow(
                        label: l10n.languageLabel,
                        value: profile.preferredLanguage.toUpperCase(),
                      ),
                      _InfoRow(
                        label: l10n.experienceLabel,
                        value: profile.experienceLevel,
                      ),
                      _InfoRow(label: l10n.bioLabel, value: profile.bio ?? '—'),
                      const SizedBox(height: 12),
                      if (currentUser != null)
                        Text(
                          'UID: ${currentUser.uid}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appLanguageLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.appLanguageDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<Locale>(
                        initialValue: localeController.locale,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.appLanguageLabel,
                        ),
                        items: AppLocalizations.supportedLocales
                            .map(
                              (locale) => DropdownMenuItem<Locale>(
                                value: locale,
                                child: Text(locale.languageCode.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (locale) async {
                          if (locale != null) {
                            await ref
                                .read(appLocaleProvider.notifier)
                                .setLocale(locale);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  final repository = ref.read(authRepositoryProvider);
                  await repository.signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                icon: const Icon(Icons.logout_rounded),
                label: Text(l10n.logoutAction),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('${l10n.profileLoadError}: $error'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
