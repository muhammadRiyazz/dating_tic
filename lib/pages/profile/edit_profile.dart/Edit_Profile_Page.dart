// import 'dart:io';
// import 'dart:ui';
// import 'dart:convert';
// import 'package:dating/main.dart'; 
// import 'package:dating/models/profile_model.dart';
// import 'package:dating/pages/profile/edit_profile.dart/edit_education.dart';
// import 'package:dating/pages/profile/edit_profile.dart/edit_hieght.dart';
// import 'package:dating/pages/profile/edit_profile.dart/habit_choosing.dart';
// import 'package:dating/pages/profile/edit_profile.dart/location_edit.dart';
// import 'package:dating/pages/profile/edit_profile.dart/relationship_goal.dart';
// import 'package:dating/pages/profile/edit_profile.dart/update_intrest.dart';
// import 'package:dating/providers/my_profile_provider.dart';
// import 'package:dating/providers/profile_update.dart';
// import 'package:dating/providers/registration_data_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   late TextEditingController _nameController;
//   late TextEditingController _bioController;
//   late TextEditingController _jobController;
  
//   // Photo Management
//   final List<ProfilePhoto> _profilePhotos = [];
//   final ImagePicker _picker = ImagePicker();
//   int _primaryPhotoIndex = 0;
//   bool _isUploading = false;

//   @override
//   void initState() {
//     super.initState();
//     final firstProfile = context.read<MyProfileProvider>().userProfile;
//     context.read<UpdateProfileProvider>().initializeProfile(firstProfile!);
    
//     final updatedProfile = context.read<UpdateProfileProvider>().userProfile;
//     final provider = context.read<RegistrationDataProvider>();

//     provider.loadRelationshipGoals(updatedProfile.gender.id.toString());
//     provider.loadEducationLevels();

//     _nameController = TextEditingController(text: updatedProfile.userName);
//     _bioController = TextEditingController(text: updatedProfile.bio ?? "");
//     _jobController = TextEditingController(text: updatedProfile.job ?? "");
    
//     // Initialize photos from profile
//     _initializePhotos(updatedProfile.photos);
//   }

//   void _initializePhotos(List<String> photoUrls) {
//     _profilePhotos.clear();
//     for (int i = 0; i < photoUrls.length; i++) {
//       _profilePhotos.add(ProfilePhoto(
//         id: i,
//         url: photoUrls[i],
//         isLocal: false,
//         isPrimary: i == 0,
//       ));
//     }
//   }

//   // PHOTO MANAGEMENT FUNCTIONS
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         imageQuality: 85,
//       );
      
//       if (pickedFile != null) {
//         await _cropImage(File(pickedFile.path));
//       }
//     } catch (e) {
//       _showErrorSnackbar('Failed to pick image');
//     }
//   }

//   Future<void> _cropImage(File imageFile) async {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: imageFile.path,
//       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//       compressQuality: 80,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Photo',
//           toolbarColor: AppColors.deepBlack,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.square,
//           lockAspectRatio: true,
//           hideBottomControls: true,
//           showCropGrid: false,
//         ),
//         IOSUiSettings(
//           title: 'Crop Photo',
//           aspectRatioLockEnabled: true,
//           aspectRatioPickerButtonHidden: true,
//           resetButtonHidden: true,
//           rotateButtonsHidden: true,
//           doneButtonTitle: 'Done',
//           cancelButtonTitle: 'Cancel',
//         ),
//       ],
//     );

//     if (croppedFile != null) {
//       _addNewPhoto(File(croppedFile.path));
//     }
//   }

//   void _addNewPhoto(File imageFile) {
//     if (_profilePhotos.length >= 6) {
//       _showErrorSnackbar('Maximum 6 photos allowed');
//       return;
//     }

//     // Convert image to base64 for temporary storage
//     final bytes = imageFile.readAsBytesSync();
//     final base64Image = base64Encode(bytes);
    
//     setState(() {
//       _profilePhotos.add(ProfilePhoto(
//         id: DateTime.now().millisecondsSinceEpoch,
//         localPath: imageFile.path,
//         base64: base64Image,
//         isLocal: true,
//         isPrimary: _profilePhotos.isEmpty,
//       ));
//     });
//   }

