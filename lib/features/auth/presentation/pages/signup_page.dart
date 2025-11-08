import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/core/utils/validators.dart';
import 'package:vehicle_part_app/shared/widgets/app_text_field.dart';
import 'package:vehicle_part_app/shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _acceptTerms = false;
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    _buttonScaleController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must accept the terms and conditions'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      setState(() {
        _isLoading = true;
        _apiError = null;
      });
      
      final success = await authProvider.register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Show success dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Welcome to M AUTO-ZONE!'),
              content: Text(
                'Hello ${_firstNameController.text.trim()}! '
                'Your account has been created successfully.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/home');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          );
        } else {
          // Show error message
          setState(() {
            _apiError = authProvider.errorMessage ?? 'Registration failed';
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return "Passwords don't match";
    }
    return null;
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return '$fieldName must be less than 50 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
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
              AppColors.accentUltraLight,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 4),

              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 24),

              // Brand section
              _buildBrand(),

              const SizedBox(height: 40),

              // Auth card with form
              _buildAuthCard(),

              // Bottom spacing
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 24),
            ],
          ),
        ),
      ),
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
                                  AppColors.accent,
                                  AppColors.accentLight,
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.accentLight,
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
                              Icons.person_add,
                              size: 50,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Brand name
                  Text(
                    'M AUTO-ZONE',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your account and start your journey',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
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
                padding: const EdgeInsets.all(24),
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
                            'Create Account',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fill in your details to get started',
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
                      AppTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        hint: 'Enter your first name',
                        type: AppTextFieldType.text,
                        prefixIcon: Icons.person_outline,
                        validator: (value) => _validateName(value, 'First name'),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        hint: 'Enter your last name',
                        type: AppTextFieldType.text,
                        prefixIcon: Icons.person_outline,
                        validator: (value) => _validateName(value, 'Last name'),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'you@example.com',
                        type: AppTextFieldType.email,
                        validator: Validators.validateEmail,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: '+1 (555) 123-4567',
                        type: AppTextFieldType.phone,
                        validator: Validators.validatePhoneNumber,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Create a strong password',
                        type: AppTextFieldType.password,
                        obscureText: !_showPassword,
                        suffixIcon: _showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        validator: _validatePassword,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Confirm your password',
                        type: AppTextFieldType.password,
                        obscureText: !_showConfirmPassword,
                        suffixIcon: _showConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconTap: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        validator: _validateConfirmPassword,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 16),

                      // Terms checkbox
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
                                'I agree to the Terms of Service and Privacy Policy',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
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

                      // Sign Up button
                      AnimatedBuilder(
                        animation: _buttonScaleAnim,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buttonScaleAnim.value,
                            child: GestureDetector(
                              onTapDown: (_) => _handleButtonPressIn(),
                              onTapUp: (_) => _handleButtonPressOut(),
                              onTapCancel: _handleButtonPressOut,
                              child: AppButton(
                                height: 53,
                                text: _isLoading ? 'Creating Account…' : 'Create Account',
                                onPressed: _isLoading ? null : _handleSignUp,
                                isLoading: _isLoading,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

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

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

