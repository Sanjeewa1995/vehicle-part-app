import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/help_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/parts/presentation/pages/parts_list_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/requets/presentation/pages/my_request_list_page.dart';
import '../../features/requets/presentation/pages/request_detail_page.dart';
import '../../features/requets/presentation/pages/add_request_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/change_password_page.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/payment/presentation/pages/checkout_page.dart';
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
      final isOnSignupPage = state.matchedLocation == '/signup';
      final isOnProtectedRoute = state.matchedLocation != '/welcome' &&
          state.matchedLocation != '/login' &&
          state.matchedLocation != '/signup' &&
          state.matchedLocation != '/forgot-password' &&
          state.matchedLocation != '/otp-verification' &&
          state.matchedLocation != '/reset-password' &&
          state.matchedLocation != '/splash' &&
          state.matchedLocation != '/help' &&
          state.matchedLocation != '/';

      // If user is authenticated and trying to access welcome/login/signup, redirect to home
      if (isAuthenticated && (isOnWelcomePage || isOnLoginPage || isOnSignupPage)) {
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
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final email = state.extra is Map
              ? (state.extra as Map)['email'] as String?
              : state.uri.queryParameters['email'];
          if (email == null || email.isEmpty) {
            // If no email provided, redirect back to forgot password
            return const ForgotPasswordPage();
          }
          return OTPVerificationPage(email: email);
        },
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) {
          final email = state.extra is Map
              ? (state.extra as Map)['email'] as String?
              : state.uri.queryParameters['email'];
          final otp = state.extra is Map
              ? (state.extra as Map)['otp'] as String?
              : state.uri.queryParameters['otp'];
          if (email == null || email.isEmpty || otp == null || otp.isEmpty) {
            // If no email or OTP provided, redirect back to forgot password
            return const ForgotPasswordPage();
          }
          return ResetPasswordPage(email: email, otp: otp);
        },
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
      // More specific routes must come before parameterized routes
      GoRoute(
        path: '/profile/edit',
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/profile/change-password',
        name: 'change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const HelpPage(),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PaymentPage(
            billingAddress: extra?['billingAddress'],
            cartItems: extra?['cartItems'] ?? [],
            totalAmount: extra?['totalAmount'] ?? 0.0,
          );
        },
      ),
    ],
    refreshListenable: ServiceLocator.getAuthProvider(),
  );
}

