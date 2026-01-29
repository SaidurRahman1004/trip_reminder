import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:trip_reminder/services/db_helper.dart';

import '../main.dart';
import '../screens/details/trip_details_screen.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotificatin() async {
    tz.initializeTimeZones();

    //Settings For Android
    const androidInitSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    //ios
    const iosInitSettings = DarwinInitializationSettings();
    //All Settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitSettings,
          iOS: iosInitSettings,
        );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) async{
        //Tap Notification
        if (details.payload != null) {
          // Parse the payload as an integer
          int tripId = int.parse(details.payload!);
          // Navigate to the trip details screen with the trip ID
          final trip = await TripDb.instance.fetchTripById(tripId);
          if(trip != null){
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => TripDetailsScreen(trip: trip)),
            );
          }


        }

      },
    );

    //Permissins For Android and Ios
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  //schedule Alarm For Button Click
  static Future<void> scheduleAlarmNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    //AndroidDetails sound and notification
    const androidDetails = AndroidNotificationDetails(
      'trip_reminder_channel',
      'Trip Alarms',
      channelDescription: 'Notifications for scheduled trips',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'), //custom sound
      playSound: true,
    );
    //Akll ios and Anroid
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: notificationDetails,
      payload: payload,
      //if phone sleep  then show notification alarm
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: title,
      body: body,
    );
  }

  //Cancle Alarm (toggle or Switch)
  static Future<void> cancelAlarmNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  //Cancle all alarms
  static Future<void> cancelAllAlarmNotification() async {
    await _notificationsPlugin.cancelAll();
  }
}
