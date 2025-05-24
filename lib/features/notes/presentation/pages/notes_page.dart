import 'package:bext_notes/core/theme/styles.dart';
import 'package:bext_notes/core/widgets/note_card.dart';
import 'package:bext_notes/features/auth/bloc/auth_bloc.dart';
import 'package:bext_notes/features/auth/bloc/auth_state.dart';
import 'package:bext_notes/features/notes/bloc/note_bloc.dart';
import 'package:bext_notes/features/notes/bloc/note_event.dart';
import 'package:bext_notes/features/notes/bloc/note_state.dart';
import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final token = authState is Authenticated ? authState.user.token : '';
    //TODO Remove

    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(context),
    );
  }

  Column _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        _buildNoteList(),
      ],
    );
  }

  Expanded _buildNoteList() {
    return Expanded(
      child: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteLoaded) {
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(child: Text('Sin notas aún.'));
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, i) {
                final note = notes[i];
                return NoteCard(note: note, onTap: () => _showNoteDialog);
              },
            );
          } else {
            return const Center(child: Text('Error cargando notas.'));
          }
        },
      ),
    );
  }

  Padding _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Buscar...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onChanged: (value) {
          context.read<NoteBloc>().add(SearchNotes(value));
        },
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text('Notas', style: AppStyles.appBarStyle),
      actions: [
        IconButton(
          icon: const Icon(Icons.sort_by_alpha),
          onPressed: () {
            context.read<NoteBloc>().add(SortNotes(byTitle: true));
          },
          tooltip: 'Ordenar por título',
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            context.read<NoteBloc>().add(SortNotes(byTitle: false));
          },
          tooltip: 'Ordenar por fecha',
        ),
      ],
    );
  }

  void _showNoteDialog(BuildContext context, {NoteEntity? note}) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(note == null ? 'Nueva Nota' : 'Editar Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Contenido'),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final newNote = NoteEntity(
                id: note?.id,
                title: titleController.text,
                content: contentController.text,
                createdAt: DateTime.now(),
              );
              final bloc = context.read<NoteBloc>();
              if (note == null) {
                bloc.add(AddNote(newNote));
              } else {
                bloc.add(UpdateNote(newNote));
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
