import 'package:flutter/material.dart';
import 'package:trip_reminder/models/trip_model.dart';
import 'package:trip_reminder/services/db_helper.dart';
import 'package:trip_reminder/services/notification_service.dart';
import 'package:trip_reminder/widgets/customText.dart';
import 'package:trip_reminder/widgets/custom_button.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripModel trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Txt(txt: "Trip Details", fontWeight: FontWeight.bold),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.tealAccent,
              child: Icon(Icons.map, size: 50, color: Colors.teal),
            ),
            const SizedBox(height: 30),
            _buildInfoRow(Icons.location_on, "Destination", trip.destination),
            _buildInfoRow(Icons.calendar_month, "Date", trip.date),
            _buildInfoRow(Icons.access_time, "Time", trip.time),
            const Spacer(),
            CustomButton(
              buttonName: "Delete Trip & Stop Alarm",
              color: Colors.redAccent,
              icon: Icons.delete_forever,
              onPressed: () async {
                await NotificationService.cancelAlarmNotification(trip.id!);
                await TripDb.instance.deleteTrip(trip.id!);
                if (context.mounted) {
                  Navigator.pop(context); // ফিরে যাবে হোমস্ক্রিনে
                }
              },
            ),
            const SizedBox(height: 15),
            CustomButton(
              buttonName: "Back to Home",
              color: Colors.grey,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Txt(txt: label, fntSize: 12, color: Colors.grey),
              Txt(txt: value, fntSize: 18, fontWeight: FontWeight.bold),
            ],
          ),
        ],
      ),
    );
  }
}