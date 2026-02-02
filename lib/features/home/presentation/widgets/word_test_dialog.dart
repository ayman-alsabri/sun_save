import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class WordTestDialog extends StatefulWidget {
  final String correctEn;
  final String correctAr;

  const WordTestDialog({
    super.key,
    required this.correctEn,
    required this.correctAr,
  });

  @override
  State<WordTestDialog> createState() => _WordTestDialogState();
}

class _WordTestDialogState extends State<WordTestDialog> {
  final _controller = TextEditingController();

  String _normalize(String s) {
    return s
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '') // zero-width chars
        .replaceAll('\u00A0', ' ') // non-breaking space -> normal space
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // collapse multi spaces
        .toLowerCase();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.testTitle),
      content: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.correctAr, style: Theme.of(context).textTheme.bodyMedium),
          TextField(
            controller: _controller,
            autofocus: true,
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.typeWhatYouRemember,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(_normalize(_controller.text) == _normalize(widget.correctEn)),
          child: Text(l10n.testTitle),
        ),
      ],
    );
  }
}
