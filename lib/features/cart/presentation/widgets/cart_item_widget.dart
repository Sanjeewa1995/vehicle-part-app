import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/cart_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.image != null && product.image!.isNotEmpty
                ? Image.network(
                    product.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: AppColors.backgroundSecondary,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.textTertiary,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: AppColors.backgroundSecondary,
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.textTertiary,
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Product Details - Expanded to take remaining space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Product Description
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Price and Quantity Controls
                Row(
                  children: [
                    // Price - Flexible to allow proper display
                    Flexible(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatLKR(cartItem.totalPrice),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Quantity Controls - Fixed width to prevent overflow
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Decrease Button
                        InkWell(
                          onTap: () {
                            final cartProvider =
                                Provider.of<CartProvider>(context, listen: false);
                            cartProvider.updateQuantity(
                              product.id,
                              cartItem.quantity - 1,
                            );
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Quantity Display
                        SizedBox(
                          width: 32,
                          child: Text(
                            '${cartItem.quantity}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Increase Button
                        InkWell(
                          onTap: () {
                            final cartProvider =
                                Provider.of<CartProvider>(context, listen: false);
                            cartProvider.updateQuantity(
                              product.id,
                              cartItem.quantity + 1,
                            );
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 20,
            ),
            onPressed: () {
              final cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              cartProvider.removeFromCart(product.id);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

