import 'package:bext_notes/features/notes/domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    super.id,
    required super.title,
    required super.content,
    required super.createdAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
