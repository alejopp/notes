import 'package:bext_notes/features/auth/bloc/auth_bloc.dart';
import 'package:bext_notes/features/auth/bloc/auth_event.dart';
import 'package:bext_notes/features/auth/bloc/auth_state.dart';
import 'package:bext_notes/features/notes/bloc/note_bloc.dart';
import 'package:bext_notes/features/notes/bloc/note_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            final user = authState.user;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      user.email[0].toUpperCase(),
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    user.email,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<NoteBloc, NoteState>(
                  builder: (context, noteState) {
                    if (noteState is NoteLoaded) {
                      final count = noteState.notes.length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Total de notas:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$count',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      );
                    } else if (noteState is NoteLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Center(
                          child: Text('No se pudo cargar el total de notas.'));
                    }
                  },
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar sesión'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Usuario no autenticado'));
          }
        },
      ),
    );
  }
}
