import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light); // Initial theme is light mode

  void toggleTheme() {
    // Toggles between light and dark modes
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}