import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../shared/presentation/placeholder_screen.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PlaceholderScreen(
      title: l10n.learning,
      description: l10n.learningPlaceholder,
      showAppBar: false,
    );
  }
}
