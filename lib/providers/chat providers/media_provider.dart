import 'dart:io';
import 'package:dating/models/media_model.dart.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaProvider with ChangeNotifier {
  List<MediaModel> _galleryMedia = [];
  MediaModel? _viewingMedia;
  bool _isPlaying = false;

  List<MediaModel> get galleryMedia => _galleryMedia;
  MediaModel? get viewingMedia => _viewingMedia;
  bool get isPlaying => _isPlaying;

  Future<void> loadGalleryMedia() async {
    // Load media from device gallery
    // This would use photo_manager or similar package
  }

  Future<String?> generateVideoThumbnail(String videoPath) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await Directory.systemTemp).path,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
    );
    return thumbnail;
  }

  void setViewingMedia(MediaModel media) {
    _viewingMedia = media;
    notifyListeners();
  }

  void clearViewingMedia() {
    _viewingMedia = null;
    _isPlaying = false;
    notifyListeners();
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}