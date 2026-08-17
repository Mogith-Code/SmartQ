import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showTurnApproachingNotification({
    required String ticketNumber,
    required String counterName,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'smartq_queue_channel',
      'Queue Alerts',
      channelDescription: 'Notifications when your queue turn is approaching',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      1,
      'Your Turn is Coming Up! 🚨',
      'Ticket $ticketNumber at $counterName is only 2 spots away. Start heading over!',
      notificationDetails,
    );
  }
}
