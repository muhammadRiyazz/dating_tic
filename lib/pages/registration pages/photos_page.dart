import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/home/home_screen.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/registration_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_cropper/image_cropper.dart';

// Import notification service
import 'package:dating/services/notification_service.dart';

// Import your main app file
import 'package:dating/main.dart';
import 'package:provider/provider.dart';

import '../../providers/my_profile_provider.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({
    super.key,
    required this.userdata,
  });

  final UserRegistrationModel userdata;

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  final ImagePicker _picker = ImagePicker();
  List<ProfilePhoto> _profilePhotos = [];
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isVerifying = false;
  bool _isProcessingNotifications = false;
  String _uploadError = '';
  String? _fcmToken;
  
  final int _minPhotos = 1;
  final int _maxPhotos = 6;

  @override
  void initState() {
    super.initState();
    _loadInitialPhotos();
  }

  void _loadInitialPhotos() {
    // If there are any existing photos in userdata, load them
    if (widget.userdata.photos != null && widget.userdata.photos!.isNotEmpty) {
      for (int i = 0; i < widget.userdata.photos!.length; i++) {
        _profilePhotos.add(ProfilePhoto(
          id: i,
          base64: widget.userdata.photos![i],
          isLocal: false,
          isPrimary: i == 0,
        ));
      }
    }
  }

  @override
  void dispose() {
    FirebaseNotificationService.dispose();
    super.dispose();
  }

  // ====================== NOTIFICATION HANDLING ======================
  Future<String?> _initializeNotificationsAndGetToken() async {
    setState(() {
      _isProcessingNotifications = true;
    });

    try {
      log("🚀 Starting notification setup...");
          
      // Initialize notifications
      await FirebaseNotificationService.init();
      
      // Wait a bit for initialization
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Try to get token
      String? token = await FirebaseNotificationService.getToken(retry: true);
      
      if (token == null || token.isEmpty) {
        // Token might not be available yet, especially on iOS
        await Future.delayed(const Duration(seconds: 1));
        
        // Try force refresh
        token = await FirebaseNotificationService.forceRefreshToken();
      }
      
      if (token != null && token.isNotEmpty) {
        log("✅ FCM Token obtained: $token");
        _fcmToken = token;
        
        return token;
      } else {
        // Token not available - user might have denied or iOS needs time
        log("⚠️ No FCM token available");
        
        // Check permission status
        final settings = await FirebaseMessaging.instance.getNotificationSettings();
        
        if (settings.authorizationStatus == AuthorizationStatus.denied ||
            settings.authorizationStatus == AuthorizationStatus.notDetermined) {
          
          // Show friendly message about notifications
          if (mounted) {
            await _showNotificationEnablingGuide();
          }
        }
        
        // Continue without token
        return null;
      }
      
    } catch (e) {
      log("❌ Error in notification setup: $e");
      
      // Show error message but continue
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Iconsax.info_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Notification setup skipped. You can enable later in settings.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange.withOpacity(0.9),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      
      return null;
    } finally {
      setState(() {
        _isProcessingNotifications = false;
      });
    }
  }

  Future<void> _showNotificationEnablingGuide() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.deepBlack,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: AppColors.neonGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.neonGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Iconsax.notification,
                  color: AppColors.neonGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Stay Connected!',
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.neonGold,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enable notifications for the best experience:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildFeaturePoint('🔥 Instant match alerts'),
              _buildFeaturePoint('💬 Real-time messages'),
              _buildFeaturePoint('👀 Profile view notifications'),
              _buildFeaturePoint('🎯 Personalized recommendations'),
              
              const SizedBox(height: 20),
              
              Text(
                'To enable:',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Android: Allow when prompted\n• iOS: Go to Settings → Notifications → Weekend App → Allow',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                'You can always enable notifications later in settings.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                // Enable Later
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSkipConfirmation();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Maybe Later',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Try Again
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _retryNotificationSetup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Enable Now',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeaturePoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Iconsax.tick_circle,
            color: AppColors.neonGold,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSkipConfirmation() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.deepBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.orange.withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(Iconsax.info_circle, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          content: Text(
            'Without notifications, you might miss important matches and messages. '
            'We recommend enabling them for the best experience.',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Go Back',
                style: TextStyle(
                  color: AppColors.neonGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showFinalSkipMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
                foregroundColor: Colors.grey.shade400,
              ),
              child: Text('Skip Anyway'),
            ),
          ],
        );
      },
    );
  }

  void _showFinalSkipMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.emoji_sad, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'You can enable notifications anytime in Settings → Notifications',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0.9),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
      ),
    );
  }

  Future<void> _retryNotificationSetup() async {
    setState(() {
      _isProcessingNotifications = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.neonGold,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Checking notification permissions...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
    );
    
    await Future.delayed(const Duration(seconds: 2));
    
    String? token = await FirebaseNotificationService.forceRefreshToken();
    
    if (token != null) {
      _fcmToken = token;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showSuccessSnackbar('Notifications enabled successfully!');
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showErrorSnackbar('Unable to enable notifications. Please try from Settings.');
    }
    
    setState(() {
      _isProcessingNotifications = false;
    });
  }

  // ====================== IMAGE HANDLING METHODS ======================
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
              color: AppColors.deepBlack.withOpacity(0.9),
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
                        Text("Add Photo",
                          style: TextStyle(
                            color: AppColors.neonGold,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5
                          )
                        ),
                        const SizedBox(height: 4),
                        Text("Select a source",
                          style: TextStyle(color: Colors.white38, fontSize: 13)),
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
                        child: Icon(Iconsax.close_circle, color: AppColors.neonGold, size: 20),
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
                      color: AppColors.neonGold,
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
                        decoration: BoxDecoration(
                          color: AppColors.neonGold.withOpacity(0.1),
                          shape: BoxShape.circle
                        ),
                        child: Icon(Iconsax.magic_star, color: AppColors.neonGold, size: 20),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pro Tip",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              )
                            ),
                            Text("Use clear, well-lit photos showing your face for better matches.",
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
            color: AppColors.cardBlack,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_profilePhotos.length >= _maxPhotos) {
      _showErrorSnackbar('Maximum $_maxPhotos photos allowed');
      return;
    }
    
    try {
      setState(() {
        _isVerifying = true;
        _uploadError = '';
      });
      
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.front,
      );
      
      if (pickedFile != null) {
        await _cropImage(File(pickedFile.path));
      }
    } catch (e) {
      log('Error picking image: $e');
      _showErrorSnackbar('Failed to pick image. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Your Photo',
            toolbarColor: AppColors.deepBlack,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppColors.neonGold,
            backgroundColor: AppColors.deepBlack,
            statusBarColor: AppColors.deepBlack,
            cropFrameColor: AppColors.neonGold,
            cropGridColor: Colors.white.withOpacity(0.3),
            dimmedLayerColor: Colors.black.withOpacity(0.85),
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true,
            hideBottomControls: false,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
            resetButtonHidden: false,
            doneButtonTitle: 'USE',
            cancelButtonTitle: 'CANCEL',
          ),
        ],
      );

      if (croppedFile != null && mounted) {
        _addNewPhoto(File(croppedFile.path));
      }
    } catch (e) {
      log('Error cropping image: $e');
      _showErrorSnackbar('Failed to crop image');
    }
  }

  void _addNewPhoto(File imageFile) {
    // Convert image to base64
    final bytes = imageFile.readAsBytesSync();
    final base64Image = base64Encode(bytes);
    
    setState(() {
      _profilePhotos.add(ProfilePhoto(
        id: DateTime.now().millisecondsSinceEpoch,
        base64: base64Image,
        isLocal: true,
        isPrimary: _profilePhotos.isEmpty,
      ));
    });
    
    _showSuccessSnackbar('Photo added successfully!');
  }

  void _removePhoto(int index) {
    if (index < _profilePhotos.length) {
      setState(() {
        final wasPrimary = _profilePhotos[index].isPrimary;
        _profilePhotos.removeAt(index);
        
        if (wasPrimary && _profilePhotos.isNotEmpty) {
          _profilePhotos[0] = _profilePhotos[0].copyWith(isPrimary: true);
        }
        _uploadError = '';
      });
    }
  }

  void _setPrimaryPhoto(int index) {
    if (index < _profilePhotos.length) {
      setState(() {
        for (int i = 0; i < _profilePhotos.length; i++) {
          _profilePhotos[i] = _profilePhotos[i].copyWith(
            isPrimary: i == index,
          );
        }
      });
    }
  }

  void _reorderPhoto(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final photo = _profilePhotos.removeAt(oldIndex);
    setState(() {
      _profilePhotos.insert(newIndex, photo);
      _uploadError = '';
    });
  }

  void _showFullScreenImage(int index) {
    if (_profilePhotos[index].base64 != null) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Stack(
              children: [
                PhotoView(
                  imageProvider: MemoryImage(base64Decode(_profilePhotos[index].base64!)),
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Iconsax.close_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // ====================== REGISTRATION FLOW ======================
  void _uploadAndContinue() async {
    log('_uploadAndContinue');
    log(jsonEncode(widget.userdata.interests).toString());

    // Validation
    if (_profilePhotos.length < _minPhotos) {
      _showErrorSnackbar('Please add at least $_minPhotos photos');
      return;
    }
    
    if (widget.userdata.userRegId == null) {
      _showErrorSnackbar('User ID not found. Please restart registration.');
      return;
    }
    
    // Start the registration process
    setState(() {
      _isUploading = true;
      _uploadError = '';
    });
    
    try {
      // Extract base64 images from profile photos
      final List<String> base64Images = [];
      for (final photo in _profilePhotos) {
        if (photo.base64 != null && photo.base64!.isNotEmpty) {
          base64Images.add(photo.base64!);
        }
      }
      
      if (base64Images.isEmpty) {
        throw Exception('No valid photos to upload');
      }
      
      // Validate base64 strings
      for (int i = 0; i < base64Images.length; i++) {
        try {
          base64Decode(base64Images[i]);
        } catch (e) {
          throw Exception('Photo ${i + 1} has invalid base64 encoding');
        }
      }
      
      // Prepare user data
      String mainPhotoUrl = base64Images.isNotEmpty ? base64Images[0] : '';
      
      final UserRegistrationModel data = UserRegistrationModel(
        userName: widget.userdata.userName,
        userRegId: widget.userdata.userRegId,
        dateOfBirth: widget.userdata.dateOfBirth,
        gender: widget.userdata.gender,
        height: widget.userdata.height,
        smokingHabit: widget.userdata.smokingHabit,
        drinkingHabit: widget.userdata.drinkingHabit,
        relationshipGoal: widget.userdata.relationshipGoal,
        job: widget.userdata.job,
        education: widget.userdata.education,
        latitude: widget.userdata.latitude,
        longitude: widget.userdata.longitude,
        city: widget.userdata.city,
        state: widget.userdata.state,
        country: widget.userdata.country,
        address: widget.userdata.address,
        bio: widget.userdata.bio,
        interests: widget.userdata.interests,
        photos: base64Images,
        mainPhotoUrl: mainPhotoUrl,
      );
      
      // Handle notifications
      _fcmToken = await _initializeNotificationsAndGetToken();
      log('Final FCM Token for registration: $_fcmToken');
      
      // Call API with notification token
      final apiResult = await RegistrationService().updateProfileToAPI(data, _fcmToken ?? '');
      
      if (apiResult['success'] == true) {
        // Login user
        final authService = AuthService();
        final responseData = apiResult['data'];
        final String userName = responseData?['data']?['user_name'] ?? widget.userdata.userName ?? '';
        final String userPhone = responseData?['data']?['phone'] ?? '';
        
        await authService.login(
          userId: widget.userdata.userRegId.toString(),
          token: responseData?['data']?['token'] ?? '',
          phone: userPhone,
          name: userName,
          photo: mainPhotoUrl,
        );
        
        _showSuccessSnackbar('🎉 Registration Complete! Welcome to Weekend!');
        
        // Navigate to home
        await Future.delayed(const Duration(milliseconds: 1500));
        
        if (mounted) {
          context.read<MyProfileProvider>().fetchUserProfile(widget.userdata.userRegId.toString());
          
          // Navigate to home screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const WeekendHome(),
            ),
            (route) => false,
          );
        }
      } else {
        setState(() {
          _uploadError = apiResult['message'] ?? 'Failed to update profile';
        });
        _showErrorSnackbar(apiResult['message'] ?? 'Failed to update profile. Please try again.');
      }
      
    } catch (e) {
      log('Registration error: $e');
      setState(() {
        _uploadError = e.toString();
      });
      _showErrorSnackbar('An error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.tick_circle, color: Colors.black, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.neonGold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.info_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ====================== UI BUILD METHOD ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.neonGold.withOpacity(0.15),
              Colors.transparent,
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Iconsax.arrow_left_2,
                        color: AppColors.neonGold,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                
                // Title section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [
                            Colors.white,
                            AppColors.neonGold,
                          ],
                          stops: const [0.7, 1.0],
                        ).createShader(bounds);
                      },
                      child: Text(
                        'Profile Photos',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Add up to 6 photos. First photo is your primary profile picture.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_profilePhotos.length}/$_maxPhotos photos added',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.neonGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                // Progress indicator
                if (_profilePhotos.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 20),
                    child: LinearProgressIndicator(
                      value: _profilePhotos.length / _maxPhotos,
                      backgroundColor: AppColors.cardBlack,
                      color: AppColors.neonGold,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                
                // Error message
                if (_uploadError.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.info_circle, color: Colors.red, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _uploadError,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Image verification indicator
                if (_isVerifying)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Processing and verifying photo...',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Photo grid
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [                        const SizedBox(height: 22),

                        _buildPhotoEditorGrid(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                
                // Register button with loading states
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _profilePhotos.length >= _minPhotos && 
                                !_isUploading && 
                                !_isVerifying &&
                                !_isProcessingNotifications
                          ? _uploadAndContinue
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _profilePhotos.length >= _minPhotos
                            ? AppColors.neonGold
                            : AppColors.neonGold.withOpacity(0.3),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isUploading || _isProcessingNotifications
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _isUploading ? 'Registering...' : 'Setting up notifications...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _profilePhotos.length < _minPhotos
                                      ? 'ADD ${_minPhotos - _profilePhotos.length} MORE PHOTOS'
                                      : 'COMPLETE REGISTRATION',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoEditorGrid() {
    return Column(
      children: [
        // Add photo button (if space available)
      
        // Photos Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: _maxPhotos,
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
    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.05,
          child: Container(
            width: (MediaQuery.of(context).size.width - 72) / 3,
            height: ((MediaQuery.of(context).size.width - 72) / 3) / 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: photo.base64 != null
                  ? DecorationImage(
                      image: MemoryImage(base64Decode(photo.base64!)),
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
              border: Border.all(
                color: AppColors.neonGold.withOpacity(0.5),
                width: 2,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.cardBlack.withOpacity(0.5),
          border: Border.all(
            color: AppColors.neonGold.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: DragTarget<int>(
        onAccept: (draggedIndex) {
          _reorderPhoto(draggedIndex, index);
        },
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            onTap: () => _showFullScreenImage(index),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: photo.base64 != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(photo.base64!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: photo.base64 == null
                        ? AppColors.cardBlack
                        : null,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                
                if (photo.isPrimary)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.neonGold,
                            AppColors.neonGold.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        'MAIN',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _removePhoto(index),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Iconsax.close_circle,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                
                // Set primary button overlay
                if (!photo.isPrimary)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _setPrimaryPhoto(index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.star_1,
                                color: AppColors.neonGold,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyPhotoCard(int index) {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.03),
          border: Border.all(
            color: Colors.white10,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.add,
                color: Colors.white24,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePhoto {
  final int id;
  final String? base64;
  final bool isLocal;
  final bool isPrimary;

  ProfilePhoto({
    required this.id,
    this.base64,
    required this.isLocal,
    this.isPrimary = false,
  });

  ProfilePhoto copyWith({
    int? id,
    String? base64,
    bool? isLocal,
    bool? isPrimary,
  }) {
    return ProfilePhoto(
      id: id ?? this.id,
      base64: base64 ?? this.base64,
      isLocal: isLocal ?? this.isLocal,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}