import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_providers.dart';
import '../data/team_repository.dart';
import '../domain/team.dart';

class TeamsScreen extends ConsumerStatefulWidget {
  const TeamsScreen({super.key});

  @override
  ConsumerState<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String _searchQuery = '';
  String _cityFilter = '';
  String _countryFilter = '';
  String? _selectedTeamId;

  @override
  void dispose() {
    _searchController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Stream<List<Team>> _watchPublicTeams() {
    final repository = ref.read(teamRepositoryProvider);
    return repository.watchPublicTeams(
      city: _cityFilter,
      countryCode: _countryFilter,
      query: _searchQuery,
    );
  }

  Stream<List<Team>> _watchMyTeams(String? userId) {
    if (userId == null || userId.trim().isEmpty) {
      return const Stream<List<Team>>.empty();
    }

    final repository = ref.read(teamRepositoryProvider);
    return repository.watchMyTeams(userId);
  }

  Team? _selectedTeam(List<Team> teams) {
    for (final team in teams) {
      if (team.id == _selectedTeamId) {
        return team;
      }
    }
    return null;
  }

  Widget _buildCreateTeamButton({bool fullWidth = false}) {
    final l10n = AppLocalizations.of(context)!;

    final button = FilledButton.icon(
      onPressed: () {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          context.go('/login?redirect=/teams/create');
          return;
        }
        context.push('/teams/create');
      },
      icon: const Icon(Icons.add_rounded),
      label: Text(l10n.createTeamAction),
    );

    if (!fullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool compact,
  ) {
    final title = Text(
      l10n.teams,
      style: Theme.of(context).textTheme.headlineMedium,
    );
    final description = Text(
      l10n.teamsPageDescription,
      style: Theme.of(context).textTheme.bodyLarge,
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 8),
          description,
          const SizedBox(height: 16),
          _buildCreateTeamButton(fullWidth: true),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 8), description],
          ),
        ),
        const SizedBox(width: 16),
        _buildCreateTeamButton(),
      ],
    );
  }

  Widget _buildMyTeamsSection(
    BuildContext context,
    AppLocalizations l10n,
    User? currentUser,
  ) {
    final theme = Theme.of(context);

    if (currentUser == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.myTeamsSectionTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(l10n.myTeamsSignedOutMessage),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.go('/login?redirect=/teams/create'),
                icon: const Icon(Icons.login_rounded),
                label: Text(l10n.loginAction),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<List<Team>>(
      stream: _watchMyTeams(currentUser.uid),
      builder: (context, snapshot) {
        final teams = snapshot.data ?? const <Team>[];

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.myTeamsSectionTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.myTeamsLoadError),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.myTeamsRetryAction),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            teams.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.myTeamsSectionTitle),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.myTeamsSectionTitle,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() {}),
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: l10n.myTeamsRetryAction,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (teams.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.myTeamsEmptyState),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.push('/teams/create'),
                        icon: const Icon(Icons.add_rounded),
                        label: Text(l10n.createYourFirstTeamAction),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      for (final team in teams)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TeamCard(
                            team: team,
                            isSelected: _selectedTeamId == team.id,
                            showOwnerBadge: true,
                            onEdit: () {
                              context.push('/teams/${team.id}/edit');
                            },
                            onDelete: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(l10n.teamDeleteDialogTitle),
                                    content: Text(
                                      l10n.teamDeleteDialogContent(team.name),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          l10n.teamDeleteCancelAction,
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          l10n.teamDeleteConfirmAction,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmed != true) {
                                return;
                              }

                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) {
                                return;
                              }

                              try {
                                await ref
                                    .read(teamRepositoryProvider)
                                    .deleteTeam(
                                      ownerUid: user.uid,
                                      teamId: team.id,
                                    );

                                if (!mounted) return;
                                setState(() {
                                  _selectedTeamId = null;
                                });
                              } catch (_) {
                                if (!mounted) return;
                              }
                            },
                            onTap: () {
                              setState(() {
                                _selectedTeamId = _selectedTeamId == team.id
                                    ? null
                                    : team.id;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPublicTeamsSection(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return StreamBuilder<List<Team>>(
      stream: _watchPublicTeams(),
      builder: (context, snapshot) {
        final teams = snapshot.data ?? const <Team>[];
        final selectedTeam = _selectedTeam(teams);

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.discoverTeamsSectionTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text('${l10n.teamLoadError}: ${snapshot.error}'),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            teams.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.teamLoadError),
                  ],
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.discoverTeamsSectionTitle,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.teamSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: l10n.cityFilterHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _cityFilter = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      hintText: l10n.countryFilterHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _countryFilter = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (teams.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.teamEmptyState),
                ),
              )
            else
              Column(
                children: [
                  for (final team in teams)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TeamCard(
                        team: team,
                        isSelected: _selectedTeamId == team.id,
                        showOwnerBadge: false,
                        onTap: () {
                          setState(() {
                            _selectedTeamId = _selectedTeamId == team.id
                                ? null
                                : team.id;
                          });
                        },
                      ),
                    ),
                  if (selectedTeam != null) const SizedBox(height: 12),
                  if (selectedTeam != null) TeamDetailCard(team: selectedTeam),
                ],
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateChangesProvider);
    final currentUser = authState.maybeWhen(
      data: (user) => user,
      orElse: () => FirebaseAuth.instance.currentUser,
    );

    if (_searchController.text != _searchQuery) {
      _searchController.value = TextEditingValue(
        text: _searchQuery,
        selection: TextSelection.collapsed(offset: _searchQuery.length),
      );
    }
    if (_cityController.text != _cityFilter) {
      _cityController.value = TextEditingValue(
        text: _cityFilter,
        selection: TextSelection.collapsed(offset: _cityFilter.length),
      );
    }
    if (_countryController.text != _countryFilter) {
      _countryController.value = TextEditingValue(
        text: _countryFilter,
        selection: TextSelection.collapsed(offset: _countryFilter.length),
      );
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeader(context, l10n, compact),
              const SizedBox(height: 24),
              _buildMyTeamsSection(context, l10n, currentUser),
              const SizedBox(height: 24),
              _buildPublicTeamsSection(context, l10n),
            ],
          );
        },
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard({
    required this.team,
    required this.isSelected,
    required this.onTap,
    this.showOwnerBadge = false,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final Team team;
  final bool isSelected;
  final bool showOwnerBadge;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final actionMenu = (onEdit != null || onDelete != null)
        ? PopupMenuButton<String>(
            tooltip: l10n.teamEditAction,
            onSelected: (value) {
              if (value == 'edit') {
                onEdit?.call();
              } else if (value == 'delete') {
                onDelete?.call();
              }
            },
            itemBuilder: (context) => [
              if (onEdit != null)
                PopupMenuItem(value: 'edit', child: Text(l10n.teamEditAction)),
              if (onDelete != null)
                PopupMenuItem(
                  value: 'delete',
                  child: Text(l10n.teamDeleteAction),
                ),
            ],
          )
        : null;

    return Card(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(team.name, style: theme.textTheme.titleLarge),
                  ),
                  if (showOwnerBadge)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Chip(label: Text(l10n.teamOwnerBadge)),
                    ),
                  if (team.recruitingEnabled)
                    Padding(
                      padding: EdgeInsets.only(left: showOwnerBadge ? 8 : 0),
                      child: Chip(label: Text(l10n.teamRecruitingOpen)),
                    ),
                  if (actionMenu != null) ...[
                    const SizedBox(width: 8),
                    actionMenu,
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${team.city}, ${team.countryCode}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(team.organizationType, style: theme.textTheme.labelLarge),
              const SizedBox(height: 12),
              Text(
                team.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamDetailCard extends StatelessWidget {
  const TeamDetailCard({required this.team, super.key});

  final Team team;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.teamDetailTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(team.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('${team.city}, ${team.countryCode}'),
            const SizedBox(height: 8),
            Text(team.organizationType),
            const SizedBox(height: 12),
            Text(team.description),
            const SizedBox(height: 12),
            Text(
              team.recruitingEnabled
                  ? l10n.teamRecruitingOpen
                  : l10n.teamRecruitingClosed,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: team.recruitingEnabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
