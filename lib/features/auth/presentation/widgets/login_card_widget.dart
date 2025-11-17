import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class LoginCardWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  const LoginCardWidget({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.onLogin,
  });

  String? _validatePhone(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 9) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 6) {
      return l10n.passwordMinLength;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Text
              Text(
                l10n.welcomeBack,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.signInToContinue,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Phone Field
              AppTextField(
                controller: phoneController,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                type: AppTextFieldType.phone,
                validator: (value) => _validatePhone(value, l10n),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Password Field
              AppTextField(
                controller: passwordController,
                label: l10n.password,
                hint: l10n.enterYourPassword,
                type: AppTextFieldType.password,
                prefixIcon: Icons.lock_outlined,
                validator: (value) => _validatePassword(value, l10n),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onLogin(),
              ),
              const SizedBox(height: 12),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.go('/forgot-password');
                  },
                  child: Text(
                    l10n.forgotPassword,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return AppButton(
                    text: l10n.signIn,
                    onPressed: authProvider.status == AuthStatus.loading
                        ? null
                        : onLogin,
                    isLoading: authProvider.status == AuthStatus.loading,
                    type: AppButtonType.primary,
                    primaryColor: AppColors.primary,
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

