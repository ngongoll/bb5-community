import 'package:b5_community/features/activities/presentation/activities_screen.dart';
import 'package:b5_community/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('activities screen renders title and create button', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ActivitiesScreen(),
      ),
    );

    expect(find.text('Activities'), findsOneWidget);
    expect(find.byTooltip('Create activity'), findsOneWidget);
  });
}
