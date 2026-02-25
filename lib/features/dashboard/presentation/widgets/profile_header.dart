import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final int lostCount;
  final int foundCount;
  final String? lostCountText;
  final String? foundCountText;
  final String? totalCountText;
  final String? lostLabel;
  final String? foundLabel;
  final String? totalLabel;
  final String? myProfileLabel;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.lostCount,
    required this.foundCount,
    this.lostCountText,
    this.foundCountText,
    this.totalCountText,
    this.lostLabel,
    this.foundLabel,
    this.totalLabel,
    this.myProfileLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            myProfileLabel ?? 'My Profile',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          _buildAvatar(),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userEmail,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          _buildStatsRow(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black20,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white,
        child: Text(
          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            title: lostLabel ?? 'Lost',
            value: lostCountText ?? '$lostCount',
          ),
          Container(width: 1, height: 40, color: AppColors.white30),
          _StatItem(
            title: foundLabel ?? 'Found',
            value: foundCountText ?? '$foundCount',
          ),
          Container(width: 1, height: 40, color: AppColors.white30),
          _StatItem(
            title: totalLabel ?? 'Total',
            value: totalCountText ?? '${lostCount + foundCount}',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppColors.white80),
        ),
      ],
    );
  }
}
