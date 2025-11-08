import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/core/utils/validators.dart';
import '../providers/auth_provider.dart';

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
  bool _obscurePassword = true;
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
    final screenSize = MediaQuery.of(context).size;

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
          child: Stack(
            children: [
              // Decorative background elements (positioned absolutely)
              _buildBackground(screenSize),

              // Main scrollable content
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  const SizedBox(height: 24),

                  // Header with back button
                  _buildHeader(),

                  const SizedBox(height: 48),

                  // Brand section
                  _buildBrand(),

                  const SizedBox(height: 40),

                  // Auth card with form
                  _buildAuthCard(),

                  // Bottom spacing
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(Size screenSize) {
    // For ListView, we use a Container with Stack for decorative elements
    // The gradient will be handled by Scaffold background
    return SizedBox(
      height: 0, // No height, decorative elements are positioned absolutely
      child: Stack(
        children: [
          // Decorative circles - positioned relative to viewport
          Positioned(
            top: -120,
            right: -120,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnim.value,
                  child: Transform.rotate(
                    angle: _rotateAnim.value * 3.14159, // 180 degrees
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: -180,
            left: -180,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnim.value,
                  child: Transform.rotate(
                    angle: -_rotateAnim.value * 1.5708, // -90 degrees
                    child: Container(
                      width: 360,
                      height: 360,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: screenSize.height * 0.25,
            right: -60,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnim.value,
                  child: Transform.rotate(
                    angle: _rotateAnim.value * 0.7854, // 45 degrees
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Floating particles
          Positioned(
            top: screenSize.height * 0.2,
            left: screenSize.width * 0.1,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.4,
            right: screenSize.width * 0.15,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.7),
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.6,
            left: screenSize.width * 0.2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
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

  Widget _buildAuthCard() {
    return AnimatedBuilder(
      animation: _fadeAnim,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnim.value),
            child: Transform.scale(
              scale: _scaleAnim.value,
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card header
                      Column(
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Welcome back — let\'s get you on the road.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Form fields
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildPasswordField(),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      // API Error
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          final error = _apiError ?? authProvider.errorMessage;
                          if (error != null && error.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                error,
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
                      _buildSignInButton(),

                      const SizedBox(height: 48),

                      // Footer
                      _buildFooter(),
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

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMAIL ADDRESS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'you@example.com',
            hintStyle: TextStyle(
              color: AppColors.textLight,
            ),
            prefixIcon: const Icon(
              Icons.mail_outline,
              size: 18,
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 16,
            ),
          ),
          validator: Validators.validateEmail,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PASSWORD',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(
              color: AppColors.textLight,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 18,
              color: AppColors.textTertiary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.textTertiary,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 16,
            ),
          ),
          validator: Validators.validatePassword,
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check if form fields have valid content
        final emailValid = _emailController.text.isNotEmpty &&
            Validators.validateEmail(_emailController.text) == null;
        final passwordValid = _passwordController.text.isNotEmpty &&
            Validators.validatePassword(_passwordController.text) == null;
        final isValid = emailValid && passwordValid;
        final isDisabled = !isValid || _isLoading || authProvider.isLoading;

        return AnimatedBuilder(
          animation: _buttonScaleAnim,
          builder: (context, child) {
            return Transform.scale(
              scale: _buttonScaleAnim.value,
              child: GestureDetector(
                onTapDown: (_) => _handleButtonPressIn(),
                onTapUp: (_) {
                  _handleButtonPressOut();
                  if (!isDisabled) {
                    _handleLogin();
                  }
                },
                onTapCancel: _handleButtonPressOut,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isDisabled
                        ? null
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primaryLight,
                            ],
                          ),
                    color: isDisabled ? AppColors.border : null,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDisabled
                          ? AppColors.borderDark
                          : AppColors.primaryLight,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDisabled
                            ? AppColors.shadow
                            : AppColors.shadowColored,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading || authProvider.isLoading)
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
                      if (!_isLoading && !authProvider.isLoading) ...[
                        const SizedBox(width: 8),
                        AnimatedBuilder(
                          animation: _rotateAnim,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_rotateAnim.value * 5, 0),
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

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
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
            // TODO: Navigate to sign up
          },
          child: Text(
            'Sign Up',
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
