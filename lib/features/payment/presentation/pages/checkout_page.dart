import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/billing_address.dart';
import '../widgets/checkout_header_widget.dart';
import '../widgets/checkout_empty_widget.dart';
import '../widgets/checkout_summary_widget.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/billing_address_form.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  BillingAddress? _billingAddress;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Consumer2<CartProvider, AuthProvider>(
          builder: (context, cartProvider, authProvider, child) {
            // Empty State
            if (cartProvider.isEmpty) {
              return const CheckoutEmptyWidget();
            }

            // Initialize billing address from user profile if available
            final user = authProvider.user;
            if (_billingAddress == null && user != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _billingAddress = BillingAddress(
                    firstName: user.firstName ?? '',
                    lastName: user.lastName ?? '',
                    email: user.email,
                    phone: user.phone ?? '',
                    address: '',
                    city: '',
                    postalCode: '',
                    country: 'Sri Lanka',
                  );
                });
              });
            }

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header
                  const CheckoutHeaderWidget(),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Summary
                          OrderSummaryCard(
                            cartProvider: cartProvider,
                          ),
                          const SizedBox(height: 24),

                          // Billing Address Section
                          Text(
                            'Billing Address',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          BillingAddressForm(
                            initialAddress: _billingAddress,
                            onChanged: (address) {
                              setState(() {
                                _billingAddress = address;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Summary and Checkout Button
                  CheckoutSummaryWidget(
                    cartProvider: cartProvider,
                    isLoading: _isLoading,
                    onCheckout: () => _handleCheckout(context, cartProvider),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleCheckout(
    BuildContext context,
    CartProvider cartProvider,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_billingAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all billing address fields'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Navigate to payment page with billing address and cart data
      if (mounted) {
        context.push(
          '/payment',
          extra: {
            'billingAddress': _billingAddress,
            'cartItems': cartProvider.items,
            'totalAmount': cartProvider.totalPrice,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
