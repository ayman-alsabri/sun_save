// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sun Save';

  @override
  String get wordsTitle => 'Words';

  @override
  String get unsavedTab => 'Unsaved';

  @override
  String get savedTab => 'Saved';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get aboutTitle => 'About';

  @override
  String get loginTitle => 'Login';

  @override
  String get registerTitle => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get nameLabel => 'Name';

  @override
  String get loginButton => 'Login';

  @override
  String get registerButton => 'Create account';

  @override
  String get goToRegister => 'Create an account';

  @override
  String get goToLogin => 'I already have an account';

  @override
  String get addWordTitle => 'Add a word';

  @override
  String get englishLabel => 'English';

  @override
  String get arabicLabel => 'Arabic';

  @override
  String get addToSaved => 'Add to Saved';

  @override
  String get addToUnsaved => 'Add to Unsaved';

  @override
  String get addWordFab => 'Add a word';

  @override
  String get autoTranslate => 'Auto translate';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get ttsIterations => 'TTS iterations';

  @override
  String get appLanguage => 'App language';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get speak => 'Speak';

  @override
  String get speakSaved => 'Speak Saved';

  @override
  String get speakUnsaved => 'Speak Unsaved';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get reshuffle => 'Reshuffle';

  @override
  String get resetOrder => 'Reset order';

  @override
  String get showEnglish => 'Show English';

  @override
  String get showArabic => 'Show Arabic';

  @override
  String get hideEnglish => 'Hide English';

  @override
  String get hideArabic => 'Hide Arabic';

  @override
  String get save => 'Save';

  @override
  String get unsave => 'Unsave';

  @override
  String get options => 'Options';

  @override
  String get snackSaved => 'Saved';

  @override
  String get snackUnsaved => 'Unsaved';

  @override
  String get snackWordAdded => 'Word added';

  @override
  String get validationRequiredEnglish => 'English word is required';

  @override
  String get validationRequiredArabic => 'Arabic translation is required';

  @override
  String get validationTooShort => 'Too short';

  @override
  String routeNotFound(String route) {
    return 'Route not found: $route';
  }

  @override
  String get testTitle => 'Test';

  @override
  String get typeWhatYouRemember => 'Type what you remember';

  @override
  String get close => 'Close';

  @override
  String get editWordTitle => 'Edit word';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get correctAnswer => 'Correct!';

  @override
  String get wrongAnswer => 'Wrong answer. Try again!';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get paused => 'Paused';

  @override
  String get wordsMsgSaved => 'Saved';

  @override
  String get wordsMsgUnsaved => 'Unsaved';

  @override
  String get wordsMsgNothingToSpeak => 'Nothing to speak';

  @override
  String get wordsMsgNothingToSpeakBothHidden =>
      'Nothing to speak (both hidden)';

  @override
  String wordsMsgTtsFailed(String error) {
    return 'TTS failed: $error';
  }

  @override
  String wordsMsgFailed(String error) {
    return 'Failed: $error';
  }

  @override
  String wordsMsgLoadFailed(String error) {
    return 'Failed to load words: $error';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get wordsPerDay => 'Words per day';

  @override
  String get notifyStartTime => 'Start time';

  @override
  String get notifyEndTime => 'End time';

  @override
  String get applyNotificationSchedule => 'Apply schedule';

  @override
  String get noSavedWords => 'No saved words';

  @override
  String get noUnsavedWords => 'No unsaved words';

  @override
  String get autoTranslateError => 'Translation failed';

  @override
  String get autoTranslateNoSuggestions => 'No suggestions';

  @override
  String get notificationsChannelName => 'Daily words';

  @override
  String get notificationsChannelDescription => 'Daily word practice reminders';
}
