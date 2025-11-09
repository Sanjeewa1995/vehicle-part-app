import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class SignUpCardWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSignUp;

  const SignUpCardWidget({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSignUp,
  });

  @override
  State<SignUpCardWidget> createState() => _SignUpCardWidgetState();
}

class _SignUpCardWidgetState extends State<SignUpCardWidget> {
  bool _acceptTerms = false;

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return '$fieldName must be less than 50 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != widget.passwordController.text) {
      return "Passwords don't match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Text
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in your details to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // First Name Field
              AppTextField(
                controller: widget.firstNameController,
                label: 'First Name',
                hint: 'Enter your first name',
                type: AppTextFieldType.text,
                prefixIcon: Icons.person_outline,
                validator: (value) => _validateName(value, 'First name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Last Name Field
              AppTextField(
                controller: widget.lastNameController,
                label: 'Last Name',
                hint: 'Enter your last name',
                type: AppTextFieldType.text,
                prefixIcon: Icons.person_outline,
                validator: (value) => _validateName(value, 'Last name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Email Field
              AppTextField(
                controller: widget.emailController,
                label: 'Email Address',
                hint: 'you@example.com',
                type: AppTextFieldType.email,
                validator: Validators.validateEmail,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Phone Field
              AppTextField(
                controller: widget.phoneController,
                label: 'Phone Number',
                hint: '+1 (555) 123-4567',
                type: AppTextFieldType.phone,
                validator: Validators.validatePhoneNumber,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Password Field
              AppTextField(
                controller: widget.passwordController,
                label: 'Password',
                hint: 'Create a strong password',
                type: AppTextFieldType.password,
                validator: _validatePassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              AppTextField(
                controller: widget.confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Confirm your password',
                type: AppTextFieldType.password,
                validator: _validateConfirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (_acceptTerms && widget.formKey.currentState!.validate()) {
                    widget.onSignUp();
                  } else if (!_acceptTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You must accept the terms and conditions'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Terms Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'I agree to the Terms of Service and Privacy Policy',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign Up Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return AppButton(
                    text: 'Create Account',
                    onPressed: (authProvider.status == AuthStatus.loading || !_acceptTerms)
                        ? null
                        : widget.onSignUp,
                    isLoading: authProvider.status == AuthStatus.loading,
                    type: AppButtonType.primary,
                  );
                },
              ),

              // Error Message
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.errorMessage != null &&
                      authProvider.errorMessage!.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.errorMessage!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

