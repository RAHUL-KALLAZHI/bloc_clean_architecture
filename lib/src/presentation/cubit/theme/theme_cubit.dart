import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'is_dark_theme';

  ThemeCubit() : super(ThemeSystem()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey);
      if (isDark == null) {
        emit(ThemeSystem());
      } else if (isDark) {
        emit(ThemeDark());
      } else {
        emit(ThemeLight());
      }
    } catch (_) {
      emit(ThemeSystem());
    }
  }

  Future<void> changeTheme(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
      if (isDark) {
        emit(ThemeDark());
      } else {
        emit(ThemeLight());
      }
    } catch (_) {
      if (isDark) {
        emit(ThemeDark());
      } else {
        emit(ThemeLight());
      }
    }
  }
}
