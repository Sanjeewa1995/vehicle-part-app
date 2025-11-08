import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _apiError;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _buttonScaleController;

  // Animations
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotateAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _buttonScaleAnim;

  @override
  void initState() {
    super.initState();

    // Add listeners to text controllers for reactive button state
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _buttonScaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Setup animations
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
    _rotateAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeOutCubic),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _buttonScaleController, curve: Curves.easeInOut),
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    // Sequence animations
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();

    // Rotate animation after others
    Future.delayed(const Duration(milliseconds: 100), () {
      _rotateController.forward();
    });

    // Pulse loop
    _pulseController.repeat(reverse: true);
  }

  void _updateButtonState() {
    setState(() {
      // Trigger rebuild to update button state
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    _buttonScaleController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      setState(() {
        _isLoading = true;
        _apiError = null;
      });
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Navigate to home on successful login
          context.go('/home');
        } else {
          // Show error message
          setState(() {
            _apiError = authProvider.errorMessage ?? 'Login failed';
          });
        }
      }
    }
  }

  void _handleButtonPressIn() {
    _buttonScaleController.forward();
  }

  void _handleButtonPressOut() {
    _buttonScaleController.reverse();
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
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 4),

              // Header with back button
              // _buildHeader(),

              const SizedBox(height: 48),

              // Brand section
              _buildBrand(),

              const SizedBox(height: 40),

              // Auth card with form
              AuthCard(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: _isLoading,
                apiError: _apiError,
                onLogin: _handleLogin,
                fadeAnim: _fadeAnim,
                slideAnim: _slideAnim,
                scaleAnim: _scaleAnim,
                buttonScaleAnim: _buttonScaleAnim,
                rotateAnim: _rotateAnim,
                onButtonPressIn: _handleButtonPressIn,
                onButtonPressOut: _handleButtonPressOut,
              ),

              // Bottom spacing
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _fadeAnim,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnim.value),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrand() {
    return AnimatedBuilder(
      animation: _fadeAnim,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnim.value),
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: Column(
                children: [
                  // Logo badge with gradient
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnim.value,
                        child: Transform.rotate(
                          angle: _rotateAnim.value * 6.28318, // 360 degrees
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryLight,
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.primaryLight,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowColored,
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.build,
                              size: 40,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Brand title
                  Text(
                    'M AUTO-ZONE',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: AppColors.shadowLight,
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    'Performance parts. Trusted quality.',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
