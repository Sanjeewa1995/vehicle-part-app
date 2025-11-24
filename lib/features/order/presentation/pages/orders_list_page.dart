import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/bottom_app_bar_v2_floating.dart' show AppBottomNavigationBarV2Floating;
import '../../../../l10n/app_localizations.dart';
import '../providers/order_list_provider.dart';
import '../widgets/order_card_widget.dart';
import '../widgets/order_empty_widget.dart';
import '../widgets/order_loading_widget.dart';
import '../widgets/order_error_widget.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ChangeNotifierProvider(
      create: (_) => ServiceLocator.get<OrderListProvider>(),
      builder: (context, child) {
        final provider = context.read<OrderListProvider>();
        if (provider.status == OrderListStatus.initial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.loadOrders(refresh: true);
          });
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            if (!didPop) {
              // Navigate to home when back button is pressed
              context.go('/home');
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(
              l10n.myOrders,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                onPressed: () => provider.refresh(),
                tooltip: l10n.refresh,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: AppColors.borderLight,
              ),
            ),
          ),
          body: Consumer<OrderListProvider>(
            builder: (context, provider, child) {
              if (provider.status == OrderListStatus.loading &&
                  provider.orders.isEmpty) {
                return const OrderLoadingWidget();
              }

              if (provider.status == OrderListStatus.error &&
                  provider.orders.isEmpty) {
                return OrderErrorWidget(
                  errorMessage: provider.errorMessage ?? l10n.failedToLoadOrders,
                  onRetry: () => provider.refresh(),
                );
              }

              if (provider.orders.isEmpty) {
                return OrderEmptyWidget(provider: provider);
              }

              return RefreshIndicator(
                onRefresh: () => provider.refresh(),
                color: AppColors.primary,
                child: ListView.builder(
                  controller: _scrollController
                    ..addListener(() {
                      if (_scrollController.position.pixels >=
                          _scrollController.position.maxScrollExtent * 0.8) {
                        if (provider.hasMore && !provider.isLoading) {
                          provider.loadOrders();
                        }
                      }
                    }),
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.orders.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.orders.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }
                    return OrderCardWidget(order: provider.orders[index]);
                  },
                ),
              );
            },
          ),
          bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
          ),
        );
      },
    );
  }
}

