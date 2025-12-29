import 'package:flutter/material.dart';
import 'package:vehicle_part_app/core/utils/validators.dart';
import 'package:vehicle_part_app/shared/widgets/app_text_field.dart';

/// Email field widget using shared AppTextField component
class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'EMAIL ADDRESS',
      hint: 'you@example.com',
      type: AppTextFieldType.email,
      validator: Validators.emailValidator(context),
    );
  }
}

