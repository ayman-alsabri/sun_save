import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../words/presentation/bloc/words_bloc.dart';

class TtsControlsBar extends StatelessWidget {
  const TtsControlsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordsBloc, WordsState>(
      buildWhen: (p, c) =>
          p.speakingStatus != c.speakingStatus ||
          p.speakingMode != c.speakingMode ||
          p.speakingWordId != c.speakingWordId ||
          p.speakingItemIndex != c.speakingItemIndex ||
          p.speakingItemTotal != c.speakingItemTotal,
      builder: (context, state) {
        if (state.speakingMode == SpeakingMode.none) {
          return const SizedBox.shrink();
        }

        final isPlaying = state.speakingStatus == SpeakingStatus.playing;
        final isPaused = state.speakingStatus == SpeakingStatus.paused;

        final title = switch (state.speakingMode) {
          SpeakingMode.unsavedList => 'Speaking: Unsaved',
          SpeakingMode.savedList => 'Speaking: Saved',
          SpeakingMode.single => 'Speaking',
          SpeakingMode.none => '',
        };

        final progress =
            (state.speakingItemTotal <= 0 || state.speakingItemIndex < 0)
            ? ''
            : ' ${state.speakingItemIndex + 1}/${state.speakingItemTotal}';

        return SafeArea(
          top: false,
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$title$progress',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: isPlaying ? 'Pause' : 'Play',
                    onPressed: () {
                      final bloc = context.read<WordsBloc>();
                      if (isPlaying) {
                        bloc.add(const SpeakPauseRequested());
                      } else {
                        // Resume only (doesn't restart list).
                        bloc.add(const SpeakResumeRequested());
                      }
                    },
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                  IconButton(
                    tooltip: 'Stop',
                    onPressed: () => context.read<WordsBloc>().add(
                      const SpeakStopRequested(),
                    ),
                    icon: const Icon(Icons.stop),
                  ),
                  if (isPaused)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text('Paused'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
