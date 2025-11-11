import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/core/di/service_locator.dart';
import 'package:vehicle_part_app/shared/widgets/bottom_app_bar_v2_floating.dart';
import '../providers/product_list_provider.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/product_card_widget.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceLocator.get<ProductListProvider>(),
      builder: (context, child) {
        // Load products after provider is created
        final provider = context.read<ProductListProvider>();
        if (provider.status == ProductListStatus.initial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.loadProducts(refresh: true);
          });
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppColors.textSecondary),
                onPressed: () {
                  // TODO: Implement filter
                },
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
          body: Consumer<ProductListProvider>(
            builder: (context, provider, child) {
              if (provider.status == ProductListStatus.loading &&
                  provider.products.isEmpty) {
                return const ProductLoadingStateWidget();
              }

              if (provider.status == ProductListStatus.error &&
                  provider.products.isEmpty) {
                return ProductErrorStateWidget(
                  errorMessage: provider.errorMessage ?? 'Failed to load products',
                );
              }

              if (provider.products.isEmpty) {
                return ProductEmptyStateWidget(provider: provider);
              }

              return _buildProductList(provider);
            },
          ),
          bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
        );
      },
    );
  }

  Widget _buildProductList(ProductListProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          return ProductCardWidget(product: provider.products[index]);
        },
      ),
    );
  }
}


