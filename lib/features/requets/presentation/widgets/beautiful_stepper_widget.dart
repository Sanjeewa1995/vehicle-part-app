import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BeautifulStepperWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;

  const BeautifulStepperWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryUltraLight,
            AppColors.backgroundSecondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step Indicators Row with Connectors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isActive = index == currentStep;
              final isPending = index > currentStep;

              return Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Circle with Label
                    Expanded(
                      child: Column(
                        children: [
                          // Step Circle
                          _StepCircle(
                            stepNumber: index + 1,
                            isCompleted: isCompleted,
                            isActive: isActive,
                            isPending: isPending,
                          ),
                          const SizedBox(height: 6),
                          // Step Label
                          Text(
                            stepLabels != null && 
                            stepLabels!.length == totalSteps
                                ? stepLabels![index]
                                : 'Step ${index + 1}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive || isCompleted
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isActive || isCompleted
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Connector Line
                    if (index < totalSteps - 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _StepConnector(
                          isCompleted: isCompleted,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final bool isCompleted;
  final bool isActive;
  final bool isPending;

  const _StepCircle({
    required this.stepNumber,
    required this.isCompleted,
    required this.isActive,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isActive || isCompleted
            ? LinearGradient(
                colors: isActive
                    ? [AppColors.primary, AppColors.primaryLight]
                    : [AppColors.success, AppColors.success.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPending ? AppColors.background : null,
        border: Border.all(
          color: isPending
              ? AppColors.border
              : (isActive || isCompleted
                  ? Colors.transparent
                  : AppColors.primary),
          width: isPending ? 2 : 0,
        ),
        boxShadow: isActive || isCompleted
            ? [
                BoxShadow(
                  color: (isActive ? AppColors.primary : AppColors.success)
                      .withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: AppColors.textWhite,
                size: 16,
              )
            : Text(
                '$stepNumber',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isPending
                      ? AppColors.textSecondary
                      : AppColors.textWhite,
                ),
              ),
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isCompleted;

  const _StepConnector({
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? LinearGradient(
                colors: [AppColors.success, AppColors.primary],
              )
            : null,
        color: isCompleted ? null : AppColors.border,
        borderRadius: BorderRadius.circular(2),
        boxShadow: isCompleted
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
    );
  }
}

