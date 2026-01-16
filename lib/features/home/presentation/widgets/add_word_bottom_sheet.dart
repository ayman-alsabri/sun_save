import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';

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
              'Add a word',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _enController,
              decoration: const InputDecoration(
                labelText: 'English',
                prefixIcon: Icon(Icons.abc),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'English word is required';
                if (value.length < 2) return 'Too short';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _arController,
              decoration: const InputDecoration(
                labelText: 'Arabic',
                prefixIcon: Icon(Icons.translate),
              ),
              textInputAction: TextInputAction.done,
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Arabic translation is required';
                if (value.length < 2) return 'Too short';
                return null;
              },
            ),
            const SizedBox(height: 8),
            if (hasEnglish)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    final en = _enController.text;

                    // Close the bottom sheet first to avoid controller usage after dispose.
                    Navigator.of(context).pop();

                    // Navigate after the sheet is removed.
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.autoTranslate, arguments: en);
                    });
                  },
                  child: const Text('Auto translate'),
                ),
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
                widget.addToSaved ? 'Add to Saved' : 'Add to Unsaved',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
