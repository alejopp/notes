import 'package:bext_notes/core/theme/styles.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: Text('Perfil', style: TextStyle(fontSize: 24)),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Perfil',
        style: AppStyles.appBarStyle,
      ),
    );
  }
}
