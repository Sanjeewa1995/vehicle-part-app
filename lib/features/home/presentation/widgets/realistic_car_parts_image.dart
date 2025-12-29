import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Widget to display realistic 3D car parts images
/// Supports both local assets and network URLs
class RealisticCarPartsImage extends StatelessWidget {
  final String? imagePath; // Local asset path or network URL
  final double? width;
  final double? height;
  final BoxFit fit;
  final double opacity;
  final bool isNetworkImage;

  const RealisticCarPartsImage({
    super.key,
    this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.opacity = 1.0,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    Widget imageWidget;
    
    if (isNetworkImage) {
      imageWidget = Image.network(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      imageWidget = Image.asset(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    if (opacity < 1.0) {
      return Opacity(
        opacity: opacity,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primaryLight.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.precision_manufacturing,
        color: AppColors.primary.withValues(alpha: 0.3),
        size: (width != null && height != null) 
            ? (width! < height! ? width! * 0.4 : height! * 0.4)
            : 48,
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }
}


