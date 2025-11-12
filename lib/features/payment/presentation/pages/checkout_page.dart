import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/billing_address.dart';
import '../widgets/checkout_header_widget.dart';
import '../widgets/checkout_empty_widget.dart';
import '../widgets/checkout_summary_widget.dart';
import '../widgets/order_summary_card.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  BillingAddress? _billingAddress;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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

            return Column(
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

                        // Billing Address Card
                        GestureDetector(
                          onTap: () => _navigateToBillingAddress(context),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _billingAddress != null &&
                                        _billingAddress!.address.isNotEmpty
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: _billingAddress != null &&
                                        _billingAddress!.address.isNotEmpty
                                    ? 2
                                    : 1,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryUltraLight,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              Icons.location_on,
                                              color: AppColors.primary,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  l10n.billingAddress,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _billingAddress != null &&
                                                          _billingAddress!.address.isNotEmpty
                                                      ? _billingAddress!.fullAddress
                                                      : l10n.fillBillingAddressFields,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: _billingAddress != null &&
                                                            _billingAddress!.address.isNotEmpty
                                                        ? AppColors.textSecondary
                                                        : AppColors.textLight,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
            );
          },
        ),
      ),
    );
  }

  Future<void> _navigateToBillingAddress(BuildContext context) async {
    final result = await context.push<BillingAddress>(
      '/billing-address',
      extra: {
        'billingAddress': _billingAddress,
      },
    );

    if (result != null && mounted) {
      setState(() {
        _billingAddress = result;
      });
    }
  }

  Future<void> _handleCheckout(
    BuildContext context,
    CartProvider cartProvider,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (_billingAddress == null || _billingAddress!.address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillBillingAddressFields),
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorOccurred(e.toString())),
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
