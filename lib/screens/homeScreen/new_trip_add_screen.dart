import 'package:flutter/material.dart';
import 'package:trip_reminder/models/trip_model.dart';
import 'package:trip_reminder/widgets/custo_snk.dart';
import 'package:trip_reminder/widgets/customRow.dart';
import 'package:trip_reminder/widgets/custom_button.dart';
import '../../services/db_helper.dart';
import '../../services/notification_service.dart';
import '../../widgets/customText.dart';
import '../../widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class NewTripAddScreen extends StatefulWidget {
  final TripModel? trip; //For edit trip
  const NewTripAddScreen({super.key, this.trip});

  @override
  State<NewTripAddScreen> createState() => _NewTripAddScreenState();
}

class _NewTripAddScreenState extends State<NewTripAddScreen> {
  final _destinationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    //if edit mode feild fill with data
    if (widget.trip != null) {
      _destinationController.text = widget.trip!.destination;
      _dateController.text = widget.trip!.date;
      _timeController.text = widget.trip!.time;
      _selectedDate = DateFormat('MM/dd/yyyy').parse(widget.trip!.date);
    }
  }

  //date select Methode
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickeddate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickeddate != null) {
      setState(() {
        _selectedDate = pickeddate;
        _dateController.text = DateFormat('MM/dd/yyyy').format(pickeddate);
      });
    }
  }

  //Time Select Methode
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        _selectedDate?.year ?? now.year,
        _selectedDate?.month ?? now.month,
        _selectedDate?.day ?? now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (selectedDateTime.isBefore(now)) {
        if (mounted)
          mySnkmsg('Cannot select past time!', context, isError: true);
        return;
      }
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  //SaveTrip
  void _saveTrip() async {
    if (_destinationController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty) {
      mySnkmsg('All fields are required!', context, isError: true);
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      mySnkmsg('Please select valid date and time!', context, isError: true);
      return;
    }

    final alarmDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (alarmDateTime.isBefore(DateTime.now())) {
      mySnkmsg('Cannot set alarm for past time!', context, isError: true);
      return;
    }

    TripModel newtrip = TripModel(
      id: widget.trip?.id,
      destination: _destinationController.text.trim(),
      date: _dateController.text,
      time: _timeController.text,
      isActive: 1,
    );

    try {
      int tripId;
      if (widget.trip == null) {
        tripId = await TripDb.instance.addTrip(newtrip);
      } else {
        await TripDb.instance.updateFullTrip(newtrip);
        tripId = widget.trip!.id!;
        await NotificationService.cancelAlarmNotification(tripId);
      }

      await NotificationService.scheduleAlarmNotification(
        id: tripId,
        title: widget.trip == null ? 'New Journey!' : 'Journey Updated!',
        body: 'Heading to ${newtrip.destination} at ${newtrip.time}',
        scheduledDate: alarmDateTime,
        payload: tripId.toString(),
      );

      if (mounted) {
        mySnkmsg(widget.trip == null ? 'Trip Saved!' : 'Trip Updated!', context);
        Navigator.pop(context);
      }
    } catch (e) {
      mySnkmsg('Error: $e', context, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding * 0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Txt(
                txt: "Plan New Journey",
                fntSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 25),
              CustomRow(icon: Icons.location_on_outlined, label: 'Destination'),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _destinationController,
                labelText: 'Enter Your Destination',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomRow(
                          icon: Icons.calendar_month_outlined,
                          label: 'Date',
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: CustomTextField(
                              controller: _dateController,
                              labelText: 'mm/dd/yyyy',
                              prefixIcon: Icons.date_range,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomRow(icon: Icons.access_time, label: 'Time'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectTime(context),
                          child: AbsorbPointer(
                            child: CustomTextField(
                              controller: _timeController,
                              labelText: 'HH:MM',
                              prefixIcon: Icons.more_time,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonName: 'Save Trip',
                onPressed: _saveTrip,
                color: Colors.lightBlueAccent,
                icon: Icons.save,
              ),
              const SizedBox(height: 10),
              CustomButton(
                buttonName: 'Cancel',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
