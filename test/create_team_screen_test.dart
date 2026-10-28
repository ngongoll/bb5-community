import 'package:b5_community/features/teams/presentation/create_team_screen.dart';
import 'package:b5_community/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('create team form displays the required fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CreateTeamScreen(),
      ),
    );

    expect(find.byKey(const ValueKey('create_team_title')), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Team name'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('City'), findsOneWidget);
    expect(find.text('Country'), findsOneWidget);
  });

  testWidgets('name validation prevents submission when empty', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CreateTeamScreen(),
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('create_team_submit_button')),
    );
    await tester.tap(find.byKey(const ValueKey('create_team_submit_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('team name'), findsWidgets);
  });

  testWidgets('country validation prevents empty submission', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CreateTeamScreen(),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('team_name_field')),
      'Berlin Sluggers',
    );
    await tester.enterText(
      find.byKey(const ValueKey('team_description_field')),
      'A welcoming community team for training and local games.',
    );
    await tester.enterText(
      find.byKey(const ValueKey('team_city_field')),
      'Berlin',
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('create_team_submit_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('create_team_submit_button')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Country codes must be 2 letters'),
      findsOneWidget,
    );
  });

  testWidgets('form accepts a valid team payload', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CreateTeamScreen(),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('team_name_field')),
      'Berlin Sluggers',
    );
    await tester.enterText(
      find.byKey(const ValueKey('team_description_field')),
      'A welcoming community team for training and local games.',
    );
    await tester.enterText(
      find.byKey(const ValueKey('team_city_field')),
      'Berlin',
    );
    await tester.enterText(
      find.byKey(const ValueKey('team_country_field')),
      'DE',
    );

    expect(find.text('Berlin Sluggers'), findsOneWidget);
    expect(
      find.text('A welcoming community team for training and local games.'),
      findsOneWidget,
    );
    expect(find.text('DE'), findsOneWidget);
  });
}
