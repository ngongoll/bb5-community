import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/auth_providers.dart';
import '../domain/user_profile.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _displayNameController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _preferredLanguage = 'en';
  String _experienceLevel = 'beginner';
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _displayNameController.dispose();
    _countryCodeController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (user == null) {
      setState(() => _errorMessage = l10n.notAuthenticatedError);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(userProfileRepositoryProvider);
      final existingProfile = await repository.fetchProfile(user.uid);
      final profile =
          (existingProfile ??
                  UserProfile.empty(uid: user.uid, email: user.email ?? ''))
              .copyWith(
                uid: user.uid,
                displayName: _displayNameController.text.trim(),
                email: user.email ?? '',
                countryCode: _countryCodeController.text.trim().toUpperCase(),
                city: _cityController.text.trim(),
                preferredLanguage: _preferredLanguage,
                experienceLevel: _experienceLevel,
                bio: _bioController.text.trim().isEmpty
                    ? null
                    : _bioController.text.trim(),
                updatedAt: DateTime.now().toUtc(),
              );

      profile.validate();
      await repository.saveProfile(profile);

      if (!mounted) return;
      context.pop();
    } on StateError catch (error) {
      setState(() => _errorMessage = error.message);
    } on ArgumentError catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (_) {
      setState(() => _errorMessage = l10n.profileSaveError);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.profileTitle)),
        body: Center(child: Text(l10n.notAuthenticatedError)),
      );
    }

    final profileAsync = ref.watch(userProfileStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfileTitle)),
      body: profileAsync.when(
        data: (profile) {
          if (profile != null) {
            _displayNameController.text = _displayNameController.text.isEmpty
                ? profile.displayName
                : _displayNameController.text;
            _countryCodeController.text = _countryCodeController.text.isEmpty
                ? (profile.countryCode ?? '')
                : _countryCodeController.text;
            _cityController.text = _cityController.text.isEmpty
                ? (profile.city ?? '')
                : _cityController.text;
            _bioController.text = _bioController.text.isEmpty
                ? (profile.bio ?? '')
                : _bioController.text;
            _preferredLanguage = profile.preferredLanguage;
            _experienceLevel = profile.experienceLevel;
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        labelText: l10n.displayNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().length < 2) {
                          return l10n.displayNameValidationMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _countryCodeController,
                      initialValue: null,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 2,
                      decoration: InputDecoration(
                        labelText: l10n.countryCodeLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final text = (value ?? '').trim();
                        if (text.isNotEmpty && text.length != 2) {
                          return l10n.countryCodeValidationMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: l10n.cityLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue:
                          UserProfile.supportedLanguages.contains(
                            _preferredLanguage,
                          )
                          ? _preferredLanguage
                          : 'en',
                      items: UserProfile.supportedLanguages
                          .map(
                            (language) => DropdownMenuItem(
                              value: language,
                              child: Text(language.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _preferredLanguage = value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: l10n.languageLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue:
                          UserProfile.supportedExperienceLevels.contains(
                            _experienceLevel,
                          )
                          ? _experienceLevel
                          : 'beginner',
                      items: UserProfile.supportedExperienceLevels
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _experienceLevel = value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: l10n.experienceLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: l10n.bioLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().length > 300) {
                          return l10n.bioValidationMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _errorMessage!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _saveProfile,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(
                        _isSaving ? l10n.loading : l10n.saveProfileAction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('${l10n.profileLoadError}: $error'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
