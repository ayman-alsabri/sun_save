import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../words/domain/entities/word.dart';

class WordEditDialog extends StatefulWidget {
  final Word word;
  final ValueChanged<Word> onSave;

  const WordEditDialog({super.key, required this.word, required this.onSave});

  @override
  State<WordEditDialog> createState() => _WordEditDialogState();
}

class _WordEditDialogState extends State<WordEditDialog> {
  late TextEditingController _enController;
  late TextEditingController _arController;

  @override
  void initState() {
    super.initState();
    _enController = TextEditingController(text: widget.word.en);
    _arController = TextEditingController(text: widget.word.ar);
  }

  @override
  void dispose() {
    _enController.dispose();
    _arController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.editWordTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _enController,
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.englishLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _arController,
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.arabicLabel,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final newWord = widget.word.copyWith(
              en: _enController.text.trim(),
              ar: _arController.text.trim(),
            );
            widget.onSave(newWord);
            Navigator.of(context).pop();
          },
          child: Text(l10n.saveChanges),
        ),
      ],
    );
  }
}
