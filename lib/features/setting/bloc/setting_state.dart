class SettingState {
  final bool isDarkMode;
  final bool isEnglish;
  final bool isTokenVisible;
  final String token;

  SettingState({
    required this.isDarkMode,
    required this.isEnglish,
    required this.isTokenVisible,
    required this.token,
  });

  SettingState copyWith({
    bool? isDarkMode,
    bool? isEnglish,
    bool? isTokenVisible,
    String? token,
  }) {
    return SettingState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isEnglish: isEnglish ?? this.isEnglish,
      isTokenVisible: isTokenVisible ?? this.isTokenVisible,
      token: token ?? this.token,
    );
  }
}
