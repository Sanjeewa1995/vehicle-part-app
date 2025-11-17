import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  String _currentRoute = '/home';
  dynamic _routerDelegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save reference to router delegate for safe disposal
    _routerDelegate = GoRouter.of(context).routerDelegate;
    _updateCurrentRoute();
    // Listen to route changes
    _routerDelegate?.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    // Use saved reference instead of accessing context
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

    return Container(
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
        child: Container(
          constraints: const BoxConstraints(minHeight: 60, maxHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                route: '/home',
                isActive: _currentRoute == '/home',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.list_outlined,
                activeIcon: Icons.list,
                label: 'My Requests',
                route: '/requests',
                isActive: _currentRoute == '/requests',
              ),
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return _buildNavItem(
                    context: context,
                    icon: Icons.shopping_cart_outlined,
                    activeIcon: Icons.shopping_cart,
                    label: 'Cart',
                    route: '/cart',
                    isActive: _currentRoute == '/cart',
                    badgeCount: cartProvider.itemCount > 0 ? cartProvider.itemCount : null,
                  );
                },
              ),
              _buildNavItem(
                context: context,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Settings',
                route: '/settings',
                isActive: _currentRoute == '/settings' || _currentRoute == '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required bool isActive,
    int? badgeCount,
  }) {
    final iconColor = isActive ? AppColors.primary : AppColors.textSecondary;
    final textColor = isActive ? AppColors.primary : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (!isActive) {
            context.go(route);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isActive ? activeIcon : icon,
                    size: 20,
                    color: iconColor,
                  ),
                  if (badgeCount != null && badgeCount > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.0,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

