import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NoteViewType { list, grid }

class NoteViewCubit extends Cubit<NoteViewType> {
  static const _viewKey = 'note_view_type';

  NoteViewCubit() : super(NoteViewType.list) {
    _loadView();
  }

  Future<void> _loadView() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_viewKey);
    if (saved == NoteViewType.grid.name) {
      emit(NoteViewType.grid);
    }
  }

  Future<void> toggleView() async {
    final newView =
        state == NoteViewType.list ? NoteViewType.grid : NoteViewType.list;
    emit(newView);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_viewKey, newView.name);
  }
}
