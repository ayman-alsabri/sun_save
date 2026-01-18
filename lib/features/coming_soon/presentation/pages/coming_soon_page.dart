import 'package:flutter/material.dart';
import 'package:sun_save/l10n/app_localizations.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.autoTranslate)),
      body: Center(
        child: Text(
          l10n.comingSoonTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
