import 'package:bext_notes/features/auth/data/repositories/auth_reposotory_impl.dart';
import 'package:bext_notes/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(authRepository)..add(CheckAuthStatus())),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => NoteBloc(
            NoteRepositoryImpl(
              NoteLocalDatasource(),
            ),
          )..add(
              LoadNotes(),
            ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Notas',
            themeMode: themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.teal, brightness: Brightness.dark),
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
