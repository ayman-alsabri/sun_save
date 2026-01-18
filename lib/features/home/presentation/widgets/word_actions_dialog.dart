import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../words/domain/entities/word.dart';

class WordActionsDialog extends StatelessWidget {
  final Word word;
  final bool isSaved;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleSave;

  const WordActionsDialog({
    super.key,
    required this.word,
    required this.isSaved,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleDialog(
      title: Text(word.en),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            onToggleSave();
          },
          child: Row(
            children: [
              Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              const SizedBox(width: 8),
              Text(isSaved ? l10n.unsave : l10n.save),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            onEdit();
          },
          child: Row(
            children: [
              Icon(Icons.edit),
              const SizedBox(width: 8),
              Text(l10n.edit),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            onDelete();
          },
          child: Row(
            children: [
              Icon(Icons.delete),
              const SizedBox(width: 8),
              Text(l10n.delete),
            ],
          ),
        ),

        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ],
    );
  }
}
