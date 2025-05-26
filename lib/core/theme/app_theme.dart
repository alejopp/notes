import 'package:bext_notes/core/theme/custom_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    fontFamily: 'Montserrat',
    brightness: Brightness.light,
    colorScheme: CustomColorScheme.lightScheme(),
    cardColor: CustomColorScheme.lightScheme().primary,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Color(0xfff4ad47),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Color(0xffe8a04d),
      indicatorColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600);
        }
        return const TextStyle(color: Colors.black54);
      }),
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: Colors.white);
        }
        return IconThemeData(color: Colors.black54);
      }),
    ),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    fontFamily: 'Montserrat',
    brightness: Brightness.dark,
    colorScheme: CustomColorScheme.darkScheme(),
    cardColor: CustomColorScheme.darkScheme().primary,
    navigationBarTheme: NavigationBarThemeData(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      backgroundColor: Color(0xffe8a04d),
      indicatorColor: Colors.transparent,
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600);
        }
        return const TextStyle(color: Colors.black);
      }),
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: Colors.white);
        }
        return const IconThemeData(color: Colors.black);
      }),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xffe8a04d),
      centerTitle: true,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Color(0xfff4ad47),
    ),
    // scaffoldBackgroundColor: const Color(0xFF121212),
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Colors.transparent,
    //   foregroundColor: Colors.white,
    //   elevation: 0,
    // ),
    useMaterial3: true,
  );
}
