import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/cart_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/cart_provider.dart';

class CartItemCardWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCardWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    final unitPrice = double.tryParse(product.price) ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(product.image),
            const SizedBox(width: 12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Free Delivery Text
                      Text(
                        'Eligible for free delivery',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // In Stock Status
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'In Stock',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Price and Quantity Row - Responsive
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 200;
                          
                          if (isCompact) {
                            // Stack vertically on small screens
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Quantity Controls
                                _buildQuantityControls(context, cartItem, isCompact: true),
                                const SizedBox(height: 8),
                                // Price
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    CurrencyFormatter.formatLKR(unitPrice),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Horizontal layout on larger screens
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Quantity Controls
                                _buildQuantityControls(context, cartItem, isCompact: false),
                                const SizedBox(width: 8),
                                // Price
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      CurrencyFormatter.formatLKR(unitPrice),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Delete Button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.textTertiary,
                    size: 22,
                  ),
                  onPressed: () {
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.removeFromCart(product.id);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.backgroundSecondary,
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.textTertiary,
                      size: 32,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.backgroundSecondary,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: AppColors.backgroundSecondary,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textTertiary,
                  size: 40,
                ),
              ),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, CartItem cartItem, {bool isCompact = false}) {
    final buttonSize = isCompact ? 28.0 : 32.0;
    final fontSize = isCompact ? 16.0 : 18.0;
    final quantityWidth = isCompact ? 36.0 : 40.0;
    final quantityFontSize = isCompact ? 14.0 : 15.0;
    final borderRadius = isCompact ? 6.0 : 8.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: cartItem.quantity > 1
                  ? () {
                      final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);
                      cartProvider.updateQuantity(
                        cartItem.product.id,
                        cartItem.quantity - 1,
                      );
                    }
                  : null,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
              ),
              child: Container(
                width: buttonSize,
                height: buttonSize,
                alignment: Alignment.center,
                child: Text(
                  '-',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: cartItem.quantity > 1
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),

          // Quantity Display
          Container(
            width: quantityWidth,
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 6 : 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              '${cartItem.quantity}',
              style: TextStyle(
                fontSize: quantityFontSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Increase Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                cartProvider.updateQuantity(
                  cartItem.product.id,
                  cartItem.quantity + 1,
                );
              },
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              child: Container(
                width: buttonSize,
                height: buttonSize,
                alignment: Alignment.center,
                child: Text(
                  '+',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
