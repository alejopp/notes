import 'package:bext_notes/features/auth/bloc/bloc.dart';
import 'package:bext_notes/features/notes/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select((AuthBloc bloc) => bloc.state is Authenticated
        ? (bloc.state as Authenticated).user.email
        : 'Desconocido');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Image.asset('assets/images/note.png'),
              ),
              const SizedBox(height: 32),
              Divider(color: Colors.grey[400]),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text('Email: $email'),
              ),
              Divider(color: Colors.grey[400]),
              BlocBuilder<NoteBloc, NoteState>(
                builder: (context, state) {
                  final noteCount =
                      state is NoteLoaded ? state.notes.length : 0;
                  return ListTile(
                    leading: const Icon(Icons.sticky_note_2_outlined),
                    title: Row(
                      children: [
                        const Text('Notas creadas:  '),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$noteCount',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey[400]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: GestureDetector(
                  onTap: () {
                    _confirmLogout(context);
                  },
                  child: Text(
                    'Cerrar sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Salir'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      context.read<AuthBloc>().add(LogoutRequested());
    }
  }
}
