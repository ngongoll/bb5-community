import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../shared/presentation/placeholder_screen.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PlaceholderScreen(
      title: l10n.activities,
      description: l10n.activitiesPlaceholder,
      showAppBar: false,
    );
  }
}
