import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/billing_address.dart';
import '../../data/repositories/payhere_service.dart';
import '../../data/models/payment_request.dart';

class PaymentPage extends StatefulWidget {
  final BillingAddress? billingAddress;
  final String paymentMethod;
  final List<CartItem> cartItems;
  final double totalAmount;

  const PaymentPage({
    super.key,
    required this.billingAddress,
    this.paymentMethod = 'payhere',
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
        title: const Text(
          'Payment',
          style: TextStyle(
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
                  // Billing Address Summary
                  if (widget.billingAddress != null) ...[
                    const Text(
                      'Billing Address',
                      style: TextStyle(
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
                              'Phone: ${widget.billingAddress!.phone}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Email: ${widget.billingAddress!.email}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Payment Method Display
                  const Text(
                    'Payment Method',
                    style: TextStyle(
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
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: widget.paymentMethod == 'payhere'
                                  ? const Color(0xFF00A651).withValues(alpha: 0.1)
                                  : AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.paymentMethod == 'payhere'
                                  ? Icons.payment
                                  : Icons.money,
                              color: widget.paymentMethod == 'payhere'
                                  ? const Color(0xFF00A651)
                                  : AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.paymentMethod == 'payhere'
                                      ? 'PayHere'
                                      : 'Cash on Delivery',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.paymentMethod == 'payhere'
                                      ? 'Secure payment gateway'
                                      : 'Pay when you receive',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Order Summary
                  const Text(
                    'Order Summary',
                    style: TextStyle(
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
                                          'Qty: ${item.quantity} × ${CurrencyFormatter.formatLKR(double.tryParse(item.product.price) ?? 0.0)}',
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
                      const Text(
                        'Total',
                        style: TextStyle(
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
                    text: widget.paymentMethod == 'payhere'
                        ? 'Pay'
                        : 'Place Order (Cash on Delivery)',
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
    if (widget.billingAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Billing address is required'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      if (widget.paymentMethod == 'payhere') {
        await _handlePayHerePayment(context, total);
      } else if (widget.paymentMethod == 'cod') {
        await _handleCashOnDelivery(context, total);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
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

        // Clear cart after successful payment
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.clearCart();

        if (!mounted) return;

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Payment Successful'),
                ),
              ],
            ),
            content: Text(
              'Your payment has been processed successfully.\n\nPayment ID: $paymentId\n\nYour order will be processed shortly.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (mounted) {
                    context.go('/orders');
                  }
                },
                child: const Text('View Orders'),
              ),
            ],
          ),
        );
      },
      onError: (error) {
        if (!mounted) return;

        // Show error dialog
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: AppColors.error, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Payment Failed'),
                ),
              ],
            ),
            content: Text('Payment could not be processed.\n\nError: $error\n\nPlease try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      onDismissed: () {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment was cancelled'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }

  Future<void> _handleCashOnDelivery(BuildContext context, double total) async {
    // Show confirmation dialog for COD
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Text(
          'You are placing an order for ${CurrencyFormatter.formatLKR(total)}.\n\nYou will pay when you receive the items.\n\nDo you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    // Process COD order
    // TODO: Create order in backend
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Clear cart after successful order
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.clearCart();

    if (!mounted) return;

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Text('Order Placed'),
            ),
          ],
        ),
        content: const Text(
          'Your order has been placed successfully.\n\nYou will pay when you receive the items.\n\nYour order will be processed shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (mounted) {
                context.go('/orders');
              }
            },
            child: const Text('View Orders'),
          ),
        ],
      ),
    );
  }
}
