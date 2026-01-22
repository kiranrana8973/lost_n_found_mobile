import 'package:flutter/material.dart';
import '../../../../app/theme/theme_extensions.dart';

class MediaPickerBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onVideoTap;

  const MediaPickerBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onVideoTap,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
    required VoidCallback onVideoTap,
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
              leading: const Icon(Icons.camera),
              title: const Text('Open Camera'),
              onTap: onCameraTap,
            ),
            ListTile(
              leading: const Icon(Icons.browse_gallery),
              title: const Text('Open Gallery'),
              onTap: onGalleryTap,
            ),
            ListTile(
              leading: const Icon(Icons.video_call),
              title: const Text('Record Video'),
              onTap: onVideoTap,
            ),
          ],
        ),
      ),
    );
  }
}
