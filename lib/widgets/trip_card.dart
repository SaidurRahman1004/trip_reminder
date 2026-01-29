import 'package:flutter/material.dart';
import 'package:trip_reminder/widgets/customText.dart';

class TripCard extends StatelessWidget {
  final String location;
  final String date;
  final String time;
  final bool isActive;
  final ValueChanged<bool> onStatusChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TripCard({
    super.key,
    required this.location,
    required this.date,
    required this.time,
    required this.isActive,
    required this.onStatusChanged,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt(txt: location, fontWeight: FontWeight.bold, fntSize: 18),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                        Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Txt(txt: date, fntSize: 12, color: Colors.grey),
                    const SizedBox(width: 15),
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Txt(txt: time, fntSize: 12, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: isActive,
                onChanged: onStatusChanged,
                activeColor: Colors.teal,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_note, color: Colors.green),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                        Icons.delete_outline, color: Colors.redAccent),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}