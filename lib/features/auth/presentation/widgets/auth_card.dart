import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/core/utils/error_message_helper.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'sign_in_button.dart';

class AuthCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? apiError;
  final VoidCallback onLogin;
  final Animation<double> fadeAnim;
  final Animation<double> slideAnim;
  final Animation<double> scaleAnim;
  final Animation<double> buttonScaleAnim;
  final Animation<double> rotateAnim;
  final VoidCallback onButtonPressIn;
  final VoidCallback onButtonPressOut;

  const AuthCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.apiError,
    required this.onLogin,
    required this.fadeAnim,
    required this.slideAnim,
    required this.scaleAnim,
    required this.buttonScaleAnim,
    required this.rotateAnim,
    required this.onButtonPressIn,
    required this.onButtonPressOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeAnim,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnim.value,
          child: Transform.translate(
            offset: Offset(0, slideAnim.value),
            child: Transform.scale(
              scale: scaleAnim.value,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card header
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return Column(
                            children: [
                              Text(
                                l10n.signIn,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.signInToContinue,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Form fields
                      EmailField(controller: emailController),
                      const SizedBox(height: 16),
                      PasswordField(controller: passwordController),

                      // Forgot password
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                context.go('/forgot-password');
                              },
                              child: Text(
                                l10n.forgotPassword,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // API Error
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          final error = apiError ?? authProvider.errorMessage;
                          if (error != null && error.isNotEmpty) {
                            // Translate error message
                            final errorMsg = ErrorMessageHelper.getUserFriendlyMessage(
                              error,
                              context: context,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                errorMsg,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 24),

                      // Sign In button
                      SignInButton(
                        isLoading: isLoading,
                        onPressed: onLogin,
                        buttonScaleAnim: buttonScaleAnim,
                        rotateAnim: rotateAnim,
                        onPressIn: onButtonPressIn,
                        onPressOut: onButtonPressOut,
                      ),

                      const SizedBox(height: 48),

                      // Footer
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dontHaveAnAccount,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textSecondary,
            shadows: [
              Shadow(
                color: AppColors.shadowLight,
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            context.go('/signup');
          },
          child: Text(
            l10n.signUp,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              shadows: [
                Shadow(
                  color: AppColors.shadowLight,
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

