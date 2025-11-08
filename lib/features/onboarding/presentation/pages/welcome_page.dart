import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // Spacing constants matching React Native
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacing2xl = 40;
  static const double spacing3xl = 48;
  static const double spacing4xl = 64;

  // Responsive sizing
  static bool _isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < 700;
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = _isSmallScreen(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final initialSize = isSmall ? 56.0 : 64.0; // M badge size
    
    // Auto-resize AUTO-ZONE based on screen width
    // Base size: 40px, scales down proportionally for smaller screens
    // Minimum: 28px, Maximum: 40px
    final nameFontSize = (screenWidth / 10).clamp(28.0, 40.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background shapes
            Positioned(
              top: -120,
              right: -120,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -180,
              left: -180,
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              right: -60,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
            ),

            // Main content using ListView
            ListView(
              padding: EdgeInsets.only(
                left: spacingXl,
                right: spacingXl,
                top: spacing4xl,
                bottom: isSmall ? 100 : 110, // Space for floating button
              ),
              children: [
                // Logo Section - Centered
                Column(
                  children: [
                    // Logo Icon Container (90x90)
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryUltraLight,
                        border: Border.all(
                          color: AppColors.primaryLight,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.build,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: spacingLg),
                    
                    // Brand Row - M badge + AUTO-ZONE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // M Badge with gradient effect
                        Container(
                          width: initialSize,
                          height: initialSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.primaryLight],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.background,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'M',
                                  style: TextStyle(
                                    fontSize: isSmall ? 22 : 26,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 0.5,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), // columnGap: 12
                        
                        // AUTO-ZONE text - Flexible to prevent overflow with auto-resize
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'AUTO-ZONE',
                              style: TextStyle(
                                fontSize: nameFontSize,
                                height: 1.05,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: 1.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Subtitle - Premium Vehicle Parts
                    Padding(
                      padding: const EdgeInsets.only(top: spacingXs),
                      child: Text(
                        'Premium Vehicle Parts',
                        style: TextStyle(
                          fontSize: isSmall ? 20 : 24, // xl or 2xl
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: spacingLg),
                    
                    // Tagline Container - Centered
                    Column(
                      children: [
                        Text(
                          'Your trusted partner for',
                          style: TextStyle(
                            fontSize: 20, // Typography.fontSize.xl
                            color: AppColors.textSecondary,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'quality auto parts',
                          style: TextStyle(
                            fontSize: 20, // Typography.fontSize.xl
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: spacing2xl),
                  ],
                ),
                
                // Features Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: spacingMd),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeatureIcon(
                        context: context,
                        isSmall: isSmall,
                        emoji: '⚡',
                        backgroundColor: AppColors.primary,
                        title: 'Fast Delivery',
                        subtitle: 'Same day shipping',
                      ),
                      _buildFeatureIcon(
                        context: context,
                        isSmall: isSmall,
                        emoji: '🛡️',
                        backgroundColor: AppColors.warning,
                        title: 'Quality',
                        subtitle: 'Guaranteed',
                      ),
                      _buildFeatureIcon(
                        context: context,
                        isSmall: isSmall,
                        emoji: '🔧',
                        backgroundColor: AppColors.success,
                        title: 'Expert Support',
                        subtitle: '24/7 assistance',
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: spacing4xl),
              ],
            ),

            // Floating Button at Bottom
            Positioned(
              bottom: isSmall ? 20 : 30,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007AFF), Color(0xFF4DA6FF), Color(0xFF007AFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.go('/login'),
                    borderRadius: BorderRadius.circular(25),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isSmall ? 16 : 20,
                        horizontal: 32,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '🚀',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            '→',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcon({
    required BuildContext context,
    required bool isSmall,
    required String emoji,
    required Color backgroundColor,
    required String title,
    required String subtitle,
  }) {
    final iconSize = isSmall ? 60.0 : 80.0;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
              border: Border.all(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: backgroundColor == AppColors.primary
                      ? [AppColors.primary, AppColors.primaryLight]
                      : backgroundColor == AppColors.warning
                          ? [AppColors.warning, AppColors.warningLight]
                          : [AppColors.success, AppColors.successLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 28), // Typography.fontSize["3xl"]
                ),
              ),
            ),
          ),
          SizedBox(height: spacingMd),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14, // Typography.fontSize.sm
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 18 / 14, // lineHeight: 18
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacingXs),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12, // Typography.fontSize.xs
              color: AppColors.textTertiary,
              height: 16 / 12, // lineHeight: 16
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

