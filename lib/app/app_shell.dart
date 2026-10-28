import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWideLayout = MediaQuery.sizeOf(context).width >= 900;

    final destinations = [
      _AppNavItem(label: l10n.home, icon: Icons.home_rounded, route: '/'),
      _AppNavItem(
        label: l10n.discover,
        icon: Icons.explore_rounded,
        route: '/discover',
      ),
      _AppNavItem(
        label: l10n.teams,
        icon: Icons.groups_rounded,
        route: '/teams',
      ),
      _AppNavItem(
        label: l10n.activities,
        icon: Icons.event_available_rounded,
        route: '/activities',
      ),
      _AppNavItem(
        label: l10n.profileTitle,
        icon: Icons.person_rounded,
        route: '/profile',
      ),
    ];

    final body = navigationShell;

    final appBar = AppBar(
      title: Tooltip(
        message: l10n.home,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => navigationShell.goBranch(0),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text('Baseball5'),
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          tooltip: l10n.notifications,
          onPressed: () => context.push('/notifications'),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          tooltip: l10n.profileTitle,
          onPressed: () => navigationShell.goBranch(4),
          icon: const Icon(Icons.account_circle_rounded),
        ),
      ],
    );

    if (isWideLayout) {
      return Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) =>
                    navigationShell.goBranch(index),
                labelType: NavigationRailLabelType.all,
                minWidth: 180,
                destinations: destinations
                    .map(
                      (destination) => NavigationRailDestination(
                        icon: Icon(destination.icon),
                        label: Text(destination.label),
                      ),
                    )
                    .toList(),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index),
        destinations: destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.icon),
                label: destination.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AppNavItem {
  const _AppNavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
