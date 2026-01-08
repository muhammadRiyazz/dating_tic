import 'dart:developer';

import 'package:dating/main.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class PhotosPage extends StatefulWidget {
  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isVerifying = false;
  
  final int _minPhotos = 2;
  final int _maxPhotos = 4;
  
  // API Configuration
  static const String API_URL = 'https://your-api-endpoint.com/upload_photos';
  static const String VERIFY_API_URL = 'https://your-api-endpoint.com/verify_human';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Target image dimensions (3:4 ratio)
  final double _targetAspectRatio = 3.0 / 4.0;

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= _maxPhotos) return;
    
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );
      
      if (image != null) {
        // Show cropping interface
        File? croppedFile = await _showCustomCropper(File(image.path));
        if (croppedFile != null) {
          // Verify if image contains human face
          bool isHuman = await _verifyHumanImage(croppedFile);
          
          if (isHuman) {
            setState(() {
              _selectedImages.add(croppedFile);
            });
            _showSuccessSnackbar('Photo added successfully!');
          } else {
            _showErrorSnackbar('Please upload a clear photo showing your face');
          }
        }
      }
    } catch (e) {
      log('Error picking image: $e');
      _showErrorSnackbar('Failed to pick image. Please try again.');
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
    // For demo purposes, simulate AI verification
    // In production, call your AI API endpoint
    setState(() => _isVerifying = true);
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() => _isVerifying = false);
    
    // Simulate verification - return true for demo
    // Replace with actual API call:
    /*
    try {
      String base64Image = base64Encode(imageFile.readAsBytesSync());
      final response = await http.post(
        Uri.parse(VERIFY_API_URL),
        headers: headers,
        body: jsonEncode({'image': base64Image}),
      );
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['is_human'] == true && data['has_face'] == true;
      }
    } catch (e) {
      log('Verification error: $e');
    }
    */
    
    return true; // For demo, always return true
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
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
            color: AppColors.neonGold.withOpacity(0.2),
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
              
              // Header
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
                'Choose how to add your photo',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 24),
              
              // Camera Option
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
              
              // Gallery Option
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
              border: Border.all(
                color: AppColors.neonGold.withOpacity(0.1),
                width: 1,
              ),
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

  // Convert image to base64
  String _imageToBase64(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  // Prepare data for API submission
  Map<String, dynamic> _preparePhotoData() {
    List<String> base64Images = [];
    for (File image in _selectedImages) {
      base64Images.add(_imageToBase64(image));
    }
    
    return {
      'user_id': 'current_user_id', // Replace with actual user ID
      'photos': base64Images,
      'photo_count': _selectedImages.length,
      'main_photo_index': 0,
      'aspect_ratio': '3:4',
      'upload_timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Submit photos to API
  Future<bool> _submitPhotos() async {
    try {
      final response = await http.post(
        Uri.parse(API_URL),
        headers: headers,
        body: jsonEncode(_preparePhotoData()),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        log('API Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Network Error: $e');
      return false;
    }
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

  void _reorderImage(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final File image = _selectedImages.removeAt(oldIndex);
    setState(() {
      _selectedImages.insert(newIndex, image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.cardBlack,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.neonGold.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Iconsax.arrow_left_2,
                          color: AppColors.neonGold,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
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
                                fontStyle: FontStyle.italic,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add clear photos showing your face',
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
              ),
              
              // Progress Indicator
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
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedImages.length}/$_maxPhotos photos',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _selectedImages.length >= _minPhotos
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedImages.length >= _minPhotos
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _selectedImages.length >= _minPhotos
                                    ? Iconsax.tick_circle
                                    : Iconsax.info_circle,
                                size: 12,
                                color: _selectedImages.length >= _minPhotos
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _selectedImages.length >= _minPhotos
                                    ? 'Ready'
                                    : '${_minPhotos - _selectedImages.length} more',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _selectedImages.length >= _minPhotos
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
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
                        'Verifying photo...',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Photo Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75, // 3:4 ratio
                        ),
                        itemCount: _maxPhotos,
                        itemBuilder: (context, index) {
                          if (index < _selectedImages.length) {
                            // Filled photo box
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
                                        border: Border.all(
                                          color: isFirstPhoto
                                              ? AppColors.neonGold.withOpacity(0.8)
                                              : Colors.transparent,
                                          width: isFirstPhoto ? 3 : 0,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Gradient overlay
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
                                          
                                          // Main Photo Badge
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
                                          
                                          // Remove Button
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
                                          
                                          // Photo Number
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
                                          
                                          // Drag indicator at bottom
                                          Positioned(
                                            bottom: 12,
                                            left: 12,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Icon(
                                                Iconsax.arrow,
                                                color: Colors.white,
                                                size: 12,
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
                          } else {
                            // Empty photo box (Add button)
                            return GestureDetector(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cardBlack,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.neonGold.withOpacity(0.2),
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
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
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tap to add',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Instructions Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBlack,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.neonGold.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Iconsax.like_shapes,
                                    color: AppColors.neonGold,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Photo Guidelines',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildGuideline(
                                  '✓ Show your face clearly in good lighting',
                                ),
                                const SizedBox(height: 8),
                                _buildGuideline(
                                  '✓ Use recent photos (last 6 months)',
                                ),
                                const SizedBox(height: 8),
                                _buildGuideline(
                                  '✓ Smile! It makes you more approachable',
                                ),
                                const SizedBox(height: 8),
                                _buildGuideline(
                                  '✓ Avoid group photos or heavily filtered images',
                                ),
                                const SizedBox(height: 8),
                                _buildGuideline(
                                  '✓ All photos will be cropped to 3:4 ratio',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              
              // Upload Button
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedImages.length >= _minPhotos && !_isUploading && !_isVerifying
                        ? _uploadAndContinue
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading || _isUploading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedImages.length < _minPhotos
                                    ? 'ADD ${_minPhotos - _selectedImages.length} MORE PHOTOS'
                                    : 'COMPLETE PROFILE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              if (_selectedImages.length >= _minPhotos) ...[
                                const SizedBox(width: 10),
                                Icon(
                                  Iconsax.arrow_right_3,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ],
                            ],
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

  Widget _buildGuideline(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Iconsax.tick_circle,
          color: AppColors.neonGold,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade300,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
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

  void _uploadAndContinue() async {
    if (_selectedImages.length < _minPhotos) return;
    
    setState(() {
      _isUploading = true;
    });
    
    try {
      // Verify all images are of the same person (AI check)
      // This would be an additional API call in production
      
      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, simulate successful upload
      bool uploadSuccess = true; // Replace with actual API call
      // bool uploadSuccess = await _submitPhotos();
      
        _showSuccessSnackbar('Profile completed successfully!');
        
        // Navigate to next screen
        await Future.delayed(const Duration(milliseconds: 500));
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => WeekendHome(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
    } catch (e) {
      log('Upload error: $e');
      _showErrorSnackbar('An error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
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
  
  // Frame is fixed in center, image moves inside it
  double _frameWidth = 0;
  double _frameHeight = 0;
  bool _isImageLoaded = false;
  double _minScale = 1.0;
  double _maxScale = 3.0;
  
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
    final padding = 40.0; // Padding from screen edges
    
    // Calculate frame dimensions based on aspect ratio
    _frameWidth = screenSize.width - (padding * 2);
    _frameHeight = _frameWidth / widget.aspectRatio;
    
    // If frame is too tall for screen, adjust
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
    // For demo, return original file
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
            // Header
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
                    'Zoom and position your photo within the frame',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            
            // Frame Container (Fixed in center)
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
                    borderRadius: BorderRadius.circular(9), // Slightly smaller than border
                    child: Stack(
                      children: [
                        // Interactive Image (moves/zooms inside frame)
                        Positioned.fill(
                          child: GestureDetector(
                            onScaleUpdate: (details) {
                              // Allow scale update when scaling
                              if (details.scale != 1.0) {
                                _transformationController.value = Matrix4.identity()
                                  ..translate(
                                    _transformationController.value.getTranslation().x,
                                    _transformationController.value.getTranslation().y,
                                  )
                                  ..scale(
                                    (_photoViewController.scale ?? 1.0) * details.scale,
                                  );
                              }
                            },
                            child: PhotoView(
                              imageProvider: FileImage(widget.imageFile),
                              controller: _photoViewController,
                              backgroundDecoration: const BoxDecoration(color: Colors.black),
                              minScale: PhotoViewComputedScale.contained * 0.5,
                              maxScale: PhotoViewComputedScale.covered * 3,
                              initialScale: PhotoViewComputedScale.contained,
                              basePosition: Alignment.center,
                              enableRotation: false,
                              scaleStateCycle: (currentState) {
                                switch (currentState) {
                                  case PhotoViewScaleState.covering:
                                    return PhotoViewScaleState.originalSize;
                                  case PhotoViewScaleState.originalSize:
                                    return PhotoViewScaleState.initial;
                                  case PhotoViewScaleState.initial:
                                    return PhotoViewScaleState.covering;
                                  case PhotoViewScaleState.zoomedIn:
                                    return PhotoViewScaleState.covering;
                                  case PhotoViewScaleState.zoomedOut:
                                    return PhotoViewScaleState.covering;
                                  default:
                                    return PhotoViewScaleState.covering;
                                }
                              },
                              // onScaleUpdate: (scale) {
                              //   // Update transformation controller
                              //   _transformationController.value = Matrix4.identity()
                              //     ..translate(
                              //       _transformationController.value.getTranslation().x,
                              //       _transformationController.value.getTranslation().y,
                              //     )
                              //     ..scale(scale);
                              // },
                            ),
                          ),
                        ),
                        
                        // Grid overlay inside frame (only visible corners)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _FrameGridPainter(),
                            ),
                          ),
                        ),
                        
                        // Aspect ratio label
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '3:4',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Zoom Controls
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildZoomButton(
                    icon: Iconsax.minus,
                    onPressed: () {
                      final currentScale = _photoViewController.scale ?? 1.0;
                      final newScale = (currentScale * 0.8).clamp(0.5, 3.0);
                      _photoViewController.scale = newScale;
                      _transformationController.value = Matrix4.identity()
                        ..scale(newScale);
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildZoomButton(
                    icon: Iconsax.refresh,
                    onPressed: () {
                      _photoViewController.reset();
                      _transformationController.value = Matrix4.identity();
                    },
                    label: 'Reset',
                  ),
                  const SizedBox(width: 20),
                  _buildZoomButton(
                    icon: Iconsax.add,
                    onPressed: () {
                      final currentScale = _photoViewController.scale ?? 1.0;
                      final newScale = (currentScale * 1.2).clamp(0.5, 3.0);
                      _photoViewController.scale = newScale;
                      _transformationController.value = Matrix4.identity()
                        ..scale(newScale);
                    },
                  ),
                ],
              ),
            ),
            
            // Instructions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '• Pinch to zoom • Drag to position • Frame is fixed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            
            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Cancel Button
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
                  
                  // Crop Button
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
  
  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}

// Grid painter for inside the frame
class _FrameGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    
    // Draw vertical lines (rule of thirds)
    for (int i = 1; i < 3; i++) {
      final x = size.width * i / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Draw horizontal lines (rule of thirds)
    for (int i = 1; i < 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Draw corner indicators
    final cornerPaint = Paint()
      ..color = AppColors.neonGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    final cornerLength = 15.0;
    
    // Top-left corner
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), cornerPaint);
    
    // Top-right corner
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), cornerPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), cornerPaint);
    
    // Bottom-left corner
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), cornerPaint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), cornerPaint);
    
    // Bottom-right corner
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), cornerPaint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), cornerPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}