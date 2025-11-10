import 'package:flutter/material.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class HomeStatsWidget extends StatelessWidget {
  const HomeStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.inventory_2_outlined,
              label: l10n.totalRequests,
              value: '0',
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
              icon: Icons.pending_outlined,
              label: l10n.pending,
              value: '0',
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
              icon: Icons.check_circle_outline,
              label: l10n.completed,
              value: '0',
              color: const Color(0xFF10B981), // Green (success)
            ),
          ),
        ],
      ),
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

