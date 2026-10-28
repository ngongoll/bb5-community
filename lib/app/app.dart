import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'app_locale_provider.dart';
import 'router.dart';
import 'theme.dart';

class Baseball5App extends ConsumerWidget {
  const Baseball5App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final localeController = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'Baseball5 Community',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: localeController.locale,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
