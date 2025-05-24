import 'package:bext_notes/features/notes/bloc/note_bloc.dart';
import 'package:bext_notes/features/notes/bloc/note_event.dart';
import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCard extends StatelessWidget {
  final NoteEntity note;
  final void Function() onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal[900],
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          note.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70),
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            context.read<NoteBloc>().add(DeleteNote(note.id!));
          },
        ),
      ),
    );
  }
}
