import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_save/core/services/settings_local_data_source.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../db/app_database.dart';

@pragma('vm:entry-point')
Future<NotificationsService> launchWorker([
  bool reset = false,
  NotificationsService? service,
]) async {
  final notificationsService = service ?? NotificationsService.background();
  if (reset) {
    await Workmanager().cancelAll();
    notificationsService.plugin.cancelAll();
    await SharedPreferences.getInstance().then(
      (prefs) => prefs.setInt(
        NotificationsService.lastNotificationTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
  await Workmanager().registerPeriodicTask(
    NotificationsService.channelId,
    NotificationsService.taskName,
    frequency: Duration(minutes: 15),
    initialDelay: Duration.zero,
  );
  return notificationsService;
}

class NotificationsService {
  static const String channelId = 'daily_words';
  static const String taskName = 'daily_word_notification_task';
  static const String counterKey = 'notification_word_counter';
  static const String lastNotificationTimeKey = 'last_notification_time';

  final FlutterLocalNotificationsPlugin _plugin;
  FlutterLocalNotificationsPlugin get plugin => _plugin;

  NotificationsService(this._plugin);

  NotificationsService.background()
    : _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    final String timeZoneName =
        (await FlutterTimezone.getLocalTimezone()).identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const android = AndroidInitializationSettings('noti_icon');
    const initSettings = InitializationSettings(android: android);
    await _plugin.initialize(initSettings);
    await _ensureAndroidChannel();
  }

  Future<bool> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return true;
    await android.requestExactAlarmsPermission() ?? true;
    return (await android.requestNotificationsPermission()) ?? true;
  }

  Future<void> _ensureAndroidChannel() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        channelId,
        'Daily Words',
        description: 'Tracked vocabulary reminders',
        importance: Importance.high,
      ),
    );
  }

  bool _isInWindow(DateTime time, int startMinutes, int endMinutes) {
    final nowMinutes = time.hour * 60 + time.minute;

    if (startMinutes <= endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
    } else {
      return nowMinutes >= startMinutes || nowMinutes <= endMinutes;
    }
  }

  String get _randomNotificationDescription {
    return [
      // English Support & Motivation
      "A new word to brighten your journey.",
      "Small steps lead to great distances. Keep going.",
      "Your future self will thank you for today's effort.",
      "Language is the key to a thousand worlds.",
      "Consistency is the secret of mastery.",
      "Every word you learn is a new window to the world.",
      "You are doing better than you think. Stay focused.",
      "Unlock your potential, one word at a time.",
      "Wisdom begins with the hunger for knowledge.",
      "Don't stop until you're proud.",
      "The limit of your language is the limit of your world.",
      "Success is the sum of small efforts repeated daily.",
      "Make learning your favorite habit.",
      "Growth happens outside of your comfort zone.",
      "Knowledge is the only treasure that grows when shared.",

      // Arabic Support & Motivation (تحفيزية)
      "كلمة جديدة.. خطوة أخرى نحو القمة.",
      "الاستمرارية هي سر النجاح، واصل تقدمك.",
      "كل كلمة تتعلمها اليوم هي استثمار لمستقبلك.",
      "لغتك هي مرآة فكرك، اجعلها تلمع.",
      "القليل الدائم خير من الكثير المنقطع.",
      "أنت تبني مستقبلك بكلماتك، لا تتوقف.",
      "تذكر أن رحلة الألف ميل تبدأ بكلمة واحدة.",
      "العلم نور، وأنت اليوم تزداد ضياءً.",
      "اجعل من التعلم عادة، ومن النجاح غاية.",
      "كلما زادت كلماتك، اتسعت آفاق عالمك.",
      "أنت تملك القدرة على التميز، استمر في المحاولة.",
      "لا شيء مستحيل مع الإصرار والعزيمة.",
      "اليوم كلمة، وغداً فصاحة وبيان.",
      "تعلم لغة جديدة يعني امتلاك روح ثانية.",
      "كن فخوراً بما وصلت إليه، وكن طموحاً للأفضل.",
    ][Random().nextInt(30)];
  }

  NotificationDetails get _notificationDetails {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      'Daily Words',
      icon: 'noti_icon',
      channelDescription: 'Daily vocabulary reminders',
      sound: RawResourceAndroidNotificationSound('noti_sound'),
      playSound: true,
      importance: Importance.high,
      priority: Priority.high,
    );
    return const NotificationDetails(android: androidDetails);
  }

  Future<List<WordsTableData>> _selectUnsavedWords(
    AppDatabase db, {
    required int limit,
    required int offset,
  }) {
    return (db.select(db.wordsTable)
          ..where((t) => t.isSaved.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<bool> handleBackground(
    String task,
    Map<String, dynamic>? inputData,
  ) async {
    if (task != taskName) return true;

    await init();

    final prefs = await SharedPreferences.getInstance();
    final settings = await SettingsLocalDataSourceImpl(prefs).read();
    final wordsPerDay = settings.wordsPerDay;
    final startMinutes = settings.notifyStartMinutes;
    final endMinutes = settings.notifyEndMinutes;

    if (wordsPerDay <= 0) return true;

    final now = DateTime.now();
    if (!_isInWindow(now, startMinutes, endMinutes)) return true;

    int totalWindowMinutes = 0;
    if (startMinutes <= endMinutes) {
      totalWindowMinutes = endMinutes - startMinutes;
    } else {
      totalWindowMinutes = (24 * 60 - startMinutes) + endMinutes;
    }
    if (totalWindowMinutes <= 0) totalWindowMinutes = 1;

    try {
      // 15 is for the duration of workmanager
      final wordsLimit = wordsPerDay * 15 ~/ totalWindowMinutes;
      final db = AppDatabase();
      int counter = prefs.getInt(counterKey) ?? 0;
      final allWordsCount =
          await (db.selectOnly(db.wordsTable)
                ..addColumns([db.wordsTable.id.count()])
                ..where(db.wordsTable.isSaved.equals(false)))
              .map((row) => row.read(db.wordsTable.id.count()))
              .getSingle() ??
          0;
      late final List<WordsTableData> unsavedWords;
      if (counter == allWordsCount) {
        unsavedWords = await _selectUnsavedWords(
          db,
          limit: wordsLimit,
          offset: 0,
        );
      } else if (counter + wordsLimit > allWordsCount) {
        unsavedWords = [
          ...await _selectUnsavedWords(
            db,
            limit: allWordsCount - counter,
            offset: counter,
          ),
          ...await _selectUnsavedWords(
            db,
            limit: wordsLimit - (allWordsCount - counter),
            offset: 0,
          ),
        ];
      } else {
        unsavedWords = await _selectUnsavedWords(
          db,
          limit: wordsLimit,
          offset: counter,
        );
      }

      if (unsavedWords.isEmpty) {
        await db.close();
        return true;
      }

      final wordDurationMinutes = wordsPerDay / totalWindowMinutes;
      final wordDuration = Duration(
        minutes: wordDurationMinutes.floor(),
        seconds: (wordDurationMinutes % 1 * 60).round(),
      );
      final lastNotification = prefs.getInt(lastNotificationTimeKey);
      DateTime lastNotificationTime = lastNotification != null
          ? DateTime.fromMillisecondsSinceEpoch(lastNotification)
          : DateTime.now();

      if (now.isAfter(lastNotificationTime.add(wordDuration))) {
        lastNotificationTime = now;
      }

      for (int i = 0; i < wordsLimit; i++) {
        final word = unsavedWords[i % unsavedWords.length];
        final scheduledTime = lastNotificationTime.add(wordDuration);
        if (!_isInWindow(scheduledTime, startMinutes, endMinutes)) {
          break;
        }
        lastNotificationTime = scheduledTime;
        counter = (counter + 1) % allWordsCount;

        await _plugin.zonedSchedule(
          word.id.hashCode,
          '${word.en} — ${word.ar}',
          _randomNotificationDescription,
          tz.TZDateTime.from(scheduledTime, tz.local),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          _notificationDetails,
          payload: '${word.en} - ${word.ar}',
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }

      await prefs.setInt(counterKey, counter);
      await prefs.setInt(
        lastNotificationTimeKey,
        lastNotificationTime.millisecondsSinceEpoch,
      );

      await db.close();
    } catch (e) {
      print("Error in background task: $e");
    }

    return true;
  }
}
