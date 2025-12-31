import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_message_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class OTPVerificationCardWidget extends StatefulWidget {
  final String contact;
  final Function(String otp) onVerify;
  final VoidCallback onResend;

  const OTPVerificationCardWidget({
    super.key,
    required this.contact,
    required this.onVerify,
    required this.onResend,
  });

  @override
  State<OTPVerificationCardWidget> createState() =>
      _OTPVerificationCardWidgetState();
}

class _OTPVerificationCardWidgetState
    extends State<OTPVerificationCardWidget> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String? _apiError;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    // Add focus listeners to update UI
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
    // Add text listeners to update UI
    for (var controller in _otpControllers) {
      controller.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
    // Auto-focus first field
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNodes[0].requestFocus();
    });
    // Start resend cooldown timer
    _startResendCooldown();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendCooldown() {
    _resendCooldown = 60;
    _updateResendCooldown();
  }

  void _updateResendCooldown() {
    if (_resendCooldown > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _resendCooldown--;
          });
          _updateResendCooldown();
        }
      });
    }
  }

  void _onOTPChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste
      final pastedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (pastedValue.length <= 6) {
        for (int i = 0; i < pastedValue.length && (index + i) < 6; i++) {
          _otpControllers[index + i].text = pastedValue[i];
          if (index + i < 5) {
            _focusNodes[index + i + 1].requestFocus();
          }
        }
      }
      return;
    }

    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      // Move to previous field
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  String _getOTP() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  bool _isOTPComplete() {
    return _getOTP().length == 6;
  }

  void _handleResend() {
    if (_resendCooldown > 0) return;
    widget.onResend();
    _startResendCooldown();
    // Clear OTP fields
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Text
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.enterThe6DigitCodeSentTo,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.weveSentA6DigitCodeToContact(widget.contact),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // OTP Input Fields
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate available width minus padding (48 total: 24 on each side)
                final availableWidth = constraints.maxWidth;
                // Reserve space for spacing between boxes (5 gaps * 8px = 40px)
                final spacing = 8.0;
                final totalSpacing = spacing * 5;
                // Calculate box width to fit 6 boxes with spacing
                final boxWidth = ((availableWidth - totalSpacing) / 6).clamp(45.0, 52.0);
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final isFocused = _focusNodes[index].hasFocus;
                    final hasValue = _otpControllers[index].text.isNotEmpty;
                    return Container(
                      width: boxWidth,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _apiError != null
                              ? AppColors.error
                              : isFocused
                                  ? AppColors.primary
                                  : hasValue
                                      ? AppColors.primary.withValues(alpha: 0.5)
                                      : AppColors.border,
                          width: isFocused ? 2.5 : 1.5,
                        ),
                        color: isFocused
                            ? AppColors.primary.withValues(alpha: 0.05)
                            : AppColors.backgroundSecondary,
                        boxShadow: isFocused
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: boxWidth > 48 ? 32 : 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0,
                          height: 1.2,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          _onOTPChanged(index, value);
                          setState(() {
                            _apiError = null;
                          });
                        },
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 24),

            // Verify Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final l10n = AppLocalizations.of(context)!;
                return AppButton(
                  text: l10n.sendVerificationCode, // Using existing key
                  onPressed: (authProvider.status == AuthStatus.loading ||
                          !_isOTPComplete())
                      ? null
                      : () {
                          final otp = _getOTP();
                          if (otp.length != 6) {
                            setState(() {
                              _apiError = l10n.pleaseEnterTheComplete6DigitCode;
                            });
                            return;
                          }
                          widget.onVerify(otp);
                        },
                  isLoading: authProvider.status == AuthStatus.loading,
                  type: AppButtonType.primary,
                );
              },
            ),

            // Error Message
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final error = _apiError ?? authProvider.errorMessage;
                if (error != null && error.isNotEmpty) {
                  // Translate error message
                  final errorMsg = ErrorMessageHelper.getUserFriendlyMessage(
                    error,
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

            const SizedBox(height: 24),

            // Resend Section
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Column(
                  children: [
                    Text(
                      l10n.rememberYourPassword, // Placeholder - could add specific key later
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_resendCooldown > 0)
                      Text(
                        'Resend code in $_resendCooldown seconds', // TODO: Add translation key with placeholder
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          _handleResend();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          l10n.sendVerificationCode,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

