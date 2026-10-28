import 'package:b5_community/features/teams/domain/team.dart';
import 'package:b5_community/features/teams/presentation/teams_screen.dart';
import 'package:b5_community/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final activeTeam = Team(
    id: 'team-1',
    name: 'Berlin Sluggers',
    description: 'Weekend training and community baseball for all levels.',
    city: 'Berlin',
    countryCode: 'DE',
    organizationType: 'team',
    visibility: 'public',
    recruitingEnabled: true,
    status: 'active',
    createdBy: 'user-1',
    createdAt: DateTime.utc(2025, 1, 1),
    updatedAt: DateTime.utc(2025, 1, 2),
  );

  final inactiveTeam = activeTeam.copyWith(
    id: 'team-2',
    name: 'Munich Keepers',
    recruitingEnabled: false,
    visibility: 'private',
    status: 'inactive',
  );

  testWidgets('team card renders public recruitment state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TeamCard(team: activeTeam, isSelected: false, onTap: () {}),
      ),
    );

    expect(find.text('Berlin Sluggers'), findsOneWidget);
    expect(find.text('Open to join'), findsOneWidget);
    expect(find.text('Berlin, DE'), findsOneWidget);
  });

  testWidgets('team detail shows the selected team information', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TeamDetailCard(team: inactiveTeam),
      ),
    );

    expect(find.text('Selected team'), findsOneWidget);
    expect(find.text('Munich Keepers'), findsOneWidget);
    expect(find.text('Currently not recruiting'), findsOneWidget);
  });
}
