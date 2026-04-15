import 'package:flutter/material.dart';

InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) =>
    InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      fillColor: Colors.transparent,
      hoverColor: Colors.transparent,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
      errorStyle: TextStyle(color: colorScheme.error),
      helperStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
