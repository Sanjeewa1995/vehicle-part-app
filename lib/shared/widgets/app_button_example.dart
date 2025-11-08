// Example usage of AppButton component
// This file demonstrates various ways to use AppButton

import 'package:flutter/material.dart';
import 'package:vehicle_part_app/shared/widgets/app_button.dart';

class AppButtonExamples extends StatelessWidget {
  const AppButtonExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Primary Button
          const AppButton(
            text: 'Primary Button',
            type: AppButtonType.primary,
            size: AppButtonSize.large,
            onPressed: null, // Example: disabled
          ),
          const SizedBox(height: 16),

          // Primary Button with Icon
          AppButton(
            text: 'Continue',
            icon: Icons.arrow_forward,
            type: AppButtonType.primary,
            onPressed: () {
              // Handle press
            },
          ),
          const SizedBox(height: 16),

          // Secondary Button
          AppButton(
            text: 'Secondary',
            type: AppButtonType.secondary,
            onPressed: () {},
          ),
          const SizedBox(height: 16),

          // Outline Button
          AppButton(
            text: 'Outline',
            type: AppButtonType.outline,
            onPressed: () {},
          ),
          const SizedBox(height: 16),

          // Text Button
          AppButton(
            text: 'Text Button',
            type: AppButtonType.text,
            onPressed: () {},
          ),
          const SizedBox(height: 16),

          // Danger Button
          AppButton(
            text: 'Delete',
            type: AppButtonType.danger,
            onPressed: () {},
          ),
          const SizedBox(height: 16),

          // Loading Button
          const AppButton(
            text: 'Loading...',
            isLoading: true,
            onPressed: null,
          ),
          const SizedBox(height: 16),

          // Small Button
          AppButton(
            text: 'Small',
            size: AppButtonSize.small,
            onPressed: () {},
          ),
          const SizedBox(height: 16),

          // Full Width Button
          AppButton(
            text: 'Full Width',
            fullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 16),

          // Button with Trailing Icon
          AppButton(
            text: 'Next',
            trailingIcon: Icons.arrow_forward,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

