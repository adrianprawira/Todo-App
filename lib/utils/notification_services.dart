import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  NotificationService();

  FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  void initialize() async {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSetting = InitializationSettings(android: android);
    await notificationPlugin.initialize(initSetting);
  }

  Future<void> setNotificationSchedule(
      int id, String? title, DateTime date) async {
    int _id = id;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Todo List', 'Todo List', 'Todo List Notification');
    var notifDetails =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    return notificationPlugin.zonedSchedule(
      _id++,
      title,
      'U HAVE A TASK TO DO, MY FRIEND!',
      TZDateTime.from(date, local),
      notifDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
