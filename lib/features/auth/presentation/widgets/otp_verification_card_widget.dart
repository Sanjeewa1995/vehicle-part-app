import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class OTPVerificationCardWidget extends StatefulWidget {
  final String email;
  final Function(String otp) onVerify;
  final VoidCallback onResend;

  const OTPVerificationCardWidget({
    super.key,
    required this.email,
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
            Text(
              'Enter Verification Code',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ve sent a 6-digit code to ${widget.email}. If you don\'t receive a code, the email might not be registered.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 44,
                  height: 56,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: AppColors.backgroundSecondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _apiError != null
                              ? AppColors.error
                              : AppColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _apiError != null
                              ? AppColors.error
                              : AppColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
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
            ),
            const SizedBox(height: 24),

            // Verify Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return AppButton(
                  text: 'Verify Code',
                  onPressed: (authProvider.status == AuthStatus.loading ||
                          !_isOTPComplete())
                      ? null
                      : () {
                          final otp = _getOTP();
                          if (otp.length != 6) {
                            setState(() {
                              _apiError = 'Please enter the complete 6-digit code';
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
                              error,
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
            Column(
              children: [
                Text(
                  'Didn\'t receive the code?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                if (_resendCooldown > 0)
                  Text(
                    'Resend code in $_resendCooldown seconds',
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
                      'Resend Code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

