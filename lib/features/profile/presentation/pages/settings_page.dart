import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/shared/widgets/bottom_app_bar_v2_floating.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_part_app/core/di/service_locator.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.backgroundSecondary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.borderLight,
          ),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          return ListView(
            children: [
              const SizedBox(height: 24),

              // Profile Section
              _buildProfileSection(context, user),

              // Account Section
              _buildAccountSection(context),

              // Support Section
              _buildSupportSection(context),

              // Logout Section
              _buildLogoutSection(context, authProvider),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
    );
  }

  Widget _buildProfileSection(BuildContext context, user) {
    final l10n = AppLocalizations.of(context)!;
    final firstName = user?.firstName ?? 'User';
    final lastName = user?.lastName ?? '';
    final email = user?.email ?? 'user@example.com';
    final initials = '${firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U'}${lastName.isNotEmpty ? lastName[0].toUpperCase() : ''}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profile,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$firstName $lastName',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit Button
                GestureDetector(
                  onTap: () {
                    context.push('/profile/edit');
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.account,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _SettingItem(
                  icon: Icons.person_outline,
                  title: l10n.editProfile,
                  subtitle: l10n.editProfileSubtitle,
                  onTap: () {
                    context.push('/profile/edit');
                  },
                ),
                _buildDivider(),
                _SettingItem(
                  icon: Icons.lock_outline,
                  title: l10n.changePassword,
                  subtitle: l10n.changePasswordSubtitle,
                  onTap: () {
                    context.push('/profile/change-password');
                  },
                ),
                _buildDivider(),
                _SettingItem(
                  icon: Icons.language,
                  title: l10n.language,
                  subtitle: l10n.languageSubtitle,
                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
                _buildDivider(),
                _SettingItem(
                  icon: Icons.shield_outlined,
                  title: l10n.privacySecurity,
                  subtitle: l10n.privacySecuritySubtitle,
                  onTap: () {
                    _showComingSoonDialog(context, l10n.privacySecurity);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.support,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _SettingItem(
                  icon: Icons.help_outline,
                  title: l10n.helpSupport,
                  subtitle: l10n.helpSupportSubtitle,
                  onTap: () {
                    _showComingSoonDialog(context, l10n.helpSupport);
                  },
                ),
                _buildDivider(),
                _SettingItem(
                  icon: Icons.description_outlined,
                  title: l10n.privacyPolicy,
                  subtitle: l10n.privacyPolicySubtitle,
                  onTap: () {
                    _showComingSoonDialog(context, l10n.privacyPolicy);
                  },
                ),
                _buildDivider(),
                _SettingItem(
                  icon: Icons.description_outlined,
                  title: l10n.termsOfService,
                  subtitle: l10n.termsOfServiceSubtitle,
                  onTap: () {
                    _showComingSoonDialog(context, l10n.termsOfService);
                  },
                ),
                _buildDivider(),
                _SettingItem(
                  icon: Icons.info_outline,
                  title: l10n.about,
                  subtitle: l10n.aboutSubtitle,
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _SettingItem(
          icon: Icons.logout,
          title: l10n.logout,
          subtitle: l10n.logoutSubtitle,
          onTap: () {
            _showLogoutDialog(context, authProvider);
          },
          isDestructive: true,
          showChevron: false,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.borderLight,
      indent: 64,
    );
  }

  void _showLanguageDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final prefs = ServiceLocator.get<SharedPreferences>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleProvider.supportedLocales.map((locale) {
            final isSelected = localeProvider.locale == locale;
            return RadioListTile<Locale>(
              title: Text(
                localeProvider.getLanguageName(locale.languageCode),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              value: locale,
              groupValue: localeProvider.locale,
              onChanged: (Locale? value) async {
                if (value != null) {
                  await localeProvider.setLocale(value, prefs);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.comingSoon),
        content: Text(l10n.comingSoonMessage(feature)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.aboutTitle),
        content: Text(l10n.aboutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    final l10n = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              // Close dialog first
              Navigator.pop(dialogContext);
              
              // Perform logout
              await authProvider.logout();
              
              // Navigate to splash screen
              // Use a small delay to ensure state updates are processed
              await Future.delayed(const Duration(milliseconds: 200));
              
              // Use the router directly to ensure navigation works
              if (context.mounted) {
                router.go('/splash');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool showChevron;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDestructive = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.error.withValues(alpha: 0.2)
                    : AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? AppColors.error : AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive
                          ? AppColors.error
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Chevron
            if (showChevron && onTap != null)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

