import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';
import 'package:bext_notes/features/notes/domain/repositories/note_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NotesEvent, NoteState> {
  final NoteRepository repository;
  List<NoteEntity> _allNotes = [];

  NoteBloc(this.repository) : super(NoteInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      try {
        _allNotes = await repository.getNotes();
        emit(NoteLoaded(List.from(_allNotes)));
      } catch (_) {
        emit(NotesError('Error cargando notas'));
      }
    });

    on<AddNote>((event, emit) async {
      await repository.addNote(event.note);
      add(LoadNotes());
    });

    on<UpdateNote>((event, emit) async {
      await repository.updateNote(event.note);
      add(LoadNotes());
    });

    on<DeleteNote>((event, emit) async {
      await repository.deleteNote(event.id);
      add(LoadNotes());
    });

    on<SearchNotes>((event, emit) {
      if (event.query.trim().isEmpty) {
        emit(NoteLoaded(List.from(_allNotes)));
        return;
      }

      final filtered = _allNotes
          .where((note) =>
              note.title.toLowerCase().contains(event.query.toLowerCase()) ||
              note.content.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(NoteLoaded(filtered));
    });

    on<SortNotes>((event, emit) {
      final sorted = List<NoteEntity>.from(
          state is NoteLoaded ? (state as NoteLoaded).notes : _allNotes);
      sorted.sort((a, b) {
        if (event.byTitle) {
          return a.title.compareTo(b.title);
        } else {
          return b.createdAt.compareTo(a.createdAt);
        }
      });
      emit(NoteLoaded(sorted));
    });
  }
}
