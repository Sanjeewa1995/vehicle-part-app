import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_router.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/cart/presentation/providers/cart_provider.dart';
import '../core/di/service_locator.dart';
import '../core/providers/locale_provider.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final LocaleProvider _localeProvider;

  @override
  void initState() {
    super.initState();
    _localeProvider = LocaleProvider();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: _localeProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.getAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.get<CartProvider>(),
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

