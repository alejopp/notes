import 'package:bext_notes/features/notes/bloc/note_bloc.dart';
import 'package:bext_notes/features/notes/bloc/note_event.dart';
import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NoteDetailPage extends StatelessWidget {
  final NoteEntity note;

  const NoteDetailPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Text(
          'Detalle de nota',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              context.read<NoteBloc>().add(DeleteNote(note.id!));
              Navigator.pop(context);
            },
          ),
        ]);
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat.yMMMMd().format(note.createdAt),
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 8.h),
          Text(note.title, style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 8.h),
          Text(note.content, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Editar nota'),
            onPressed: () => _showEditDialog(context, note),
          )
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, NoteEntity note) {
    final titleCtrl = TextEditingController(text: note.title);
    final contentCtrl = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(labelText: 'Contenido'),
              maxLines: 5,
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
              context.read<NoteBloc>().add(UpdateNote(
                    note.copyWith(
                        title: titleCtrl.text, content: contentCtrl.text),
                  ));
              Navigator.pop(context);
              Navigator.pop(context); // cerrar detalle y volver al home
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
