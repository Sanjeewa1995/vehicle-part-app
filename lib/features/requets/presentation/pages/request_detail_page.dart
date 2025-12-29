import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/core/di/service_locator.dart';
import 'package:vehicle_part_app/core/utils/error_message_helper.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';
import '../providers/request_detail_provider.dart';
import '../../domain/entities/vehicle_part_request.dart';
import '../widgets/product_card.dart';
import '../../domain/entities/product.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import 'package:intl/intl.dart';

class RequestDetailPage extends StatelessWidget {
  final int requestId;

  const RequestDetailPage({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceLocator.get<RequestDetailProvider>()
        ..loadRequest(requestId),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (!didPop) {
            // Navigate to request list page when back button is pressed
            context.go('/requests');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
            onPressed: () => context.go('/requests'),
          ),
          title: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return Text(
                l10n.requestDetails,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              );
            },
          ),
          centerTitle: true,
          // actions: [
          //   Consumer<RequestDetailProvider>(
          //     builder: (context, provider, child) {
          //       if (provider.isLoading || provider.isDeleting) {
          //         return const Padding(
          //           padding: EdgeInsets.all(16),
          //           child: SizedBox(
          //             width: 20,
          //             height: 20,
          //             child: CircularProgressIndicator(
          //               strokeWidth: 2,
          //               valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
          //             ),
          //           ),
          //         );
          //       }
          //       return IconButton(
          //         icon: const Icon(Icons.delete_outline, color: AppColors.error),
          //         onPressed: provider.isDeleting
          //             ? null
          //             : () {
          //                 _showDeleteDialog(context, provider);
          //               },
          //       );
          //     },
          //   ),
          // ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: AppColors.borderLight,
            ),
          ),
        ),
        body: Consumer<RequestDetailProvider>(
          builder: (context, provider, child) {
            if (provider.status == RequestDetailStatus.loading) {
              return _buildLoadingState();
            }

            if (provider.status == RequestDetailStatus.error) {
              return _buildErrorState(context, provider);
            }

            if (provider.request == null) {
              return _buildNotFoundState(context);
            }

            return _buildContent(context, provider);
          },
        ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.loadingRequestDetails,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, RequestDetailProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.error,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage != null
                  ? ErrorMessageHelper.getUserFriendlyMessage(
                      provider.errorMessage!,
                      context: context,
                    )
                  : l10n.failedToLoadRequestDetails,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                provider.loadRequest(requestId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.retry,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.requestNotFound,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/requests'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.goBack,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, RequestDetailProvider provider) {
    final request = provider.request!;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildStatusBadge(request.status, l10n),
          ),

          // Part Information
          _buildSection(
            title: l10n.partInformation,
            children: [
              _buildInfoRow(l10n.partName, request.partName),
              if (request.partNumber != null && request.partNumber!.isNotEmpty)
                _buildInfoRow(l10n.partNumber, request.partNumber!),
              _buildInfoRow(l10n.description, request.description),
            ],
          ),

          // Vehicle Information
          _buildSection(
            title: l10n.vehicleInformation,
            children: [
              _buildInfoRow(
                l10n.vehicleType,
                _capitalizeFirst(request.vehicleType),
              ),
              _buildInfoRow(l10n.model, request.vehicleModel),
              _buildInfoRow(l10n.year, request.vehicleYear.toString()),
            ],
          ),

          // Media Section
          if (request.vehicleImage != null ||
              request.partImage != null ||
              request.partVideo != null)
            _buildMediaSection(context, request, l10n),

          // Products Section (Admin's suggested products)
          if (request.products.isNotEmpty)
            _buildProductsSection(context, request, l10n),

          // Request Information
          _buildSection(
            title: l10n.requestInformation,
            children: [
              _buildInfoRow(l10n.requestId, '#${request.id}'),
              _buildInfoRow(
                l10n.created,
                _formatDate(request.createdAt),
              ),
              _buildInfoRow(
                l10n.lastUpdated,
                _formatDate(request.updatedAt),
              ),
            ],
          ),

          const SizedBox(height: 32), // Bottom spacing
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, AppLocalizations l10n) {
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
    String statusText = status.toUpperCase();
    
    // Translate status if available
    if (status.toLowerCase() == 'pending') {
      statusText = l10n.pending.toUpperCase();
    } else if (status.toLowerCase() == 'completed') {
      statusText = l10n.completed.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 16,
            color: AppColors.textWhite,
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(
    BuildContext context,
    VehiclePartRequest request,
    AppLocalizations l10n,
  ) {
    return _buildSection(
      title: l10n.media,
      children: [
        if (request.vehicleImage != null && request.vehicleImage!.isNotEmpty)
          _buildImageItem(
            context,
            l10n.vehicleImage,
            request.vehicleImage!,
          ),
        if (request.partImage != null && request.partImage!.isNotEmpty)
          _buildImageItem(
            context,
            l10n.partImage,
            request.partImage!,
          ),
        if (request.partVideo != null && request.partVideo!.isNotEmpty)
          _buildVideoItem(context, l10n.partVideo, request.partVideo!, l10n),
      ],
    );
  }

  Widget _buildImageItem(BuildContext context, String label, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showImageModal(context, imageUrl),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: AppColors.backgroundSecondary,
                    child: const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItem(BuildContext context, String label, String videoUrl, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _openVideo(videoUrl),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.videocam,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tapToViewVideo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(
    BuildContext context,
    VehiclePartRequest request,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(
          top: BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
          bottom: BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.suggestedProducts,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${request.products.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.adminSuggestedProducts,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ...request.products.map((product) {
            return ProductCard(
              product: product,
              onAddToCart: () {
                _handleAddToCart(context, product);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _handleAddToCart(BuildContext context, Product product) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    try {
      await cartProvider.addToCart(product);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.addedToCart(product.name)),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: l10n.viewCart,
              textColor: AppColors.textWhite,
              onPressed: () {
                context.go('/cart');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToAddToCart(e.toString())),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showImageModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openVideo(String videoUrl) async {
    final uri = Uri.parse(videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showDeleteDialog(
    BuildContext context,
    RequestDetailProvider provider,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _DeleteDialogContent(
          dialogContext: dialogContext,
          parentContext: context,
          provider: provider,
          requestId: requestId,
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return AppColors.info;
      case 'quoted':
        return AppColors.accent;
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'processing':
        return Icons.refresh;
      case 'quoted':
        return Icons.description;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'completed':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy h:mm a').format(date);
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

class _DeleteDialogContent extends StatefulWidget {
  final BuildContext dialogContext;
  final BuildContext parentContext;
  final RequestDetailProvider provider;
  final int requestId;

  const _DeleteDialogContent({
    required this.dialogContext,
    required this.parentContext,
    required this.provider,
    required this.requestId,
  });

  @override
  State<_DeleteDialogContent> createState() => _DeleteDialogContentState();
}

class _DeleteDialogContentState extends State<_DeleteDialogContent> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.deleteRequest),
      content: _isDeleting
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l10n.deletingRequest),
              ],
            )
          : Text(
              l10n.deleteRequestMessage,
            ),
      actions: [
        TextButton(
          onPressed: _isDeleting
              ? null
              : () => Navigator.of(widget.dialogContext).pop(),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: _isDeleting
              ? null
              : () async {
                  setState(() {
                    _isDeleting = true;
                  });
                  
                  try {
                    await widget.provider.deleteRequest(widget.requestId);
                    
                    // Close dialog first
                    if (widget.dialogContext.mounted) {
                      Navigator.of(widget.dialogContext).pop();
                    }
                    
                    // Check result and navigate/show message
                    if (widget.provider.isDeleted) {
                      // Navigate back to requests list after successful deletion
                      if (widget.parentContext.mounted) {
                        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                          SnackBar(
                            content: Text(l10n.requestDeletedSuccessfully),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        GoRouter.of(widget.parentContext).go('/requests');
                      }
                    } else if (widget.provider.status == RequestDetailStatus.error) {
                      // Show error message
                      if (widget.parentContext.mounted) {
                        final errorMsg = widget.provider.errorMessage != null
                            ? ErrorMessageHelper.getUserFriendlyMessage(
                                widget.provider.errorMessage!,
                                context: widget.parentContext,
                              )
                            : l10n.failedToDeleteRequest;
                        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                          SnackBar(
                            content: Text(errorMsg),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    // Close dialog on error
                    if (widget.dialogContext.mounted) {
                      Navigator.of(widget.dialogContext).pop();
                    }
                    // Show error message
                    if (widget.parentContext.mounted) {
                      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.failedToDeleteRequest,
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
          child: Text(
            l10n.delete,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}

