import 'package:flutter/material.dart';
import '../../../../app/theme/theme_extensions.dart';

class MediaPickerBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onVideoTap;
  final VoidCallback? onVideoGalleryTap;

  const MediaPickerBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onVideoTap,
    this.onVideoGalleryTap,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
    required VoidCallback onVideoTap,
    VoidCallback? onVideoGalleryTap,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MediaPickerBottomSheet(
        onCameraTap: () {
          Navigator.pop(context);
          onCameraTap();
        },
        onGalleryTap: () {
          Navigator.pop(context);
          onGalleryTap();
        },
        onVideoTap: () {
          Navigator.pop(context);
          onVideoTap();
        },
        onVideoGalleryTap: onVideoGalleryTap != null
            ? () {
                Navigator.pop(context);
                onVideoGalleryTap();
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Take Photo'),
              onTap: onCameraTap,
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose Photo'),
              onTap: onGalleryTap,
            ),
            ListTile(
              leading: const Icon(Icons.videocam_rounded),
              title: const Text('Record Video'),
              onTap: onVideoTap,
            ),
            if (onVideoGalleryTap != null)
              ListTile(
                leading: const Icon(Icons.video_library_rounded),
                title: const Text('Choose Video'),
                onTap: onVideoGalleryTap,
              ),
          ],
        ),
      ),
    );
  }
}
