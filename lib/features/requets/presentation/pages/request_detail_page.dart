import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_part_app/core/theme/app_colors.dart';
import 'package:vehicle_part_app/core/di/service_locator.dart';
import '../providers/request_detail_provider.dart';
import '../../domain/entities/vehicle_part_request.dart';
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
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
            onPressed: () => context.go('/orders'),
          ),
          title: const Text(
            'Request Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
          actions: [
            Consumer<RequestDetailProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading || provider.isDeleting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
                      ),
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: provider.isDeleting
                      ? null
                      : () {
                          _showDeleteDialog(context, provider);
                        },
                );
              },
            ),
          ],
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
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading request details...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, RequestDetailProvider provider) {
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
              'Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage ?? 'Failed to load request details',
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
              child: const Text(
                'Retry',
                style: TextStyle(
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
              'Request not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/orders'),
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
              child: const Text(
                'Go Back',
                style: TextStyle(
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildStatusBadge(request.status),
          ),

          // Part Information
          _buildSection(
            title: 'Part Information',
            children: [
              _buildInfoRow('Part Name', request.partName),
              if (request.partNumber != null && request.partNumber!.isNotEmpty)
                _buildInfoRow('Part Number', request.partNumber!),
              _buildInfoRow('Description', request.description),
            ],
          ),

          // Vehicle Information
          _buildSection(
            title: 'Vehicle Information',
            children: [
              _buildInfoRow(
                'Vehicle Type',
                _capitalizeFirst(request.vehicleType),
              ),
              _buildInfoRow('Model', request.vehicleModel),
              _buildInfoRow('Year', request.vehicleYear.toString()),
            ],
          ),

          // Media Section
          if (request.vehicleImage != null ||
              request.partImage != null ||
              request.partVideo != null)
            _buildMediaSection(context, request),

          // Request Information
          _buildSection(
            title: 'Request Information',
            children: [
              _buildInfoRow('Request ID', '#${request.id}'),
              _buildInfoRow(
                'Created',
                _formatDate(request.createdAt),
              ),
              _buildInfoRow(
                'Last Updated',
                _formatDate(request.updatedAt),
              ),
            ],
          ),

          const SizedBox(height: 32), // Bottom spacing
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

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
            status.toUpperCase(),
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
  ) {
    return _buildSection(
      title: 'Media',
      children: [
        if (request.vehicleImage != null && request.vehicleImage!.isNotEmpty)
          _buildImageItem(
            context,
            'Vehicle Image',
            request.vehicleImage!,
          ),
        if (request.partImage != null && request.partImage!.isNotEmpty)
          _buildImageItem(
            context,
            'Part Image',
            request.partImage!,
          ),
        if (request.partVideo != null && request.partVideo!.isNotEmpty)
          _buildVideoItem(context, 'Part Video', request.partVideo!),
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

  Widget _buildVideoItem(BuildContext context, String label, String videoUrl) {
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
                    'Tap to view video',
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
    return AlertDialog(
      title: const Text('Delete Request'),
      content: _isDeleting
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting request...'),
              ],
            )
          : const Text(
              'Are you sure you want to delete this request? This action cannot be undone.',
            ),
      actions: [
        TextButton(
          onPressed: _isDeleting
              ? null
              : () => Navigator.of(widget.dialogContext).pop(),
          child: Text(
            'Cancel',
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
                          const SnackBar(
                            content: Text('Request deleted successfully'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        GoRouter.of(widget.parentContext).go('/orders');
                      }
                    } else if (widget.provider.status == RequestDetailStatus.error) {
                      // Show error message
                      if (widget.parentContext.mounted) {
                        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.provider.errorMessage ?? 'Failed to delete request',
                            ),
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
                            'Failed to delete request: ${e.toString()}',
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
          child: const Text(
            'Delete',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}

