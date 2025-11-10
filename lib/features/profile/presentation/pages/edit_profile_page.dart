import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import 'package:vehicle_part_app/shared/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, BuildContext context, bool isFirstName) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return isFirstName ? l10n.firstNameRequired : l10n.lastNameRequired;
    }
    if (value.trim().length < 2) {
      return isFirstName ? l10n.firstNameMustBeAtLeast2Characters : l10n.lastNameMustBeAtLeast2Characters;
    }
    return null;
  }

  String? _validatePhone(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.phoneNumberRequired;
    }
    // Basic phone validation - can be enhanced
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return l10n.pleaseEnterValidPhoneNumber;
    }
    return null;
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdatedSuccessfully),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else {
      setState(() {
        _errorMessage = authProvider.errorMessage ?? l10n.failedToUpdateProfile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Text(
              l10n.editProfile,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            );
          },
        ),
        backgroundColor: AppColors.backgroundSecondary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.borderLight,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // First Name
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return AppTextField(
                      controller: _firstNameController,
                      label: l10n.firstName,
                      hint: l10n.enterFirstName,
                      type: AppTextFieldType.text,
                      prefixIcon: Icons.person_outline,
                      validator: (value) => _validateName(value, context, true),
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Last Name
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return AppTextField(
                      controller: _lastNameController,
                      label: l10n.lastName,
                      hint: l10n.enterLastName,
                      type: AppTextFieldType.text,
                      prefixIcon: Icons.person_outline,
                      validator: (value) => _validateName(value, context, false),
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return AppTextField(
                      controller: _phoneController,
                      label: l10n.phoneNumber,
                      hint: l10n.enterPhoneNumber,
                      type: AppTextFieldType.phone,
                      prefixIcon: Icons.phone_outlined,
                      validator: (value) => _validatePhone(value, context),
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      onSubmitted: (_) => _handleUpdate(),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Update Button
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return ElevatedButton(
                      onPressed: _isLoading ? null : _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textWhite,
                                ),
                              ),
                            )
                          : Text(
                              l10n.updateProfile,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Cancel Button
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return OutlinedButton(
                      onPressed: _isLoading ? null : () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: AppColors.border,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

