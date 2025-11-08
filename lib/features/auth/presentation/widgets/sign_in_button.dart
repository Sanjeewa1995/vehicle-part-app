import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class SignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final Animation<double> buttonScaleAnim;
  final Animation<double> rotateAnim;
  final VoidCallback onPressIn;
  final VoidCallback onPressOut;

  const SignInButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.buttonScaleAnim,
    required this.rotateAnim,
    required this.onPressIn,
    required this.onPressOut,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isProcessing = isLoading || authProvider.isLoading;

        return AnimatedBuilder(
          animation: buttonScaleAnim,
          builder: (context, child) {
            return Transform.scale(
              scale: buttonScaleAnim.value,
              child: GestureDetector(
                onTapDown: (_) => onPressIn(),
                onTapUp: (_) {
                  onPressOut();
                  onPressed();
                },
                onTapCancel: onPressOut,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryLight,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColored,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isProcessing)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textWhite,
                            ),
                          ),
                        )
                      else
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: AppColors.shadowDark,
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      if (!isProcessing) ...[
                        const SizedBox(width: 8),
                        AnimatedBuilder(
                          animation: rotateAnim,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(rotateAnim.value * 5, 0),
                              child: const Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: AppColors.textWhite,
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

