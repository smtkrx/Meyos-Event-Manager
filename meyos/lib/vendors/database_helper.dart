import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Initilizing variables
  static final _dbName = 'events.db';
  static final _dbVersion = 1;
  static final _eventTable = 'allEvents';
  static final _columnId = 'id';
  static final _columnTitle = 'title';
  static final _columnDate = 'date';
  static final _columnStartTime = 'startTime';
  static final _columnEndTime = 'endTime';
  static final _columnGroup = 'club';
  // For categories
  static final _catergoryTable = 'categories';
  static final _clubTitle = 'clubTitle';
  static final _clubColorCode = 'color';

  // making it a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }
//The local database has been created and split into columns and rows.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_eventTable(
      $_columnId INTEGER PRIMARY KEY,
      $_columnTitle TEXT NOT NULL,
      $_columnDate TEXT NOT NULL,
      $_columnStartTime TEXT NOT NULL,
      $_columnEndTime TEXT NOT NULL,
      $_columnGroup TEXT NOT NULL
      )
      ''');
    print(1);
    await db.execute('''
      CREATE TABLE $_catergoryTable(
      $_columnId INTEGER PRIMARY KEY,
      $_clubTitle TEXT NOT NULL,
      $_clubColorCode INTEGER NOT NULL
      )
      ''');
    print(2);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_eventTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_eventTable);
  }

  Future<List<Map<String, dynamic>>> queryAllCategories() async {
    Database db = await instance.database;
    return await db.query(_catergoryTable);
  }

  Future<int> insertclub(Map<String, dynamic> row) async {
    print(row);
    Database db = await instance.database;
    return await db.insert(_catergoryTable, row);
  }
}
