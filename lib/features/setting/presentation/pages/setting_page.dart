import 'package:bext_notes/features/auth/bloc/auth_bloc.dart';
import 'package:bext_notes/features/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool showToken = false;
  bool themeExpanded = false;
  bool languageExpanded = false;

  bool themeSwitch = false;
  bool languageSwitch = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          _buildExpandableSetting(
            title: 'Tema',
            expanded: themeExpanded,
            onTap: () => setState(() => themeExpanded = !themeExpanded),
            switchValue: themeSwitch,
            onSwitchChanged: (val) => setState(() => themeSwitch = val),
            children: themeSwitch
                ? [
                    RadioListTile(
                      title: const Text('Claro'),
                      value: ThemeMode.light,
                      groupValue:
                          Theme.of(context).brightness == Brightness.light
                              ? ThemeMode.light
                              : ThemeMode.dark,
                      onChanged: (val) {
                        // Lógica para cambiar tema
                      },
                    ),
                    RadioListTile(
                      title: const Text('Oscuro'),
                      value: ThemeMode.dark,
                      groupValue:
                          Theme.of(context).brightness == Brightness.light
                              ? ThemeMode.light
                              : ThemeMode.dark,
                      onChanged: (val) {
                        // Lógica para cambiar tema
                      },
                    ),
                  ]
                : [],
          ),
          const Divider(),
          _buildExpandableSetting(
            title: 'Idioma',
            expanded: languageExpanded,
            onTap: () => setState(() => languageExpanded = !languageExpanded),
            switchValue: languageSwitch,
            onSwitchChanged: (val) => setState(() => languageSwitch = val),
            children: languageSwitch
                ? [
                    ListTile(
                      title: const Text('Español'),
                      onTap: () {
                        // Cambiar idioma a español
                      },
                    ),
                    ListTile(
                      title: const Text('Inglés'),
                      onTap: () {
                        // Cambiar idioma a inglés
                      },
                    ),
                  ]
                : [],
          ),
          const Divider(),
          ListTile(
            title: const Text('Cambiar contraseña'),
            leading: const Icon(Icons.lock),
            onTap: () {
              // Ir a pantalla de cambiar contraseña
            },
          ),
          const Divider(),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Token actual:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              showToken
                                  ? state.user.token
                                  : '••••••••••••••••••••••••',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontFamily: 'Courier',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(showToken
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => showToken = !showToken),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  Widget _buildExpandableSetting({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(expanded ? Icons.expand_less : Icons.expand_more),
          trailing: Switch(value: switchValue, onChanged: onSwitchChanged),
          onTap: onTap,
        ),
        if (expanded && switchValue) ...children,
      ],
    );
  }
}
