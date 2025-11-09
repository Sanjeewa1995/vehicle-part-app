import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header Section
          _buildHeaderSection(),

          const SizedBox(height: 32),

          // How to Request Section
          _buildSectionTitle('How to Request a Spare Part'),
          const SizedBox(height: 16),
          _buildStepCard(
            stepNumber: 1,
            title: 'Tap "Add Request"',
            description: 'From the home screen, tap the "Add Request" button or navigate to the Requests section.',
            icon: Icons.add_circle_outline,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildStepCard(
            stepNumber: 2,
            title: 'Fill Vehicle Information',
            description: 'Enter your vehicle type, model, and year. Upload a photo of your vehicle if available.',
            icon: Icons.directions_car_outlined,
            color: AppColors.accent,
          ),
          const SizedBox(height: 12),
          _buildStepCard(
            stepNumber: 3,
            title: 'Add Part Details',
            description: 'Specify the part name, part number (if known), and provide a detailed description.',
            icon: Icons.description_outlined,
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          _buildStepCard(
            stepNumber: 4,
            title: 'Upload Images/Video',
            description: 'Add photos of the part or vehicle area where the part is needed. You can also upload a video.',
            icon: Icons.camera_alt_outlined,
            color: AppColors.warning,
          ),
          const SizedBox(height: 12),
          _buildStepCard(
            stepNumber: 5,
            title: 'Submit Request',
            description: 'Review your information and submit the request. You\'ll receive updates on your request status.',
            icon: Icons.send_outlined,
            color: AppColors.primary,
          ),

          const SizedBox(height: 32),

          // Managing Requests Section
          _buildSectionTitle('Managing Your Requests'),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'View All Requests',
            description: 'Go to "My Requests" from the home screen to see all your submitted requests and their current status.',
            icon: Icons.list_alt_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: 'Request Status',
            description: 'Track your requests with status indicators: Pending, In Progress, Completed, or Cancelled.',
            icon: Icons.track_changes_outlined,
            color: AppColors.accent,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: 'View Request Details',
            description: 'Tap on any request card to see full details, including vehicle information, part details, and attached media.',
            icon: Icons.info_outline,
            color: AppColors.success,
          ),

          const SizedBox(height: 32),

          // FAQ Section
          _buildSectionTitle('Frequently Asked Questions'),
          const SizedBox(height: 16),
          _buildFAQCard(
            question: 'How long does it take to process a request?',
            answer: 'Request processing time varies depending on part availability. Typically, you\'ll receive a response within 24-48 hours.',
          ),
          const SizedBox(height: 12),
          _buildFAQCard(
            question: 'Can I edit or cancel my request?',
            answer: 'You can view your request details, but editing and cancellation features are currently being developed.',
          ),
          const SizedBox(height: 12),
          _buildFAQCard(
            question: 'What information should I include?',
            answer: 'Provide as much detail as possible: vehicle make, model, year, part name/number, and clear photos or videos.',
          ),
          const SizedBox(height: 12),
          _buildFAQCard(
            question: 'How do I track my request status?',
            answer: 'Navigate to "My Requests" to see all your requests with their current status. Tap on any request for detailed information.',
          ),

          const SizedBox(height: 32),

          // Contact Section
          _buildSectionTitle('Need More Help?'),
          const SizedBox(height: 16),
          _buildContactCard(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.textWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.help_outline,
              color: AppColors.textWhite,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Help Center',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find answers and learn how to use AUTO-ZONE',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textWhite.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStepCard({
    required int stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$stepNumber',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard({
    required String question,
    required String answer,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentUltraLight,
            AppColors.primaryUltraLight,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.support_agent,
              color: AppColors.textWhite,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Still Need Help?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Contact our support team for assistance',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactButton(
                icon: Icons.email_outlined,
                label: 'Email',
                onTap: () {
                  // TODO: Open email
                },
              ),
              const SizedBox(width: 12),
              _buildContactButton(
                icon: Icons.phone_outlined,
                label: 'Call',
                onTap: () {
                  // TODO: Make phone call
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textWhite, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

