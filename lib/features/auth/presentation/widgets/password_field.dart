import 'package:flutter/material.dart';
import 'package:vehicle_part_app/core/utils/validators.dart';
import 'package:vehicle_part_app/shared/widgets/app_text_field.dart';

/// Password field widget using shared AppTextField component
class PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'PASSWORD',
      hint: '••••••••',
      type: AppTextFieldType.password,
      validator: Validators.passwordValidator(context),
    );
  }
}

