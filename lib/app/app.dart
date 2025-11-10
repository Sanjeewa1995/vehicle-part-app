import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_router.dart';
import '../features/cart/presentation/providers/cart_provider.dart';
import '../core/di/service_locator.dart';
import '../core/providers/locale_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.getAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.get<CartProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.get<LocaleProvider>(),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp.router(
            title: 'Vehicle Parts App 🚗',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            routerConfig: AppRouter.router,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
          );
        },
      ),
    );
  }
}

