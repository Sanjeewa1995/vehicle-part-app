import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/billing_address.dart';

class BillingAddressForm extends StatefulWidget {
  final BillingAddress? initialAddress;
  final ValueChanged<BillingAddress> onChanged;

  const BillingAddressForm({
    super.key,
    this.initialAddress,
    required this.onChanged,
  });

  @override
  State<BillingAddressForm> createState() => _BillingAddressFormState();
}

class _BillingAddressFormState extends State<BillingAddressForm> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialAddress?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.initialAddress?.lastName ?? '');
    _emailController = TextEditingController(text: widget.initialAddress?.email ?? '');
    _phoneController = TextEditingController(text: widget.initialAddress?.phone ?? '');
    _addressController = TextEditingController(text: widget.initialAddress?.address ?? '');
    _cityController = TextEditingController(text: widget.initialAddress?.city ?? '');
    _stateController = TextEditingController(text: widget.initialAddress?.state ?? '');
    _postalCodeController = TextEditingController(text: widget.initialAddress?.postalCode ?? '');
    _countryController = TextEditingController(text: widget.initialAddress?.country ?? 'Sri Lanka');

    // Add listeners to update billing address
    _firstNameController.addListener(_updateBillingAddress);
    _lastNameController.addListener(_updateBillingAddress);
    _emailController.addListener(_updateBillingAddress);
    _phoneController.addListener(_updateBillingAddress);
    _addressController.addListener(_updateBillingAddress);
    _cityController.addListener(_updateBillingAddress);
    _stateController.addListener(_updateBillingAddress);
    _postalCodeController.addListener(_updateBillingAddress);
    _countryController.addListener(_updateBillingAddress);
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
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _updateBillingAddress() {
    final address = BillingAddress(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim().isEmpty ? null : _stateController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      country: _countryController.text.trim(),
    );
    widget.onChanged(address);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderLight, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name & Last Name Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateRequired,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateRequired,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email *',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),

            // Phone
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                prefixIcon: Icon(Icons.phone_outlined),
                hintText: '+94 77 123 4567',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (value.length < 9) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Address
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Street Address *',
                prefixIcon: Icon(Icons.home_outlined),
                hintText: 'House number, street name',
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.words,
              validator: Validators.validateRequired,
            ),
            const SizedBox(height: 16),

            // City & Postal Code Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City *',
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.validateRequired,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _postalCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Postal Code *',
                      prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validateRequired,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // State (Optional)
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(
                labelText: 'State/Province (Optional)',
                prefixIcon: Icon(Icons.map_outlined),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Country
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Country *',
                prefixIcon: Icon(Icons.public_outlined),
              ),
              textCapitalization: TextCapitalization.words,
              validator: Validators.validateRequired,
            ),
          ],
        ),
      ),
    );
  }
}

