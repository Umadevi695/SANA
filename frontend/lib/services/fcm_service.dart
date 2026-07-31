import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static final FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

await flutterLocalNotificationsPlugin.initialize(
  initializationSettings,
);

    String? token = await messaging.getToken();

    print("=================================");
    print("FCM TOKEN:");
    print(token);
    print("=================================");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  print("================================");
  print("NOTIFICATION RECEIVED");
  print(message.notification?.title);
  print(message.notification?.body);
  print("================================");

  final bool isReminder = message.data["type"] == "reminder";

final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      isReminder ? "reminder_channel" : "notice_channel",
      isReminder ? "Deadline Reminders" : "Academic Notices",

      importance: isReminder
          ? Importance.max
          : Importance.high,

      priority: isReminder
          ? Priority.max
          : Priority.high,

      playSound: true,
      enableVibration: true,

      ticker: isReminder
          ? "Deadline Reminder"
          : "Academic Notice",
    );

final NotificationDetails notificationDetails =
    NotificationDetails(
      android: androidDetails,
    );

await flutterLocalNotificationsPlugin.show(
  isReminder ? 100 : 0,
  message.notification?.title,
  message.notification?.body,
  notificationDetails,
);
});
  }
}