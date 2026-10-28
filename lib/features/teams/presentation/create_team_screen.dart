import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/team_repository.dart';
import '../domain/team.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key, this.teamId});

  final String? teamId;

  bool get isEditing => teamId != null && teamId!.trim().isNotEmpty;

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isSubmitting = false;
  bool _isLoadingTeam = false;
  String? _errorMessage;
  Team? _loadedTeam;
  String _organizationType = Team.supportedOrganizationTypes.first;
  String _visibility = Team.supportedVisibilities.first;
  bool _recruitingEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadExistingTeam();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingTeam() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      context.go('/login?redirect=/teams');
      return;
    }

    setState(() {
      _isLoadingTeam = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(teamRepositoryProvider);
      final team = await repository.fetchOwnedTeam(
        teamId: widget.teamId!,
        ownerUid: user.uid,
      );

      if (!mounted) return;

      if (team == null) {
        setState(() => _errorMessage = l10n.teamNotFoundError);
        return;
      }

      _loadedTeam = team;
      _nameController.text = team.name;
      _descriptionController.text = team.description;
      _cityController.text = team.city;
      _countryController.text = team.countryCode;
      _organizationType = team.organizationType;
      _visibility = team.visibility;
      _recruitingEnabled = team.recruitingEnabled;
    } on FirebaseException catch (error) {
      setState(() {
        _errorMessage = _messageForFirestoreError(error, l10n);
      });
    } catch (_) {
      setState(() => _errorMessage = l10n.teamNotFoundError);
    } finally {
      if (mounted) {
        setState(() => _isLoadingTeam = false);
      }
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      setState(() => _errorMessage = l10n.teamCreateError);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      context.go('/login?redirect=/teams/create');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(teamRepositoryProvider);
      final team = Team(
        id:
            widget.teamId ??
            'new-team-${DateTime.now().microsecondsSinceEpoch}',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        city: _cityController.text.trim(),
        countryCode: _countryController.text.trim().toUpperCase(),
        organizationType: _organizationType,
        visibility: _visibility,
        recruitingEnabled: _recruitingEnabled,
        status: 'active',
        createdBy: user.uid,
        createdAt: _loadedTeam?.createdAt ?? DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      team.validate();

      final savedTeam = widget.isEditing
          ? await repository.updateTeam(
              ownerUid: user.uid,
              teamId: widget.teamId!,
              team: team,
            )
          : await repository.createTeam(ownerUid: user.uid, team: team);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? l10n.teamUpdateSuccessMessage(savedTeam.name)
                : l10n.teamCreateSuccessMessage(savedTeam.name),
          ),
        ),
      );

      if (widget.isEditing) {
        context.pop();
        return;
      }

      context.go('/teams');
    } on FirebaseException catch (error) {
      setState(() {
        _errorMessage = _messageForFirestoreError(error, l10n);
      });
    } on StateError catch (error) {
      setState(() => _errorMessage = error.message);
    } on ArgumentError catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (_) {
      setState(() => _errorMessage = l10n.teamCreateError);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _messageForFirestoreError(
    FirebaseException error,
    AppLocalizations l10n,
  ) {
    if (error.code == 'permission-denied') {
      return widget.isEditing
          ? l10n.teamUpdatePermissionError
          : l10n.teamCreatePermissionError;
    }
    if (error.code == 'unavailable') {
      return widget.isEditing
          ? l10n.teamUpdateNetworkError
          : l10n.teamCreateNetworkError;
    }
    return widget.isEditing ? l10n.teamUpdateError : l10n.teamCreateError;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isLoadingTeam) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editTeamTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final formTitle = widget.isEditing
        ? l10n.editTeamTitle
        : l10n.createTeamTitle;

    return Scaffold(
      appBar: AppBar(title: Text(formTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      formTitle,
                      key: const ValueKey('create_team_title'),
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('team_name_field'),
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: Team.maxNameLength,
                      decoration: InputDecoration(
                        labelText: l10n.teamNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final text = (value ?? '').trim();
                        if (text.length < 2) {
                          return l10n.teamNameValidationMessage;
                        }
                        if (text.length > Team.maxNameLength) {
                          return l10n.teamNameLengthMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('team_description_field'),
                      controller: _descriptionController,
                      maxLines: 4,
                      maxLength: Team.maxDescriptionLength,
                      decoration: InputDecoration(
                        labelText: l10n.teamDescriptionLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final text = (value ?? '').trim();
                        if (text.length > Team.maxDescriptionLength) {
                          return l10n.teamDescriptionValidationMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('team_city_field'),
                      controller: _cityController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: Team.maxCityLength,
                      decoration: InputDecoration(
                        labelText: l10n.cityLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('team_country_field'),
                      controller: _countryController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 2,
                      decoration: InputDecoration(
                        labelText: l10n.countryCodeLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final text = (value ?? '').trim();
                        if (text.isEmpty) {
                          return l10n.countryCodeValidationMessage;
                        }
                        if (text.length != 2) {
                          return l10n.countryCodeValidationMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: const ValueKey('team_organization_type_field'),
                      initialValue: _organizationType,
                      items: Team.supportedOrganizationTypes
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _organizationType = value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: l10n.teamOrganizationTypeLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: const ValueKey('team_visibility_field'),
                      initialValue: _visibility,
                      items: Team.supportedVisibilities
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value == 'public'
                                    ? l10n.teamVisibilityPublic
                                    : l10n.teamVisibilityPrivate,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _visibility = value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: l10n.teamVisibilityLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile.adaptive(
                      key: const ValueKey('team_recruiting_field'),
                      value: _recruitingEnabled,
                      onChanged: (value) {
                        setState(() => _recruitingEnabled = value);
                      },
                      title: Text(l10n.teamRecruitingFieldLabel),
                      subtitle: Text(
                        _recruitingEnabled
                            ? l10n.teamRecruitingOpen
                            : l10n.teamRecruitingClosed,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                      key: const ValueKey('create_team_submit_button'),
                      onPressed: _isSubmitting ? null : _submit,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.groups_rounded),
                      label: Text(
                        _isSubmitting
                            ? l10n.loading
                            : (widget.isEditing
                                  ? l10n.saveTeamAction
                                  : l10n.createTeamAction),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
