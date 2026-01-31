import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dating/main.dart';
import 'package:dating/models/profile_model.dart';
import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/profile/edit_profile.dart/edit_education.dart';
import 'package:dating/pages/profile/edit_profile.dart/edit_hieght.dart';
import 'package:dating/pages/profile/edit_profile.dart/habit_choosing.dart';
import 'package:dating/pages/profile/edit_profile.dart/location_edit.dart';
import 'package:dating/pages/profile/edit_profile.dart/relationship_goal.dart';
import 'package:dating/pages/profile/edit_profile.dart/update_intrest.dart';
import 'package:dating/providers/my_profile_provider.dart';
import 'package:dating/providers/profile_update.dart';
import 'package:dating/providers/registration_data_provider.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/notification_service.dart';
import 'package:dating/services/registration_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _jobController;
  late TextEditingController _dateOfBirthController;
  
  final List<ProfilePhoto> _publicPhotos = [];
  final List<ProfilePhoto> _privatePhotos = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;
  bool _showPrivatePhotos = false;

  @override
  void initState() {
    super.initState();
    final firstProfile = context.read<MyProfileProvider>().userProfile;
    context.read<UpdateProfileProvider>().initializeProfile(firstProfile!);
    
    final updatedProfile = context.read<UpdateProfileProvider>().userProfile;
    final provider = context.read<RegistrationDataProvider>();

    provider.loadRelationshipGoals(updatedProfile.gender.id.toString());
    provider.loadEducationLevels();
    provider.loadInterests();

    _nameController = TextEditingController(text: updatedProfile.userName);
    _bioController = TextEditingController(text: updatedProfile.bio ?? "");
    _jobController = TextEditingController(text: updatedProfile.job ?? "");
    
    final dob = updatedProfile.dateOfBirth ?? "Select Date of Birth";
    _dateOfBirthController = TextEditingController(text: dob);
    
    _initializePhotos(updatedProfile.photos, updatedProfile.privatePhotos, updatedProfile.photo);
  }

  void _initializePhotos(List<Photo> publicPhotos, List<Photo> privatePhotos, String mainPhotoUrl) {
    _publicPhotos.clear();
    _privatePhotos.clear();
    
    // Initialize public photos
    for (int i = 0; i < publicPhotos.length; i++) {
      final photo = publicPhotos[i];
      final isPrimary = photo.photoUrl == mainPhotoUrl;
      
      _publicPhotos.add(ProfilePhoto(
        id: i,
        photoId: photo.id,
        url: photo.photoUrl,
        isLocal: false,
        isPrimary: isPrimary,
        isPrivate: false,
      ));
    }
    
    // Ensure we have a primary photo if public photos exist
    if (_publicPhotos.isNotEmpty && !_publicPhotos.any((photo) => photo.isPrimary)) {
      _publicPhotos[0] = _publicPhotos[0].copyWith(isPrimary: true);
    }
    
    // Initialize private photos
    for (int i = 0; i < privatePhotos.length; i++) {
      _privatePhotos.add(ProfilePhoto(
        id: i,
        photoId: privatePhotos[i].id,
        url: privatePhotos[i].photoUrl,
        isLocal: false,
        isPrimary: false,
        isPrivate: true,
      ));
    }
  }

  Future<void> _showDatePicker() async {
    final initialDate = _dateOfBirthController.text.isNotEmpty && 
                       _dateOfBirthController.text != "Select Date of Birth"
        ? DateTime.parse(_dateOfBirthController.text)
        : DateTime.now().subtract(const Duration(days: 365 * 20));
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.neonPink,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF0A0A0A),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF0A0A0A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text = pickedDate.toIso8601String().split('T')[0];
        context.read<UpdateProfileProvider>().updateBasicInfo(
          dateOfBirth: _dateOfBirthController.text,
        );
      });
    }
  }

  void _showImageSourceSheet({bool isPrivate = false}) {
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPrivate ? "Add Private Photo" : "Add to Studio",
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isPrivate ? "Only visible to your matches" : "Select a source",
                          style: const TextStyle(color: Colors.white38, fontSize: 13),
                        ),
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
                        _pickImage(ImageSource.camera, isPrivate: isPrivate);
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildGlassySourceCard(
                      icon: Iconsax.gallery,
                      label: "Gallery",
                      color: AppColors.neonGold,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery, isPrivate: isPrivate);
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPrivate ? "Private Gallery" : "Pro Tip",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              isPrivate ? "These photos are only visible to users you match with." : "Use natural lighting for the best match potential.",
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
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

  Future<void> _pickImage(ImageSource source, {bool isPrivate = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
      if (pickedFile == null) return;
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      await _cropImage(pickedFile.path, isPrivate: isPrivate);
    } catch (e) {
      log("Image pick error: $e");
      _showSnackbar("Failed to pick image", isError: true);
    }
  }

  Future<void> _cropImage(String imagePath, {bool isPrivate = false}) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1.5),
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'STUDIO ADAPT',
            toolbarColor: const Color(0xFF0A0A0A),
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppColors.neonPink,
            backgroundColor: const Color(0xFF0A0A0A),
            statusBarColor: const Color(0xFF0A0A0A),
            cropFrameColor: AppColors.neonPink,
            cropGridColor: Colors.white.withOpacity(0.3),
            dimmedLayerColor: Colors.black.withOpacity(0.85),
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
        _addNewPhoto(File(croppedFile.path), isPrivate: isPrivate);
      }
    } catch (e) {
      log("Crop error: $e");
      _showSnackbar("Failed to crop image", isError: true);
    }
  }

  void _addNewPhoto(File imageFile, {bool isPrivate = false}) {
    final targetList = isPrivate ? _privatePhotos : _publicPhotos;
    final maxLimit = isPrivate ? 6 : 6;
    
    if (targetList.length >= maxLimit) {
      _showSnackbar("Maximum $maxLimit ${isPrivate ? 'private' : 'public'} photos allowed", isError: true);
      return;
    }
    
    final bytes = imageFile.readAsBytesSync();
    final base64Image = base64Encode(bytes);
    setState(() {
      final newPhoto = ProfilePhoto(
        id: DateTime.now().millisecondsSinceEpoch,
        localPath: imageFile.path,
        base64: base64Image,
        isLocal: true,
        isPrimary: !isPrivate && _publicPhotos.isEmpty,
        isPrivate: isPrivate,
      );
      targetList.add(newPhoto);
    });
    _showSnackbar("${isPrivate ? 'Private' : 'Public'} photo added successfully!", isError: false);
  }

  void _showDeleteConfirmation(ProfilePhoto photo) {
    final isPrimaryAndPublic = photo.isPrimary && !photo.isPrivate;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(color: AppColors.neonPink.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: const Icon(Iconsax.trash, color: Colors.red, size: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Delete Photo?",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "This ${photo.isPrivate ? 'private' : 'public'} photo will be permanently removed.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                if (isPrimaryAndPublic) ...[
                  const SizedBox(height: 8),
                  Text(
                    "This is your main profile photo. A new one will be set automatically.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.neonPink.withOpacity(0.8), fontSize: 12),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _deletePhoto(photo);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.red.withOpacity(0.7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deletePhoto(ProfilePhoto photo) async {
    final wasPrimary = photo.isPrimary;
    final isPrivate = photo.isPrivate;
    final targetList = isPrivate ? _privatePhotos : _publicPhotos;
    
    if (photo.isLocal) {
      // Just remove local photo
      setState(() {
        targetList.remove(photo);
        // If primary photo was deleted, set a new primary
        if (wasPrimary && !isPrivate && _publicPhotos.isNotEmpty) {
          _setNewPrimaryPhoto();
        }
      });
      _showSnackbar("Photo removed", isError: false);
    } else if (photo.photoId != null) {
      // Delete from server
      try {
        final isDeleted = await RegistrationService().deletePhoto(
          photoId: photo.photoId!,
          type: photo.isPrivate ? 'private' : 'public',
        );
        
        if (isDeleted) {
          setState(() {
            targetList.remove(photo);
            // If primary photo was deleted, set a new primary
            if (wasPrimary && !isPrivate && _publicPhotos.isNotEmpty) {
              _setNewPrimaryPhoto();
            }
          });
          _showSnackbar("Photo deleted successfully", isError: false);
        } else {
          _showSnackbar("Failed to delete photo", isError: true);
        }
      } catch (e) {
        log("Delete error: $e");
        _showSnackbar("Error deleting photo", isError: true);
      }
    }
  }

  void _setNewPrimaryPhoto() {
    if (_publicPhotos.isNotEmpty) {
      // Set the first photo in the list as primary
      setState(() {
        _publicPhotos[0] = _publicPhotos[0].copyWith(isPrimary: true);
      });
    }
  }

  void _removePhoto(ProfilePhoto photo) {
    if (photo.isLocal) {
      // For local photos, just remove
      final wasPrimary = photo.isPrimary;
      final isPrivate = photo.isPrivate;
      final targetList = isPrivate ? _privatePhotos : _publicPhotos;
      
      setState(() {
        targetList.remove(photo);
        if (wasPrimary && !isPrivate && _publicPhotos.isNotEmpty) {
          _setNewPrimaryPhoto();
        }
      });
      _showSnackbar("Photo removed", isError: false);
    } else {
      // For uploaded photos, show confirmation
      _showDeleteConfirmation(photo);
    }
  }

  void _setPrimaryPhoto(ProfilePhoto photo) {
    if (!photo.isPrivate) {
      setState(() {
        for (int i = 0; i < _publicPhotos.length; i++) {
          _publicPhotos[i] = _publicPhotos[i].copyWith(isPrimary: _publicPhotos[i].id == photo.id);
        }
      });
      _showSnackbar("Set as main profile photo", isError: false);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.neonPink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPhotoEditorGrid({bool isPrivate = false}) {
    final photos = isPrivate ? _privatePhotos : _publicPhotos;
    final title = isPrivate ? "PRIVATE GALLERY" : "PUBLIC GALLERY";
    final subtitle = isPrivate ? "Visible only to matches" : "Visible to everyone";
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isPrivate ? AppColors.neonGold.withOpacity(0.6) : Colors.white.withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: isPrivate ? AppColors.neonGold.withOpacity(0.4) : Colors.white.withOpacity(0.3),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
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
            if (index < photos.length) {
              return _buildPhotoCard(photos[index]);
            } else {
              return _buildEmptyPhotoCard(isPrivate: isPrivate);
            }
          },
        ),
        if (isPrivate) const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPhotoCard(ProfilePhoto photo) {
    final isPrivate = photo.isPrivate;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.03),
            border: Border.all(
              color: photo.isPrimary ? AppColors.neonPink.withOpacity(0.5) 
                    : isPrivate ? AppColors.neonGold.withOpacity(0.3) 
                    : Colors.white10,
              width: photo.isPrimary ? 2 : 1,
            ),
            image: photo.isLocal && photo.localPath != null
                ? DecorationImage(
                    image: FileImage(File(photo.localPath!)),
                    fit: BoxFit.cover,
                  )
                : photo.url != null
                    ? DecorationImage(
                        image: NetworkImage(photo.url!),
                        fit: BoxFit.cover,
                      )
                    : null,
          ),
        ),
        if (photo.isPrimary)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.neonPink,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(19)),
              ),
              child: const Text(
                "MAIN",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        if (photo.isPrivate)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.lock, color: AppColors.neonGold, size: 12),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: Column(
            children: [
              if (!photo.isPrivate && !photo.isPrimary)
                GestureDetector(
                  onTap: () => _setPrimaryPhoto(photo),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.star_1, color: AppColors.neonGold, size: 14),
                  ),
                ),
              GestureDetector(
                onTap: () => _removePhoto(photo),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.close_circle, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPhotoCard({bool isPrivate = false}) {
    return GestureDetector(
      onTap: () => _showImageSourceSheet(isPrivate: isPrivate),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.03),
          border: Border.all(
            color: isPrivate ? AppColors.neonGold.withOpacity(0.1) : Colors.white10,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.add,
                color: isPrivate ? AppColors.neonGold.withOpacity(0.3) : Colors.white.withOpacity(0.2),
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo',
              style: TextStyle(
                color: isPrivate ? AppColors.neonGold.withOpacity(0.3) : Colors.white.withOpacity(0.2),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _prepareProfileData() async {
    final profile = context.read<UpdateProfileProvider>().userProfile;
    
    // Validate at least one public photo
    if (_publicPhotos.isEmpty) {
      throw Exception("At least one public photo is required");
    }
    
    // Find main photo (primary from public photos)
    final mainPhoto = _publicPhotos.firstWhere((photo) => photo.isPrimary, orElse: () => _publicPhotos[0]);
    
    // Get main photo - send base64 if it's new, otherwise backend should keep existing URL
    String? mainPhotoBase64;
    if (mainPhoto.base64 != null) {
      mainPhotoBase64 = mainPhoto.base64; // New photo
    }
    // If it's an existing photo (has URL but no base64), backend should keep the existing URL
    
    // Get all NEW public photos (only base64 for new ones)
    final List<String> newPublicPhotos = [];
    for (final photo in _publicPhotos) {
      if (photo.base64 != null) {
        // Only send base64 for new photos
        newPublicPhotos.add(photo.base64!);
      }
    }
    
    // Get all NEW private photos (only base64 for new ones)
    final List<String> newPrivatePhotos = [];
    for (final photo in _privatePhotos) {
      if (photo.base64 != null) {
        // Only send base64 for new private photos
        newPrivatePhotos.add(photo.base64!);
      }
    }
    
    // Convert interests to List<String> of IDs
    final List<String> interestIds = profile.interests.map((interest) => interest.id.toString()).toList();
    
    return {
      'profile': profile,
      'mainPhotoBase64': mainPhotoBase64, // May be null if main photo is existing
      'newPublicPhotos': newPublicPhotos, // Empty list if no new photos
      'newPrivatePhotos': newPrivatePhotos, // Empty list if no new private photos
      'interestIds': interestIds,
    };
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    
    setState(() => _isSaving = true);
    
    try {
      final data = await _prepareProfileData();
      final profile = data['profile'] as Profile;
      final mainPhotoBase64 = data['mainPhotoBase64'] as String?; // May be null
      final newPublicPhotos = data['newPublicPhotos'] as List<String>;
      final newPrivatePhotos = data['newPrivatePhotos'] as List<String>;
      final interestIds = data['interestIds'] as List<String>;
      final userId = await AuthService().getUserId();

      // Create UserRegistrationModel
      final registrationData = UserRegistrationModel(
        userName: profile.userName,
        userRegId: userId,
        dateOfBirth: profile.dateOfBirth ?? "",
        gender: profile.gender.id.toString(),
        height: double.tryParse(profile.height.toString()) ?? 0.0,
        smokingHabit: profile.smokingHabit,
        drinkingHabit: profile.drinkingHabit,
        relationshipGoal: profile.relationshipGoal?.id.toString() ?? "",
        job: profile.job ?? "",
        education: profile.education.id.toString(),
        latitude: double.tryParse(profile.latitude ?? '0') ?? 0.0,
        longitude: double.tryParse(profile.longitude ?? '0') ?? 0.0,
        city: profile.city ?? "",
        state: profile.state ?? "",
        country: profile.country ?? "",
        address: profile.address ?? "",
        bio: profile.bio ?? "",
        interests: interestIds,
        photos: newPublicPhotos, // Only new photos as base64
        phoneNo: profile.phno,
        privatePhotos: newPrivatePhotos, // Only new private photos as base64
        mainPhotoUrl: mainPhotoBase64, // May be null or base64 string
      );
      
      log(registrationData.toJson().toString());
      String? token = await FirebaseNotificationService.getToken(retry: true);

      // Call update API
      final apiResult = await RegistrationService().updateProfileToAPI(registrationData, token ?? '');
      
      if (apiResult['success']) {
        _showSnackbar("Profile updated successfully!", isError: false);
        
        // Update local profile
        final myProfileProvider = context.read<MyProfileProvider>();
        myProfileProvider.fetchUserProfile(userId??'');
        
        // Navigate back after a delay
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.pop(context);
      } else {
        _showSnackbar("Failed to update profile", isError: true);
      }
    } on Exception catch (e) {
      _showSnackbar(e.toString(), isError: true);
    } catch (e) {
      log("Save error: $e");
      _showSnackbar("An error occurred: $e", isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
                        _buildPhotoEditorGrid(isPrivate: false),
                        const SizedBox(height: 20),
                        
                        // Private Photos Toggle
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _showPrivatePhotos = !_showPrivatePhotos;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.neonGold.withOpacity(_showPrivatePhotos ? 0.3 : 0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.lock,
                                    color: AppColors.neonGold.withOpacity(0.7),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    'Private Gallery',
                                    style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${_privatePhotos.length}/6',
                                    style: TextStyle(
                                      color: AppColors.neonGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    _showPrivatePhotos ? Iconsax.arrow_up_2 : Iconsax.arrow_down_2,
                                    color: AppColors.neonGold.withOpacity(0.5),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Private Photos Grid (Conditional)
                        if (_showPrivatePhotos) _buildPhotoEditorGrid(isPrivate: true),
                        
                        const SizedBox(height: 20),
                        _buildSectionTitle("BASIC INFO"),
                        _buildSelectorTile(
                          icon: Iconsax.calendar,
                          title: "Date of Birth",
                          value: _dateOfBirthController.text,
                          onTap: _showDatePicker,
                        ),
                        _buildGlassInput(
                          label: "Full Name",
                          controller: _nameController,
                          icon: Iconsax.user,
                          onChanged: (v) => context.read<UpdateProfileProvider>().updateBasicInfo(userName: v),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassInput(
                          label: "About Me",
                          controller: _bioController,
                          icon: Iconsax.document_text,
                          maxLines: 4,
                          onChanged: (v) => context.read<UpdateProfileProvider>().updateBio(v),
                        ),
                        const SizedBox(height: 12),
                        _buildGlassInput(
                          label: "Occupation",
                          controller: _jobController,
                          icon: Iconsax.briefcase,
                          onChanged: (v) => context.read<UpdateProfileProvider>().updateJob(v),
                        ),
                        const SizedBox(height: 12),
                        _buildSelectorTile(
                          icon: Iconsax.location,
                          title: "Current City",
                          value: data.city ??'',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LocationEditPage())),
                        ),
                        _buildSelectorTile(
                          icon: Iconsax.teacher,
                          title: "Education",
                          value: data.education.name,
                          onTap: () => showEducationBottomSheet(context),
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle("HABITS"),
                        _buildSelectorTile(
                          icon: Iconsax.status,
                          title: "Smoking",
                          value: getDisplayHabit(data.smokingHabit),
                          onTap: () => showSmokingHabitSheet(context),
                        ),
                        _buildSelectorTile(
                          icon: Iconsax.cup,
                          title: "Drinking",
                          value: getDisplayHabit(data.drinkingHabit),
                          onTap: () => showDrinkingHabitSheet(context),
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle("PREFERENCES"),
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => showRelationshipGoalSheet(context),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Iconsax.heart, color: Colors.white38, size: 15),
                                      const SizedBox(width: 15),
                                      const Text('Relationship Goal', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                      const Spacer(),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Text(
                                        data.relationshipGoal?.name ?? "Set Goal",
                                        style: const TextStyle(color: AppColors.neonGold, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Iconsax.arrow_right_3, color: Colors.white24, size: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _buildSelectorTile(
                          icon: Iconsax.ruler,
                          title: "Height",
                          value: data.height ?? "Select Height",
                          onTap: () => showHeightBottomSheet(context),
                        ),
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
          _buildFixedSaveAction(),
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
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white38, size: 20),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.neonGold, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
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
          spacing: 10,
          runSpacing: 10,
          children: [
            ...interests.map((interest) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.neonPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.neonPink.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(interest.emoji),
                      const SizedBox(width: 6),
                      Text(interest.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => updateProvider.removeInterest(interest),
                        child: const Icon(Icons.close, color: Colors.white38, size: 14),
                      ),
                    ],
                  ),
                )),
            GestureDetector(
              onTap: () => showInterestsBottomSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.add, color: AppColors.neonGold, size: 16),
                    SizedBox(width: 4),
                    Text("Add", style: TextStyle(color: AppColors.neonGold, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlassInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.neonGold.withOpacity(0.5), size: 20),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 15, top: 10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildFixedSaveAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 100,
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: _buildSaveButton(),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      onTap: _isSaving ? null : _saveChanges,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: _isSaving
              ? LinearGradient(
                  colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [AppColors.neonPink, AppColors.neonGold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isSaving
              ? []
              : [
                  BoxShadow(
                    color: AppColors.neonPink.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: _isSaving
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation(AppColors.neonPink),
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "UPDATING...",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.cloud, color: Colors.black, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "SAVE CHANGES",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF4D67).withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Edit Studio", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
              Text("Manage your digital presence", style: TextStyle(color: Colors.white38, fontSize: 13)),
            ],
          ),
          _glassIconButton(Iconsax.arrow_left_2, () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _glassIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _jobController.dispose();
    _dateOfBirthController.dispose();
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
  final bool isPrivate;
  final String? photoId;

  ProfilePhoto({
    required this.id,
    this.url,
    this.localPath,
    this.base64,
    required this.isLocal,
    this.isPrimary = false,
    required this.isPrivate,
    this.photoId,
  });

  ProfilePhoto copyWith({
    int? id,
    String? url,
    String? localPath,
    String? base64,
    bool? isLocal,
    bool? isPrimary,
    bool? isPrivate,
    String? photoId,
  }) {
    return ProfilePhoto(
      id: id ?? this.id,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      base64: base64 ?? this.base64,
      isLocal: isLocal ?? this.isLocal,
      isPrimary: isPrimary ?? this.isPrimary,
      isPrivate: isPrivate ?? this.isPrivate,
      photoId: photoId ?? this.photoId,
    );
  }
}