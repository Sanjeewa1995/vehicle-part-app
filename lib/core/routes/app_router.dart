import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/parts/presentation/pages/parts_list_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/requets/presentation/pages/my_request_list_page.dart';
import '../../features/requets/presentation/pages/request_detail_page.dart';
import '../../features/requets/presentation/pages/add_request_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../core/di/service_locator.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
      // Don't redirect from splash page - let it handle navigation
      if (state.matchedLocation == '/splash') {
        return null;
      }

      final authProvider = Provider.of<AuthProvider>(
        context,
        listen: false,
      );

      // Wait for auth status to be checked (not in initial/loading state)
      if (authProvider.status == AuthStatus.initial || 
          authProvider.status == AuthStatus.loading) {
        // Allow current navigation while checking auth status
        return null;
      }

      final isAuthenticated = authProvider.isAuthenticated;
      final isOnWelcomePage = state.matchedLocation == '/welcome';
      final isOnLoginPage = state.matchedLocation == '/login';
      final isOnProtectedRoute = state.matchedLocation != '/welcome' &&
          state.matchedLocation != '/login' &&
          state.matchedLocation != '/splash' &&
          state.matchedLocation != '/';

      // If user is authenticated and trying to access welcome/login, redirect to home
      if (isAuthenticated && (isOnWelcomePage || isOnLoginPage)) {
        return '/home';
      }

      // If user is not authenticated and trying to access protected routes, redirect to welcome
      if (!isAuthenticated && isOnProtectedRoute) {
        return '/welcome';
      }

      // Allow navigation to welcome/login for unauthenticated users
      // Allow navigation to protected routes for authenticated users
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/splash',
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/parts',
        name: 'parts',
        builder: (context, state) => const PartsListPage(),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const MyRequestList(),
      ),
      // More specific route must come before parameterized route
      GoRoute(
        path: '/requests/add',
        name: 'add-request',
        builder: (context, state) => const AddRequestPage(),
      ),
      GoRoute(
        path: '/requests/:id',
        name: 'request-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return RequestDetailPage(requestId: id);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) => const PaymentPage(),
      ),
    ],
    refreshListenable: ServiceLocator.getAuthProvider(),
  );
}

