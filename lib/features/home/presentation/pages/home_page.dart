import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/bottom_app_bar_v2_floating.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_quick_actions_widget.dart';
import '../widgets/home_stats_widget.dart';
import '../widgets/home_help_widget.dart';
import '../widgets/home_top_bar_widget.dart';
import '../providers/home_stats_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ServiceLocator.get<HomeStatsProvider>();
        // Load stats when provider is created
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.loadStats();
        });
        return provider;
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Slightly darker gray for contrast
      body: Stack(
        children: [
          // Subtle vehicle-themed background decoration
          Positioned(
            right: -50,
            top: 100,
            child: Opacity(
              opacity: 0.03,
              child: Icon(
                Icons.precision_manufacturing,
                size: 300,
                color: AppColors.primary,
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: 200,
            child: Opacity(
              opacity: 0.03,
              child: Icon(
                Icons.engineering,
                size: 250,
                color: AppColors.primary,
              ),
            ),
          ),
          // Main content
          Column(
        children: [
          // Top safe area with white background (matching top app bar)
          Container(
            height: topPadding,
            color: Colors.white,
          ),
          // Content with SafeArea (excluding top)
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Top Bar
                  const HomeTopBarWidget(),
            // Scrollable Content
            Expanded(
              child: Consumer<HomeStatsProvider>(
                builder: (context, statsProvider, child) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await statsProvider.loadStats();
                    },
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  children: [
                    // Header Section with Greeting
                    const HomeHeaderWidget(),

                    const SizedBox(height: 32),

                    // Quick Actions Section
                    const HomeQuickActionsWidget(),

                    const SizedBox(height: 32),

                    // Stats Section
                    const HomeStatsWidget(),

                    const SizedBox(height: 32),

                    // Help Section
                    const HomeHelpWidget(),

                    const SizedBox(height: 32),
                  ],
                ),
                  );
                },
              ),
            ),
                ],
              ),
            ),
          ),
        ],
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
    ),
    );
  }
}
