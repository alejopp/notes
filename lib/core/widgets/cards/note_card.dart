import 'package:bext_notes/core/extentions/theme_extention.dart';
import 'package:bext_notes/core/widgets/cards/stick_note_card.dart';
import 'package:bext_notes/features/notes/bloc/note_bloc.dart';
import 'package:bext_notes/features/notes/bloc/note_event.dart';
import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';
import 'package:bext_notes/features/notes/presentation/pages/note_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NoteCardViewType { list, grid }

class NoteCard extends StatelessWidget {
  final NoteEntity note;
  final NoteCardViewType? viewType;

  const NoteCard({
    super.key,
    required this.note,
    this.viewType,
  });

  @override
  Widget build(BuildContext context) {
    return viewType == NoteCardViewType.grid
        ? StickNoteCard(note: note)
        : _buildCard(context);
  }

  _buildCard(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          note.title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onPrimary),
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: context.colorScheme.onPrimary,
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteDetailPage(note: note),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: context.colorScheme.onPrimary,
          ),
          onPressed: () {
            context.read<NoteBloc>().add(DeleteNote(note.id!));
          },
        ),
      ),
    );
  }
}
