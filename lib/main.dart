import 'package:bext_notes/features/auth/data/repositories/auth_reposotory_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router/root_router.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/notes/bloc/note_bloc.dart';
import 'features/notes/bloc/note_event.dart';
import 'features/notes/data/datasources/note_local_datasource.dart';
import 'features/notes/data/repositories/note_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final AuthRepositoryImpl authRepository = AuthRepositoryImpl();

  MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository)..add(CheckAuthStatus()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notas App',
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) =>
                    AuthBloc(authRepository)..add(CheckAuthStatus())),
            BlocProvider(
              create: (_) => NoteBloc(
                NoteRepositoryImpl(NoteLocalDatasource()),
              )..add(LoadNotes()),
            ),
          ],
          child: const RootRouter(),
        ),
      ),
    );
  }
}
