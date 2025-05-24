import 'package:bext_notes/features/notes/data/datasources/note_local_datasource.dart';
import 'package:bext_notes/features/notes/data/models/note_model.dart';
import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';
import 'package:bext_notes/features/notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDatasource datasource;

  NoteRepositoryImpl(this.datasource);

  @override
  Future<List<NoteEntity>> getNotes() async {
    return await datasource.getNotes();
  }

  @override
  Future<void> addNote(NoteEntity note) async {
    await datasource.insertNote(NoteModel(
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
    ));
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    await datasource.updateNote(NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
    ));
  }

  @override
  Future<void> deleteNote(int id) async {
    await datasource.deleteNote(id);
  }
}
