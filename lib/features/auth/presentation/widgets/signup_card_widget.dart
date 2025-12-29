import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_message_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldIsRequired(fieldName);
    }
    if (value.trim().length < 2) {
      return l10n.fieldMustBeAtLeast2Characters(fieldName);
    }
    if (value.trim().length > 50) {
      return l10n.fieldMustBeLessThan50Characters(fieldName);
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 6) {
      return l10n.passwordMustBeAtLeast6Characters;
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
              // Welcome Text
              Text(
                l10n.createAccount,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.fillInYourDetailsToGetStarted,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // First Name Field
              AppTextField(
                controller: widget.firstNameController,
                label: l10n.firstName,
                hint: l10n.enterYourFirstName,
                type: AppTextFieldType.text,
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  final localizations = AppLocalizations.of(context)!;
                  return _validateName(value, localizations.firstName);
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Last Name Field
              AppTextField(
                controller: widget.lastNameController,
                label: l10n.lastName,
                hint: l10n.enterYourLastName,
                type: AppTextFieldType.text,
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  final localizations = AppLocalizations.of(context)!;
                  return _validateName(value, localizations.lastName);
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Email Field
              AppTextField(
                controller: widget.emailController,
                label: l10n.emailAddress,
                hint: l10n.youExampleCom,
                type: AppTextFieldType.email,
                validator: Validators.emailValidator(context),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Phone Field
              AppTextField(
                controller: widget.phoneController,
                label: l10n.phoneNumber,
                hint: l10n.phonePlaceholder,
                type: AppTextFieldType.phone,
                validator: Validators.phoneNumberValidator(context),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Password Field
              AppTextField(
                controller: widget.passwordController,
                label: l10n.password,
                hint: l10n.createAStrongPassword,
                type: AppTextFieldType.password,
                validator: _validatePassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              AppTextField(
                controller: widget.confirmPasswordController,
                label: l10n.confirmNewPassword,
                hint: l10n.confirmYourPassword,
                type: AppTextFieldType.password,
                validator: _validateConfirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (_acceptTerms && widget.formKey.currentState!.validate()) {
                    widget.onSignUp();
                  } else if (!_acceptTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.youMustAcceptTheTermsAndConditions),
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
                        l10n.iAgreeToTheTermsOfServiceAndPrivacyPolicy,
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
                    text: l10n.createAccount,
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

