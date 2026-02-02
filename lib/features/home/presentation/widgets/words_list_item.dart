import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../words/domain/entities/word.dart';
import '../../../words/presentation/bloc/words_bloc.dart';
import 'word_actions_dialog.dart';
import 'word_edit_dialog.dart';
import 'word_test_dialog.dart';

class WordsListItem extends StatefulWidget {
  final Word word;
  final bool isSaved;

  const WordsListItem({super.key, required this.word, required this.isSaved});

  @override
  State<WordsListItem> createState() => _WordsListItemState();
}

class _WordsListItemState extends State<WordsListItem> {
  bool _isTesting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.select((WordsBloc b) => b.state);

    final showEn =
        (state.showEnById[widget.word.id] ?? state.showEn) && !_isTesting;
    final showAr = state.showArById[widget.word.id] ?? state.showAr;
    final isSpeaking = state.speakingWordId == widget.word.id;

    final cs = Theme.of(context).colorScheme;
    final speakingBg = cs.primary.withAlpha(18);

    final textDecoration = widget.isSaved ? TextDecoration.lineThrough : null;
    final textOpacity = widget.isSaved ? 0.5 : 1.0;

    return BlocListener<WordsBloc, WordsState>(
      listener: (context, state) {
        setState(() {});
      },
      listenWhen: (previous, current) =>
          previous.showAr != current.showAr ||
          previous.showEn != current.showEn,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: isSpeaking
            ? speakingBg
            : widget.isSaved
            ? cs.surfaceContainerLow
            : cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: cs.outlineVariant.withAlpha(90)),
        ),
        child: InkWell(
          onLongPress: () => _showActions(context, widget.isSaved),
          onTap: () => _showTest(showEn, showAr),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ActionIcon(
                  isSaved: widget.isSaved,
                  tooltip: l10n.speak,
                  icon: Icons.volume_up_outlined,
                  isActive: isSpeaking,
                  onPressed: () => context.read<WordsBloc>().add(
                    SpeakWordRequested(widget.word.id),
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showEn ? widget.word.en : '\u2022\u2022\u2022',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: isSpeaking
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: (isSpeaking ? cs.primary : cs.onSurface)
                                  .withValues(alpha: textOpacity),
                              decoration: textDecoration,
                            ),
                      ),
                      Text(
                        showAr ? widget.word.ar : '\u2022\u2022\u2022',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant.withValues(
                            alpha: textOpacity,
                          ),
                          decoration: textDecoration,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: FittedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ActionIcon(
                          isSaved: widget.isSaved,
                          tooltip: showEn ? l10n.hideEnglish : l10n.showEnglish,
                          icon: showEn
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onPressed: () => context.read<WordsBloc>().add(
                            WordShowEnToggled(
                              wordId: widget.word.id,
                              show: !showEn,
                            ),
                          ),
                        ),
                        _ActionIcon(
                          isSaved: widget.isSaved,
                          tooltip: showAr ? l10n.hideArabic : l10n.showArabic,
                          icon: showAr
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onPressed: () => context.read<WordsBloc>().add(
                            WordShowArToggled(
                              wordId: widget.word.id,
                              show: !showAr,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showTest(bool showEn, bool showAr) async {
    setState(() {
      _isTesting = true;
    });
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) =>
          WordTestDialog(correctEn: widget.word.en, correctAr: widget.word.ar),
    );
    setState(() {
      _isTesting = false;
    });
    if (!mounted || result == null) return;
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).correctAnswer)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).wrongAnswer),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showEdit(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => WordEditDialog(
        word: widget.word,
        onSave: (Word updatedWord) {
          context.read<WordsBloc>().add(WordUpdated(updatedWord));
        },
      ),
    );
  }

  void _showActions(BuildContext context, bool isSaved) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => WordActionsDialog(
        word: widget.word,
        isSaved: isSaved,
        onEdit: () => _showEdit(context),
        onDelete: () {
          context.read<WordsBloc>().add(WordDeleted(widget.word.id));
        },
        onToggleSave: () {
          context.read<WordsBloc>().add(
            WordSavedToggled(wordId: widget.word.id, saved: !isSaved),
          );
        },
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;
  final bool isSaved;

  const _ActionIcon({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    required this.isSaved,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: FittedBox(
        child: Icon(
          icon,
          color: (isActive ? cs.primary : cs.onSurfaceVariant).withValues(
            alpha: isSaved ? 0.5 : 1,
          ),
        ),
      ),
    );
  }
}
