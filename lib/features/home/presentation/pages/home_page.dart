import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/bottom_app_bar_v2_floating.dart';
import '../../../../core/di/service_locator.dart';
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
      backgroundColor: const Color(0xFFF9FAFB), // Light gray background
      body: Column(
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
      bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
    ),
    );
  }
}
