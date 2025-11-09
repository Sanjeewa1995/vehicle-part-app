import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bottom_app_bar_v2_floating.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_quick_actions_widget.dart';
import '../widgets/home_stats_widget.dart';
import '../widgets/home_help_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Refresh home page data
            await Future.delayed(const Duration(seconds: 1));
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
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
    );
  }
}
