part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeSystem extends ThemeState {}
class ThemeLight extends ThemeState {}
class ThemeDark extends ThemeState {}
