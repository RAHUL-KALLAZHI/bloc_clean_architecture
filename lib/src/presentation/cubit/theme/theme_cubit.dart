import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'is_dark_theme';

  ThemeCubit() : super(ThemeLight()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      if (isDark) {
        emit(ThemeDark());
      } else {
        emit(ThemeLight());
      }
    } catch (_) {
      emit(ThemeLight());
    }
  }

  Future<void> changeTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (state is ThemeLight) {
        await prefs.setBool(_themeKey, true);
        emit(ThemeDark());
      } else {
        await prefs.setBool(_themeKey, false);
        emit(ThemeLight());
      }
    } catch (_) {
      if (state is ThemeLight) {
        emit(ThemeDark());
      } else {
        emit(ThemeLight());
      }
    }
  }
}
