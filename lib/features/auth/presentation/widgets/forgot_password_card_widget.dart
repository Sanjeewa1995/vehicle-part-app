import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_message_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';

class ForgotPasswordCardWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController contactController;
  final VoidCallback onSendCode;

  const ForgotPasswordCardWidget({
    super.key,
    required this.formKey,
    required this.contactController,
    required this.onSendCode,
  });

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
                l10n.noWorriesWellSendYouAVerificationCodeToResetYourPassword,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Contact Number Field
              AppTextField(
                controller: contactController,
                label: l10n.contactNumber,
                hint: l10n.enterYourContactNumber,
                type: AppTextFieldType.phone,
                prefixIcon: Icons.phone_outlined,
                validator: Validators.phoneNumberValidator(context),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onSendCode(),
              ),
              const SizedBox(height: 24),

              // Send Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return AppButton(
                    text: l10n.sendVerificationCode,
                    onPressed: authProvider.status == AuthStatus.loading
                        ? null
                        : onSendCode,
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

