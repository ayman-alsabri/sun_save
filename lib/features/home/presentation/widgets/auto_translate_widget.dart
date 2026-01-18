import 'package:flutter/material.dart';
import 'package:sun_save/core/services/google_translate_service.dart';
import 'package:sun_save/l10n/app_localizations.dart';

class AutoTranslateWidget extends StatefulWidget {
  final TextEditingController enController;
  final ValueChanged<String> onTranslationClicked;

  const AutoTranslateWidget({
    super.key,
    required this.enController,
    required this.onTranslationClicked,
  });

  @override
  State<AutoTranslateWidget> createState() => _AutoTranslateWidgetState();
}

class _AutoTranslateWidgetState extends State<AutoTranslateWidget> {
  bool _loading = false;
  Object? _error;
  List<String> _suggestions = const [];
  final GoogleTranslateService _translate = GoogleTranslateService();

  Future<void> _run() async {
    final en = widget.enController.text.trim();

    if (en.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
      _suggestions = const [];
    });

    try {
      final suggestions = await _translate.translate(text: en);
      if (!mounted) return;
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
      });
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _loading ? null : _run,
          icon: const Icon(Icons.translate),
          label: _loading
              ? const LinearProgressIndicator()
              : Text(l10n.autoTranslate),
        ),

        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            l10n.autoTranslateError,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        if (!_loading && _error == null && _suggestions.isEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.autoTranslateNoSuggestions,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        if (_suggestions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in _suggestions)
                ActionChip(
                  label: Text(s),
                  onPressed: () => widget.onTranslationClicked(s),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
