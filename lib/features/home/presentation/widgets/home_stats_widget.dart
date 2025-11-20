import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../providers/home_stats_provider.dart';

class HomeStatsWidget extends StatelessWidget {
  const HomeStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<HomeStatsProvider>(
      builder: (context, provider, child) {
        final stats = provider.stats;
        
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFE5E7EB), // Light gray border
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: provider.isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.precision_manufacturing,
                        label: l10n.totalRequests,
                        value: stats?.totalRequests.toString() ?? '0',
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: const Color(0xFFE5E7EB), // Light gray border
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.build_circle,
                        label: l10n.pending,
                        value: stats?.pendingRequests.toString() ?? '0',
                        color: const Color(0xFFF59E0B), // Amber/Orange
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: const Color(0xFFE5E7EB), // Light gray border
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.check_circle,
                        label: l10n.completed,
                        value: stats?.completedRequests.toString() ?? '0',
                        color: const Color(0xFF10B981), // Green (success)
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280), // Medium gray for secondary text
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

