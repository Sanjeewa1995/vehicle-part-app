import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bottom_app_bar_v2_floating.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_header_widget.dart';
import '../widgets/cart_empty_widget.dart';
import '../widgets/cart_item_card_widget.dart';
import '../widgets/cart_summary_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            // Loading State
            if (cartProvider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading cart...',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Empty State
            if (cartProvider.isEmpty) {
              return const CartEmptyWidget();
            }

            // Cart with Items
            return Column(
              children: [
                // Header
                const CartHeaderWidget(),

                // Cart Items List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await cartProvider.refreshCart();
                    },
                    color: AppColors.primary,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartProvider.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 0),
                      itemBuilder: (context, index) {
                        return CartItemCardWidget(
                          cartItem: cartProvider.items[index],
                        );
                      },
                    ),
                  ),
                ),

                // Summary and Checkout
                CartSummaryWidget(
                  totalPrice: cartProvider.totalPrice,
                  itemCount: cartProvider.itemCount,
                  isLoading: cartProvider.isLoading,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
    );
  }
}
