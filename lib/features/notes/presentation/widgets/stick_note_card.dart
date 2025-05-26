import 'package:bext_notes/core/extentions/theme_extention.dart';
import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';
import 'package:bext_notes/features/notes/presentation/pages/note_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StickNoteCard extends StatelessWidget {
  final NoteEntity note;

  const StickNoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NotePainter(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteDetailPage(note: note),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(note.createdAt),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                note.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.colorScheme.onPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotePainter extends CustomPainter {
  final BuildContext context;

  const NotePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final double cornerSize = (size.shortestSide * 0.15).clamp(10.0, 40.0);

    // Sombra de la nota
    final shadowPath = Path()
      ..moveTo(5, 5)
      ..lineTo(size.width - cornerSize + 5, 5)
      ..lineTo(size.width + 5, cornerSize + 5)
      ..lineTo(size.width + 5, size.height + 5)
      ..lineTo(5, size.height + 5)
      ..close();

    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black26
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Cuerpo de la nota
    final Path notePath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - cornerSize, 0)
      ..lineTo(size.width, cornerSize)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      notePath,
      Paint()..color = context.cardColor,
    );

    // Esquina doblada
    final foldPath = Path()
      ..moveTo(size.width - cornerSize, 0)
      ..lineTo(size.width - cornerSize, cornerSize)
      ..lineTo(size.width, cornerSize)
      ..close();

    canvas.drawPath(
      foldPath,
      Paint()..color = context.cardColor.withAlpha(70),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
