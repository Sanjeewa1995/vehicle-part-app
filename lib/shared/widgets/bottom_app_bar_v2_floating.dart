import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

/// Floating Pill-Style Bottom Navigation Bar
/// Features: Floating design with rounded pill shape, elevated above screen
class AppBottomNavigationBarV2Floating extends StatefulWidget {
  const AppBottomNavigationBarV2Floating({super.key});

  @override
  State<AppBottomNavigationBarV2Floating> createState() =>
      _AppBottomNavigationBarV2FloatingState();
}

class _AppBottomNavigationBarV2FloatingState
    extends State<AppBottomNavigationBarV2Floating> {
  String _currentRoute = '/home';
  dynamic _routerDelegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routerDelegate = GoRouter.of(context).routerDelegate;
    _updateCurrentRoute();
    _routerDelegate?.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    _routerDelegate?.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    _updateCurrentRoute();
  }

  void _updateCurrentRoute() {
    final router = GoRouter.of(context);
    final location = router.routerDelegate.currentConfiguration.uri.path;
    if (_currentRoute != location) {
      setState(() {
        _currentRoute = location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
              route: '/home',
              isActive: _currentRoute == '/home',
            ),
            _buildNavItem(
              icon: Icons.list_alt_outlined,
              activeIcon: Icons.list_alt_rounded,
              label: 'Requests',
              route: '/orders',
              isActive: _currentRoute == '/orders',
            ),
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return _buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart_rounded,
                  label: 'Cart',
                  route: '/cart',
                  isActive: _currentRoute == '/cart',
                  badgeCount: cartProvider.itemCount > 0
                      ? cartProvider.itemCount
                      : null,
                );
              },
            ),
            _buildNavItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings_rounded,
              label: 'Settings',
              route: '/settings',
              isActive: _currentRoute == '/settings' ||
                  _currentRoute == '/profile',
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required bool isActive,
    int? badgeCount,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isActive) {
            context.go(route);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isActive ? activeIcon : icon,
                    size: 24,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  if (badgeCount != null && badgeCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Center(
                          child: Text(
                            badgeCount > 9 ? '9+' : '$badgeCount',
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

