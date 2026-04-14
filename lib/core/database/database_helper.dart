import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:diary_with_lock/features/home/data/models/diary_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    debugPrint("DatabaseHelper: Initializing database...");
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    debugPrint("DatabaseHelper: DB Path: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    debugPrint("DatabaseHelper: Creating diary_entries table...");
    await db.execute('''
      CREATE TABLE diary_entries (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        date TEXT,
        imagePaths TEXT,
        mood TEXT,
        tags TEXT,
        backgroundColor TEXT
      )
    ''');
  }

  Future<int> insert(DiaryEntry entry) async {
    final db = await instance.database;
    final map = _entryToMap(entry);
    debugPrint("DatabaseHelper: Inserting entry ID: ${entry.id}");
    final res = await db.insert('diary_entries', map);
    debugPrint("DatabaseHelper: Insert result: $res");
    return res;
  }

  Future<List<DiaryEntry>> getAllEntries() async {
    final db = await instance.database;
    debugPrint("DatabaseHelper: Fetching all entries...");
    final result = await db.query('diary_entries', orderBy: 'date DESC');
    debugPrint("DatabaseHelper: Fetched ${result.length} entries");
    return result.map((json) => _mapToEntry(json)).toList();
  }

  Future<int> update(DiaryEntry entry) async {
    final db = await instance.database;
    return await db.update(
      'diary_entries',
      _entryToMap(entry),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(
      'diary_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete('diary_entries');
  }

  Map<String, dynamic> _entryToMap(DiaryEntry entry) {
    final map = entry.toJson();
    // Convert lists to strings for SQLite
    if (map['imagePaths'] is List) {
      map['imagePaths'] = (map['imagePaths'] as List).join(',');
    }
    if (map['tags'] is List) {
      map['tags'] = (map['tags'] as List).join(',');
    }
    return map;
  }

  DiaryEntry _mapToEntry(Map<String, dynamic> map) {
    final mutableMap = Map<String, dynamic>.from(map);
    // Convert strings back to lists
    if (mutableMap['imagePaths'] != null && mutableMap['imagePaths'].toString().isNotEmpty) {
      mutableMap['imagePaths'] = mutableMap['imagePaths'].toString().split(',');
    } else {
      mutableMap['imagePaths'] = [];
    }
    
    if (mutableMap['tags'] != null && mutableMap['tags'].toString().isNotEmpty) {
      mutableMap['tags'] = mutableMap['tags'].toString().split(',');
    } else {
      mutableMap['tags'] = [];
    }
    
    return DiaryEntry.fromJson(mutableMap);
  }
}
