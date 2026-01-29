import 'package:flutter/material.dart';
import 'package:trip_reminder/screens/homeScreen/trip_reminder_home.dart';

void main() {
  runApp(const TripReminderApp());
}

class TripReminderApp extends StatelessWidget {
  const TripReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripReminder',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: TripReminderHome(),
    );
  }
}


