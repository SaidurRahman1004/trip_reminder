import 'package:flutter/material.dart';

import 'new_trip_add_screen.dart';

class TripReminderHome extends StatelessWidget {
  const TripReminderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TripReminder"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: NewTripAddScreen(),
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
        tooltip: "Add Trip",
        elevation: 5,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),

      ),
    );
  }
}
