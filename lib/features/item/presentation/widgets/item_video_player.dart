import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../app/theme/app_colors.dart';

class ItemVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isLost;

  const ItemVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.isLost,
  });

  @override
  State<ItemVideoPlayer> createState() => _ItemVideoPlayerState();
}

class _ItemVideoPlayerState extends State<ItemVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    try {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false,
        looping: false,
        showControlsOnInitialize: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: widget.isLost
              ? AppColors.lostColor
              : AppColors.foundColor,
          handleColor: Colors.white,
          bufferedColor: Colors.white38,
          backgroundColor: Colors.white24,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 36),
                const SizedBox(height: 8),
                Text(
                  'Could not load video',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          );
        },
      );
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    if (_chewieController == null || !_videoController.value.isInitialized) {
      return _buildLoadingWidget();
    }

    return Chewie(controller: _chewieController!);
  }

  Widget _buildLoadingWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.isLost
            ? AppColors.lostGradient
            : AppColors.foundGradient,
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.isLost
            ? AppColors.lostGradient
            : AppColors.foundGradient,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.videocam_off_rounded,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            const Text(
              'Could not load video',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
