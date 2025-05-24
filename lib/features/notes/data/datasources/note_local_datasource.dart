import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';

class NoteLocalDatasource {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            created_at TEXT
          )
        ''');
      },
    );
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'created_at DESC');
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<void> insertNote(NoteModel note) async {
    final db = await database;
    await db.insert('notes', note.toMap());
  }

  Future<void> updateNote(NoteModel note) async {
    final db = await database;
    await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
