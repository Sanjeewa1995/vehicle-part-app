import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeStatsWidget extends StatelessWidget {
  const HomeStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.inventory_2_outlined,
              label: 'Total Requests',
              value: '0',
              color: AppColors.primary,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.borderLight,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.pending_outlined,
              label: 'Pending',
              value: '0',
              color: AppColors.warning,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.borderLight,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.check_circle_outline,
              label: 'Completed',
              value: '0',
              color: AppColors.success,
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

