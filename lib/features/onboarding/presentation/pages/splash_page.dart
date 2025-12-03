import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/onboarding_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late AnimationController _shimmerAnimationController;
  late AnimationController _textAnimationController;
  
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  String _loadingMessage = 'Initializing...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthAndNavigate();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Shimmer animation controller
    _shimmerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Text animation controller
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animations
    _logoAnimationController.forward();
    _textAnimationController.forward().then((_) {
      _progressAnimationController.forward();
    });
  }

  void _updateLoadingState(String message, double progress) {
    if (mounted) {
      setState(() {
        _loadingMessage = message;
        _progress = progress;
      });
    }
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Simulate loading stages with progress updates
      _updateLoadingState('Loading assets...', 0.2);
      await Future.delayed(const Duration(milliseconds: 400));

      _updateLoadingState('Checking authentication...', 0.4);
      final authRepository = ServiceLocator.get<AuthRepository>();
      final isAuthenticated = await authRepository.isAuthenticated();

      _updateLoadingState('Preparing your experience...', 0.6);
      final hasSeenWelcome = await OnboardingService.hasSeenWelcome();

      _updateLoadingState('Almost ready...', 0.8);
      await Future.delayed(const Duration(milliseconds: 300));

      _updateLoadingState('Welcome!', 1.0);
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // Navigate based on authentication status and onboarding status
      if (isAuthenticated) {
        context.go('/home');
      } else if (!hasSeenWelcome) {
        context.go('/welcome');
      } else {
        context.go('/login');
      }
    } catch (e) {
      _updateLoadingState('Preparing...', 0.9);
      if (!mounted) return;
      final hasSeenWelcome = await OnboardingService.hasSeenWelcome();
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (!hasSeenWelcome) {
        context.go('/welcome');
      } else {
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    _shimmerAnimationController.dispose();
    _textAnimationController.dispose();
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
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacing
              const Spacer(flex: 2),
              
              // Logo section with shimmer effect
              AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: _buildLogoWithShimmer(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 48),
              
              // Loading message with animation
              AnimatedBuilder(
                animation: _textAnimationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _textFadeAnimation,
                    child: SlideTransition(
                      position: _textSlideAnimation,
                      child: Column(
                        children: [
                          Text(
                            _loadingMessage,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary.withValues(alpha: 0.8),
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              // Progress indicator section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Column(
                  children: [
                    // Animated progress bar
                    AnimatedBuilder(
                      animation: _progressAnimationController,
                      builder: (context, child) {
                        final animatedProgress = _progressAnimation.value * _progress;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: animatedProgress,
                            minHeight: 4,
                            backgroundColor: AppColors.borderLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Loading spinner
                    SpinKitFadingCircle(
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ],
                ),
              ),
              
              // Bottom spacing
              const Spacer(flex: 3),
              
              // App version or tagline (optional)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  'Premium Vehicle Parts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoWithShimmer() {
    return AnimatedBuilder(
      animation: _shimmerAnimationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              // Shimmer overlay
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.0),
                        Colors.transparent,
                      ],
                      stops: [
                        0.0,
                        (1.0 + _shimmerAnimation.value) / 2 - 0.2,
                        (1.0 + _shimmerAnimation.value) / 2,
                        (1.0 + _shimmerAnimation.value) / 2 + 0.2,
                        1.0,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
