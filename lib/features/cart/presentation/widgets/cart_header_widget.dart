import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';

class CartHeaderWidget extends StatelessWidget {
  const CartHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Text(
          l10n.myCart,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
