import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../features/words/domain/entities/word.dart';
import '../../l10n/app_localizations.dart';

class NotificationsService {
  static const String channelId = 'daily_words';
  static const int _baseId = 2000;
  static const int _maxScheduled = 200; // safety cap

  final FlutterLocalNotificationsPlugin _plugin;

  NotificationsService(this._plugin);

  Future<void> init() async {
    tzdata.initializeTimeZones();

    // Ensure tz.local is initialized; without a native timezone plugin we fall
    // back to UTC to avoid crashes.
    try {
      tz.setLocalLocation(tz.local);
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);
    await _plugin.initialize(initSettings);

    // Create channel on Android.
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        // These will be overridden by localized channel creation below when
        // scheduleDailyWords is called.
        'daily_words',
        description: 'daily_words',
        importance: Importance.high,
      ),
    );
  }

  Future<void> _ensureAndroidChannel(AppLocalizations l10n) async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        channelId,
        l10n.notificationsChannelName,
        description: l10n.notificationsChannelDescription,
        importance: Importance.high,
      ),
    );
  }

  Future<bool> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return true;
    return (await android.requestNotificationsPermission()) ?? true;
  }

  Future<void> cancelAllScheduled() => _plugin.cancelAll();

  /// Schedules [count] notifications per day, spaced within the time window.
  ///
  /// The notification body will include English + Arabic for the chosen unsaved
  /// words.
  ///
  /// Minutes are minutes-from-midnight in local time.
  /// If end <= start, it is treated as spanning midnight (end is next day).
  Future<void> scheduleDailyWords({
    required int count,
    required int startMinutes,
    required int endMinutes,
    required AppLocalizations l10n,
    required List<Word> unsavedWords,
  }) async {
    // Ensure Android channel exists with localized name/description.
    await _ensureAndroidChannel(l10n);

    await cancelAllScheduled();

    if (count <= 0) return;
    if (unsavedWords.isEmpty) return;

    final target = min(count, unsavedWords.length);
    if (target <= 0) return;

    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime start = _dateTimeFromMinutes(now, startMinutes);
    tz.TZDateTime end = _dateTimeFromMinutes(now, endMinutes);
    if (!end.isAfter(start)) {
      end = end.add(const Duration(days: 1));
    }

    // If the entire window is in the past, move to next day.
    if (!end.isAfter(now)) {
      start = start.add(const Duration(days: 1));
      end = end.add(const Duration(days: 1));
    }

    // Ensure start isn't in the past.
    if (!start.isAfter(now)) {
      start = now.add(const Duration(minutes: 1));
    }
    if (!end.isAfter(start)) return;

    final windowMinutes = end.difference(start).inMinutes;
    if (windowMinutes <= 0) return;

    final spacing = max(1, (windowMinutes / target).floor());

    final androidDetails = AndroidNotificationDetails(
      channelId,
      l10n.wordsTitle,
      channelDescription: l10n.wordsTitle,
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);

    // Pick which words to show today.
    final chosen = List<Word>.from(unsavedWords);
    chosen.shuffle();

    for (var i = 0; i < target && i < _maxScheduled; i++) {
      final id = _baseId + i;
      var scheduledAt = start.add(Duration(minutes: i * spacing));
      if (!end.isAfter(scheduledAt)) {
        scheduledAt = end.subtract(const Duration(minutes: 1));
      }

      final w = chosen[i];
      final body = '${w.en} — ${w.ar}';

      await _plugin.zonedSchedule(
        id,
        l10n.wordsTitle,
        body,
        scheduledAt,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: w.id,
      );
    }
  }

  tz.TZDateTime _dateTimeFromMinutes(
    tz.TZDateTime day,
    int minutesFromMidnight,
  ) {
    final m = minutesFromMidnight.clamp(0, 1439);
    return tz.TZDateTime(
      tz.local,
      day.year,
      day.month,
      day.day,
      m ~/ 60,
      m % 60,
    );
  }
}
