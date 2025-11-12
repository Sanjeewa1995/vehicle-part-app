import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/core/di/service_locator.dart';
import 'package:vehicle_part_app/shared/widgets/bottom_app_bar_v2_floating.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../providers/request_list_provider.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/request_card_widget.dart';

class MyRequestList extends StatefulWidget {
  const MyRequestList({super.key});

  @override
  State<MyRequestList> createState() => _MyRequestListState();
}

class _MyRequestListState extends State<MyRequestList> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceLocator.get<RequestListProvider>(),
      builder: (context, child) {
        // Load requests after provider is created
        final provider = context.read<RequestListProvider>();
        if (provider.status == RequestListStatus.initial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.loadRequests(refresh: true);
          });
        }
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            l10n.myRequests,
            style: const TextStyle(
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
        body: Consumer<RequestListProvider>(
          builder: (context, provider, child) {
            if (provider.status == RequestListStatus.loading &&
                provider.requests.isEmpty) {
              return const LoadingStateWidget();
            }

            if (provider.status == RequestListStatus.error &&
                provider.requests.isEmpty) {
              final l10n = AppLocalizations.of(context)!;
              return ErrorStateWidget(
                errorMessage: provider.errorMessage ?? l10n.failedToLoadRequestDetails,
              );
            }

            if (provider.requests.isEmpty) {
              return EmptyStateWidget(provider: provider);
            }

            return _buildRequestList(provider);
          },
        ),
        floatingActionButton: Consumer<RequestListProvider>(
          builder: (context, provider, child) {
            if (provider.status == RequestListStatus.loading &&
                provider.requests.isEmpty) {
              return const SizedBox.shrink();
            }
            return FloatingActionButton(
              onPressed: () {
                context.go('/requests/add');
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.textWhite),
            );
          },
        ),
        bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
        );
      },
    );
  }


  Widget _buildRequestList(RequestListProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: provider.requests.length,
        itemBuilder: (context, index) {
          return RequestCardWidget(request: provider.requests[index]);
        },
      ),
    );
  }
}
