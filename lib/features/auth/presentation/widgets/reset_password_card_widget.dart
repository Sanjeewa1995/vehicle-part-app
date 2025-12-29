import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_message_helper.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';

class ResetPasswordCardWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onResetPassword;

  const ResetPasswordCardWidget({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onResetPassword,
  });

  @override
  State<ResetPasswordCardWidget> createState() =>
      _ResetPasswordCardWidgetState();
}

class _ResetPasswordCardWidgetState extends State<ResetPasswordCardWidget> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.newPasswordRequired;
    }
    if (value.length < 4) {
      return l10n.passwordMustBeAtLeast4Characters;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.pleaseConfirmPassword;
    }
    if (value != widget.passwordController.text) {
      return l10n.passwordsDoNotMatch;
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
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Text
              Text(
                l10n.resetPassword,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.enterYourNewPasswordMakeSureItsStrongAndSecure,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Password Field
              AppTextField(
                controller: widget.passwordController,
                label: l10n.newPassword,
                hint: l10n.enterNewPassword,
                type: AppTextFieldType.password,
                prefixIcon: Icons.lock_outline,
                obscureText: !_showPassword,
                suffixIcon: _showPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onSuffixIconTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                validator: _validatePassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              AppTextField(
                controller: widget.confirmPasswordController,
                label: l10n.confirmNewPassword,
                hint: l10n.confirmNewPasswordHint,
                type: AppTextFieldType.password,
                prefixIcon: Icons.lock_outline,
                obscureText: !_showConfirmPassword,
                suffixIcon: _showConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onSuffixIconTap: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
                validator: _validateConfirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => widget.onResetPassword(),
              ),
              const SizedBox(height: 24),

              // Update Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return AppButton(
                    text: l10n.updatePassword,
                    onPressed: authProvider.status == AuthStatus.loading
                        ? null
                        : widget.onResetPassword,
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
                    // Translate error message
                    final errorMsg = ErrorMessageHelper.getUserFriendlyMessage(
                      authProvider.errorMessage!,
                      context: context,
                    );
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
                                errorMsg,
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

