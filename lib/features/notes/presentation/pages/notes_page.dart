import 'package:bext_notes/core/widgets/cards/note_card.dart';
import 'package:bext_notes/features/auth/bloc/auth_bloc.dart';
import 'package:bext_notes/features/auth/bloc/auth_state.dart';
import 'package:bext_notes/features/notes/bloc/note_bloc.dart';
import 'package:bext_notes/features/notes/bloc/note_event.dart';
import 'package:bext_notes/features/notes/bloc/note_state.dart';
import 'package:bext_notes/features/notes/bloc/note_view_cubit.dart';
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
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return _buildNoteListSliver();
    // return Column(
    //   children: [
    //     _buildSearchBar(context),
    //     _buildNoteList(),
    //   ],
    // );
  }

  _buildNoteListSliver() {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NoteLoaded) {
          final notes = state.notes;
          if (notes.isEmpty) {
            return const Center(child: Text('Sin notas aún.'));
          }

          return BlocBuilder<NoteViewCubit, NoteViewType>(
            builder: (context, viewType) {
              final isGrid = viewType == NoteViewType.grid;

              return CustomScrollView(
                slivers: [
                  _buildSearchBarSliver(context),
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  isGrid
                      ? SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final note = notes[i];
                                return NoteCard(
                                  note: note,
                                  viewType: NoteCardViewType.grid,
                                );
                              },
                              childCount: notes.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2 / 2,
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final note = notes[i];
                              return NoteCard(
                                note: note,
                                viewType: NoteCardViewType.list,
                              );
                            },
                            childCount: notes.length,
                          ),
                        ),
                ],
              );
            },
          );
        } else {
          return const Center(child: Text('Error cargando notas.'));
        }
      },
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

            return BlocBuilder<NoteViewCubit, NoteViewType>(
              builder: (context, viewType) {
                final isGrid = viewType == NoteViewType.grid;

                return isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notes.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2 / 2,
                        ),
                        itemBuilder: (_, i) {
                          final note = notes[i];
                          return NoteCard(
                            note: note,
                            viewType: NoteCardViewType.grid,
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (_, i) {
                          final note = notes[i];
                          return NoteCard(
                            note: note,
                            viewType: NoteCardViewType.list,
                          );
                        },
                      );
              },
            );
          } else {
            return const Center(child: Text('Error cargando notas.'));
          }
        },
      ),
    );
  }

  _buildSearchBarSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Buscar...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onChanged: (value) {
            context.read<NoteBloc>().add(SearchNotes(value));
          },
        ),
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
      title: Text('Notas'),
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
        BlocBuilder<NoteViewCubit, NoteViewType>(
          builder: (context, viewType) {
            return IconButton(
              icon: Icon(
                  viewType == NoteViewType.list ? Icons.grid_view : Icons.list),
              onPressed: () => context.read<NoteViewCubit>().toggleView(),
            );
          },
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
