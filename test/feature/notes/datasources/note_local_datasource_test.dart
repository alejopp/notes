import 'package:bext_notes/features/notes/data/datasources/note_local_datasource.dart';
import 'package:bext_notes/features/notes/data/models/note_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late NoteLocalDatasource datasource;
  late Database db;

  setUpAll(() {
    // Inicializa FFI para sqflite
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactory.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
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
        ));

    datasource = NoteLocalDatasource(testDb: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('inserta y recupera una nota', () async {
    final note = NoteModel(
      id: null,
      title: 'Nota de prueba',
      content: 'Contenido',
      createdAt: DateTime.now(),
    );

    await datasource.insertNote(note);

    final notes = await datasource.getNotes();

    expect(notes.length, 1);
    expect(notes.first.title, equals('Nota de prueba'));
  });

  test('actualiza una nota', () async {
    final note = NoteModel(
      id: null,
      title: 'Original',
      content: 'Contenido original',
      createdAt: DateTime.now(),
    );

    await datasource.insertNote(note);
    final notes = await datasource.getNotes();
    final insertedNote = notes.first;

    final updatedNote = NoteModel(
      id: insertedNote.id,
      title: 'Actualizada',
      content: 'Contenido actualizado',
      createdAt: insertedNote.createdAt,
    );

    await datasource.updateNote(updatedNote);

    final updatedNotes = await datasource.getNotes();
    expect(updatedNotes.first.title, equals('Actualizada'));
    expect(updatedNotes.first.content, equals('Contenido actualizado'));
  });

  test('elimina una nota', () async {
    final note = NoteModel(
      id: null,
      title: 'Eliminar',
      content: 'Esta será eliminada',
      createdAt: DateTime.now(),
    );

    await datasource.insertNote(note);
    var notes = await datasource.getNotes();
    final insertedNote = notes.first;

    await datasource.deleteNote(insertedNote.id!);

    notes = await datasource.getNotes();
    expect(notes, isEmpty);
  });

  test('obtiene multiples notas en orden de creacion descendente', () async {
    final now = DateTime.now();
    final notes = [
      NoteModel(
        id: null,
        title: 'Primera',
        content: 'A',
        createdAt: now.subtract(Duration(days: 2)),
      ),
      NoteModel(
        id: null,
        title: 'Segunda',
        content: 'B',
        createdAt: now.subtract(Duration(days: 1)),
      ),
      NoteModel(
        id: null,
        title: 'Tercera',
        content: 'C',
        createdAt: now,
      ),
    ];

    for (var note in notes) {
      await datasource.insertNote(note);
    }

    final storedNotes = await datasource.getNotes();
    expect(storedNotes.length, 3);
    expect(storedNotes.first.title, 'Tercera'); // más reciente
    expect(storedNotes.last.title, 'Primera'); // más antigua
  });
}
