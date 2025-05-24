import 'package:bext_notes/features/auth/data/repositories/auth_reposotory_impl.dart';
import 'package:bext_notes/features/auth/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_screen.dart';

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
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const HomeScreen();
            } else if (state is Unauthenticated || state is AuthError) {
              return const LoginScreen();
            } else {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ),
    );
  }
}
