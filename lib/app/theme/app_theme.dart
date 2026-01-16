import 'package:flutter/material.dart';

class AppTheme {
  static const _radius = 16.0;

  static ThemeData light() {
    return _base(ColorScheme.fromSeed(seedColor: Colors.deepPurple));
  }

  static ThemeData dark() {
    return _base(
      ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
    );
  }

  static ThemeData _base(ColorScheme scheme) {
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_radius),
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardThemeData(
        shape: shape,
        elevation: 1,
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(shape: shape),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withAlpha(90),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: shape,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(shape: shape),
    );
  }
}
