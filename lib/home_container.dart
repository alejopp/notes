import 'package:bext_notes/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

import 'features/setting/presentation/pages/setting_page.dart';
import 'home_screen.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  int _currentIndex = 0;

  final _pages = const [
    HomeScreen(), // TODO YP Change by NotesPage
    ProfilePage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.note), label: 'Notas'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Config.'),
        ],
      ),
    );
  }
}
