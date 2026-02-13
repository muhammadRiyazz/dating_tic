// // import 'dart:io';

// // import 'package:dating/models/message_models.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:video_compress/video_compress.dart';

// // void showAttachmentSheet(BuildContext context ) {
// //   showModalBottomSheet(
// //     context: context,
// //     backgroundColor: Colors.transparent, // We use a container for custom styling
// //     builder: (context) => Container(
// //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// //       decoration: const BoxDecoration(
// //         color: Color(0xFF1A1A1A),
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(30),
// //           topRight: Radius.circular(30),
// //         ),
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Container(
// //             width: 40,
// //             height: 4,
// //             margin: const EdgeInsets.all(20),
// //             decoration: BoxDecoration(
// //               color: Colors.white.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //           ),
// //           GridView.count(
// //             shrinkWrap: true,
// //             crossAxisCount: 3,
// //             mainAxisSpacing: 20,
// //             children: [
// //               _buildAttachmentItem(context,
// //                 Iconsax.image, "Gallery", const Color(0xFF4785FF), 
// //                 onTap: () => _handleImageSelection(fromCamera: false)
// //               ),
// //               _buildAttachmentItem(context,
// //                 Iconsax.camera, "Camera", const Color(0xFFFF4D67),
// //                 onTap: () => _handleImageSelection(fromCamera: true)
// //               ),
// //               _buildAttachmentItem(context,
// //                 Iconsax.video_play, "Video", const Color(0xFF9147FF),
// //                 onTap: () => _handleVideoSelection(context)
// //               ),
// //               _buildAttachmentItem(context,
// //                 Iconsax.location, "Location", const Color(0xFF27AE60),
// //                 onTap: () => _handleLocationSelection()
// //               ),
// //               _buildAttachmentItem(context,
// //                 Iconsax.music, "Audio", const Color(0xFFFFD700),
// //                 onTap: () {} // Logic for documents or audio files
// //               ),
// //               _buildAttachmentItem(context,
// //                 Iconsax.user, "Contact", const Color(0xFFF2994A),
// //                 onTap: () {}
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 20),
// //         ],
// //       ),
// //     ),
// //   );
// // }







// // Widget _buildAttachmentItem( BuildContext context, IconData icon, String label, Color color, {required VoidCallback onTap}) {
// //   return GestureDetector(
// //     onTap: () {
// //       Navigator.pop(context); // Close sheet
// //       onTap();
// //     },
// //     child: Column(
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: color.withOpacity(0.1),
// //             shape: BoxShape.circle,
// //             border: Border.all(color: color.withOpacity(0.2)),
// //           ),
// //           child: Icon(icon, color: color, size: 28),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
// //       ],
// //     ),
// //   );
// // }


// // Future<void> _handleImageSelection({required bool fromCamera}) async {

// //   final ImagePicker picker = ImagePicker();
  
// //   if (fromCamera) {
// //     final XFile? photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
// //     if (photo != null) {
// //       // _uploadMediaMessage([File(photo.path)], MessageType.image);
// //     }
// //   } else {
// //     final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
// //     if (images.isNotEmpty) {
// //       // _uploadMediaMessage(images.map((e) => File(e.path)).toList(), MessageType.image);
// //     }
// //   }
// // }

// // Future<void> _handleVideoSelection( BuildContext context) async {
// //   final ImagePicker picker = ImagePicker();
// //   final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

// //   if (video != null) {
// //     // Show a simple loading overlay while compressing
// //     showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));

// //     // Compress video
// //     MediaInfo? mediaInfo = await VideoCompress.compressVideo(
// //       video.path,
// //       quality: VideoQuality.MediumQuality,
// //       deleteOrigin: false,
// //     );

// //     Navigator.pop(context); // Close loader

// //     if (mediaInfo != null && mediaInfo.file != null) {
// //       // _uploadMediaMessage([mediaInfo.file!], MessageType.video);
// //     }
// //   }
// // }


