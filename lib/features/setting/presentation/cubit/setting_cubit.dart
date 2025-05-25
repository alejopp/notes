import 'dart:ui';

import 'package:bext_notes/features/setting/bloc/setting_state.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit()
      : super(SettingState(
          isDarkMode: false,
          isEnglish: false,
          isTokenVisible: false,
          token: '',
        )) {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final isSystemDark = brightness == Brightness.dark;

    emit(SettingState(
      isDarkMode: prefs.getBool('isDarkMode') ?? isSystemDark,
      isEnglish: prefs.getBool('isEnglish') ?? false,
      isTokenVisible: prefs.getBool('isTokenVisible') ?? false,
      token: prefs.getString('token') ?? '',
    ));
  }

  Future<void> toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final newVal = !state.isDarkMode;
    await prefs.setBool('isDarkMode', newVal);
    emit(state.copyWith(isDarkMode: newVal));
  }

  Future<void> toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final newVal = !state.isEnglish;
    await prefs.setBool('isEnglish', newVal);
    emit(state.copyWith(isEnglish: newVal));
  }

  Future<void> toggleTokenVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final newVal = !state.isTokenVisible;
    await prefs.setBool('isTokenVisible', newVal);
    emit(state.copyWith(isTokenVisible: newVal));
  }

  Future<void> refreshToken() async {
    //TODO Validate
    final prefs = await SharedPreferences.getInstance();
    final newToken = prefs.getString('token') ?? '';
    emit(state.copyWith(token: newToken));
  }
}
