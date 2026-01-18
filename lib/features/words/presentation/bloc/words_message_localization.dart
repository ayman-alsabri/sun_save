import '../../../../l10n/app_localizations.dart';
import 'words_bloc.dart';

extension WordsMessageL10n on WordsMessage {
  String localize(AppLocalizations l10n) {
    switch (key) {
      case WordsMessageKey.saved:
        return l10n.wordsMsgSaved;
      case WordsMessageKey.unsaved:
        return l10n.wordsMsgUnsaved;
      case WordsMessageKey.nothingToSpeak:
        return l10n.wordsMsgNothingToSpeak;
      case WordsMessageKey.nothingToSpeakBothHidden:
        return l10n.wordsMsgNothingToSpeakBothHidden;
      case WordsMessageKey.ttsFailed:
        return l10n.wordsMsgTtsFailed('${args['error'] ?? ''}');
      case WordsMessageKey.failed:
        return l10n.wordsMsgFailed('${args['error'] ?? ''}');
      case WordsMessageKey.loadFailed:
        return l10n.wordsMsgLoadFailed('${args['error'] ?? ''}');
    }
  }
}
