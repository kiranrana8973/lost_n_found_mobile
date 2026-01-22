import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';

class FoundItemCard extends StatelessWidget {
  final String title;
  final String foundBy;
  final String location;
  final String time;
  final int index;
  final VoidCallback? onTap;

  const FoundItemCard({
    super.key,
    required this.title,
    required this.foundBy,
    required this.location,
    required this.time,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradients = [
      AppColors.primaryGradient,
      AppColors.secondaryGradient,
      AppColors.accentGradient,
    ];

    final gradient = gradients[index % gradients.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageContainer(gradient),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(Gradient gradient) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.devices_rounded,
              size: 60,
              color: AppColors.white90,
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.person_outline_rounded, foundBy, context),
          const SizedBox(height: 4),
          _buildInfoRow(Icons.location_on_rounded, location, context),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: context.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: context.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
