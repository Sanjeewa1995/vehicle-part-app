import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class HomeQuickActionsWidget extends StatelessWidget {
  const HomeQuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quickActions = [
      {
        'id': 'request-part',
        'title': l10n.requestSparePart,
        'subtitle': l10n.findPartYouNeed,
        'icon': Icons.search_outlined,
        'gradient': [
          AppColors.primary,
          AppColors.primaryLight,
        ],
        'route': '/parts',
      },
      {
        'id': 'my-requests',
        'title': l10n.myRequests,
        'subtitle': l10n.viewYourRequests,
        'icon': Icons.list_alt_outlined,
        'gradient': [
          AppColors.primaryLight,
          const Color(0xFF5BA3D6), // Light blue
        ],
        'route': '/orders',
      },
      {
        'id': 'add-request',
        'title': l10n.addRequest,
        'subtitle': l10n.createNewRequest,
        'icon': Icons.add_circle_outline,
        'gradient': [
          AppColors.primary,
          AppColors.primaryLight,
        ],
        'route': '/requests/add',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937), // Dark gray
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              l10n.quickActions,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937), // Dark gray
                letterSpacing: -0.5,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Text(
                l10n.viewAll,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 175,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: quickActions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return _buildActionCard(
                context: context,
                title: action['title'] as String,
                subtitle: action['subtitle'] as String,
                icon: action['icon'] as IconData,
                gradient: action['gradient'] as List<Color>,
                onTap: () {
                  context.go(action['route'] as String);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 175,
        width: 160,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.textWhite,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textWhite.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

