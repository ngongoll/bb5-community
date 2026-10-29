import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/activity_repository.dart';
import '../domain/activity.dart';

class ActivityDetailScreen extends ConsumerStatefulWidget {
  const ActivityDetailScreen({super.key, required this.activityId});

  final String activityId;

  @override
  ConsumerState<ActivityDetailScreen> createState() =>
      _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends ConsumerState<ActivityDetailScreen> {
  late Future<Activity?> _activityFuture;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _activityFuture = ref
        .read(activityRepositoryProvider)
        .fetchActivity(widget.activityId);
  }

  Future<void> _toggleRegistration(Activity activity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    setState(() => _isRegistering = true);

    try {
      final isRegistered = await ref
          .read(activityRepositoryProvider)
          .isUserRegistered(activityId: activity.id, userId: user.uid);

      if (isRegistered) {
        await ref
            .read(activityRepositoryProvider)
            .cancelRegistration(activityId: activity.id, userId: user.uid);
      } else {
        await ref
            .read(activityRepositoryProvider)
            .registerForActivity(activityId: activity.id, userId: user.uid);
      }

      if (!mounted) return;
      setState(() {
        _activityFuture = ref
            .read(activityRepositoryProvider)
            .fetchActivity(widget.activityId);
      });
    } finally {
      if (mounted) {
        setState(() => _isRegistering = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.activities)),
      body: FutureBuilder<Activity?>(
        future: _activityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final activity = snapshot.data;
          if (activity == null) {
            return Center(child: Text(l10n.teamNotFoundError));
          }

          final currentUser = FirebaseAuth.instance.currentUser;
          final isOwner = currentUser?.uid == activity.organizerId;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(activity.type.toUpperCase()),
                  const SizedBox(height: 16),
                  Text(
                    activity.description.isEmpty
                        ? 'No description provided.'
                        : activity.description,
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(label: 'City', value: activity.city),
                  _InfoRow(
                    label: 'Meeting place',
                    value: activity.locationName,
                  ),
                  _InfoRow(
                    label: 'Starts',
                    value: activity.startAt.toLocal().toString(),
                  ),
                  _InfoRow(
                    label: 'Ends',
                    value: activity.endAt.toLocal().toString(),
                  ),
                  if (activity.participantLimit != null)
                    _InfoRow(
                      label: 'Limit',
                      value: activity.participantLimit.toString(),
                    ),
                  const SizedBox(height: 24),
                  if (currentUser != null)
                    FilledButton.icon(
                      onPressed: _isRegistering || activity.status != 'active'
                          ? null
                          : () => _toggleRegistration(activity),
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        _isRegistering
                            ? 'Working...'
                            : isOwner
                            ? 'You are the organizer'
                            : 'Register',
                      ),
                    ),
                  if (isOwner) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('Edit activity'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
