import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/activity_repository.dart';
import '../domain/activity.dart';

class ActivitiesScreen extends StatefulWidget {
  ActivitiesScreen({super.key, ActivityRepository? repository})
    : _repository = repository ?? ActivityRepository();

  final ActivityRepository _repository;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activities),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Create activity',
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                context.go('/login?redirect=/activities/create');
                return;
              }
              context.push('/activities/create');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.activitiesSummary,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'all', label: Text('All')),
                  ButtonSegment(value: 'training', label: Text('Training')),
                  ButtonSegment(value: 'openPlay', label: Text('Open Play')),
                ],
                selected: {_filter},
                onSelectionChanged: (value) =>
                    setState(() => _filter = value.first),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<List<Activity>>(
                  stream: widget._repository.watchPublicActivities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('${l10n.teamLoadError}: ${snapshot.error}'),
                      );
                    }

                    final activities = (snapshot.data ?? const <Activity>[])
                        .where(
                          (activity) =>
                              _filter == 'all' || activity.type == _filter,
                        )
                        .toList();

                    if (activities.isEmpty) {
                      return const Center(
                        child: Text('No upcoming activities found.'),
                      );
                    }

                    return ListView.separated(
                      itemCount: activities.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return Card(
                          child: ListTile(
                            title: Text(activity.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${activity.type} • ${activity.city}'),
                                const SizedBox(height: 4),
                                Text(
                                  '${activity.startAt.toLocal()} - ${activity.endAt.toLocal()}',
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () =>
                                context.push('/activities/${activity.id}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
