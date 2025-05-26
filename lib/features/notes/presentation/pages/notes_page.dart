import 'package:bext_notes/features/notes/bloc/bloc.dart';
import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';
import 'package:bext_notes/features/notes/presentation/widgets/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _showClear = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final isNotEmpty = _searchController.text.isNotEmpty;
      _showClear.value = isNotEmpty;

      if (!isNotEmpty) {
        FocusScope.of(context).unfocus();
        context.read<NoteBloc>().add(SearchNotes(''));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Notas',
        style: TextStyle(color: Colors.black87),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.sort_by_alpha,
            color: Colors.black87,
          ),
          onPressed: () {
            context.read<NoteBloc>().add(SortNotes(byTitle: true));
          },
          tooltip: 'Ordenar por título',
        ),
        IconButton(
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.black87,
          ),
          onPressed: () {
            context.read<NoteBloc>().add(SortNotes(byTitle: false));
          },
          tooltip: 'Ordenar por fecha',
        ),
        BlocBuilder<NoteViewCubit, NoteViewType>(
          builder: (context, viewType) {
            return IconButton(
              icon: Icon(
                  color: Colors.black87,
                  viewType == NoteViewType.list ? Icons.grid_view : Icons.list),
              onPressed: () => context.read<NoteViewCubit>().toggleView(),
            );
          },
        ),
      ],
    );
  }

  _buildBody(BuildContext context) {
    return _buildNoteListSliver();
  }

  _buildNoteListSliver() {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NoteLoaded) {
          final notes = state.notes;

          return BlocBuilder<NoteViewCubit, NoteViewType>(
            builder: (context, viewType) {
              final isGrid = viewType == NoteViewType.grid;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(height: 20.h),
                  ),
                  _buildSearchBarSliver(context),
                  SliverPadding(padding: EdgeInsets.symmetric(vertical: 8.h)),
                  if (notes.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text('Sin notas aún.'),
                      ),
                    )
                  else if (isGrid)
                    SliverPadding(
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
                  else
                    SliverList(
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

  _buildSearchBarSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: ValueListenableBuilder<bool>(
          valueListenable: _showClear,
          builder: (_, show, __) => TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: show
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                        context.read<NoteBloc>().add(SearchNotes(''));
                      },
                    )
                  : null,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onChanged: (value) {
              context.read<NoteBloc>().add(SearchNotes(value));
            },
          ),
        ),
      ),
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
