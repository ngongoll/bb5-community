import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

const String appLocaleStorageKey = 'app_locale_language_code';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController({Locale? platformLocale})
    : _platformLocale =
          platformLocale ?? WidgetsBinding.instance.platformDispatcher.locale,
      _locale = _resolveLocale(
        platformLocale:
            platformLocale ?? WidgetsBinding.instance.platformDispatcher.locale,
      );

  final Locale _platformLocale;
  Locale _locale;

  Locale get locale => _locale;

  static Locale _resolveLocale({
    required Locale platformLocale,
    String? savedLocaleCode,
  }) {
    final candidates = <String>[
      savedLocaleCode ?? '',
      platformLocale.languageCode,
      AppLocalizations.supportedLocales.first.languageCode,
    ].where((candidate) => candidate.isNotEmpty).toList();

    for (final candidate in candidates) {
      final supportedLocale = AppLocalizations.supportedLocales.firstWhere(
        (locale) => locale.languageCode == candidate,
        orElse: () => AppLocalizations.supportedLocales.first,
      );

      if (supportedLocale.languageCode == candidate) {
        return supportedLocale;
      }
    }

    return AppLocalizations.supportedLocales.first;
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocaleCode = prefs.getString(appLocaleStorageKey);
    _locale = _resolveLocale(
      platformLocale: _platformLocale,
      savedLocaleCode: savedLocaleCode,
    );
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    final selectedLocale = AppLocalizations.supportedLocales.firstWhere(
      (supportedLocale) =>
          supportedLocale.languageCode == newLocale.languageCode,
      orElse: () => AppLocalizations.supportedLocales.first,
    );

    _locale = selectedLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(appLocaleStorageKey, selectedLocale.languageCode);
  }
}

final appLocaleProvider = ChangeNotifierProvider<AppLocaleController>((ref) {
  final controller = AppLocaleController();
  Future.microtask(controller.loadSavedLocale);
  return controller;
});
