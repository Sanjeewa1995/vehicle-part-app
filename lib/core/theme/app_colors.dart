import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Electric Blue for energy & reliability
  static const Color primary = Color(0xFF007AFF); // Electric Blue - main brand color
  static const Color primaryDark = Color(0xFF0056CC); // Darker blue for pressed states
  static const Color primaryLight = Color(0xFF4DA6FF); // Lighter blue for hover states
  static const Color primaryUltraLight = Color(0xFFE6F3FF); // Ultra light blue for backgrounds

  // Secondary Colors - Sophisticated Grays
  static const Color secondary = Color(0xFF2C2C2E); // Charcoal Gray - sophisticated depth
  static const Color secondaryLight = Color(0xFF48484A); // Lighter charcoal for cards
  static const Color secondaryDark = Color(0xFF1C1C1E); // Darker charcoal for emphasis
  static const Color secondaryUltraLight = Color(0xFFF2F2F7); // Ultra light gray for subtle backgrounds

  // Accent Colors - Premium Gold/Amber
  static const Color accent = Color(0xFFFFB300); // Premium Gold - luxury highlight
  static const Color accentDark = Color(0xFFE6A000); // Darker gold for pressed states
  static const Color accentLight = Color(0xFFFFC233); // Lighter gold for highlights
  static const Color accentUltraLight = Color(0xFFFFF8E6); // Ultra light gold for backgrounds

  // Background Colors - Clean & Modern
  static const Color background = Color(0xFFFFFFFF); // Pure white - clean primary background
  static const Color backgroundSecondary = Color(0xFFF8F9FA); // Light gray - subtle secondary background
  static const Color backgroundTertiary = Color(0xFFF2F2F7); // Ultra light gray - tertiary background
  static const Color backgroundDark = Color(0xFF1C1C1E); // Dark background for contrast elements

  // Text Colors - High Contrast & Readable
  static const Color textPrimary = Color(0xFF1C1C1E); // Deep charcoal - maximum readability
  static const Color textSecondary = Color(0xFF48484A); // Medium gray - secondary text
  static const Color textTertiary = Color(0xFF8E8E93); // Light gray - tertiary text
  static const Color textLight = Color(0xFFC7C7CC); // Very light gray - placeholders
  static const Color textWhite = Color(0xFFFFFFFF); // White text for dark backgrounds
  static const Color textInverse = Color(0xFFFFFFFF); // White text for dark elements

  // Status Colors - Vibrant & Clear
  static const Color success = Color(0xFF34C759); // Vibrant green for success states
  static const Color successLight = Color(0xFFE8F5E8); // Light green background
  static const Color warning = Color(0xFFFF9500); // Bright orange for warnings
  static const Color warningLight = Color(0xFFFFF4E6); // Light orange background
  static const Color error = Color(0xFFFF3B30); // Clear red for errors
  static const Color errorLight = Color(0xFFFFEBEE); // Light red background
  static const Color info = Color(0xFF007AFF); // Blue for info (same as primary)
  static const Color infoLight = Color(0xFFE6F3FF); // Light blue background

  // Border Colors - Subtle & Refined
  static const Color border = Color(0xFFE5E5EA); // Light border - subtle separation
  static const Color borderDark = Color(0xFFD1D1D6); // Medium border - clear separation
  static const Color borderLight = Color(0xFFF2F2F7); // Very light border - minimal separation
  static const Color borderAccent = Color(0xFF007AFF); // Accent border - primary color

  // Shadow Colors - Soft & Modern
  static const Color shadow = Color.fromRGBO(0, 0, 0, 0.08);
  static const Color shadowDark = Color.fromRGBO(0, 0, 0, 0.15);
  static const Color shadowLight = Color.fromRGBO(0, 0, 0, 0.04);
  static const Color shadowColored = Color.fromRGBO(0, 122, 255, 0.15); // Colored shadow for primary elements

  // Legacy support (for backward compatibility)
  static const Color surface = background;
  static const Color surfaceDark = backgroundTertiary;
  static const Color textHint = textTertiary;
  static const Color divider = border;

  // Private constructor to prevent instantiation
  AppColors._();
}

