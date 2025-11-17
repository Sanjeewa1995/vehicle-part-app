import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../order/domain/usecases/create_order_usecase.dart';
import '../../domain/entities/billing_address.dart';
import '../../data/repositories/payhere_service.dart';
import '../../data/models/payment_request.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  final BillingAddress? billingAddress;
  final List<CartItem> cartItems;
  final double totalAmount;

  const PaymentPage({
    super.key,
    this.billingAddress,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = widget.totalAmount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.payment,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.borderLight,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  Text(
                    l10n.orderSummary,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.borderLight, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Items List
                          ...widget.cartItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: item.product.image != null &&
                                            item.product.image!.isNotEmpty
                                        ? Image.network(
                                            item.product.image!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 60,
                                                height: 60,
                                                color: AppColors.backgroundSecondary,
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  size: 24,
                                                  color: AppColors.textTertiary,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            width: 60,
                                            height: 60,
                                            color: AppColors.backgroundSecondary,
                                            child: const Icon(
                                              Icons.shopping_bag_outlined,
                                              size: 24,
                                              color: AppColors.textTertiary,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${l10n.quantity}: ${item.quantity} × ${CurrencyFormatter.formatLKR(double.tryParse(item.product.price) ?? 0.0)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.formatLKR(item.totalPrice),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Billing Address Summary
                  if (widget.billingAddress != null) ...[
                    Text(
                      l10n.billingAddress,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
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
                            Text(
                              widget.billingAddress!.fullName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.billingAddress!.fullAddress,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${l10n.phoneLabel}: ${widget.billingAddress!.phone}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${l10n.emailLabel}: ${widget.billingAddress!.email}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Payment Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.total,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatLKR(total),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: l10n.pay,
                    onPressed: _isProcessing ? null : () => _handlePayment(context, total),
                    type: AppButtonType.primary,
                    size: AppButtonSize.large,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Future<void> _handlePayment(BuildContext context, double total) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.billingAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.billingAddressRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await _handlePayHerePayment(context, total);
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorOccurred(e.toString())),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handlePayHerePayment(BuildContext context, double total) async {
    // Create payment items list
    final paymentItems = widget.cartItems.map((item) {
      return PaymentItem(
        itemNumber: item.product.id.toString(),
        itemName: item.product.name,
        amount: double.tryParse(item.product.price) ?? 0.0,
        quantity: item.quantity,
      );
    }).toList();

    // Create payment request
    final paymentRequest = PaymentRequest(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      items: widget.cartItems.length == 1
          ? widget.cartItems.first.product.name
          : '${widget.cartItems.length} Vehicle Parts',
      amount: total,
      firstName: widget.billingAddress!.firstName,
      lastName: widget.billingAddress!.lastName,
      email: widget.billingAddress!.email,
      phone: widget.billingAddress!.phone,
      address: widget.billingAddress!.address,
      city: widget.billingAddress!.city,
      country: widget.billingAddress!.country,
      deliveryAddress: widget.billingAddress!.address,
      deliveryCity: widget.billingAddress!.city,
      deliveryCountry: widget.billingAddress!.country,
      paymentItems: paymentItems,
    );

    PayHereService.startPayment(
      paymentRequest: paymentRequest,
      onSuccess: (paymentId) async {
        if (!mounted) return;

        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final cartId = cartProvider.cartId;
        final l10n = AppLocalizations.of(context)!;

        // Create order after successful payment
        if (cartId != null && widget.billingAddress != null) {
          try {
            final createOrderUseCase = ServiceLocator.get<CreateOrderUseCase>();
            
            // Convert billing address to shipping address format
            // Handle empty postal code - use a default value if empty to avoid API validation errors
            final postalCode = widget.billingAddress!.postalCode?.trim();
            final shippingAddress = {
              'first_name': widget.billingAddress!.firstName,
              'last_name': widget.billingAddress!.lastName,
              'country': widget.billingAddress!.country,
              'state': widget.billingAddress!.state?.trim() ?? '',
              'post_code': postalCode?.isNotEmpty == true ? postalCode! : '00000',
              'city': widget.billingAddress!.city,
              'address1': widget.billingAddress!.address,
            };

            await createOrderUseCase(
              cartId: cartId,
              shippingAddress: shippingAddress,
              source: 'web',
              currency: 'LKR',
            );

            // Clear cart only after successful order creation
            await cartProvider.clearCart();

            if (!mounted) return;

            // Show success dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l10n.paymentSuccessful),
                    ),
                  ],
                ),
                content: Text(
                  l10n.paymentProcessedSuccessfully(paymentId),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      if (mounted) {
                        context.go('/orders');
                      }
                    },
                    child: Text(l10n.viewOrders),
                  ),
                ],
              ),
            );
          } catch (e, stackTrace) {
            // Log detailed error
            debugPrint('❌ Order creation failed: $e');
            debugPrint('Stack trace: $stackTrace');
            
            if (!mounted) return;

            // Show error dialog to user
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Payment Successful, Order Failed'),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your payment was processed successfully (Payment ID: $paymentId), but we encountered an issue creating your order.',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error: ${e.toString()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Please contact support with your payment ID. Your cart has been preserved.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      if (mounted) {
                        context.pop(); // Go back to checkout
                      }
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
            // DO NOT clear cart if order creation failed
          }
        } else {
          // Missing cart ID or billing address
          debugPrint('⚠️ Cannot create order: cartId=$cartId, billingAddress=${widget.billingAddress != null}');
          
          if (!mounted) return;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Payment Successful, Order Failed'),
                  ),
                ],
              ),
              content: Text(
                'Your payment was processed successfully (Payment ID: $paymentId), but we could not create your order due to missing information. Please contact support.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    if (mounted) {
                      context.pop();
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      onError: (error) {
        if (!mounted) return;

        // Show error dialog
        final l10n = AppLocalizations.of(context)!;
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l10n.paymentFailed),
                ),
              ],
            ),
            content: Text(l10n.paymentCouldNotBeProcessed(error)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      },
      onDismissed: () {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.paymentCancelled),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

}
