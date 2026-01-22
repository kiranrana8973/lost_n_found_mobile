import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../domain/entities/item_entity.dart';

class MediaUploadSection extends StatelessWidget {
  final List<File> selectedMedia;
  final ItemType itemType;
  final VoidCallback onAddMedia;
  final VoidCallback onRemoveMedia;

  const MediaUploadSection({
    super.key,
    required this.selectedMedia,
    required this.itemType,
    required this.onAddMedia,
    required this.onRemoveMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Photos / Videos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _AddMediaButton(
              itemType: itemType,
              onTap: onAddMedia,
            ),
            if (selectedMedia.isNotEmpty) ...[
              const SizedBox(width: 12),
              _MediaPreview(
                file: selectedMedia.first,
                onRemove: onRemoveMedia,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _AddMediaButton extends StatelessWidget {
  final ItemType itemType;
  final VoidCallback onTap;

  const _AddMediaButton({
    required this.itemType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.borderColor,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: itemType == ItemType.lost
                    ? AppColors.lostGradient
                    : AppColors.foundGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo / Video',
              style: TextStyle(
                fontSize: 11,
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaPreview extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const _MediaPreview({
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
