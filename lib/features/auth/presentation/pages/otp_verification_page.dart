import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/otp_verification_header_widget.dart';
import '../widgets/otp_verification_card_widget.dart';
import '../providers/auth_provider.dart';

class OTPVerificationPage extends StatefulWidget {
  final String contact;

  const OTPVerificationPage({
    super.key,
    required this.contact,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOTP(String otp) async {
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.verifyOTP(
      widget.contact,
      otp,
    );

    if (mounted && success) {
      // Navigate to reset password page
      context.go('/reset-password', extra: {
        'contact': widget.contact,
        'otp': otp,
      });
    }
  }

  Future<void> _handleResendOTP() async {
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.forgotPassword(widget.contact);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A new OTP has been sent to your contact number.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.background,
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Header Section
                    OTPVerificationHeaderWidget(contact: widget.contact),

                    const SizedBox(height: 48),

                    // OTP Verification Card
                    OTPVerificationCardWidget(
                      contact: widget.contact,
                      onVerify: _handleVerifyOTP,
                      onResend: _handleResendOTP,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
