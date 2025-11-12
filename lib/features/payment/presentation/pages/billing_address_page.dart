import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/billing_address.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';

class BillingAddressPage extends StatefulWidget {
  final BillingAddress? initialAddress;

  const BillingAddressPage({
    super.key,
    this.initialAddress,
  });

  @override
  State<BillingAddressPage> createState() => _BillingAddressPageState();
}

class _BillingAddressPageState extends State<BillingAddressPage> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialAddress;
    _firstNameController = TextEditingController(text: initial?.firstName ?? '');
    _lastNameController = TextEditingController(text: initial?.lastName ?? '');
    _emailController = TextEditingController(text: initial?.email ?? '');
    _phoneController = TextEditingController(text: initial?.phone ?? '');
    _addressController = TextEditingController(text: initial?.address ?? '');
    _cityController = TextEditingController(text: initial?.city ?? '');
    _stateController = TextEditingController(text: initial?.state ?? '');
    _countryController = TextEditingController(text: initial?.country ?? 'Sri Lanka');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  BillingAddress _getBillingAddress() {
    return BillingAddress(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim().isEmpty ? null : _stateController.text.trim(),
      postalCode: '',
      country: _countryController.text.trim(),
    );
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      final billingAddress = _getBillingAddress();
      // Return the billing address to the previous page
      context.pop(billingAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 18,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
          ).createShader(bounds),
          child: Text(
            l10n.billingAddress,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Initialize from user profile if not already set
            final user = authProvider.user;
            if (user != null && _firstNameController.text.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _firstNameController.text = user.firstName ?? '';
                    _lastNameController.text = user.lastName ?? '';
                    _emailController.text = user.email;
                    _phoneController.text = user.phone ?? '';
                    _countryController.text = 'Sri Lanka';
                  });
                }
              });
            }

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          MediaQuery.of(context).padding.bottom + 16,
                        ),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryUltraLight,
                                  AppColors.backgroundSecondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.billingInformation,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.enterBillingDetails,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Personal Information Section
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.personalInformation,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _firstNameController,
                                        decoration: InputDecoration(
                                          labelText: '${l10n.firstName} *',
                                          hintText: l10n.enterFirstName,
                                          prefixIcon: const Icon(Icons.person_outline),
                                        ),
                                        textCapitalization: TextCapitalization.words,
                                        validator: Validators.validateRequired,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _lastNameController,
                                        decoration: InputDecoration(
                                          labelText: '${l10n.lastName} *',
                                          hintText: l10n.enterLastName,
                                          prefixIcon: const Icon(Icons.person_outline),
                                        ),
                                        textCapitalization: TextCapitalization.words,
                                        validator: Validators.validateRequired,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: '${l10n.emailAddress} *',
                                    hintText: l10n.enterYourEmail,
                                    prefixIcon: const Icon(Icons.email_outlined),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.validateEmail,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    labelText: '${l10n.phoneNumber} *',
                                    hintText: l10n.enterPhoneNumber,
                                    prefixIcon: const Icon(Icons.phone_outlined),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l10n.phoneNumberRequired;
                                    }
                                    if (value.length < 9) {
                                      return l10n.pleaseEnterValidPhoneNumber;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Address Information Section
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.home,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.addressInformation,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    labelText: '${l10n.streetAddress} *',
                                    hintText: l10n.houseNumberStreetName,
                                    prefixIcon: const Icon(Icons.home_outlined),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  validator: Validators.validateRequired,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _cityController,
                                  decoration: InputDecoration(
                                    labelText: '${l10n.city} *',
                                    hintText: l10n.city,
                                    prefixIcon: const Icon(Icons.location_city_outlined),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  validator: Validators.validateRequired,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _stateController,
                                  decoration: InputDecoration(
                                    labelText: l10n.stateProvinceOptional,
                                    hintText: l10n.provinceStateHint,
                                    prefixIcon: const Icon(Icons.map_outlined),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _countryController,
                                  decoration: InputDecoration(
                                    labelText: '${l10n.country} *',
                                    hintText: l10n.selectCountry,
                                    prefixIcon: const Icon(Icons.public_outlined),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  validator: Validators.validateRequired,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      ),
                    ),
                  ),

                  // Continue Button
                  Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _handleContinue,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.continueButton,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textWhite,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                color: AppColors.textWhite,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

