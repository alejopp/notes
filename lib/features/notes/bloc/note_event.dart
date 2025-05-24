import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';

abstract class NotesEvent {}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final NoteEntity note;
  AddNote(this.note);
}

class UpdateNote extends NotesEvent {
  final NoteEntity note;
  UpdateNote(this.note);
}

class DeleteNote extends NotesEvent {
  final int id;
  DeleteNote(this.id);
}

class SearchNotes extends NotesEvent {
  final String query;
  SearchNotes(this.query);
}

class SortNotes extends NotesEvent {
  final bool byTitle;
  SortNotes({required this.byTitle});
}
