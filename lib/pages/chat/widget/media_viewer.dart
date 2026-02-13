import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaViewer extends StatefulWidget {
  final List<String> mediaUrls;
  final int initialIndex;
  final bool isVideo;
  final String heroTag;

  const MediaViewer({
    super.key,
    required this.mediaUrls,
    required this.initialIndex,
    required this.isVideo,
    required this.heroTag,
  });

  @override
  State<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  late int _currentIndex;
  late PageController _pageController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    
    if (widget.isVideo) {
      _initializeVideoPlayer(widget.mediaUrls[_currentIndex]);
    }
  }

  Future<void> _initializeVideoPlayer(String url) async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    
    try {
      await _videoController!.initialize();
      
      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: true,
            looping: false,
            aspectRatio: _videoController!.value.aspectRatio,
            placeholder: Container(color: Colors.black),
            materialProgressColors: ChewieProgressColors(
              playedColor: const Color(0xFFFF4D67),
              handleColor: const Color(0xFFFFD700),
              backgroundColor: Colors.white24,
              bufferedColor: Colors.white38,
            ),
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading video',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
              );
            },
          );
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void didUpdateWidget(MediaViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVideo && _currentIndex != oldWidget.initialIndex) {
      _chewieController?.dispose();
      _videoController?.dispose();
      _initializeVideoPlayer(widget.mediaUrls[_currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Media content
          if (!widget.isVideo)
            PhotoViewGallery(
              pageController: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              pageOptions: widget.mediaUrls.map((url) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(url),
                  heroAttributes: PhotoViewHeroAttributes(tag: '${widget.heroTag}_$url'),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              }).toList(),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              scrollPhysics: const BouncingScrollPhysics(),
            ),
          
          if (widget.isVideo)
            Center(
              child: _chewieController != null
                  ? Chewie(controller: _chewieController!)
                  : const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFF4D67)),
                    ),
            ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Index indicator for multiple images
          if (widget.mediaUrls.length > 1 && !widget.isVideo)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.mediaUrls.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),

          // Page indicator dots
          if (widget.mediaUrls.length > 1 && !widget.isVideo)
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.mediaUrls.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? const Color(0xFFFF4D67)
                          : Colors.white.withOpacity(0.3),
                      border: _currentIndex == index
                          ? Border.all(color: Colors.white.withOpacity(0.5), width: 1)
                          : null,
                    ),
                  );
                }),
              ),
            ),

          // Save/download button
          Positioned(
            bottom: 32,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon:  Icon(Iconsax.document_download, color: Colors.white),
                onPressed: () {
                  // TODO: Implement download/save functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Download feature coming soon'),
                      backgroundColor: Colors.black87,
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

  @override
  void dispose() {
    _pageController.dispose();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}