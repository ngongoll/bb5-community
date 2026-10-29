import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../teams/data/team_repository.dart';
import '../../teams/domain/team.dart';
import '../data/activity_repository.dart';
import '../domain/activity.dart';

class CreateActivityScreen extends ConsumerStatefulWidget {
  const CreateActivityScreen({super.key, this.activityId});

  final String? activityId;

  bool get isEditing => activityId != null && activityId!.trim().isNotEmpty;

  @override
  ConsumerState<CreateActivityScreen> createState() =>
      _CreateActivityScreenState();
}

class _CreateActivityScreenState extends ConsumerState<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationController = TextEditingController();
  final _participantLimitController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;
  String _type = 'training';
  String _visibility = 'public';
  String? _teamId;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  List<Team> _userTeams = const <Team>[];

  @override
  void initState() {
    super.initState();
    _startDateTime = DateTime.now().toUtc().add(const Duration(hours: 1));
    _endDateTime = DateTime.now().toUtc().add(const Duration(hours: 2));
    _loadUserTeams();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    _participantLimitController.dispose();
    super.dispose();
  }

  Future<void> _loadUserTeams() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      final teams = await ref
          .read(teamRepositoryProvider)
          .fetchMyTeams(user.uid);
      if (!mounted) return;
      setState(() {
        _userTeams = teams;
        if (teams.isNotEmpty) {
          _teamId = teams.first.id;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _userTeams = const <Team>[]);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go('/login?redirect=/activities/create');
      return;
    }

    final startAt = _startDateTime ?? DateTime.now().toUtc();
    final endAt = _endDateTime ?? startAt.add(const Duration(hours: 1));
    final participantLimit = int.tryParse(
      _participantLimitController.text.trim(),
    );

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final activity = Activity(
        id: widget.activityId ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        type: _type,
        organizerId: user.uid,
        teamId: _teamId,
        city: _cityController.text,
        locationName: _locationController.text,
        startAt: startAt,
        endAt: endAt,
        participantLimit: participantLimit != null && participantLimit > 0
            ? participantLimit
            : null,
        status: 'active',
        visibility: _visibility,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      activity.validate();

      final repository = ref.read(activityRepositoryProvider);
      final saved = await repository.createActivity(
        organizerId: user.uid,
        activity: activity,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Activity created successfully')));
      context.go('/activities/${saved.id}');
    } on FirebaseException catch (error) {
      setState(() => _errorMessage = _messageForFirestoreError(error, l10n));
    } on ArgumentError catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (error) {
      setState(() => _errorMessage = error.toString());
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
      return l10n.teamCreatePermissionError;
    }
    if (error.code == 'unavailable') {
      return l10n.teamCreateNetworkError;
    }
    return l10n.teamCreateError;
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDateTime : _endDateTime) ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (!mounted) return;
    if (picked == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        (isStart ? _startDateTime : _endDateTime) ?? now,
      ),
    );
    if (!mounted) return;
    if (time == null) return;

    final selected = DateTime(
      picked.year,
      picked.month,
      picked.day,
      time.hour,
      time.minute,
    ).toUtc();

    if (!mounted) return;
    setState(() {
      if (isStart) {
        _startDateTime = selected;
      } else {
        _endDateTime = selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.activities)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create activity',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) =>
                          (value == null || value.trim().length < 2)
                          ? 'Add a valid title.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _type,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: Activity.supportedTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _type = value ?? 'training'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _visibility,
                      decoration: const InputDecoration(
                        labelText: 'Visibility',
                      ),
                      items: Activity.supportedVisibilities
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _visibility = value ?? 'public'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'City is required.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Meeting place',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Meeting place is required.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _pickDateTime(isStart: true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start time',
                        ),
                        child: Text(
                          _startDateTime?.toLocal().toString() ??
                              'Select start time',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _pickDateTime(isStart: false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End time',
                        ),
                        child: Text(
                          _endDateTime?.toLocal().toString() ??
                              'Select end time',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _participantLimitController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Participant limit (optional)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_userTeams.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue: _teamId,
                        decoration: const InputDecoration(
                          labelText: 'Team (optional)',
                        ),
                        items: _userTeams
                            .map(
                              (team) => DropdownMenuItem(
                                value: team.id,
                                child: Text(team.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() => _teamId = value),
                      ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submit,
                      icon: const Icon(Icons.save_rounded),
                      label: Text(
                        _isSubmitting ? 'Saving...' : 'Create activity',
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
