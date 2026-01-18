import 'package:flutter/material.dart';
import 'package:sun_save/l10n/app_localizations.dart';

import 'auto_translate_widget.dart';

class AddWordResult {
  final String en;
  final String ar;
  final bool addToSaved;
  const AddWordResult({
    required this.en,
    required this.ar,
    required this.addToSaved,
  });
}

class AddWordBottomSheet extends StatefulWidget {
  final bool addToSaved;
  const AddWordBottomSheet({super.key, required this.addToSaved});

  static Future<AddWordResult?> show(
    BuildContext context, {
    required bool addToSaved,
  }) {
    return showModalBottomSheet<AddWordResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddWordBottomSheet(addToSaved: addToSaved),
    );
  }

  @override
  State<AddWordBottomSheet> createState() => _AddWordBottomSheetState();
}

class _AddWordBottomSheetState extends State<AddWordBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _enController = TextEditingController();
  final _arController = TextEditingController();

  @override
  void dispose() {
    _enController.dispose();
    _arController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasEnglish = _enController.text.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.addWordTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _enController,
              decoration: InputDecoration(
                labelText: l10n.englishLabel,
                prefixIcon: const Icon(Icons.abc),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return l10n.validationRequiredEnglish;
                if (value.length < 2) return l10n.validationTooShort;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _arController,
              decoration: InputDecoration(
                labelText: l10n.arabicLabel,
                prefixIcon: const Icon(Icons.translate),
              ),
              textInputAction: TextInputAction.done,
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return l10n.validationRequiredArabic;
                if (value.length < 2) return l10n.validationTooShort;
                return null;
              },
            ),
            const SizedBox(height: 8),
            if (hasEnglish)
              AutoTranslateWidget(
                enController: _enController,
                onTranslationClicked: (ar) {
                  _arController.text = ar;
                  setState(() {});
                },
              ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop(
                  AddWordResult(
                    en: _enController.text,
                    ar: _arController.text,
                    addToSaved: widget.addToSaved,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(
                widget.addToSaved ? l10n.addToSaved : l10n.addToUnsaved,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
