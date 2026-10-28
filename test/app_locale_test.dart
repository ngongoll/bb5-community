import 'package:b5_community/app/app_locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('uses saved locale when it exists', () async {
    SharedPreferences.setMockInitialValues({appLocaleStorageKey: 'de'});

    final controller = AppLocaleController(platformLocale: const Locale('en'));
    await controller.loadSavedLocale();

    expect(controller.locale.languageCode, 'de');
  });

  test(
    'falls back to the device locale when no saved preference exists',
    () async {
      SharedPreferences.setMockInitialValues({});

      final controller = AppLocaleController(
        platformLocale: const Locale('de'),
      );
      await controller.loadSavedLocale();

      expect(controller.locale.languageCode, 'de');
    },
  );

  test('persists a user-selected locale', () async {
    SharedPreferences.setMockInitialValues({});

    final controller = AppLocaleController(platformLocale: const Locale('en'));
    await controller.loadSavedLocale();
    await controller.setLocale(const Locale('de'));

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(appLocaleStorageKey), 'de');
    expect(controller.locale.languageCode, 'de');
  });
}
