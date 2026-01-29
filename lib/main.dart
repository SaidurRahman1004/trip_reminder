import 'package:flutter/material.dart';
import 'package:trip_reminder/screens/homeScreen/trip_reminder_home.dart';
import 'package:trip_reminder/services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(); //navigate without context
void main() async {
  //add Notificion service
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initNotificatin();
  runApp(const TripReminderApp());
}

class TripReminderApp extends StatelessWidget {
  const TripReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'TripReminder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF008080), // Teal Color
          primary: const Color(0xFF008080),
          secondary: Colors.amberAccent,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const TripReminderHome(),
    );
  }
}
