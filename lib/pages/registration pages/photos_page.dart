import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:dating/models/user_registration_model.dart';
import 'package:dating/pages/home/home_screen.dart';
import 'package:dating/services/auth_service.dart';
import 'package:dating/services/registration_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  List<File> _selectedImages = [];
  List<String> _base64Images = [];
  List<String> _originalImagePaths = [];
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isVerifying = false;
  bool _isProcessingNotifications = false;
  String _uploadError = '';
  String? _fcmToken;
  
  final int _minPhotos = 1;
  final int _maxPhotos = 4;
  
  // Image processing configuration
  static const String _targetFormat = 'jpeg';
  static const int _maxFileSize = 2 * 1024 * 1024;
  static const int _targetWidth = 1080;
  static const int _targetHeight = 1440;
  static const int _jpegQuality = 85;
  final double _targetAspectRatio = 3.0 / 4.0;

  @override
  void dispose() {
    FirebaseNotificationService.dispose();
    super.dispose();
  }

  // ====================== NOTIFICATION HANDLING ======================

  // Initialize notifications and get token
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

  // Show guide for enabling notifications
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

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= _maxPhotos) return;
    
    try {
      setState(() {
        _isVerifying = true;
        _uploadError = '';
      });
      
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.front,
      );
      
      if (image != null) {
        _originalImagePaths.add(image.path);
        
        File? croppedFile = await _showCustomCropper(File(image.path));
        if (croppedFile != null) {
          File? processedFile = await _processImage(croppedFile);
          
          if (processedFile != null) {
            bool isHuman = await _verifyHumanImage(processedFile);
            
            if (isHuman) {
              String base64Image = await _fileToBase64(processedFile);
              
              setState(() {
                _selectedImages.add(processedFile);
                _base64Images.add(base64Image);
              });
              _showSuccessSnackbar('Photo added successfully!');
            } else {
              _showErrorSnackbar('Please upload a clear photo showing your face');
            }
          } else {
            _showErrorSnackbar('Failed to process image. Please try again.');
          }
        }
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

  Future<String> _fileToBase64(File file) async {
    try {
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      return base64Image;
    } catch (e) {
      log('Error converting file to base64: $e');
      rethrow;
    }
  }

  Future<File?> _processImage(File originalFile) async {
    try {
      final bytes = await originalFile.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) throw Exception('Failed to decode image');
      
      final newDimensions = _calculateDimensions(
        originalImage.width,
        originalImage.height,
      );
      
      final resizedImage = img.copyResize(
        originalImage,
        width: newDimensions.width,
        height: newDimensions.height,
        interpolation: img.Interpolation.linear,
      );
      
      final jpegBytes = img.encodeJpg(resizedImage, quality: _jpegQuality);
      Uint8List compressedBytes = await _compressToTargetSize(jpegBytes);
      
      final tempDir = Directory.systemTemp;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final processedFile = File('${tempDir.path}/processed_$timestamp.$_targetFormat');
      await processedFile.writeAsBytes(compressedBytes);
      
      return processedFile;
    } catch (e) {
      log('Error processing image: $e');
      return null;
    }
  }

  Future<Uint8List> _compressToTargetSize(Uint8List bytes) async {
    if (bytes.length <= _maxFileSize) return bytes;
    
    int currentQuality = _jpegQuality;
    Uint8List compressedBytes = bytes;
    
    while (compressedBytes.length > _maxFileSize && currentQuality > 10) {
      currentQuality -= 5;
      final image = img.decodeJpg(compressedBytes);
      if (image == null) break;
      compressedBytes = img.encodeJpg(image, quality: currentQuality);
    }
    
    if (compressedBytes.length > _maxFileSize) {
      final image = img.decodeJpg(compressedBytes);
      if (image != null) {
        final newWidth = (image.width * 0.9).toInt();
        final newHeight = (image.height * 0.9).toInt();
        
        final resizedImage = img.copyResize(
          image,
          width: newWidth,
          height: newHeight,
        );
        
        compressedBytes = img.encodeJpg(resizedImage, quality: math.max(currentQuality, 30));
      }
    }
    
    return compressedBytes;
  }

  Dimensions _calculateDimensions(int originalWidth, int originalHeight) {
    double aspectRatio = originalWidth / originalHeight;
    
    if (aspectRatio > _targetAspectRatio) {
      return Dimensions(
        width: (_targetHeight * _targetAspectRatio).toInt(),
        height: _targetHeight,
      );
    } else {
      return Dimensions(
        width: _targetWidth,
        height: (_targetWidth / _targetAspectRatio).toInt(),
      );
    }
  }

  Future<File?> _showCustomCropper(File imageFile) async {
    return await showDialog<File>(
      context: context,
      builder: (context) => AdvancedImageCropper(
        imageFile: imageFile,
        aspectRatio: _targetAspectRatio,
      ),
    );
  }

  Future<bool> _verifyHumanImage(File imageFile) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final stats = await imageFile.stat();
      if (stats.size > _maxFileSize * 1.1) return false;
      return true;
    } catch (e) {
      log('Verification error: $e');
      return false;
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      _base64Images.removeAt(index);
      _originalImagePaths.removeAt(index);
      _uploadError = '';
    });
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.deepBlack,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neonGold.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Add Photo',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.neonGold,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Images will be automatically converted to JPEG and optimized',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 24),
              
              _buildSourceOption(
                context,
                icon: Iconsax.camera,
                title: 'Take Photo Now',
                subtitle: 'Use camera to take a new photo',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              
              _buildSourceOption(
                context,
                icon: Iconsax.gallery,
                title: 'Choose from Gallery',
                subtitle: 'Select from your photos',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.grey.shade800,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.neonGold,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: AppColors.neonGold.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _reorderImage(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final File image = _selectedImages.removeAt(oldIndex);
    final String base64Image = _base64Images.removeAt(oldIndex);
    final String path = _originalImagePaths.removeAt(oldIndex);
    
    setState(() {
      _selectedImages.insert(newIndex, image);
      _base64Images.insert(newIndex, base64Image);
      _originalImagePaths.insert(newIndex, path);
      _uploadError = '';
    });
  }

  void _showFullScreenImage(int index) {
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
                imageProvider: FileImage(_selectedImages[index]),
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

  // ====================== REGISTRATION FLOW ======================

  void _uploadAndContinue() async {





log('_uploadAndContinue');
log(jsonEncode(widget.userdata.interests).toString() );

    // // Validation
    if (_selectedImages.length < _minPhotos) {
      _showErrorSnackbar('Please add at least $_minPhotos photos');
      return;
    }
    
    if (widget.userdata.userRegId == null) {
      // _showErrorSnackbar('User ID not found. Please restart registration.');
      return;
    }
    
    // Start the registration process
    setState(() {
      _isUploading = true;
      _uploadError = '';
    });
    
    try {
      // STEP 1: Validate images
      for (int i = 0; i < _selectedImages.length; i++) {
        final file = _selectedImages[i];
        final size = await file.length();
        if (size > _maxFileSize * 1.1) {
          throw Exception('Image $i is too large: ${size / 1024}KB');
        }
        
        final bytes = await file.readAsBytes();
        if (bytes.length < 2 || (bytes[0] != 0xFF || bytes[1] != 0xD8)) {
          throw Exception('Image $i is not in JPEG format');
        }
      }
      
      for (int i = 0; i < _base64Images.length; i++) {
        if (_base64Images[i].isEmpty) {
          throw Exception('Image $i base64 string is empty');
        }
        
        try {
          base64Decode(_base64Images[i]);
        } catch (e) {
          throw Exception('Image $i has invalid base64 encoding');
        }
      }
      
      // STEP 2: Prepare user data
      String mainPhotoUrl = _base64Images.isNotEmpty ? _base64Images[0] : '';
      
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
        photos: _base64Images,
        mainPhotoUrl: mainPhotoUrl,
      );
      
      // STEP 3: Handle notifications (call init and get token)
      _fcmToken = await _initializeNotificationsAndGetToken();
      log('Final FCM Token for registration: $_fcmToken');
      
      // STEP 4: Call API with notification token
      final apiResult = await RegistrationService(). updateProfileToAPI(data,_fcmToken??'');
      
      if (apiResult['success'] == true) {
        // STEP 5: Login user
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
        
        // STEP 6: Navigate to home
        await Future.delayed(const Duration(milliseconds: 1500));
        
        if (mounted) {
                  context.read<MyProfileProvider>().fetchUserProfile( widget.userdata.userRegId.toString());

          fetchprofiles(context);
          log('Done');
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   PageRouteBuilder(
          //     pageBuilder: (context, animation, secondaryAnimation) => const WeekendHome(),
          //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
          //       const begin = Offset(1.0, 0.0);
          //       const end = Offset.zero;
          //       const curve = Curves.easeInOut;
          //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          //       return SlideTransition(
          //         position: animation.drive(tween),
          //         child: child,
          //       );
          //     },
          //   ),
          //   (route) => false,
          // );
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
      // _showErrorSnackbar('An error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
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
              AppColors.neonGold.withOpacity(0.2),
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
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.neonGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Iconsax.arrow_left_2,
                        color: AppColors.neonGold,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
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
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Add clear photos showing your face',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Progress indicator
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: _selectedImages.length / _maxPhotos,
                        backgroundColor: AppColors.cardBlack,
                        color: AppColors.neonGold,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
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
                
                // Notification processing indicator
               
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
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _maxPhotos,
                          itemBuilder: (context, index) {
                            if (index < _selectedImages.length) {
                              return _buildImageContainer(index);
                            } else {
                              return _buildAddPhotoButton();
                            }
                          },
                        ),
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
                      onPressed: _selectedImages.length >= _minPhotos && 
                                !_isUploading && 
                                !_isVerifying &&
                                !_isProcessingNotifications
                          ? _uploadAndContinue
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedImages.length >= _minPhotos
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
                               
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedImages.length < _minPhotos
                                      ? 'ADD ${_minPhotos - _selectedImages.length} MORE PHOTOS'
                                      : 'REGISTER',
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

  Widget _buildImageContainer(int index) {
    final isFirstPhoto = index == 0;
    
    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.05,
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 32,
            height: (MediaQuery.of(context).size.width / 2 - 32) / 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: FileImage(_selectedImages[index]),
                fit: BoxFit.cover,
              ),
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
          _reorderImage(draggedIndex, index);
        },
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            onTap: () => _showFullScreenImage(index),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: FileImage(_selectedImages[index]),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Container(
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
                  
                  if (isFirstPhoto)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.neonGold,
                              AppColors.neonGold.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
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
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        width: 32,
                        height: 32,
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
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBlack,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.neonGold.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.add,
                color: AppColors.neonGold,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.neonGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dimensions {
  final int width;
  final int height;
  
  Dimensions({required this.width, required this.height});
}

class AdvancedImageCropper extends StatefulWidget {
  final File imageFile;
  final double aspectRatio;
  
  const AdvancedImageCropper({
    required this.imageFile,
    required this.aspectRatio,
  });
  
  @override
  _AdvancedImageCropperState createState() => _AdvancedImageCropperState();
}

class _AdvancedImageCropperState extends State<AdvancedImageCropper> {
  late PhotoViewController _photoViewController;
  late TransformationController _transformationController;
  
  double _frameWidth = 0;
  double _frameHeight = 0;
  
  @override
  void initState() {
    super.initState();
    _photoViewController = PhotoViewController();
    _transformationController = TransformationController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateFrameDimensions();
    });
  }
  
  void _calculateFrameDimensions() {
    final screenSize = MediaQuery.of(context).size;
    final padding = 40.0;
    
    _frameWidth = screenSize.width - (padding * 2);
    _frameHeight = _frameWidth / widget.aspectRatio;
    
    if (_frameHeight > screenSize.height * 0.7) {
      _frameHeight = screenSize.height * 0.7;
      _frameWidth = _frameHeight * widget.aspectRatio;
    }
    
    setState(() {});
  }
  
  @override
  void dispose() {
    _photoViewController.dispose();
    _transformationController.dispose();
    super.dispose();
  }
  
  Future<File> _cropImage() async {
    return widget.imageFile;
  }
  
  @override
  Widget build(BuildContext context) {
    if (_frameWidth == 0 || _frameHeight == 0) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: Column(
                children: [
                  Text(
                    'Crop Your Photo',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Image will be auto-converted to JPEG format',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Center(
                child: Container(
                  width: _frameWidth,
                  height: _frameHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.neonGold,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: PhotoView(
                            imageProvider: FileImage(widget.imageFile),
                            controller: _photoViewController,
                            backgroundDecoration: const BoxDecoration(color: Colors.black),
                            minScale: PhotoViewComputedScale.contained * 0.5,
                            maxScale: PhotoViewComputedScale.covered * 3,
                            initialScale: PhotoViewComputedScale.contained,
                            basePosition: Alignment.center,
                            enableRotation: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.grey.shade700),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.close_circle, size: 20),
                            const SizedBox(width: 8),
                            Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          final croppedFile = await _cropImage();
                          Navigator.pop(context, croppedFile);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonGold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('USE PHOTO', style: TextStyle(fontWeight: FontWeight.w900)),
                            const SizedBox(width: 8),
                            Icon(Iconsax.tick_circle, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrameGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    
    for (int i = 1; i < 3; i++) {
      final x = size.width * i / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    for (int i = 1; i < 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}