import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initSettings,
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService init error (graceful fallback): $e');
    }
  }

  Future<bool> requestPermission() async {
    try {
      if (!_isInitialized) await initialize();

      final androidImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        final granted = await androidImpl.requestNotificationsPermission();
        return granted ?? false;
      }

      final iosImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (iosImpl != null) {
        final granted = await iosImpl.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }

      return true;
    } catch (e) {
      debugPrint('NotificationService permission error: $e');
      return false;
    }
  }

  Future<void> scheduleHabitReminder({
    required int notificationId,
    required String habitTitle,
    required String timeString, // "08:30"
  }) async {
    try {
      if (!_isInitialized) await initialize();

      const androidDetails = AndroidNotificationDetails(
        'verdant_habits_channel',
        'Alışkanlık Hatırlatıcıları',
        channelDescription: 'Günlük alışkanlıklarınızı hatırlatan nazik bildirimler',
        importance: Importance.high,
        priority: Priority.high,
      );

      const darwinDetails = DarwinNotificationDetails();

      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      await _notificationsPlugin.show(
        id: notificationId,
        title: 'Ritüel Zamanı: $habitTitle',
        body: 'Bugün kendin için güzel bir adım at.',
        notificationDetails: details,
      );
    } catch (e) {
      debugPrint('NotificationService schedule error: $e');
    }
  }

  Future<void> cancelReminder(int notificationId) async {
    try {
      if (!_isInitialized) await initialize();
      await _notificationsPlugin.cancel(id: notificationId);
    } catch (e) {
      debugPrint('NotificationService cancel error: $e');
    }
  }
}
