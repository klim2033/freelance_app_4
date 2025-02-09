import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Moscow')); // Set your timezone

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {
        // Handle notification tap
      },
    );
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime scheduledTime) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTZDateTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    if (scheduledTZDateTime.isBefore(now)) {
      scheduledTZDateTime = scheduledTZDateTime.add(const Duration(days: 1));
    }
    return scheduledTZDateTime;
  }

  Future<void> scheduleWaterReminder({
    required int intervalMinutes,
  }) async {
    await cancelAllNotifications();

    final now = DateTime.now();
    final scheduledTime = now.add(Duration(minutes: intervalMinutes));
    final scheduledTZDateTime = _nextInstanceOfTime(scheduledTime);

    await _notifications.zonedSchedule(
      0,
      'Время пить воду!',
      'Не забудьте выпить стакан воды',
      scheduledTZDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminder',
          'Water Reminders',
          channelDescription: 'Reminders to drink water',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
