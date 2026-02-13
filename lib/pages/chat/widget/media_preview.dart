import 'package:dating/models/media_model.dart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class MediaPreview extends StatefulWidget {
  final List<MediaModel> mediaList;
  final Function(String) onRemove;

  const MediaPreview({
    super.key,
    required this.mediaList,
    required this.onRemove,
  });

  @override
  State<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  final Map<String, VideoPlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    for (var media in widget.mediaList) {
      if (media.type == MediaType.video && !_controllers.containsKey(media.id)) {
        final controller = VideoPlayerController.file(media.file);
        controller.initialize().then((_) {
          if (mounted) setState(() {});
        });
        _controllers[media.id] = controller;
      }
    }
  }

  @override
  void didUpdateWidget(MediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clean up old controllers
    for (var media in oldWidget.mediaList) {
      if (!widget.mediaList.contains(media) && _controllers.containsKey(media.id)) {
        _controllers[media.id]?.dispose();
        _controllers.remove(media.id);
      }
    }
    // Initialize new controllers
    _initializeVideoControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          final media = widget.mediaList[index];
          return _buildMediaItem(media);
        },
      ),
    );
  }

  Widget _buildMediaItem(MediaModel media) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: media.type == MediaType.image
                ? Image.file(
                    media.file,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : _buildVideoPreview(media),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                // Clean up controller when removing
                if (_controllers.containsKey(media.id)) {
                  _controllers[media.id]?.dispose();
                  _controllers.remove(media.id);
                }
                widget.onRemove(media.id);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.close_circle,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          if (media.type == MediaType.video)
            const Positioned(
              bottom: 4,
              right: 4,
              child: Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: 20,
              ),
            ),
          if (media.type == MediaType.video && media.duration != null)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(media.duration!),
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview(MediaModel media) {
    final controller = _controllers[media.id];
    
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      );
    }
    
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[900],
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}