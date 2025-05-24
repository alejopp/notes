import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteEntity> notes;
  NoteLoaded(this.notes);
}

class NotesError extends NoteState {
  final String message;
  NotesError(this.message);
}
