import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/diary.dart';

class DatabaseHelper {
  static const _dbName = 'mydairy.db';
  static const _dbVersion = 1;
  static const _tableName = 'diary_entries';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        imagePath TEXT
      )
      ''');
  }

  Future<int> insert(Diary diary) async {
    Database db = await instance.database;
    return await db.insert(_tableName, diary.toMap());
  }

  Future<List<Diary>> queryAll() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = 
        await db.query(_tableName, orderBy: "date DESC");
    
    return List.generate(maps.length, (i) {
      return Diary.fromMap(maps[i]);
    });
  }

  Future<int> update(Diary diary) async {
    Database db = await instance.database;
    return await db.update(
      _tableName,
      diary.toMap(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}