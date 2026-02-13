// import 'dart:io';
// import 'dart:typed_data';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:video_compress/video_compress.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';

// class MediaService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   // ==================== IMAGE PROCESSING ====================

//   Future<File> compressImage(File image, {int width = 1080, int quality = 85}) async {
//     try {
//       final bytes = await image.readAsBytes();
//       final decodedImage = img.decodeImage(bytes);
      
//       if (decodedImage != null) {
//         final resizedImage = img.copyResize(decodedImage, width: width);
//         final compressed = await img.encodeJpg(resizedImage, quality: quality);
        
//         final tempDir = await Directory.systemTemp;
//         final compressedFile = File('${tempDir.path}/compressed_${path.basename(image.path)}');
//         await compressedFile.writeAsBytes(compressed);
        
//         return compressedFile;
//       }
//       return image;
//     } catch (e) {
//       return image;
//     }
//   }

//   Future<File> generateThumbnail(File image, {int width = 400, int quality = 70}) async {
//     try {
//       final bytes = await image.readAsBytes();
//       final decodedImage = img.decodeImage(bytes);
      
//       if (decodedImage != null) {
//         final thumbnail = img.copyResize(decodedImage, width: width);
//         final thumbnailBytes = await img.encodeJpg(thumbnail, quality: quality);
        
//         final tempDir = await Directory.systemTemp;
//         final thumbnailFile = File('${tempDir.path}/thumb_${path.basename(image.path)}');
//         await thumbnailFile.writeAsBytes(thumbnailBytes);
        
//         return thumbnailFile;
//       }
      
//       return image;
//     } catch (e) {
//       return image;
//     }
//   }

//   // ==================== VIDEO PROCESSING ====================

//   Future<MediaInfo?> compressVideo(String videoPath) async {
//     try {
//       return await VideoCompress.compressVideo(
//         videoPath,
//         quality: VideoQuality.MediumQuality,
//         deleteOrigin: false,
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<File> generateVideoThumbnail(String videoPath) async {
//     try {
//       return await VideoCompress.getFileThumbnail(
//         videoPath,
//         quality: 50,
//         position: -1,
//       );
//     } catch (e) {
//       throw Exception('Failed to generate video thumbnail: $e');
//     }
//   }

//   Future<int> getVideoDuration(File video) async {
//     try {
//       final info = await VideoCompress.getMediaInfo(video.path);
//       return (info.duration ?? 0) ~/ 1000;
//     } catch (e) {
//       return 0;
//     }
//   }

//   // ==================== UPLOAD SERVICES ====================

//   Future<String> uploadImage(File image, String chatId, String folder) async {
//     try {
//       String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
//       Reference ref = _storage.ref().child('chat/$folder/$chatId/$fileName');
      
//       final metadata = SettableMetadata(
//         contentType: 'image/jpeg',
//         customMetadata: {'uploaded': DateTime.now().toIso8601String()},
//       );
      
//       UploadTask uploadTask = ref.putFile(image, metadata);
//       TaskSnapshot snapshot = await uploadTask;
      
//       return await snapshot.ref.getDownloadURL();
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<String> uploadVideo(File video, String chatId) async {
//     try {
//       String fileName = '${DateTime.now().millisecondsSinceEpoch}_video.mp4';
//       Reference ref = _storage.ref().child('chat/videos/$chatId/$fileName');
      
//       final metadata = SettableMetadata(
//         contentType: 'video/mp4',
//         customMetadata: {'uploaded': DateTime.now().toIso8601String()},
//       );
      
//       UploadTask uploadTask = ref.putFile(video, metadata);
//       TaskSnapshot snapshot = await uploadTask;
      
//       return await snapshot.ref.getDownloadURL();
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<String> uploadVoice(File voice, String chatId) async {
//     try {
//       String fileName = '${DateTime.now().millisecondsSinceEpoch}_voice.m4a';
//       Reference ref = _storage.ref().child('chat/voice/$chatId/$fileName');
      
//       final metadata = SettableMetadata(
//         contentType: 'audio/m4a',
//         customMetadata: {'uploaded': DateTime.now().toIso8601String()},
//       );
      
//       UploadTask uploadTask = ref.putFile(voice, metadata);
//       TaskSnapshot snapshot = await uploadTask;
      
//       return await snapshot.ref.getDownloadURL();
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // ==================== PICK MEDIA ====================

//   Future<List<XFile>> pickMultiImages({
//     int maxWidth = 1280,
//     int maxHeight = 1280,
//     int imageQuality = 80,
//   }) async {
//     final ImagePicker picker = ImagePicker();
//     try {
//       return await picker.pickMultiImage(
//         maxWidth: maxWidth.toDouble(),
//         maxHeight: maxHeight.toDouble(),
//         imageQuality: imageQuality,
//       );
//     } catch (e) {
//       return [];
//     }
//   }

//   Future<XFile?> pickSingleImage({
//     int maxWidth = 1280,
//     int maxHeight = 1280,
//     int imageQuality = 80,
//   }) async {
//     final ImagePicker picker = ImagePicker();
//     try {
//       return await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: maxWidth.toDouble(),
//         maxHeight: maxHeight.toDouble(),
//         imageQuality: imageQuality,
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<XFile?> pickVideo() async {
//     final ImagePicker picker = ImagePicker();
//     try {
//       return await picker.pickVideo(
//         source: ImageSource.gallery,
//         maxDuration: const Duration(minutes: 5),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   // ==================== CLEANUP ====================

//   static Future<void> clearCache() async {
//     await VideoCompress.deleteAllCache();
//   }

//   Future<void> deleteFile(String url) async {
//     try {
//       final ref = _storage.refFromURL(url);
//       await ref.delete();
//     } catch (e) {
//       // Handle error silently
//     }
//   }
// }