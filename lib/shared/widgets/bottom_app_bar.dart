import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';

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
                icon: Icons.build_outlined,
                activeIcon: Icons.build,
                label: 'Request',
                route: '/requests/add',
                isActive: _currentRoute == '/requests/add',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.list_outlined,
                activeIcon: Icons.list,
                label: 'My Requests',
                route: '/orders',
                isActive: _currentRoute == '/orders',
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
              Icon(
                isActive ? activeIcon : icon,
                size: 20,
                color: iconColor,
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

