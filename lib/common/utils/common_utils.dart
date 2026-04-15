import 'package:complaints/common/utils/enum_utils.dart';
import 'package:flutter/material.dart';

class CommonUtils {
  static const List<TargetPlatform> desktopPlatforms = [
    TargetPlatform.macOS,
    TargetPlatform.linux,
    TargetPlatform.windows,
  ];

  static bool isDesktop(BuildContext context) =>
      desktopPlatforms.contains(Theme.of(context).platform);

  static void showSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.colorScheme.surface,
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  /// Returns true if the keyboard is visible, false otherwise
  static bool isKeyboardOpen(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom > 0;
  }

  static Color getColor(ComplaintSeverity severity) {
    switch (severity) {
      case ComplaintSeverity.high:
        return Colors.red;

      case ComplaintSeverity.medium:
        return Colors.orange;

      case ComplaintSeverity.low:
        return Colors.green;
    }
  }
}
