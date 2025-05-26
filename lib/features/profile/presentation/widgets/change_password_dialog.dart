import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _currentPassword;

  @override
  void initState() {
    super.initState();
    _loadCurrentPassword();
  }

  Future<void> _loadCurrentPassword() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentPassword = prefs.getString('password') ?? '';
    });
  }

  Future<void> _saveNewPassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', _newPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar contraseña'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Contraseña actual'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su contraseña actual';
                  } else if (value != _currentPassword) {
                    return 'Contraseña incorrecta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Nueva contraseña'),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Confirmar nueva contraseña'),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _saveNewPassword();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contraseña actualizada')),
                );
              }
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
