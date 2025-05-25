import 'package:bext_notes/core/extentions/theme_extention.dart';
import 'package:bext_notes/core/router/root_router.dart';
import 'package:bext_notes/core/theme/custom_color_scheme.dart';
import 'package:bext_notes/features/auth/data/repositories/auth_reposotory_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme_cubit.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/notes/bloc/note_bloc.dart';
import 'features/notes/bloc/note_event.dart';
import 'features/notes/data/datasources/note_local_datasource.dart';
import 'features/notes/data/repositories/note_repository_impl.dart';
import 'features/notes/presentation/cubit/note_view_cubit.dart';
import 'features/setting/presentation/cubit/setting_cubit.dart';

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
        BlocProvider(
          create: (_) => NoteViewCubit(),
        ),
        BlocProvider(create: (_) => SettingCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return ScreenUtilInit(
            designSize: Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Notas',
              themeMode: themeMode,
              theme: ThemeData(
                brightness: Brightness.light,
                colorScheme: CustomColorScheme.lightScheme(),
                cardColor: CustomColorScheme.lightScheme().primary,
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColorScheme.lightScheme().onPrimary,
                  ),
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                colorScheme: CustomColorScheme.darkScheme(),
                cardColor: CustomColorScheme.darkScheme().primary,
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
                // scaffoldBackgroundColor: const Color(0xFF121212),
                // appBarTheme: const AppBarTheme(
                //   backgroundColor: Colors.transparent,
                //   foregroundColor: Colors.white,
                //   elevation: 0,
                // ),
                useMaterial3: true,
              ),
              home: const RootRouter(),
            ),
          );
        },
      ),
    );
  }
}
