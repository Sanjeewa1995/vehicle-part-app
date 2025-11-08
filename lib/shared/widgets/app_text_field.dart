import 'package:flutter/material.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';

enum AppTextFieldType {
  text,
  email,
  password,
  number,
  phone,
  multiline,
}

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final AppTextFieldType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool showLabel;

  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.type = AppTextFieldType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.validator,
    this.enabled = true,
    this.maxLines,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.obscureText = false,
    this.showLabel = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;
  late bool _isPasswordField;

  @override
  void initState() {
    super.initState();
    _isPasswordField = widget.type == AppTextFieldType.password;
    _obscureText = widget.obscureText || _isPasswordField;
  }

  IconData? _getPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon;
    
    switch (widget.type) {
      case AppTextFieldType.email:
        return Icons.mail_outline;
      case AppTextFieldType.password:
        return Icons.lock_outline;
      case AppTextFieldType.phone:
        return Icons.phone_outlined;
      default:
        return null;
    }
  }

  TextInputType? _getKeyboardType() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  Widget? _buildSuffixIcon() {
    if (_isPasswordField) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
          color: AppColors.textTertiary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          size: 20,
          color: AppColors.textTertiary,
        ),
        onPressed: widget.onSuffixIconTap,
      );
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final prefixIcon = _getPrefixIcon();
    final keyboardType = _getKeyboardType();
    final isMultiline = widget.type == AppTextFieldType.multiline || 
                       (widget.maxLines != null && widget.maxLines! > 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.label != null) ...[
          Text(
            widget.label!.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: keyboardType,
          textInputAction: widget.textInputAction ?? 
              (isMultiline ? TextInputAction.newline : TextInputAction.next),
          textCapitalization: widget.type == AppTextFieldType.email || 
                             widget.type == AppTextFieldType.password
              ? TextCapitalization.none
              : TextCapitalization.sentences,
          autocorrect: widget.type != AppTextFieldType.email && 
                     widget.type != AppTextFieldType.password,
          obscureText: _obscureText,
          enabled: widget.enabled,
          maxLines: widget.maxLines ?? (isMultiline ? null : 1),
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: AppColors.textLight,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: 18,
                    color: AppColors.textTertiary,
                  )
                : null,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: widget.enabled 
                ? AppColors.background 
                : AppColors.backgroundSecondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

