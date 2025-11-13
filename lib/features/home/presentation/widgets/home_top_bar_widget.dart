import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class HomeTopBarWidget extends StatelessWidget {
  const HomeTopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _AutoZoneLogo(),
          Row(
            children: [
              SizedBox(
                height: 20,
                width: 30,
                child: ClipRRect(child: CountryFlag.fromCountryCode('LK')),
              ),
              const SizedBox(width: 16),
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
                                cartProvider.itemCount > 9
                                    ? '9+'
                                    : '${cartProvider.itemCount}',
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

class _AutoZoneLogo extends StatelessWidget {
  const _AutoZoneLogo();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/logo.jpeg',
        height: 48,
        width: 48,
        fit: BoxFit.cover,
      ),
    );
  }
}
