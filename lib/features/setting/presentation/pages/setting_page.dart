import 'package:bext_notes/core/theme/theme_cubit.dart';
import 'package:bext_notes/core/widgets/dialogs/change_password_dialog.dart';
import 'package:bext_notes/features/setting/bloc/setting_state.dart';
import 'package:bext_notes/features/setting/presentation/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Configuración')),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: ListView(
            children: [
              _buildExpandableSetting(
                title: 'Tema',
                expanded: themeExpanded,
                onTap: () => setState(() => themeExpanded = !themeExpanded),
                children: [
                  RadioListTile(
                    title: const Text('Claro'),
                    value: ThemeMode.light,
                    groupValue:
                        state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                    onChanged: (val) {
                      context.read<SettingCubit>().toggleDarkMode();
                      final themeMode =
                          state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
                      context.read<ThemeCubit>().setTheme(themeMode);
                    },
                  ),
                  RadioListTile(
                    title: const Text('Oscuro'),
                    value: ThemeMode.dark,
                    groupValue:
                        state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                    onChanged: (val) {
                      context.read<SettingCubit>().toggleDarkMode();
                      final themeMode =
                          state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
                      context.read<ThemeCubit>().setTheme(themeMode);
                    },
                  ),
                ],
              ),
              const Divider(),
              _buildExpandableSetting(
                title: 'Idioma',
                expanded: languageExpanded,
                onTap: () =>
                    setState(() => languageExpanded = !languageExpanded),
                children: [
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
                ],
              ),
              const Divider(),
              ListTile(
                title: const Text('Cambiar contraseña'),
                leading: const Icon(Icons.lock),
                onTap: () async {
                  await _showChangePasswordDialog(context);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Token actual'),
                subtitle: state.isTokenVisible
                    ? SelectableText(state.token)
                    : const Text('••••••••••••••••••••••'),
                trailing: IconButton(
                  icon: Icon(state.isTokenVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    context.read<SettingCubit>().toggleTokenVisibility();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildExpandableSetting({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(expanded ? Icons.expand_less : Icons.expand_more),
          onTap: onTap,
        ),
        if (expanded) ...children,
      ],
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => const ChangePasswordDialog(),
    );
  }
}
