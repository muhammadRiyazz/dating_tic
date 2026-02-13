import 'dart:io';

enum MediaType {
  image,
  video,
  audio,
  document
}

class MediaModel {
  final String id;
  final File file;
  final MediaType type;
  final String? thumbnail;
  final double? duration;
  final int? fileSize;
  final String? fileName;
  final double? uploadProgress;
  final bool isUploading;
  final bool isUploaded;
  final String? downloadUrl;

  MediaModel({
    required this.id,
    required this.file,
    required this.type,
    this.thumbnail,
    this.duration,
    this.fileSize,
    this.fileName,
    this.uploadProgress,
    this.isUploading = false,
    this.isUploaded = false,
    this.downloadUrl,
  });

  factory MediaModel.fromFile(File file, MediaType type) {
    return MediaModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      file: file,
      type: type,
      fileName: file.path.split('/').last,
      fileSize: file.lengthSync(),
    );
  }
}