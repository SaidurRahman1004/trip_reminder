class TripModel {
  final int? id;
  final String destination;
  final String date;
  final String time;
  final int isActive;

  TripModel({
    this.id,
    required this.destination,
    required this.date,
    required this.time,
    this.isActive = 1,
  });
//get data from database
  factory TripModel.fromMap(Map<String, dynamic> json) => TripModel(
    id: json['id'],
    destination: json['destination'],
    date: json['date'],
    time: json['time'],
    isActive: json['isActive'],
  );
//sent data database
  Map<String, dynamic> toMap() => {
    'id': id,
    'destination': destination,
    'date': date,
    'time': time,
    'isActive': isActive,
  };
}
