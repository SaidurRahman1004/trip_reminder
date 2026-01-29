import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/trip_model.dart';

class TripDb {
  static final TripDb _instance = TripDb._internal();

  factory TripDb() => _instance;

  TripDb._internal();

  static TripDb get instance => _instance;
  static Database? _db;

  // Database getter for finding database
  Future<Database> get database async {
    //check if database is already created
    if (_db != null) return _db!;
    //if not create new database then return it initialize database
    _db = await _initDatabase();
    return _db!;
  }

  //initialize database //Creating Database
  Future<Database> _initDatabase() async {
    //create path for database file Name trips.db //Use join to create path
    final path = join(await getDatabasesPath(), 'trips.db');
    //open database and return it ,_onCreate: if not exist create new
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  ////1st Time Caall Whean DAtabafe is created //Create Database Table
  Future<void> _onCreate(Database db, int version) async {
    var sql = '''
            CREATE TABLE trips (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            destination TEXT,
            date TEXT,
            time TEXT,
            isActive INTEGER
          )
    ''';
    await db.execute(sql);
  }

  //Fetch All Trips
  Future<List<TripModel>> fetchAllTrips() async {
    var db = await instance.database;
    // //get all items from database and orderd by id desc
    List<Map<String, dynamic>> maps = await db.query(
      'trips',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => TripModel.fromMap(maps[i]));
  }

  //Add Trip
  Future<int> addTrip(TripModel trip) async {
    var db = await instance.database;
    return await db.insert('trips', trip.toMap());
  }

  //Update Trip Alarm on off
  Future<int> updateTrip(int id, int status) async {
    var db = await instance.database;
    return await db.update(
      'trips',
      {'isActive': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //delete
  Future<int> deleteTrip(int id) async {
    var db = await instance.database;
    return await db.delete('trips', where: 'id = ?', whereArgs: [id]);
  }

  //close db
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  //find trip by tripId
  Future<TripModel?> fetchTripById(int id) async {
    var db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'trips',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TripModel.fromMap(maps.first);
    }
    return null;
  }

  //full trip Update Logic
  Future<int> updateFullTrip(TripModel trip) async {
    var db = await instance.database;
    return db.update(
      'trips',
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }
}