//   void _removePhoto(int index) {
//     if (index < _profilePhotos.length) {
//       setState(() {
//         final wasPrimary = _profilePhotos[index].isPrimary;
//         _profilePhotos.removeAt(index);
        
//         // If primary photo was removed, make first photo primary
//         if (wasPrimary && _profilePhotos.isNotEmpty) {
//           _profilePhotos[0] = _profilePhotos[0].copyWith(isPrimary: true);
//         }
//       });
//     }
//   }

//   void _setPrimaryPhoto(int index) {
//     if (index < _profilePhotos.length) {
//       setState(() {
//         for (int i = 0; i < _profilePhotos.length; i++) {
//           _profilePhotos[i] = _profilePhotos[i].copyWith(
//             isPrimary: i == index,
//           );
//         }
//       });
//     }
//   }

//   Future<void> _uploadPhotos() async {
//     if (_profilePhotos.isEmpty) {
//       _showErrorSnackbar('Please add at least one photo');
//       return;
//     }

//     setState(() => _isUploading = true);
    
//     try {
//       final updateProvider = context.read<UpdateProfileProvider>();
      
//       // Separate URLs (already uploaded) and new base64 images
//       final List<String> photoUrls = [];
      
//       for (final photo in _profilePhotos) {
//         if (photo.isLocal && photo.base64 != null) {
//           // Upload new photo
//           final uploadedUrl = await _uploadBase64Image(photo.base64!);
//           photoUrls.add(uploadedUrl);
//         } else {
//           // Already uploaded URL
//           photoUrls.add(photo.url!);
//         }
//       }
      
//       // Update profile with new photos
//        updateProvider.updatePhotos(photoUrls);
      
