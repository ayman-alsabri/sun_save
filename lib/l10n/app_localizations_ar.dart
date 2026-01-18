// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سن سيف';

  @override
  String get wordsTitle => 'الكلمات';

  @override
  String get unsavedTab => 'غير محفوظة';

  @override
  String get savedTab => 'محفوظة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get aboutTitle => 'حول التطبيق';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get loginButton => 'دخول';

  @override
  String get registerButton => 'إنشاء حساب';

  @override
  String get goToRegister => 'إنشاء حساب جديد';

  @override
  String get goToLogin => 'لدي حساب بالفعل';

  @override
  String get addWordTitle => 'إضافة كلمة';

  @override
  String get englishLabel => 'الإنجليزية';

  @override
  String get arabicLabel => 'العربية';

  @override
  String get addToSaved => 'إضافة إلى المحفوظة';

  @override
  String get addToUnsaved => 'إضافة إلى غير المحفوظة';

  @override
  String get addWordFab => 'أضف كلمة';

  @override
  String get autoTranslate => 'ترجمة تلقائية';

  @override
  String get comingSoonTitle => 'قريباً';

  @override
  String get ttsIterations => 'تكرار النطق';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get theme => 'المظهر';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get speak => 'نطق';

  @override
  String get speakSaved => 'نطق المحفوظة';

  @override
  String get speakUnsaved => 'نطق غير المحفوظة';

  @override
  String get shuffle => 'ترتيب عشوائي';

  @override
  String get reshuffle => 'إعادة العشوائية';

  @override
  String get resetOrder => 'إعادة الترتيب';

  @override
  String get showEnglish => 'إظهار الإنجليزية';

  @override
  String get showArabic => 'إظهار العربية';

  @override
  String get hideEnglish => 'إخفاء الإنجليزية';

  @override
  String get hideArabic => 'إخفاء العربية';

  @override
  String get save => 'حفظ';

  @override
  String get unsave => 'إلغاء الحفظ';

  @override
  String get options => 'الخيارات';

  @override
  String get snackSaved => 'تم الحفظ';

  @override
  String get snackUnsaved => 'تم الإلغاء';

  @override
  String get snackWordAdded => 'تمت الإضافة';

  @override
  String get validationRequiredEnglish => 'الكلمة الإنجليزية مطلوبة';

  @override
  String get validationRequiredArabic => 'الترجمة العربية مطلوبة';

  @override
  String get validationTooShort => 'قصير جداً';

  @override
  String routeNotFound(String route) {
    return 'المسار غير موجود: $route';
  }

  @override
  String get testTitle => 'اختبار';

  @override
  String get typeWhatYouRemember => 'اكتب ما تتذكر';

  @override
  String get close => 'إغلاق';

  @override
  String get editWordTitle => 'تعديل الكلمة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get correctAnswer => 'صحيح!';

  @override
  String get wrongAnswer => 'إجابة خاطئة. حاول مرة أخرى!';

  @override
  String get play => 'تشغيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get stop => 'إيقاف';

  @override
  String get paused => 'متوقف مؤقتًا';

  @override
  String get wordsMsgSaved => 'تم الحفظ';

  @override
  String get wordsMsgUnsaved => 'تمت الإزالة من المحفوظات';

  @override
  String get wordsMsgNothingToSpeak => 'لا يوجد ما يمكن نطقه';

  @override
  String get wordsMsgNothingToSpeakBothHidden =>
      'لا يوجد ما يمكن نطقه (كلاهما مخفي)';

  @override
  String wordsMsgTtsFailed(String error) {
    return 'فشل النطق: $error';
  }

  @override
  String wordsMsgFailed(String error) {
    return 'فشل: $error';
  }

  @override
  String wordsMsgLoadFailed(String error) {
    return 'فشل تحميل الكلمات: $error';
  }

  @override
  String get notifications => 'الإشعارات';

  @override
  String get wordsPerDay => 'عدد الكلمات يوميًا';

  @override
  String get notifyStartTime => 'وقت البدء';

  @override
  String get notifyEndTime => 'وقت الانتهاء';

  @override
  String get applyNotificationSchedule => 'تطبيق الجدول';

  @override
  String get noSavedWords => 'لا توجد كلمات محفوظة';

  @override
  String get noUnsavedWords => 'لا توجد كلمات غير محفوظة';

  @override
  String get autoTranslateError => 'فشلت الترجمة';

  @override
  String get autoTranslateNoSuggestions => 'لا توجد اقتراحات';

  @override
  String get notificationsChannelName => 'تذكير الكلمات اليومية';

  @override
  String get notificationsChannelDescription =>
      'تذكيرات للتدرب على الكلمات يوميًا';
}
