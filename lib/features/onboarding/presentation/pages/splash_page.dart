import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/onboarding_service.dart';
import '../../../../shared/widgets/loading_indicator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthAndNavigate();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Get auth repository from service locator
      final authRepository = ServiceLocator.get<AuthRepository>();

      // Check if user is authenticated using SharedPreferences (via repository)
      final isAuthenticated = await authRepository.isAuthenticated();

      // Check if user has seen welcome page
      final hasSeenWelcome = await OnboardingService.hasSeenWelcome();

      // Wait for minimum splash duration (2 seconds)
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Navigate based on authentication status and onboarding status
      if (isAuthenticated) {
        context.go('/home');
      } else if (!hasSeenWelcome) {
        // First time user - show welcome page
        context.go('/welcome');
      } else {
        // Returning user - skip welcome and go to login
        context.go('/login');
      }
    } catch (e) {
      // On error, check if user has seen welcome
      if (!mounted) return;
      final hasSeenWelcome = await OnboardingService.hasSeenWelcome();
      if (!hasSeenWelcome) {
        if (!mounted) return;
        context.go('/welcome');
      } else {
        if (!mounted) return;
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              AppColors.background,
              AppColors.backgroundSecondary,
              AppColors.primaryUltraLight,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Brand Icon
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // // Brand Name
                      // RichText(
                      //   text: TextSpan(
                      //     style: const TextStyle(
                      //       fontSize: 34,
                      //       fontWeight: FontWeight.w800,
                      //       letterSpacing: 3,
                      //       fontFamily: 'Roboto',
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //         text: 'M ',
                      //         style: TextStyle(
                      //           color: const Color(0xFF8BC34A),
                      //           shadows: [
                      //             Shadow(
                      //               color: AppColors.shadowLight,
                      //               offset: const Offset(0, 2),
                      //               blurRadius: 4,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: 'AUTO',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           shadows: [
                      //             Shadow(
                      //               color: AppColors.shadowLight,
                      //               offset: const Offset(0, 2),
                      //               blurRadius: 4,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: ' - ',
                      //         style: TextStyle(
                      //           color: Colors.white.withValues(alpha: 0.7),
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: 'ZONE',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           shadows: [
                      //             Shadow(
                      //               color: AppColors.shadowColored,
                      //               offset: const Offset(0, 2),
                      //               blurRadius: 6,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 8),
                      // Text(
                      //   '" One Zone for Every Part "',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     letterSpacing: 1.2,
                      //     color: AppColors.textSecondary.withValues(alpha: 0.9),
                      //   ),
                      // ),
                      const SizedBox(height: 20),

                      // LoadingIndicator(
                      //   showBackground: false,
                      //   backgroundColor: Colors.transparent,
                      //   spinnerColor: AppColors.primary,
                      //   spinnerSize: 48,
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
