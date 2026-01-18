import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Sun Save'**
  String get appTitle;

  /// No description provided for @wordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get wordsTitle;

  /// No description provided for @unsavedTab.
  ///
  /// In en, this message translates to:
  /// **'Unsaved'**
  String get unsavedTab;

  /// No description provided for @savedTab.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTab;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerButton;

  /// No description provided for @goToRegister.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get goToRegister;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get goToLogin;

  /// No description provided for @addWordTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a word'**
  String get addWordTitle;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @arabicLabel.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLabel;

  /// No description provided for @addToSaved.
  ///
  /// In en, this message translates to:
  /// **'Add to Saved'**
  String get addToSaved;

  /// No description provided for @addToUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Add to Unsaved'**
  String get addToUnsaved;

  /// No description provided for @addWordFab.
  ///
  /// In en, this message translates to:
  /// **'Add a word'**
  String get addWordFab;

  /// No description provided for @autoTranslate.
  ///
  /// In en, this message translates to:
  /// **'Auto translate'**
  String get autoTranslate;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// No description provided for @ttsIterations.
  ///
  /// In en, this message translates to:
  /// **'TTS iterations'**
  String get ttsIterations;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @speak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speak;

  /// No description provided for @speakSaved.
  ///
  /// In en, this message translates to:
  /// **'Speak Saved'**
  String get speakSaved;

  /// No description provided for @speakUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Speak Unsaved'**
  String get speakUnsaved;

  /// No description provided for @shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @reshuffle.
  ///
  /// In en, this message translates to:
  /// **'Reshuffle'**
  String get reshuffle;

  /// No description provided for @resetOrder.
  ///
  /// In en, this message translates to:
  /// **'Reset order'**
  String get resetOrder;

  /// No description provided for @showEnglish.
  ///
  /// In en, this message translates to:
  /// **'Show English'**
  String get showEnglish;

  /// No description provided for @showArabic.
  ///
  /// In en, this message translates to:
  /// **'Show Arabic'**
  String get showArabic;

  /// No description provided for @hideEnglish.
  ///
  /// In en, this message translates to:
  /// **'Hide English'**
  String get hideEnglish;

  /// No description provided for @hideArabic.
  ///
  /// In en, this message translates to:
  /// **'Hide Arabic'**
  String get hideArabic;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @unsave.
  ///
  /// In en, this message translates to:
  /// **'Unsave'**
  String get unsave;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @snackSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get snackSaved;

  /// No description provided for @snackUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved'**
  String get snackUnsaved;

  /// No description provided for @snackWordAdded.
  ///
  /// In en, this message translates to:
  /// **'Word added'**
  String get snackWordAdded;

  /// No description provided for @validationRequiredEnglish.
  ///
  /// In en, this message translates to:
  /// **'English word is required'**
  String get validationRequiredEnglish;

  /// No description provided for @validationRequiredArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic translation is required'**
  String get validationRequiredArabic;

  /// No description provided for @validationTooShort.
  ///
  /// In en, this message translates to:
  /// **'Too short'**
  String get validationTooShort;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Route not found: {route}'**
  String routeNotFound(String route);

  /// No description provided for @testTitle.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testTitle;

  /// No description provided for @typeWhatYouRemember.
  ///
  /// In en, this message translates to:
  /// **'Type what you remember'**
  String get typeWhatYouRemember;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @editWordTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit word'**
  String get editWordTitle;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correctAnswer;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong answer. Try again!'**
  String get wrongAnswer;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @wordsMsgSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get wordsMsgSaved;

  /// No description provided for @wordsMsgUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved'**
  String get wordsMsgUnsaved;

  /// No description provided for @wordsMsgNothingToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Nothing to speak'**
  String get wordsMsgNothingToSpeak;

  /// No description provided for @wordsMsgNothingToSpeakBothHidden.
  ///
  /// In en, this message translates to:
  /// **'Nothing to speak (both hidden)'**
  String get wordsMsgNothingToSpeakBothHidden;

  /// No description provided for @wordsMsgTtsFailed.
  ///
  /// In en, this message translates to:
  /// **'TTS failed: {error}'**
  String wordsMsgTtsFailed(String error);

  /// No description provided for @wordsMsgFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String wordsMsgFailed(String error);

  /// No description provided for @wordsMsgLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load words: {error}'**
  String wordsMsgLoadFailed(String error);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @wordsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Words per day'**
  String get wordsPerDay;

  /// No description provided for @notifyStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get notifyStartTime;

  /// No description provided for @notifyEndTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get notifyEndTime;

  /// No description provided for @applyNotificationSchedule.
  ///
  /// In en, this message translates to:
  /// **'Apply schedule'**
  String get applyNotificationSchedule;

  /// No description provided for @noSavedWords.
  ///
  /// In en, this message translates to:
  /// **'No saved words'**
  String get noSavedWords;

  /// No description provided for @noUnsavedWords.
  ///
  /// In en, this message translates to:
  /// **'No unsaved words'**
  String get noUnsavedWords;

  /// No description provided for @autoTranslateError.
  ///
  /// In en, this message translates to:
  /// **'Translation failed'**
  String get autoTranslateError;

  /// No description provided for @autoTranslateNoSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions'**
  String get autoTranslateNoSuggestions;

  /// No description provided for @notificationsChannelName.
  ///
  /// In en, this message translates to:
  /// **'Daily words'**
  String get notificationsChannelName;

  /// No description provided for @notificationsChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Daily word practice reminders'**
  String get notificationsChannelDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
