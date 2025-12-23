import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_header_widget.dart';
import '../widgets/cart_empty_widget.dart';
import '../widgets/cart_item_card_widget.dart';
import '../widgets/cart_summary_widget.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          // Handle back button - check if we can pop, otherwise navigate to home
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        body: SafeArea(
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              // Loading State
              if (cartProvider.isLoading) {
                final l10n = AppLocalizations.of(context)!;
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
                        l10n.loadingCart,
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
                return Column(
                  children: [
                    // Header
                    const CartHeaderWidget(),
                    // Empty Cart Content
                    const Expanded(
                      child: CartEmptyWidget(),
                    ),
                  ],
                );
              }

              // Cart with Items
              return Column(
                children: [
                  // Header
                  const CartHeaderWidget(),

                  // Cart Items List
                  Expanded(
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
      ),
    );
  }
}
