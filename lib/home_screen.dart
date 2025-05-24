import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/theme_cubit.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/notes/bloc/note_bloc.dart';
import 'features/notes/bloc/note_event.dart';
import 'features/notes/bloc/note_state.dart';
import 'features/notes/domain/entities/note_entity.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final token = authState is Authenticated ? authState.user.token : '';

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Notas', style: TextStyle(fontWeight: FontWeight.bold)),
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'Token: $token',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Padding(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) {
                  return Switch(
                    value: mode == ThemeMode.dark,
                    onChanged: (val) =>
                        context.read<ThemeCubit>().toggleTheme(val),
                    activeColor: Colors.teal,
                  );
                },
              ),
              const Text('Modo oscuro'),
              const SizedBox(width: 16),
            ],
          ),
          Expanded(
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
                      return Card(
                        color: Colors.teal[900],
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(note.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () => _showNoteDialog(context, note: note),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () {
                              context
                                  .read<NoteBloc>()
                                  .add(DeleteNote(note.id!));
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Error cargando notas.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
