import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Açık ve koyu tema durumunu yöneten Cubit.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  void setTheme(ThemeMode mode) {
    emit(mode);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