//       _showSuccessSnackbar('Photos updated successfully!');
//     } catch (e) {
//       _showErrorSnackbar('Failed to upload photos');
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   Future<String> _uploadBase64Image(String base64Image) async {
//     // Simulate API call - replace with your actual upload endpoint
//     await Future.delayed(const Duration(seconds: 1));
//     return 'https://example.com/uploaded-image-${DateTime.now().millisecondsSinceEpoch}.jpg';
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.neonPink,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   Widget _buildPhotoEditorGrid() {
//     return Column(
//       children: [
//         // Upload Button
//         if (_profilePhotos.length < 6)
//           Container(
//             margin: const EdgeInsets.only(bottom: 20),
//             child: _buildUploadButton(),
//           ),
        
//         // Photos Grid
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 0.8,
//           ),
//           itemCount: 6,
//           itemBuilder: (context, index) {
//             if (index < _profilePhotos.length) {
//               return _buildPhotoCard(index, _profilePhotos[index]);
//             } else {
//               return _buildEmptyPhotoCard(index);
//             }
//           },
//         ),
        
//         // Upload All Button
//         if (_profilePhotos.any((photo) => photo.isLocal))
//           Container(
//             margin: const EdgeInsets.only(top: 20),
//             child: _buildUploadAllButton(),
//           ),
//       ],
//     );
//   }

//   Widget _buildUploadButton() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.neonPink.withOpacity(0.2),
//             AppColors.neonGold.withOpacity(0.1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Iconsax.camera, color: AppColors.neonPink, size: 20),
//           const SizedBox(width: 10),
//           const Text(
//             'Add Photos',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(width: 20),
//           PopupMenuButton<ImageSource>(
//             color: Colors.white.withOpacity(0.05),
//             surfaceTintColor: Colors.transparent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               // side: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: ImageSource.gallery,
//                 child: Row(
//                   children: [
//                     const Icon(Iconsax.gallery, color: Colors.white, size: 18),
//                     const SizedBox(width: 10),
//                     const Text('Gallery', style: TextStyle(color: Colors.white)),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: ImageSource.camera,
//                 child: Row(
//                   children: [
//                     const Icon(Iconsax.camera, color: Colors.white, size: 18),
//                     const SizedBox(width: 10),
//                     const Text('Camera', style: TextStyle(color: Colors.white)),
//                   ],
//                 ),
//               ),
//             ],
//             onSelected: (source) => _pickImage(source),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(Iconsax.arrow_down_1, 
//                 color: Colors.white, 
//                 size: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUploadAllButton() {
//     return InkWell(
//       onTap: _isUploading ? null : _uploadPhotos,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: _isUploading
//                 ? [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]
//                 : [AppColors.neonPink, AppColors.neonPink.withOpacity(0.8)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: _isUploading
//               ? []
//               : [
//                   BoxShadow(
//                     color: AppColors.neonPink.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//         ),
//         child: Center(
//           child: _isUploading
//               ? const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       'Uploading...',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Iconsax.cloud, 
//                       color: Colors.black, 
//                       size: 20
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       'Upload ${_profilePhotos.where((p) => p.isLocal).length} Photos',
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPhotoCard(int index, ProfilePhoto photo) {
//     return Stack(
//       children: [
//         // Photo Container
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white.withOpacity(0.03),
//             border: Border.all(
//               color: photo.isPrimary 
//                 ? AppColors.neonPink.withOpacity(0.5)
//                 : Colors.white.withOpacity(0.1),
//               width: photo.isPrimary ? 2 : 1,
//             ),
//             image: photo.isLocal && photo.localPath != null
//                 ? DecorationImage(
//                     image: FileImage(File(photo.localPath!)),
//                     fit: BoxFit.cover,
//                   )
//                 : photo.url != null
//                     ? DecorationImage(
//                         image: NetworkImage(photo.url!),
//                         fit: BoxFit.cover,
//                       )
//                     : null,
//           ),
//           child: photo.isLocal && photo.localPath == null
//               ? const Center(
//                   child: Icon(Iconsax.image, 
//                     color: Colors.white24, 
//                     size: 28
//                   ),
//                 )
//               : null,
//         ),
        
//         // Primary Badge
//         if (photo.isPrimary)
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.neonPink.withOpacity(0.9),
//                     AppColors.neonPink.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 borderRadius: const BorderRadius.vertical(
//                   bottom: Radius.circular(19),
//                 ),
//               ),
//               child: const Text(
//                 "PRIMARY",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 9,
//                   fontWeight: FontWeight.w900,
//                   letterSpacing: 1,
//                 ),
//               ),
//             ),
//           ),
        
//         // Local Upload Badge
//         if (photo.isLocal)
//           Positioned(
//             top: 8,
//             left: 8,
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: AppColors.neonGold.withOpacity(0.9),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Iconsax.cloud_add,
//                 color: Colors.black,
//                 size: 12,
//               ),
//             ),
//           ),
        
//         // Action Buttons
//         Positioned(
//           top: 8,
//           right: 8,
//           child: Column(
//             children: [
//               // Set Primary Button
//               if (!photo.isPrimary)
//                 GestureDetector(
//                   onTap: () => _setPrimaryPhoto(index),
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     margin: const EdgeInsets.only(bottom: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.7),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Iconsax.star_1,
//                       color: AppColors.neonGold,
//                       size: 14,
//                     ),
//                   ),
//                 ),
              
//               // Remove Button
//               GestureDetector(
//                 onTap: () => _removePhoto(index),
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.7),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Iconsax.close_circle,
//                     color: Colors.white,
//                     size: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
        
//         // Hover Effect
//         Positioned.fill(
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(20),
//               onTap: () {
//                 if (!photo.isPrimary) {
//                   _setPrimaryPhoto(index);
//                 }
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyPhotoCard(int index) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.white.withOpacity(0.03),
//         border: Border.all(color: Colors.white.withOpacity(0.05)),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.05),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Iconsax.add,
//               color: Colors.white24,
//               size: 20,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Photo ${index + 1}',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.3),
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ... REST OF YOUR EXISTING METHODS (build, _buildSelectorTile, etc.) ...

//   @override
//   Widget build(BuildContext context) {
//     final data = context.watch<UpdateProfileProvider>().userProfile;

//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: Stack(
//         children: [
//           _buildTopGradient(),
//           SafeArea(
//             bottom: false,
//             child: CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               slivers: [
//                 SliverToBoxAdapter(child: _buildHeader(context)),

//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildSectionTitle("MEDIA MANAGER"),
//                         const SizedBox(height: 10),
//                         Text(
//                           'Add up to 6 photos. First photo is your primary.',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.5),
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         _buildPhotoEditorGrid(),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // FORM CONTENT
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildSectionTitle("BASIC INFO"),
//                         _buildGlassInput(
//                           label: "Full Name",
//                           controller: _nameController,
//                           icon: Iconsax.user,
//                           onChanged: (value) {
//                             context.read<UpdateProfileProvider>().updateBasicInfo(userName: value);
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         _buildGlassInput(
//                           label: "About Me",
//                           controller: _bioController,
//                           icon: Iconsax.document_text,
//                           maxLines: 4,
//                           onChanged: (value) {
//                             context.read<UpdateProfileProvider>().updateBio(value);
//                           },
//                         ),
//                         const SizedBox(height: 30),
//                         _buildSectionTitle("LIFESTYLE & WORK"),
//                         _buildGlassInput(
//                           label: "Occupation",
//                           controller: _jobController,
//                           icon: Iconsax.briefcase,
//                           onChanged: (value) {
//                             context.read<UpdateProfileProvider>().updateJob(value);
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         _buildSelectorTile(
//                           icon: Iconsax.location,
//                           title: "Current City",
//                           value: data.city ?? "Select City",
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) {
//                               return const LocationEditPage();
//                             }));
//                           },
//                         ),
//                         _buildSelectorTile(
//                           icon: Iconsax.teacher,
//                           title: "Education",
//                           value: data.education.name,
//                           onTap: () {
//                             showEducationBottomSheet(context);
//                           },
//                         ),
//                         const SizedBox(height: 30),
//                         _buildSectionTitle("HABITS"),
//                         _buildSelectorTile(
//                           icon: Iconsax.status,
//                           title: "Smoking",
//                           value: getDisplayHabit(data.smokingHabit),
//                           onTap: () => showSmokingHabitSheet(context),
//                         ),
//                         _buildSelectorTile(
//                           icon: Iconsax.cup,
//                           title: "Drinking",
//                           value: getDisplayHabit(data.drinkingHabit),
//                           onTap: () => showDrinkingHabitSheet(context),
//                         ),
//                         const SizedBox(height: 30),
//                         _buildSectionTitle("PREFERENCES"),
//                         _buildSelectorTile(
//                           icon: Iconsax.heart,
//                           title: "Relationship Goal",
//                           value: data.relationshipGoal?.name ?? "Set Goal",
//                           onTap: () {
//                             showRelationshipGoalSheet(context);
//                           },
//                         ),
//                         _buildSelectorTile(
//                           icon: Iconsax.ruler,
//                           title: "Height",
//                           value: data.height ?? "Select Height",
//                           onTap: () {
//                             showHeightBottomSheet(context);
//                           },
//                         ),
//                         const SizedBox(height: 30),
//                         _buildSectionTitle("INTERESTS"),
//                         _buildInterestChips(),
//                         const SizedBox(height: 150),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildFixedSaveAction(context),
//         ],
//       ),
//     );
//   }

//   // ... KEEP ALL YOUR EXISTING WIDGET METHODS (_buildSelectorTile, _buildInterestChips, etc.) ...

//   Widget _buildSelectorTile({
//     required IconData icon,
//     required String title,
//     required String value,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.03),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: Colors.white38, size: 20),
//               const SizedBox(width: 15),
//               Text(title,
//                   style: const TextStyle(color: Colors.white70, fontSize: 14)),
//               const Spacer(),
//               Text(value,
//                   maxLines: 1,
//                   style: const TextStyle(
//                       color: AppColors.neonGold,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14)),
//               const SizedBox(width: 10),
//               const Icon(Iconsax.arrow_right_3,
//                   color: Colors.white24, size: 16),
//             ],
//           ),
//         ),
//       ).animate().fadeIn(duration: 400.ms),
//     );
//   }

//   Widget _buildInterestChips() {
//     final data = context.watch<UpdateProfileProvider>().userProfile;
//     final interests = data.interests;

//     return Consumer<UpdateProfileProvider>(
//       builder: (context, updateProvider, child) {
//         return Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: [
//             ...interests.map((interest) => Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: AppColors.neonPink.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(15),
//                     border:
//                         Border.all(color: AppColors.neonPink.withOpacity(0.2)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(interest.emoji,
//                           style: const TextStyle(fontSize: 14)),
//                       const SizedBox(width: 6),
//                       Text(interest.name,
//                           style:
//                               const TextStyle(color: Colors.white, fontSize: 13)),
//                       const SizedBox(width: 8),
//                       GestureDetector(
//                           onTap: () {
//                             updateProvider.removeInterest(interest);
//                           },
//                           child: const Icon(Icons.close,
//                               color: Colors.white38, size: 14)),
//                     ],
//                   ),
//                 )).toList(),
//             GestureDetector(
//               onTap: () {
//                 showInterestsBottomSheet(context);
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(color: Colors.white.withOpacity(0.1)),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Iconsax.add, color: AppColors.neonGold, size: 16),
//                     SizedBox(width: 4),
//                     Text("Add",
//                         style: TextStyle(
//                             color: AppColors.neonGold,
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildGlassInput({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     int maxLines = 1,
//     ValueChanged<String>? onChanged,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.03),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           icon: Icon(icon,
//               color: AppColors.neonGold.withOpacity(0.5), size: 20),
//           labelText: label,
//           labelStyle: TextStyle(
//               color: Colors.white.withOpacity(0.3), fontSize: 13),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 5, bottom: 15, top: 10),
//       child: Text(title,
//           style: TextStyle(
//               color: Colors.white.withOpacity(0.4),
//               fontSize: 11,
//               fontWeight: FontWeight.w900,
//               letterSpacing: 2)),
//     );
//   }

//   Widget _buildFixedSaveAction(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: ClipRRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             height: 100,
//             padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.5),
//               border:
//                   Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
//             ),
//             child: InkWell(
//               onTap: () {
//                 final updatedProfile = context.read<UpdateProfileProvider>().userProfile;
                
//                 // Show success message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text("Profile updated successfully!"),
//                     backgroundColor: AppColors.neonPink,
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                 );
                
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                       colors: [AppColors.neonPink, AppColors.neonGold]),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Center(
//                   child: Text("SAVE CHANGES",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w900,
//                           letterSpacing: 1)),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopGradient() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       height: 300,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color(0xFFFF4D67).withOpacity(0.15),
//               Colors.transparent
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Edit Studio",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.w900)),
//               Text("Manage your digital presence",
//                   style: TextStyle(color: Colors.white38, fontSize: 13)),
//             ],
//           ),
//           _glassIconButton(Iconsax.arrow_left_2, () => Navigator.pop(context)),
//         ],
//       ),
//     );
//   }

//   Widget _glassIconButton(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
//         child: Icon(icon, color: Colors.white, size: 20),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _bioController.dispose();
//     _jobController.dispose();
//     super.dispose();
//   }
// }

// // Helper class for managing photos
// class ProfilePhoto {
//   final int id;
//   final String? url;
//   final String? localPath;
//   final String? base64;
//   final bool isLocal;
//   final bool isPrimary;

//   ProfilePhoto({
//     required this.id,
//     this.url,
//     this.localPath,
//     this.base64,
//     required this.isLocal,
//     this.isPrimary = false,
//   });

//   ProfilePhoto copyWith({
//     int? id,
//     String? url,
//     String? localPath,
//     String? base64,
//     bool? isLocal,
//     bool? isPrimary,
//   }) {
//     return ProfilePhoto(
//       id: id ?? this.id,
//       url: url ?? this.url,
//       localPath: localPath ?? this.localPath,
//       base64: base64 ?? this.base64,
//       isLocal: isLocal ?? this.isLocal,
//       isPrimary: isPrimary ?? this.isPrimary,
//     );
//   }
// }
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:dating/main.dart'; 
import 'package:dating/models/profile_model.dart';
import 'package:dating/pages/profile/edit_profile.dart/edit_education.dart';
import 'package:dating/pages/profile/edit_profile.dart/edit_hieght.dart';
import 'package:dating/pages/profile/edit_profile.dart/habit_choosing.dart';
import 'package:dating/pages/profile/edit_profile.dart/location_edit.dart';
import 'package:dating/pages/profile/edit_profile.dart/relationship_goal.dart';
import 'package:dating/pages/profile/edit_profile.dart/update_intrest.dart';
import 'package:dating/providers/my_profile_provider.dart';
import 'package:dating/providers/profile_update.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _jobController;
  
  final List<ProfilePhoto> _profilePhotos = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final firstProfile = context.read<MyProfileProvider>().userProfile;
    context.read<UpdateProfileProvider>().initializeProfile(firstProfile!);
    
    final updatedProfile = context.read<UpdateProfileProvider>().userProfile;
    final provider = context.read<RegistrationDataProvider>();

    provider.loadRelationshipGoals(updatedProfile.gender.id.toString());
    provider.loadEducationLevels();

    _nameController = TextEditingController(text: updatedProfile.userName);
    _bioController = TextEditingController(text: updatedProfile.bio ?? "");
    _jobController = TextEditingController(text: updatedProfile.job ?? "");
    
    _initializePhotos(updatedProfile.photos);
  }

  void _initializePhotos(List<String> photoUrls) {
    _profilePhotos.clear();
    for (int i = 0; i < photoUrls.length; i++) {
      _profilePhotos.add(ProfilePhoto(
        id: i,
        url: photoUrls[i],
        isLocal: false,
        isPrimary: i == 0,
      ));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add to Studio",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        SizedBox(height: 4),
                        Text("Select a source", style: TextStyle(color: Colors.white38, fontSize: 13)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Icon(Iconsax.add, color: Colors.white, size: 20) 
                            .animate().rotate(begin: 0, end: 0.125),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    _buildGlassySourceCard(
                      icon: Iconsax.camera,
                      label: "Camera",
                      color: AppColors.neonPink,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildGlassySourceCard(
                      icon: Iconsax.gallery,
                      label: "Gallery",
                      color: AppColors.neonGold,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.neonPink.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Iconsax.magic_star, color: AppColors.neonPink, size: 20),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pro Tip", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text("Use natural lighting for the best match potential.",
                              style: TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassySourceCard({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
      if (pickedFile == null) return;
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      await _cropImage(pickedFile.path);
    } catch (e) {}
  }

  // --- STANDARD GLASSY STUDIO CROPPER ---
  Future<void> _cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1.5),
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'STUDIO ADAPT',
            toolbarColor: const Color(0xFF0A0A0A), // Matched app background
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppColors.neonPink, // Neon highlight
            backgroundColor: const Color(0xFF0A0A0A),
            statusBarColor: const Color(0xFF0A0A0A),
            
            // Frame & Grid Styling
            cropFrameColor: AppColors.neonPink,
            cropGridColor: Colors.white.withOpacity(0.3),
            dimmedLayerColor: Colors.black.withOpacity(0.85), // Glassy dim
            
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'Studio Adapt',
            aspectRatioLockEnabled: true,
            resetButtonHidden: false,
            doneButtonTitle: 'ADAPT',
            cancelButtonTitle: 'DISCARD',
          ),
        ],
      );

      if (croppedFile != null && mounted) {
        _addNewPhoto(File(croppedFile.path));
      }
    } catch (e) {}
  }

  void _addNewPhoto(File imageFile) {
    if (_profilePhotos.length >= 6) return;
    final bytes = imageFile.readAsBytesSync();
    final base64Image = base64Encode(bytes);
    setState(() {
      _profilePhotos.add(ProfilePhoto(
        id: DateTime.now().millisecondsSinceEpoch,
        localPath: imageFile.path,
        base64: base64Image,
        isLocal: true,
        isPrimary: _profilePhotos.isEmpty,
      ));
    });
  }

  void _removePhoto(int index) {
    if (index < _profilePhotos.length) {
      setState(() {
        final wasPrimary = _profilePhotos[index].isPrimary;
        _profilePhotos.removeAt(index);
        if (wasPrimary && _profilePhotos.isNotEmpty) {
          _profilePhotos[0] = _profilePhotos[0].copyWith(isPrimary: true);
        }
      });
    }
  }

  void _setPrimaryPhoto(int index) {
    if (index < _profilePhotos.length) {
      setState(() {
        for (int i = 0; i < _profilePhotos.length; i++) {
          _profilePhotos[i] = _profilePhotos[i].copyWith(isPrimary: i == index);
        }
      });
    }
  }

  Widget _buildPhotoEditorGrid() {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            if (index < _profilePhotos.length) {
              return _buildPhotoCard(index, _profilePhotos[index]);
            } else {
              return _buildEmptyPhotoCard(index);
            }
          },
        ),
      ],
    );
  }

  Widget _buildPhotoCard(int index, ProfilePhoto photo) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.03),
            border: Border.all(
              color: photo.isPrimary ? AppColors.neonPink.withOpacity(0.5) : Colors.white10,
              width: photo.isPrimary ? 2 : 1,
            ),
            image: photo.isLocal && photo.localPath != null
                ? DecorationImage(image: FileImage(File(photo.localPath!)), fit: BoxFit.cover)
                : photo.url != null ? DecorationImage(image: NetworkImage(photo.url!), fit: BoxFit.cover) : null,
          ),
        ),
        if (photo.isPrimary)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(color: AppColors.neonPink, borderRadius: BorderRadius.vertical(bottom: Radius.circular(19))),
              child: const Text("PRIMARY", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900)),
            ),
          ),
        Positioned(
          top: 8, right: 8,
          child: Column(
            children: [
              if (!photo.isPrimary)
                GestureDetector(
                  onTap: () => _setPrimaryPhoto(index),
                  child: Container(padding: const EdgeInsets.all(4), margin: const EdgeInsets.only(bottom: 4), decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: const Icon(Iconsax.star_1, color: AppColors.neonGold, size: 14)),
                ),
              GestureDetector(
                onTap: () => _removePhoto(index),
                child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: const Icon(Iconsax.close_circle, color: Colors.white, size: 14)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPhotoCard(int index) {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          color: Colors.white.withOpacity(0.03), 
          border: Border.all(color: Colors.white10, style: BorderStyle.solid)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
              child: const Icon(Iconsax.add, color: Colors.white24, size: 20),
            ),
            const SizedBox(height: 8),
            Text('Add Photo', style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<UpdateProfileProvider>().userProfile;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          _buildTopGradient(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("MEDIA MANAGER"),
                        const SizedBox(height: 10),
                        _buildPhotoEditorGrid(),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildSectionTitle("BASIC INFO"),
                        _buildGlassInput(label: "Full Name", controller: _nameController, icon: Iconsax.user, onChanged: (v) => context.read<UpdateProfileProvider>().updateBasicInfo(userName: v)),
                        const SizedBox(height: 12),
                        _buildGlassInput(label: "About Me", controller: _bioController, icon: Iconsax.document_text, maxLines: 4, onChanged: (v) => context.read<UpdateProfileProvider>().updateBio(v)),
                        const SizedBox(height: 12),
                        _buildGlassInput(label: "Occupation", controller: _jobController, icon: Iconsax.briefcase, onChanged: (v) => context.read<UpdateProfileProvider>().updateJob(v)),
                        const SizedBox(height: 12),
                        _buildSelectorTile(icon: Iconsax.location, title: "Current City", value: data.city ?? "Select City", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LocationEditPage()))),
                        _buildSelectorTile(icon: Iconsax.teacher, title: "Education", value: data.education.name, onTap: () => showEducationBottomSheet(context)),
                        const SizedBox(height: 20),
                        _buildSectionTitle("HABITS"),
                        _buildSelectorTile(icon: Iconsax.status, title: "Smoking", value: getDisplayHabit(data.smokingHabit), onTap: () => showSmokingHabitSheet(context)),
                        _buildSelectorTile(icon: Iconsax.cup, title: "Drinking", value: getDisplayHabit(data.drinkingHabit), onTap: () => showDrinkingHabitSheet(context)),
                        const SizedBox(height: 20),
                        _buildSectionTitle("PREFERENCES"),
                        _buildSelectorTile(icon: Iconsax.heart, title: "Relationship Goal", value: data.relationshipGoal?.name ?? "Set Goal", onTap: () => showRelationshipGoalSheet(context)),
                        _buildSelectorTile(icon: Iconsax.ruler, title: "Height", value: data.height ?? "Select Height", onTap: () => showHeightBottomSheet(context)),
                        const SizedBox(height: 20),
                        _buildSectionTitle("INTERESTS"),
                        _buildInterestChips(),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildFixedSaveAction(context),
        ],
      ),
    );
  }

  Widget _buildSelectorTile({required IconData icon, required String title, required String value, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Icon(icon, color: Colors.white38, size: 20),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const Spacer(),
              Text(value, style: const TextStyle(color: AppColors.neonGold, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 10),
              const Icon(Iconsax.arrow_right_3, color: Colors.white24, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestChips() {
    final data = context.watch<UpdateProfileProvider>().userProfile;
    final interests = data.interests;
    return Consumer<UpdateProfileProvider>(
      builder: (context, updateProvider, child) {
        return Wrap(
          spacing: 10, runSpacing: 10,
          children: [
            ...interests.map((interest) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppColors.neonPink.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.neonPink.withOpacity(0.2))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(interest.emoji), const SizedBox(width: 6),
                  Text(interest.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  const SizedBox(width: 8),
                  GestureDetector(onTap: () => updateProvider.removeInterest(interest), child: const Icon(Icons.close, color: Colors.white38, size: 14)),
                ],
              ),
            )),
            GestureDetector(
              onTap: () => showInterestsBottomSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Iconsax.add, color: AppColors.neonGold, size: 16), Text("Add", style: TextStyle(color: AppColors.neonGold, fontSize: 13, fontWeight: FontWeight.bold))]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlassInput({required String label, required TextEditingController controller, required IconData icon, int maxLines = 1, ValueChanged<String>? onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20)),
      child: TextField(
        controller: controller, maxLines: maxLines, style: const TextStyle(color: Colors.white, fontSize: 15), onChanged: onChanged,
        decoration: InputDecoration(icon: Icon(icon, color: AppColors.neonGold.withOpacity(0.5), size: 20), labelText: label, labelStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13), border: InputBorder.none),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(padding: const EdgeInsets.only(left: 5, bottom: 15, top: 10), child: Text(title, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)));
  }

  Widget _buildFixedSaveAction(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 100, padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
            color: Colors.black.withOpacity(0.5),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(width: double.infinity, decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.neonPink, AppColors.neonGold]), borderRadius: BorderRadius.circular(20)), child: const Center(child: Text("SAVE CHANGES", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1)))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopGradient() {
    return Positioned(top: 0, left: 0, right: 0, height: 300, child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFFFF4D67).withOpacity(0.15), Colors.transparent]))));
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Edit Studio", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)), Text("Manage your digital presence", style: TextStyle(color: Colors.white38, fontSize: 13))]),
          _glassIconButton(Iconsax.arrow_left_2, () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _glassIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 20)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _jobController.dispose();
    super.dispose();
  }
}

class ProfilePhoto {
  final int id;
  final String? url;
  final String? localPath;
  final String? base64;
  final bool isLocal;
  final bool isPrimary;

  ProfilePhoto({required this.id, this.url, this.localPath, this.base64, required this.isLocal, this.isPrimary = false});

  ProfilePhoto copyWith({int? id, String? url, String? localPath, String? base64, bool? isLocal, bool? isPrimary}) {
    return ProfilePhoto(
      id: id ?? this.id,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      base64: base64 ?? this.base64,
      isLocal: isLocal ?? this.isLocal,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}