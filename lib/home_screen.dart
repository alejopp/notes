import 'package:bext_notes/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

import 'features/notes/presentation/pages/notes_page.dart';
import 'features/setting/presentation/pages/setting_page.dart';

enum Pages {
  profile,
  notes,
  setting,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _pages = const [
    ProfilePage(),
    NotesPage(),
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
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.person), label: Pages.profile.name),
          NavigationDestination(
              icon: Icon(Icons.note), label: Pages.notes.name),
          NavigationDestination(
              icon: Icon(Icons.settings), label: Pages.setting.name),
        ],
      ),
    );
  }
}
