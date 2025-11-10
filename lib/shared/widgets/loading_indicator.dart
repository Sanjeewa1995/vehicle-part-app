import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/theme/app_colors.dart';

/// Common loading indicator widget using SpinKit
/// Can be used as a dialog overlay or inline widget
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final String? subMessage;
  final bool showBackground;
  final Color? backgroundColor;
  final Color? spinnerColor;
  final double spinnerSize;

  const LoadingIndicator({
    super.key,
    this.message,
    this.subMessage,
    this.showBackground = true,
    this.backgroundColor,
    this.spinnerColor,
    this.spinnerSize = 50.0,
  });

  /// Show loading indicator as a dialog
  static void show(
    BuildContext context, {
    String? message,
    String? subMessage,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: LoadingIndicator(
          message: message,
          subMessage: subMessage,
        ),
      ),
    );
  }

  /// Hide loading indicator dialog
  static void hide(BuildContext context) {
    try {
      final navigator = Navigator.of(context, rootNavigator: false);
      if (navigator.canPop()) {
        navigator.pop();
      }
    } catch (e) {
      // If there's an error (e.g., context is invalid or dialog doesn't exist),
      // try with root navigator
      try {
        final rootNavigator = Navigator.of(context, rootNavigator: true);
        if (rootNavigator.canPop()) {
          rootNavigator.pop();
        }
      } catch (_) {
        // Silently fail if dialog doesn't exist
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitFadingCircle(
            color: spinnerColor ?? AppColors.primary,
            size: spinnerSize,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (subMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              subMessage!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (showBackground) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: content,
      );
    }

    return content;
  }
}

/// Full screen loading overlay with semi-transparent background
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final String? subMessage;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.child,
    this.message,
    this.subMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: LoadingIndicator(
              message: message,
              subMessage: subMessage,
              showBackground: true,
            ),
          ),
        ),
      ],
    );
  }
}

