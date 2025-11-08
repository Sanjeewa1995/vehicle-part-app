import 'package:flutter/material.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';

enum AppButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool fullWidth;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.trailingIcon,
    this.fullWidth = false,
    this.padding,
    this.width,
    this.height = 53,
  });

  Color _getBackgroundColor() {
    if (onPressed == null || isLoading) {
      return AppColors.border;
    }

    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return AppColors.secondary;
      case AppButtonType.outline:
      case AppButtonType.text:
        return Colors.transparent;
      case AppButtonType.danger:
        return AppColors.error;
    }
  }

  Color _getTextColor() {
    if (onPressed == null || isLoading) {
      return AppColors.textTertiary;
    }

    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.danger:
        return AppColors.textWhite;
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppColors.primary;
    }
  }

  Color _getBorderColor() {
    if (onPressed == null || isLoading) {
      return AppColors.borderDark;
    }

    switch (type) {
      case AppButtonType.primary:
        return AppColors.primaryLight;
      case AppButtonType.secondary:
        return AppColors.secondaryLight;
      case AppButtonType.outline:
        return AppColors.primary;
      case AppButtonType.text:
        return Colors.transparent;
      case AppButtonType.danger:
        return AppColors.error;
    }
  }

  Gradient? _getGradient() {
    if (onPressed == null || isLoading || type != AppButtonType.primary) {
      return null;
    }

    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary,
        AppColors.primaryLight,
      ],
    );
  }

  List<BoxShadow> _getBoxShadow() {
    if (onPressed == null || isLoading) {
      return [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
    }

    switch (type) {
      case AppButtonType.primary:
        return [
          BoxShadow(
            color: AppColors.shadowColored,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      case AppButtonType.secondary:
      case AppButtonType.danger:
        return [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      case AppButtonType.outline:
      case AppButtonType.text:
        return [];
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 14;
      case AppButtonSize.medium:
        return 16;
      case AppButtonSize.large:
        return 18;
    }
  }

  EdgeInsets _getPadding() {
    if (padding != null) return padding!;

    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
  }

  double _getHeight() {
    if (height != null) return height!;

    switch (size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();
    final borderColor = _getBorderColor();
    final gradient = _getGradient();
    final boxShadow = _getBoxShadow();
    final fontSize = _getFontSize();
    final buttonPadding = _getPadding();
    final buttonHeight = _getHeight();

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: buttonHeight,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? backgroundColor : null,
          borderRadius: BorderRadius.circular(16),
          border: type == AppButtonType.outline
              ? Border.all(
                  color: borderColor,
                  width: 1,
                )
              : null,
          boxShadow: boxShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed == null || isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: buttonPadding,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  else ...[
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: fontSize,
                        color: textColor,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: 0.5,
                        shadows: type == AppButtonType.primary ||
                                type == AppButtonType.secondary ||
                                type == AppButtonType.danger
                            ? [
                                Shadow(
                                  color: AppColors.shadowDark,
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        trailingIcon,
                        size: fontSize,
                        color: textColor,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

