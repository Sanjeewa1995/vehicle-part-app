import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'animated_engine_widget.dart';

/// Hero banner widget with vehicle-themed visuals
/// Makes it clear this is a vehicle spare parts app
class VehicleHeroBanner extends StatelessWidget {
  const VehicleHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.primaryLight.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Vehicle parts icons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildPartIcon(Icons.precision_manufacturing, AppColors.primary),
                    const SizedBox(width: 12),
                    _buildPartIcon(Icons.build_circle, AppColors.primaryLight),
                    const SizedBox(width: 12),
                    _buildPartIcon(Icons.engineering, AppColors.primary),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Premium Vehicle Parts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Find quality spare parts for your vehicle',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Animated engine widget
          SizedBox(
            width: 100,
            height: 100,
            child: AnimatedEngineWidget(
              size: 100,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}

