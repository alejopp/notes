import 'package:bext_notes/features/auth/bloc/auth_bloc.dart';
import 'package:bext_notes/features/auth/bloc/auth_event.dart';
import 'package:bext_notes/features/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final token = state is Authenticated ? state.user.token : "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bienvenido", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text("Token:\n$token", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