// // Future<void> _handleLocationSelection() async {
// //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //   if (!serviceEnabled) return;

// //   LocationPermission permission = await Geolocator.checkPermission();
// //   if (permission == LocationPermission.denied) {
// //     permission = await Geolocator.requestPermission();
// //     if (permission == LocationPermission.denied) return;
// //   }

// //   Position position = await Geolocator.getCurrentPosition();
  
// //   // final message = MessageModel(
// //   //   messageId: '',
// //   //   senderId: widget.currentUserId,
// //   //   receiverId: widget.receiverProfile.uID!,
// //   //   text: "📍 Shared a location",
// //   //   type: MessageType.location,
// //   //   latitude: position.latitude,
// //   //   longitude: position.longitude,
// //   //   timestamp: DateTime.now(),
// //   // );

// //   // await _chatService.sendMessage(widget.chatId, message);
// // }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:video_compress/video_compress.dart';
// import 'package:dating/models/message_models.dart';
// import 'package:dating/services/chat_service.dart';

// void showAttachmentSheet({
//   required BuildContext context,
//   required String chatId,
//   required String senderId,
//   required String receiverId,
// }) {
//   final ChatService chatService = ChatService();

//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (context) => Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
//           GridView.count(
//             shrinkWrap: true,
//             crossAxisCount: 3,
//             mainAxisSpacing: 20,
//             children: [
//               _item(context, Iconsax.image, "Gallery", const Color(0xFF4785FF), () async {
//                 final List<XFile> images = await ImagePicker().pickMultiImage();
//                 if (images.isNotEmpty) {
//                   List<String> urls = await chatService.uploadFiles(images.map((e) => File(e.path)).toList(), chatId, 'image');
//                   chatService.sendMessage(chatId, MessageModel(messageId: '', senderId: senderId, receiverId: receiverId, text: '📷 Photo', type: MessageType.image, mediaUrls: urls, timestamp: DateTime.now()));
//                 }
//               }),
//               _item(context, Iconsax.camera, "Camera", const Color(0xFFFF4D67), () async {
//                 final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
//                 if (photo != null) {
//                   List<String> urls = await chatService.uploadFiles([File(photo.path)], chatId, 'image');
//                   chatService.sendMessage(chatId, MessageModel(messageId: '', senderId: senderId, receiverId: receiverId, text: '📷 Photo', type: MessageType.image, mediaUrls: urls, timestamp: DateTime.now()));
//                 }
//               }),
//               _item(context, Iconsax.video_play, "Video", const Color(0xFF9147FF), () async {
//                 final XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
//                 if (video != null) {
//                   MediaInfo? info = await VideoCompress.compressVideo(video.path, quality: VideoQuality.MediumQuality);
//                   if (info?.file != null) {
//                     List<String> urls = await chatService.uploadFiles([info!.file!], chatId, 'video');
//                     chatService.sendMessage(chatId, MessageModel(messageId: '', senderId: senderId, receiverId: receiverId, text: '🎥 Video', type: MessageType.video, mediaUrls: urls, timestamp: DateTime.now()));
//                   }
//                 }
//               }),
//               _item(context, Iconsax.location, "Location", const Color(0xFF27AE60), () async {
//                 Position pos = await Geolocator.getCurrentPosition();
//                 chatService.sendMessage(chatId, MessageModel(messageId: '', senderId: senderId, receiverId: receiverId, text: '📍 Shared Location', type: MessageType.location, latitude: pos.latitude, longitude: pos.longitude, timestamp: DateTime.now()));
//               }),
//               _item(context, Iconsax.music, "Audio", const Color(0xFFFFD700), () {}),
//               _item(context, Iconsax.user, "Contact", const Color(0xFFF2994A), () {}),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _item(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
//   return GestureDetector(
//     onTap: () { Navigator.pop(context); onTap(); },
//     child: Column(children: [
//       Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
//       const SizedBox(height: 8),
//       Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
//     ]),
//   );
// }