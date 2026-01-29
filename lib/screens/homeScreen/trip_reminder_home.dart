import 'package:flutter/material.dart';
import 'package:trip_reminder/models/trip_model.dart';
import 'package:trip_reminder/services/db_helper.dart';
import 'package:trip_reminder/widgets/custo_snk.dart';
import 'package:trip_reminder/widgets/customText.dart';
import 'package:trip_reminder/widgets/trip_card.dart';

import '../../services/notification_service.dart';
import 'new_trip_add_screen.dart';

class TripReminderHome extends StatefulWidget {
  const TripReminderHome({super.key});

  @override
  State<TripReminderHome> createState() => _TripReminderHomeState();
}

class _TripReminderHomeState extends State<TripReminderHome> {
  //store all data from database
  late Future<List<TripModel>> _tripList;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  void _loadTrips() {
    setState(() {
      //fetch all trips from database

      _tripList = TripDb.instance.fetchAllTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TripReminder"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _loadTrips, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<List<TripModel>>(
        future: _tripList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Txt(
                txt: 'No trips planned yet!\nClick + to add a trip',
                fntSize: 16,
                textAlign: TextAlign.center,
              ),
            );
          }
          final trips = snapshot.data!;
          return ListView.builder(
            itemCount: trips.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final trip = trips[index];
              return TripCard(
                location: trip.destination,
                date: trip.date,
                time: trip.time,
                isActive: trip.isActive == 1,
                onStatusChanged: (bool value) async {
                  int newStatus = value ? 1 : 0;
                  await TripDb.instance.updateTrip(trip.id!, newStatus);
                  if (value) {
                    mySnkmsg('Alarm Turned on', context);
                  } else {
                    await NotificationService.cancelAlarmNotification(trip.id!);
                    mySnkmsg('Alarm Turned off', context);
                  }
                  _loadTrips();
                },
                onDelete: () async {
                  await NotificationService.cancelAlarmNotification(trip.id!);
                  await TripDb.instance.deleteTrip(trip.id!);
                  mySnkmsg("Trip Deleted", context, isError: true);
                  _loadTrips();
                },
                onEdit: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NewTripAddScreen(trip: trip),
                    ),
                  );
                  _loadTrips();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              child: NewTripAddScreen(),
            ),
          );
          _loadTrips();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
        tooltip: "Add Trip",
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
