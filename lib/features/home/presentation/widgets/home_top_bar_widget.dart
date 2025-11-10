import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class HomeTopBarWidget extends StatelessWidget {
  const HomeTopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Right side - Icons
          Row(
            children: [
              // American Flag Icon (using location/flag icon as placeholder)
              Icon(
                Icons.flag,
                size: 20,
                color: Colors.black.withOpacity(0.7),
              ),
              const SizedBox(width: 16),
              // Shopping Cart Icon
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return GestureDetector(
                    onTap: () => context.push('/cart'),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 22,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        if (cartProvider.itemCount > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                cartProvider.itemCount > 9 ? '9+' : '${cartProvider.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

